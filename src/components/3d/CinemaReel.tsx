'use client';

import { useRef, useMemo } from 'react';
import { Canvas, useFrame } from '@react-three/fiber';
import { Environment, Float, ContactShadows } from '@react-three/drei';
import * as THREE from 'three';

function Reel() {
  const reelRef = useRef<THREE.Group>(null);
  
  useFrame((state) => {
    if (reelRef.current) {
      reelRef.current.rotation.y = state.clock.elapsedTime * 0.1;
      reelRef.current.rotation.x = Math.sin(state.clock.elapsedTime * 0.2) * 0.1;
    }
  });

  const filmStrip = useMemo(() => {
    const shape = new THREE.Shape();
    const width = 2;
    const height = 3;
    const radius = 0.1;
    
    shape.moveTo(-width/2 + radius, -height/2);
    shape.lineTo(width/2 - radius, -height/2);
    shape.quadraticCurveTo(width/2, -height/2, width/2, -height/2 + radius);
    shape.lineTo(width/2, height/2 - radius);
    shape.quadraticCurveTo(width/2, height/2, width/2 - radius, height/2);
    shape.lineTo(-width/2 + radius, height/2);
    shape.quadraticCurveTo(-width/2, height/2, -width/2, height/2 - radius);
    shape.lineTo(-width/2, -height/2 + radius);
    shape.quadraticCurveTo(-width/2, -height/2, -width/2 + radius, -height/2);

    const extrudeSettings = {
      steps: 1,
      depth: 0.1,
      bevelEnabled: true,
      bevelThickness: 0.05,
      bevelSize: 0.05,
      bevelSegments: 4,
    };

    return new THREE.ExtrudeGeometry(shape, extrudeSettings);
  }, []);

  return (
    <Float speed={2} rotationIntensity={0.5} floatIntensity={0.5}>
      <group ref={reelRef}>
        <mesh position={[0, 0, 0]}>
          <cylinderGeometry args={[1.5, 1.5, 0.5, 32]} />
          <meshStandardMaterial color="#1a1a1a" metalness={0.8} roughness={0.2} />
        </mesh>
        
        {[0, 1, 2, 3].map((i) => (
          <mesh 
            key={i} 
            position={[
              Math.cos(i * Math.PI / 2) * 2.5, 
              Math.sin(i * Math.PI / 2) * 2.5, 
              0
            ]}
            rotation={[0, 0, i * Math.PI / 2]}
            geometry={filmStrip}
          >
            <meshStandardMaterial 
              color="#E50914" 
              emissive="#E50914"
              emissiveIntensity={0.2}
              metalness={0.5}
              roughness={0.4}
              transparent
              opacity={0.9}
            />
          </mesh>
        ))}

        <mesh position={[0, 0, 0.3]}>
          <cylinderGeometry args={[0.3, 0.3, 0.6, 16]} />
          <meshStandardMaterial color="#E50914" metalness={0.9} roughness={0.1} />
        </mesh>
      </group>
    </Float>
  );
}

export function CinemaReel() {
  return (
    <div className="w-full h-[60vh] md:h-[80vh]">
      <Canvas camera={{ position: [0, 0, 8], fov: 45 }}>
        <ambientLight intensity={0.5} />
        <spotLight position={[10, 10, 10]} angle={0.15} penumbra={1} intensity={1} />
        <pointLight position={[-10, -10, -10]} intensity={0.5} />
        <Reel />
        <ContactShadows position={[0, -4, 0]} opacity={0.4} scale={10} blur={2.5} far={4} />
        <Environment preset="city" />
      </Canvas>
    </div>
  );
}
