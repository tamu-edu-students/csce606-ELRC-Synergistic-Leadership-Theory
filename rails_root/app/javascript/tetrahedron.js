import * as THREE from 'three'
import { OBJLoader } from 'three/addons/loaders/OBJLoader.js'
import { MTLLoader } from 'three/addons/loaders/MTLLoader.js'
import { OrbitControls } from 'three/addons/controls/OrbitControls.js'

function loadModel(containerID, tetrahedronType) {
    if (!(typeof tetrahedronType === 'string' || tetrahedronType instanceof String))
        return

    const container = document.getElementById(containerID)
    const fileStem = `/models/${tetrahedronType}_tetrahedron`

    const objLoader = new OBJLoader()
    const mtlLoader = new MTLLoader()

    const renderer = new THREE.WebGLRenderer()
    container.appendChild( renderer.domElement )
    renderer.setSize( container.getBoundingClientRect().width, container.getBoundingClientRect().width )

    const scene = new THREE.Scene()
    scene.background = new THREE.Color(0xffffff)

    const camera = new THREE.PerspectiveCamera( 95, window.innerWidth / window.innerHeight, 0.1, 20 )
    const controls = new OrbitControls( camera, renderer.domElement )

    camera.position.z = 1
    controls.enableZoom = false
    controls.enablePan = false

    // var ambLight = new THREE.AmbientLight( 0xffffff )
    // scene.add(ambLight)

    var dirLight = new THREE.DirectionalLight( 0xffffff  )
    dirLight.position.set( 0, 2, 10 ).normalize()
    camera.add( dirLight )

    scene.add( camera )

    mtlLoader.load(
        fileStem + '.mtl',
        materials => {
            objLoader.setMaterials(materials)
            objLoader.load(
                fileStem + '.obj',
                tetrahedron => {
                    // FIXME: Adjust materials in MTL instead of programmatically
                    for (const material of Object.values(materials.materials))
                        material.shininess = 125

                    materials.materials.orange.color = new THREE.Color(0xFF4F00)

                    tetrahedron.scale.setScalar(8)
                    scene.add( tetrahedron )
                },
                _ => console.log('loaded obj'),
                console.warn
            )
        },
        _ => console.log('loaded mtl'),
        console.warn
    )

    function animate() {
        requestAnimationFrame( animate )

        controls.update()
        renderer.render( scene, camera )
    }

    animate()
}

export { loadModel }