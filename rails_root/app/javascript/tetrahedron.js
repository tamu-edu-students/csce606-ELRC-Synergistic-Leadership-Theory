import * as THREE from 'three';
import { OrbitControls } from 'three/addons/controls/OrbitControls.js';
import { GLTFLoader } from 'three/addons/loaders/GLTFLoader.js';

import { EffectComposer } from 'three/addons/postprocessing/EffectComposer.js';
import { RenderPass } from 'three/addons/postprocessing/RenderPass.js';
import { ShaderPass } from 'three/addons/postprocessing/ShaderPass.js';
import { OutlinePass } from 'three/addons/postprocessing/OutlinePass.js';
import { FXAAShader } from 'three/addons/shaders/FXAAShader.js';
import { GammaCorrectionShader } from 'three/addons/shaders/GammaCorrectionShader.js';

export function loadModel(containerID, tetrahedronType) {
    if (!(typeof tetrahedronType === 'string' || tetrahedronType instanceof String))
        return;

    const container = document.getElementById(containerID);

    let pose1, pose2, pose3, pose4, rest;
    let pose1Copy, pose2Copy, pose3Copy, pose4Copy, restCopy;
    let camera, scene, renderer, controls;
    let weights;
    let width, height;

    let composer, effectFXAA, outlinePass;
    let selectedObjects = [];

    const params = {
        edgeStrength: 3.0,
        rotate: true,
    };

    const raycaster = new THREE.Raycaster();
    const mouse = new THREE.Vector2();
    const group = new THREE.Group();

    const material1 = getMaterial(0xF44336); // Red 500
    const material2 = getMaterial(0x2196F3); // Blue 500
    const material3 = getMaterial(0x4CAF50); // Green 500
    const material4 = getMaterial(0xFFEB3B); // Yellow 500

    function getMaterial(color) {
        return new THREE.MeshPhysicalMaterial({
            color: color,
            metalness: 0.1,
            roughness: 0.0,
            clearcoat: 0.7,
            sheen: 0.1,
            wireframe: false,
            flatShading: true,
        })
    }

    function loadScene() {
        scene = new THREE.Scene();
        scene.background = new THREE.Color(0xffffff);

        const hemiLight = new THREE.HemisphereLight(0xffffff, 0x8d8d8d, 3);
        hemiLight.position.set(0, 20, 0);
        scene.add(hemiLight);

        const ambientLight = new THREE.AmbientLight(0x808080);
        scene.add(ambientLight);

        const directionalLight = new THREE.DirectionalLight(0xffffff, 0.5);
        directionalLight.position.set(1, 1, 1);
        scene.add(directionalLight);

        width = container.getBoundingClientRect().width
        height = container.getBoundingClientRect().height

        // camera = new THREE.PerspectiveCamera(60, window.innerWidth / window.innerHeight, 0.1, 1000);
        camera = new THREE.PerspectiveCamera(60, width / width, 0.1, 1000);

        renderer = new THREE.WebGLRenderer();
        // renderer.setSize(container.clientWidth, container.clientHeight);
        renderer.setSize(width, width)
        container.appendChild(renderer.domElement);

        controls = new OrbitControls(camera, renderer.domElement);

        controls.enableZoom = false
        controls.enablePan = false
        controls.enableDamping = true;
        controls.dampingFactor = 0.05;

        const loader = new GLTFLoader();

        loader.load(
            '/scene/poses.glb',
            gltf => {
                gltf.scene.traverse(child => {
                    if (child.isMesh) {
                        child.geometry.computeVertexNormals();

                        switch (child.name) {
                            case 'pose1':
                                pose1 = child;
                                pose1.material = material1;
                                pose1Copy = pose1.clone();
                                pose1Copy.geometry = pose1.geometry.clone();
                                break;
                            case 'pose2':
                                pose2 = child;
                                pose2.material = material2;
                                pose2Copy = pose2.clone();
                                pose2Copy.geometry = pose2.geometry.clone();
                                break;
                            case 'pose3':
                                pose3 = child;
                                pose3.material = material3;
                                pose3Copy = pose3.clone();
                                pose3Copy.geometry = pose3.geometry.clone();
                                break;
                            case 'pose4':
                                pose4 = child;
                                pose4.material = material4;
                                pose4Copy = pose4.clone();
                                pose4Copy.geometry = pose4.geometry.clone();
                                break;
                            case 'eye':
                                rest = child;
                                rest.material = getMaterial(0xa8a8a8);
                                restCopy = rest.clone();
                                restCopy.geometry = rest.geometry.clone();
                                break;
                        }
                    }
                });
                group.add(gltf.scene);
                scene.add(group);
                camera.position.z = 5;

                updateBlendShapes(tetrahedronType.split('_').map(x => parseFloat(x) / 3.));
            },
            _ => { },
            console.error
        );

        // postprocessing 
        composer = new EffectComposer(renderer);

        const renderPass = new RenderPass(scene, camera);
        composer.addPass(renderPass);

        const gammaCorrectionPass = new ShaderPass(GammaCorrectionShader);
        composer.addPass(gammaCorrectionPass);

        outlinePass = new OutlinePass(new THREE.Vector2(width, width), scene, camera);
        outlinePass.edgeStrength = params.edgeStrength;
        outlinePass.overlayMaterial.blending = THREE.CustomBlending
        composer.addPass(outlinePass);

        effectFXAA = new ShaderPass(FXAAShader);
        effectFXAA.uniforms['resolution'].value.set(1 / width, 1 / width);
        composer.addPass(effectFXAA);

        renderer.domElement.style.touchAction = 'none';
        renderer.domElement.addEventListener('pointermove', onPointerMove);

        function onPointerMove(event) {
            if (event.isPrimary === false) return;

            mouse.x = (event.clientX / width) * 2 - 1;
            mouse.y = - (event.clientY / width) * 2 + 1;

            checkIntersection();
        }

        function addSelectedObject(object) {
            selectedObjects = [];
            selectedObjects.push(object);
        }

        function checkIntersection() {
            raycaster.setFromCamera(mouse, camera);

            const intersects = raycaster.intersectObject(scene, true);

            if (intersects.length > 0) {
                const selectedObject = intersects[0].object;
                addSelectedObject(selectedObject);
                outlinePass.selectedObjects = selectedObjects;

                var poseColor = 0xffffff;
                if (selectedObject === pose1) {
                    poseColor = 0xF44336;
                } else if (selectedObject === pose2) {
                    poseColor = 0x2196F3;
                } else if (selectedObject === pose3) {
                    poseColor = 0x4CAF50;
                } else if (selectedObject === pose4) {
                    poseColor = 0xFFEB3B;
                }
                outlinePass.visibleEdgeColor.set(poseColor);
                outlinePass.hiddenEdgeColor.set(poseColor);

                renderer.domElement.style.cursor = 'pointer';
            } else {
                outlinePass.selectedObjects = [];
                renderer.domElement.style.cursor = 'default';
            }
        }

        window.addEventListener('resize', onWindowResize, false);
        animate();
    }

    function animate() {
        requestAnimationFrame(animate);

        const timer = performance.now();
        if (params.rotate) {
            group.rotation.y = timer * 0.0001;
        }
        // render();
        controls.update();
        composer.render();
    }

    function render() {
        renderer.render(scene, camera);
    }

    function onWindowResize() {
        width = container.getBoundingClientRect().width
        height = container.getBoundingClientRect().height

        camera.aspect = width / width;
        camera.updateProjectionMatrix();
        renderer.setSize(width, width);

        composer.setSize(width, width);
        effectFXAA.uniforms['resolution'].value.set(1 / width, 1 / width);
    }

    function init() {
        fetch('/scene/weights.txt')
            .then(response => response.text())
            .then(data => {
                weights = Uint8Array.from(data.split('\n').map(Number).slice(0, 2594));
                loadScene();
            })
            .catch(error => console.error(error));
    }

    function updateBlendShapes(beta = [0, 0, 0, 0]) {
        beta = beta.map(value => Math.max(0.01, Math.min(value, 1)));

        let newPosition = new THREE.Vector3();

        for (let i = 0; i < 2594; ++i) {
            let index = i * 3;
            let targetPosePosition = new THREE.Vector3().fromBufferAttribute(rest.geometry.attributes.position, i);
            {
                let restPosition = new THREE.Vector3().fromBufferAttribute(pose1Copy.geometry.attributes.position, i);
                if (weights[i] === 4) {
                    newPosition.lerpVectors(targetPosePosition, restPosition, beta[0]);

                    pose1.geometry.attributes.position.array[index] = newPosition.x;
                    pose1.geometry.attributes.position.array[index + 1] = newPosition.y;
                    pose1.geometry.attributes.position.array[index + 2] = newPosition.z;
                }
            }
            {
                let restPosition = new THREE.Vector3().fromBufferAttribute(pose2Copy.geometry.attributes.position, i);
                if (weights[i] === 3) {
                    newPosition.lerpVectors(targetPosePosition, restPosition, beta[1]);

                    pose2.geometry.attributes.position.array[index] = newPosition.x;
                    pose2.geometry.attributes.position.array[index + 1] = newPosition.y;
                    pose2.geometry.attributes.position.array[index + 2] = newPosition.z;
                }
            }
            {
                let restPosition = new THREE.Vector3().fromBufferAttribute(pose3Copy.geometry.attributes.position, i);
                if (weights[i] === 2) {
                    newPosition.lerpVectors(targetPosePosition, restPosition, beta[2]);

                    pose3.geometry.attributes.position.array[index] = newPosition.x;
                    pose3.geometry.attributes.position.array[index + 1] = newPosition.y;
                    pose3.geometry.attributes.position.array[index + 2] = newPosition.z;
                }
            }
            {
                let restPosition = new THREE.Vector3().fromBufferAttribute(pose4Copy.geometry.attributes.position, i);
                if (weights[i] === 1) {
                    newPosition.lerpVectors(targetPosePosition, restPosition, beta[3]);

                    pose4.geometry.attributes.position.array[index] = newPosition.x;
                    pose4.geometry.attributes.position.array[index + 1] = newPosition.y;
                    pose4.geometry.attributes.position.array[index + 2] = newPosition.z;
                }
            }
            {
                let restPosition = new THREE.Vector3();
                if (weights[i] === 0) {
                    restPosition = new THREE.Vector3().fromBufferAttribute(pose4Copy.geometry.attributes.position, i);
                    newPosition.lerpVectors(targetPosePosition, restPosition, beta[3]);

                    pose4.geometry.attributes.position.array[index] = newPosition.x;
                    pose4.geometry.attributes.position.array[index + 1] = newPosition.y;
                    pose4.geometry.attributes.position.array[index + 2] = newPosition.z;

                    restPosition = new THREE.Vector3().fromBufferAttribute(pose3Copy.geometry.attributes.position, i);
                    newPosition.lerpVectors(targetPosePosition, restPosition, beta[2]);

                    pose3.geometry.attributes.position.array[index] = newPosition.x;
                    pose3.geometry.attributes.position.array[index + 1] = newPosition.y;
                    pose3.geometry.attributes.position.array[index + 2] = newPosition.z;

                    restPosition = new THREE.Vector3().fromBufferAttribute(pose2Copy.geometry.attributes.position, i);
                    newPosition.lerpVectors(targetPosePosition, restPosition, beta[1]);

                    pose2.geometry.attributes.position.array[index] = newPosition.x;
                    pose2.geometry.attributes.position.array[index + 1] = newPosition.y;
                    pose2.geometry.attributes.position.array[index + 2] = newPosition.z;

                    restPosition = new THREE.Vector3().fromBufferAttribute(pose1Copy.geometry.attributes.position, i);
                    newPosition.lerpVectors(targetPosePosition, restPosition, beta[0]);

                    pose1.geometry.attributes.position.array[index] = newPosition.x;
                    pose1.geometry.attributes.position.array[index + 1] = newPosition.y;
                    pose1.geometry.attributes.position.array[index + 2] = newPosition.z;
                }
            }
        }

        pose1.geometry.attributes.position.needsUpdate = true;
        pose2.geometry.attributes.position.needsUpdate = true;
        pose3.geometry.attributes.position.needsUpdate = true;
        pose4.geometry.attributes.position.needsUpdate = true;
    }

    init();
}
