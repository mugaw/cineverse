'use client';

import { useRef, useMemo } from 'react';
import { Canvas, useFrame } from '@react-three/fiber';
import { Environment, PerspectiveCamera, Float } from '@react-three/drei';
import * as THREE from 'three';

interface SeatProps {
  position: [number, number, number];
  isSelected: boolean;
  onClick: () => void;
  row: string;
  number: number;
}

function SeatMesh({ position, isSelected, onClick }: SeatProps) {
  const meshRef = useRef<THREE.Mesh>(null);
  
  useFrame((state) => {
    if (meshRef.current && isSelected) {
      meshRef.current.scale.setScalar(1 + Math.sin(state.clock.elapsedTime * 3) * 0.05);
    }
  });

  return (
    <Float speed={isSelected ? 2 : 0} rotationIntensity={0.2} floatIntensity={isSelected ? 0.5 : 0}>
      <mesh 
        ref={meshRef}
        position={position} 
        onClick={onClick}
        onPointerOver={(e) => {
          e.stopPropagation();
          document.body.style.cursor = 'pointer';
        }}
        onPointerOut={() => {
          document.body.style.cursor = 'auto';
        }}
      >
        <boxGeometry args={[0.8, 0.8, 0.8]} />
        <meshStandardMaterial 
          color={isSelected ? '#E50914' : '#2a2a2a'}
          emissive={isSelected ? '#E50914' : '#000000'}
          emissiveIntensity={isSelected ? 0.5 : 0}
          metalness={0.6}
          roughness={0.4}
        />
      </mesh>
    </Float>
  );
}

function CinemaHallScene({ selectedSeats, onSeatClick }: { 
  selectedSeats: string[]; 
  onSeatClick: (seatId: string) => void;
}) {
  const rows = 'ABCDEFGHIJ'.split('');
  const seatsPerRow = 8;

  const seatPositions = useMemo(() => {
    const positions: { id: string; position: [number, number, number]; row: string; number: number }[] = [];
    rows.forEach((row, rowIndex) => {
      for (let i = 0; i < seatsPerRow; i++) {
        const x = (i - seatsPerRow / 2) * 1.2;
        const z = rowIndex * 1.2;
        const y = Math.sin(rowIndex * 0.2) * 0.5;
        positions.push({
          id: `${row}${i + 1}`,
          position: [x, y, z],
          row,
          number: i + 1,
        });
      }
    });
    return positions;
  }, []);

  return (
    <>
      <PerspectiveCamera makeDefault position={[0, 5, 15]} fov={60} />
      <ambientLight intensity={0.3} />
      <spotLight position={[0, 10, 0]} angle={0.5} penumbra={1} intensity={2} castShadow />
      <pointLight position={[5, 5, 5]} intensity={0.5} color="#E50914" />
      
      <mesh position={[0, 3, -2]} rotation={[0, 0, 0]}>
        <planeGeometry args={[12, 6]} />
        <meshStandardMaterial color="#ffffff" emissive="#ffffff" emissiveIntensity={0.2} />
      </mesh>

      {seatPositions.map((seat) => (
        <SeatMesh
          key={seat.id}
          position={seat.position}
          isSelected={selectedSeats.includes(seat.id)}
          onClick={() => onSeatClick(seat.id)}
          row={seat.row}
          number={seat.number}
        />
      ))}

      <Environment preset="night" />
    </>
  );
}

export function CinemaHall({ selectedSeats, onSeatClick }: { 
  selectedSeats: string[]; 
  onSeatClick: (seatId: string) => void;
}) {
  return (
    <div className="w-full h-[400px] md:h-[500px] rounded-2xl overflow-hidden bg-gradient-to-b from-[#0B0B0F] to-[#1a1a2e]">
      <Canvas shadows>
        <CinemaHallScene selectedSeats={selectedSeats} onSeatClick={onSeatClick} />
      </Canvas>
    </div>
  );
}
