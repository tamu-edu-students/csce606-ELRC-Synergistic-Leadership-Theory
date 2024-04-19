import * as THREE from 'three';
import { OrbitControls } from 'three/addons/controls/OrbitControls.js';
import { GLTFLoader } from 'three/addons/loaders/GLTFLoader.js';

export function loadModel(containerID, tetrahedronType) {
	if (!(typeof tetrahedronType === 'string' || tetrahedronType instanceof String))
		return;

	const container = document.getElementById(containerID);

	let pose1, pose2, pose3, pose4, rest;
	let pose1Copy, pose2Copy, pose3Copy, pose4Copy, restCopy;
	let camera, scene, renderer, controls;
	let weights;
	let width, height;

	const material1 = new THREE.MeshPhysicalMaterial({
		color: 0xF44336, // Red 500
		metalness: 0,
		roughness: 0.0,
		clearcoat: 0.7,
		sheen: 0.1,
		wireframe: false,
		flatShading: true,
	});

	const material2 = new THREE.MeshPhysicalMaterial({
		color: 0x2196F3, // Blue 500
		metalness: 0,
		roughness: 0.0,
		clearcoat: 0.7,
		sheen: 0.1,
		wireframe: false,
		flatShading: true,
	});

	const material3 = new THREE.MeshPhysicalMaterial({
		color: 0x4CAF50, // Green 500
		metalness: 0,
		roughness: 0.0,
		clearcoat: 0.7,
		sheen: 0.1,
		wireframe: false,
		flatShading: true,
	});

	const material4 = new THREE.MeshPhysicalMaterial({
		color: 0xFFEB3B, // Yellow 500
		metalness: 0.1,
		roughness: 0.0,
		clearcoat: 0.7,
		sheen: 0.1,
		wireframe: false,
		flatShading: true,
	});

	function loadScene() {
		scene = new THREE.Scene();
		scene.background = new THREE.Color(0xf0f0f0);

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
								restCopy = rest.clone();
								restCopy.geometry = rest.geometry.clone();
								break;
						}
					}
				});

				scene.add(gltf.scene);
				camera.position.z = 5;

				updateBlendShapes(tetrahedronType.split('_').map(x => parseFloat(x) / 3.));
			},
			_ => {},
            console.error
		);

		window.addEventListener('resize', onWindowResize, false);
		animate();
	}

	function animate() {
		requestAnimationFrame(animate);
		render();
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
		}

		pose1.geometry.attributes.position.needsUpdate = true;
		pose2.geometry.attributes.position.needsUpdate = true;
		pose3.geometry.attributes.position.needsUpdate = true;
		pose4.geometry.attributes.position.needsUpdate = true;
	}

	init();
}