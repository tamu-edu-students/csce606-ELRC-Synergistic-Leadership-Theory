import * as THREE from 'three';
import { OBJLoader } from 'three/addons/loaders/OBJLoader.js';
import { OrbitControls } from 'three/addons/controls/OrbitControls.js';

// instantiate a loader
const loader = new OBJLoader();

const scene = new THREE.Scene();
const camera = new THREE.PerspectiveCamera( 95, window.innerWidth / window.innerHeight, 0.001, 200 );
camera.position.z = .1;

scene.background = new THREE.Color(0x1d2626)

const renderer = new THREE.WebGLRenderer();

const material = new THREE.MeshStandardMaterial( { color: 0xffffff } );

const controls = new OrbitControls( camera, renderer.domElement );

var dirLight = new THREE.DirectionalLight( 0xffffff );
dirLight.position.set( 0, 100, 1000 ).normalize();
camera.add( dirLight );

scene.add( camera )

loader.load(
    '/models/tetrahedron.obj',
    object => {
        object.traverse( function ( child ) {
            if ( child instanceof THREE.Mesh ) {
                child.material = material;
            }
        } );

        scene.add( object );

        document.body.appendChild( renderer.domElement );
    },
    _ => {},
    console.warn
);

function animate() {
    requestAnimationFrame( animate );

    // required if controls.enableDamping or controls.autoRotate are set to true
    controls.update();
    renderer.render( scene, camera );
}

renderer.setSize( window.innerWidth, window.innerHeight );
animate();
