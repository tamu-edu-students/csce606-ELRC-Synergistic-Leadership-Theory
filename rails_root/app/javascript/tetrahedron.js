import * as THREE from 'three'
import { OBJLoader } from 'three/addons/loaders/OBJLoader.js'
import { MTLLoader } from 'three/addons/loaders/MTLLoader.js'
import { OrbitControls } from 'three/addons/controls/OrbitControls.js'

const objLoader = new OBJLoader()
const mtlLoader = new MTLLoader()

const scene = new THREE.Scene()
const camera = new THREE.PerspectiveCamera( 95, window.innerWidth / window.innerHeight, 0.0001, 25 )
camera.position.z = .1

scene.background = new THREE.Color(0xffffff)

const renderer = new THREE.WebGLRenderer()

const controls = new OrbitControls( camera, renderer.domElement )
controls.enableZoom = false
controls.enablePan = false

var ambLight = new THREE.AmbientLight( 0x1b1b1b )

scene.add(ambLight)

var dirLight = new THREE.DirectionalLight( 0xffffff )
dirLight.position.set( 0, 0, .1 ).normalize()
camera.add( dirLight )

scene.add( camera )

mtlLoader.load(
    '/models/tetrahedron.mtl',
    materials => {
        objLoader.setMaterials(materials)
        objLoader.load(
            '/models/tetrahedron.obj',
            tetrahedron => scene.add( tetrahedron ),
            _ => {},
            console.warn
        )
    },
    _ => {},
    console.warn
)

function animate() {
    requestAnimationFrame( animate )

    controls.update()
    renderer.render( scene, camera )
}

const container = document.getElementById("tetrahedron")
renderer.setSize( container.getBoundingClientRect().width, container.getBoundingClientRect().width )
container.appendChild( renderer.domElement )
animate()
