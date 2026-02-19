#!/bin/bash

# Create store files
mkdir -p src/store

cat > src/store/useBookingStore.ts << 'EOF'
import { create } from 'zustand';
import { persist } from 'zustand/middleware';
import { Movie, Seat } from '@/types';

interface BookingState {
  selectedMovie: Movie | null;
  selectedSeats: Seat[];
  bookingDate: string;
  showtime: string;
  setSelectedMovie: (movie: Movie | null) => void;
  toggleSeat: (seat: Seat) => void;
  clearSeats: () => void;
  setBookingDate: (date: string) => void;
  setShowtime: (time: string) => void;
  totalPrice: () => number;
}

export const useBookingStore = create<BookingState>()(
  persist(
    (set, get) => ({
      selectedMovie: null,
      selectedSeats: [],
      bookingDate: '',
      showtime: '',
      setSelectedMovie: (movie) => set({ selectedMovie: movie, selectedSeats: [] }),
      toggleSeat: (seat) => {
        const { selectedSeats } = get();
        const exists = selectedSeats.find(s => s.id === seat.id);
        if (exists) {
          set({ selectedSeats: selectedSeats.filter(s => s.id !== seat.id) });
        } else {
          set({ selectedSeats: [...selectedSeats, seat] });
        }
      },
      clearSeats: () => set({ selectedSeats: [] }),
      setBookingDate: (date) => set({ bookingDate: date }),
      setShowtime: (time) => set({ showtime: time }),
      totalPrice: () => {
        const { selectedSeats, selectedMovie } = get();
        if (!selectedMovie) return 0;
        return selectedSeats.reduce((sum, seat) => sum + (seat.price || selectedMovie.price), 0);
      },
    }),
    {
      name: 'booking-storage',
    }
  )
);
EOF

cat > src/store/useFavoritesStore.ts << 'EOF'
import { create } from 'zustand';
import { persist } from 'zustand/middleware';

interface FavoritesState {
  favorites: string[];
  toggleFavorite: (movieId: string) => void;
  isFavorite: (movieId: string) => boolean;
}

export const useFavoritesStore = create<FavoritesState>()(
  persist(
    (set, get) => ({
      favorites: [],
      toggleFavorite: (movieId) => {
        const { favorites } = get();
        if (favorites.includes(movieId)) {
          set({ favorites: favorites.filter(id => id !== movieId) });
        } else {
          set({ favorites: [...favorites, movieId] });
        }
      },
      isFavorite: (movieId) => get().favorites.includes(movieId),
    }),
    {
      name: 'favorites-storage',
    }
  )
);
EOF

# Create hooks
mkdir -p src/hooks

cat > src/hooks/useLenis.ts << 'EOF'
'use client';

import { useEffect } from 'react';
import Lenis from 'lenis';

export function useLenis() {
  useEffect(() => {
    const lenis = new Lenis({
      duration: 1.2,
      easing: (t) => Math.min(1, 1.001 - Math.pow(2, -10 * t)),
      orientation: 'vertical',
      smoothWheel: true,
    });

    function raf(time: number) {
      lenis.raf(time);
      requestAnimationFrame(raf);
    }

    requestAnimationFrame(raf);

    return () => {
      lenis.destroy();
    };
  }, []);
}
EOF

cat > src/hooks/useScrollAnimation.ts << 'EOF'
'use client';

import { useEffect, useRef } from 'react';
import gsap from 'gsap';
import { ScrollTrigger } from 'gsap/ScrollTrigger';

gsap.registerPlugin(ScrollTrigger);

export function useScrollAnimation() {
  const ref = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (!ref.current) return;

    const ctx = gsap.context(() => {
      gsap.fromTo(
        ref.current,
        { opacity: 0, y: 50 },
        {
          opacity: 1,
          y: 0,
          duration: 1,
          ease: 'power3.out',
          scrollTrigger: {
            trigger: ref.current,
            start: 'top 85%',
            toggleActions: 'play none none reverse',
          },
        }
      );
    });

    return () => ctx.revert();
  }, []);

  return ref;
}
EOF

# Create animation components
mkdir -p src/components/animations

cat > src/components/animations/PageTransition.tsx << 'EOF'
'use client';

import { motion, AnimatePresence } from 'framer-motion';
import { usePathname } from 'next/navigation';

export function PageTransition({ children }: { children: React.ReactNode }) {
  const pathname = usePathname();

  return (
    <AnimatePresence mode="wait">
      <motion.div
        key={pathname}
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        exit={{ opacity: 0, y: -20 }}
        transition={{ duration: 0.5, ease: [0.22, 1, 0.36, 1] }}
      >
        {children}
      </motion.div>
    </AnimatePresence>
  );
}
EOF

cat > src/components/animations/StaggerContainer.tsx << 'EOF'
'use client';

import { motion } from 'framer-motion';

const containerVariants = {
  hidden: { opacity: 0 },
  visible: {
    opacity: 1,
    transition: {
      staggerChildren: 0.1,
      delayChildren: 0.2,
    },
  },
};

const itemVariants = {
  hidden: { opacity: 0, y: 20 },
  visible: {
    opacity: 1,
    y: 0,
    transition: {
      duration: 0.5,
      ease: [0.22, 1, 0.36, 1],
    },
  },
};

export function StaggerContainer({ 
  children, 
  className 
}: { 
  children: React.ReactNode; 
  className?: string 
}) {
  return (
    <motion.div
      variants={containerVariants}
      initial="hidden"
      whileInView="visible"
      viewport={{ once: true, margin: "-100px" }}
      className={className}
    >
      {children}
    </motion.div>
  );
}

export function StaggerItem({ 
  children, 
  className 
}: { 
  children: React.ReactNode; 
  className?: string 
}) {
  return (
    <motion.div variants={itemVariants} className={className}>
      {children}
    </motion.div>
  );
}
EOF

cat > src/components/animations/TextReveal.tsx << 'EOF'
'use client';

import { motion } from 'framer-motion';

export function TextReveal({ 
  text, 
  className = "" 
}: { 
  text: string; 
  className?: string 
}) {
  const words = text.split(" ");

  return (
    <motion.div className={className}>
      {words.map((word, i) => (
        <motion.span
          key={i}
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{
            duration: 0.5,
            delay: i * 0.05,
            ease: [0.22, 1, 0.36, 1],
          }}
          className="inline-block mr-[0.25em]"
        >
          {word}
        </motion.span>
      ))}
    </motion.div>
  );
}
EOF

# Create 3D components
mkdir -p src/components/3d

cat > src/components/3d/CinemaReel.tsx << 'EOF'
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
EOF

cat > src/components/3d/CinemaHall.tsx << 'EOF'
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
          id: \`\${row}\${i + 1}\`,
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
EOF

# Create UI components
mkdir -p src/components/ui

cat > src/components/ui/MovieCard.tsx << 'EOF'
'use client';

import { motion } from 'framer-motion';
import Image from 'next/image';
import { Movie } from '@/types';
import { useBookingStore } from '@/store/useBookingStore';
import { useFavoritesStore } from '@/store/useFavoritesStore';
import { Heart, Clock, Star, Ticket } from 'lucide-react';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import { useRouter } from 'next/navigation';

interface MovieCardProps {
  movie: Movie;
  variant?: 'default' | 'featured' | 'compact';
}

export function MovieCard({ movie, variant = 'default' }: MovieCardProps) {
  const router = useRouter();
  const { setSelectedMovie } = useBookingStore();
  const { isFavorite, toggleFavorite } = useFavoritesStore();

  const handleBook = () => {
    setSelectedMovie(movie);
    router.push('/book');
  };

  if (variant === 'featured') {
    return (
      <motion.div
        whileHover={{ scale: 1.02 }}
        className="relative group cursor-pointer overflow-hidden rounded-2xl bg-gradient-to-br from-[#1a1a2e] to-[#0B0B0F] border border-white/10"
      >
        <div className="relative h-[400px] overflow-hidden">
          <Image
            src={movie.bannerUrl}
            alt={movie.title}
            fill
            className="object-cover transition-transform duration-700 group-hover:scale-110"
          />
          <div className="absolute inset-0 bg-gradient-to-t from-[#0B0B0F] via-transparent to-transparent" />
          
          <motion.div 
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            className="absolute bottom-0 left-0 right-0 p-6"
          >
            <div className="flex items-center gap-2 mb-2">
              <Badge variant="secondary" className="bg-[#E50914] text-white">
                {movie.genre[0]}
              </Badge>
              {movie.isTrending && (
                <Badge variant="outline" className="border-[#E50914] text-[#E50914]">
                  Trending
                </Badge>
              )}
            </div>
            <h3 className="text-2xl md:text-3xl font-bold text-white mb-2">{movie.title}</h3>
            <p className="text-gray-300 line-clamp-2 mb-4">{movie.description}</p>
            <div className="flex items-center gap-4 text-sm text-gray-400 mb-4">
              <span className="flex items-center gap-1"><Star className="w-4 h-4 text-yellow-500" /> {movie.rating}</span>
              <span className="flex items-center gap-1"><Clock className="w-4 h-4" /> {movie.duration}m</span>
              <span>{movie.year}</span>
            </div>
            <Button 
              onClick={handleBook}
              className="bg-[#E50914] hover:bg-[#b20710] text-white w-full md:w-auto"
            >
              <Ticket className="w-4 h-4 mr-2" />
              Book Now ${movie.price}
            </Button>
          </motion.div>
        </div>
      </motion.div>
    );
  }

  return (
    <motion.div
      whileHover={{ y: -5 }}
      className="relative group bg-[#1a1a2e] rounded-xl overflow-hidden border border-white/5 hover:border-[#E50914]/50 transition-colors"
    >
      <div className="relative aspect-[2/3] overflow-hidden">
        <Image
          src={movie.posterUrl}
          alt={movie.title}
          fill
          className="object-cover transition-transform duration-500 group-hover:scale-105"
        />
        <div className="absolute inset-0 bg-gradient-to-t from-[#0B0B0F]/90 via-transparent to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300" />
        
        <button
          onClick={(e) => {
            e.stopPropagation();
            toggleFavorite(movie.id);
          }}
          className="absolute top-3 right-3 p-2 rounded-full bg-black/50 backdrop-blur-sm opacity-0 group-hover:opacity-100 transition-opacity"
        >
          <Heart 
            className={\`w-5 h-5 \${isFavorite(movie.id) ? 'fill-[#E50914] text-[#E50914]' : 'text-white'}\`} 
          />
        </button>

        <motion.div 
          initial={{ opacity: 0, y: 20 }}
          whileHover={{ opacity: 1, y: 0 }}
          className="absolute bottom-0 left-0 right-0 p-4 opacity-0 group-hover:opacity-100 transition-opacity"
        >
          <Button 
            onClick={handleBook}
            className="w-full bg-[#E50914] hover:bg-[#b20710] text-white"
          >
            Book Tickets
          </Button>
        </motion.div>
      </div>

      <div className="p-4">
        <h3 className="font-semibold text-white truncate">{movie.title}</h3>
        <div className="flex items-center justify-between mt-2 text-sm text-gray-400">
          <span className="flex items-center gap-1">
            <Star className="w-3 h-3 text-yellow-500" /> {movie.rating}
          </span>
          <span>{movie.year}</span>
        </div>
        <div className="mt-2 flex flex-wrap gap-1">
          {movie.genre.slice(0, 2).map((g) => (
            <Badge key={g} variant="outline" className="text-xs border-white/20">
              {g}
            </Badge>
          ))}
        </div>
      </div>
    </motion.div>
  );
}
EOF

cat > src/components/ui/SeatGrid.tsx << 'EOF'
'use client';

import { motion } from 'framer-motion';
import { Seat } from '@/types';
import { cn } from '@/lib/utils';

interface SeatGridProps {
  seats: Seat[];
  selectedSeats: string[];
  onSeatClick: (seat: Seat) => void;
  maxSeats?: number;
}

export function SeatGrid({ seats, selectedSeats, onSeatClick, maxSeats = 8 }: SeatGridProps) {
  const rows = Array.from(new Set(seats.map(s => s.row))).sort();
  
  const getSeatColor = (seat: Seat) => {
    if (seat.status === 'reserved') return 'bg-gray-700 cursor-not-allowed';
    if (selectedSeats.includes(seat.id)) return 'bg-[#E50914] shadow-[0_0_15px_rgba(229,9,20,0.6)] scale-110';
    if (seat.status === 'vip') return 'bg-amber-500/20 border-amber-500 hover:bg-amber-500/40';
    return 'bg-gray-600 hover:bg-gray-500';
  };

  return (
    <div className="w-full overflow-x-auto pb-4">
      <div className="min-w-[600px]">
        <div className="relative mb-12">
          <div className="h-2 bg-gradient-to-r from-transparent via-white/30 to-transparent rounded-full mb-2" />
          <p className="text-center text-xs text-gray-500 uppercase tracking-widest">Screen</p>
        </div>

        <div className="space-y-3">
          {rows.map((row) => (
            <div key={row} className="flex items-center justify-center gap-2">
              <span className="w-6 text-sm text-gray-500 font-mono">{row}</span>
              <div className="flex gap-2">
                {seats
                  .filter(s => s.row === row)
                  .sort((a, b) => a.number - b.number)
                  .map((seat) => (
                    <motion.button
                      key={seat.id}
                      whileHover={seat.status !== 'reserved' ? { scale: 1.1 } : {}}
                      whileTap={seat.status !== 'reserved' ? { scale: 0.95 } : {}}
                      onClick={() => {
                        if (seat.status !== 'reserved') {
                          if (selectedSeats.includes(seat.id) || selectedSeats.length < maxSeats) {
                            onSeatClick(seat);
                          }
                        }
                      }}
                      disabled={seat.status === 'reserved'}
                      className={cn(
                        "w-8 h-8 rounded-lg transition-all duration-300 border border-transparent",
                        getSeatColor(seat),
                        seat.status === 'vip' && !selectedSeats.includes(seat.id) && 'border-amber-500'
                      )}
                    >
                      <span className="sr-only">Seat {seat.row}{seat.number}</span>
                    </motion.button>
                  ))}
              </div>
              <span className="w-6 text-sm text-gray-500 font-mono">{row}</span>
            </div>
          ))}
        </div>

        <div className="flex justify-center gap-6 mt-8 text-sm">
          <div className="flex items-center gap-2">
            <div className="w-4 h-4 rounded bg-gray-600" />
            <span className="text-gray-400">Available</span>
          </div>
          <div className="flex items-center gap-2">
            <div className="w-4 h-4 rounded bg-[#E50914] shadow-[0_0_10px_rgba(229,9,20,0.5)]" />
            <span className="text-gray-400">Selected</span>
          </div>
          <div className="flex items-center gap-2">
            <div className="w-4 h-4 rounded bg-gray-700" />
            <span className="text-gray-400">Reserved</span>
          </div>
          <div className="flex items-center gap-2">
            <div className="w-4 h-4 rounded bg-amber-500/20 border border-amber-500" />
            <span className="text-gray-400">VIP</span>
          </div>
        </div>
      </div>
    </div>
  );
}
EOF

cat > src/components/ui/Navigation.tsx << 'EOF'
'use client';

import { useState, useEffect } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { Menu, X, Film, Ticket, Image, BookOpen } from 'lucide-react';
import { cn } from '@/lib/utils';

const navItems = [
  { href: '/', label: 'Home', icon: Film },
  { href: '/galleries', label: 'Galleries', icon: Image },
  { href: '/journal', label: 'Journal', icon: BookOpen },
  { href: '/book', label: 'Book Tickets', icon: Ticket },
];

export function Navigation() {
  const [isScrolled, setIsScrolled] = useState(false);
  const [isMobileMenuOpen, setIsMobileMenuOpen] = useState(false);
  const pathname = usePathname();

  useEffect(() => {
    const handleScroll = () => {
      setIsScrolled(window.scrollY > 50);
    };
    window.addEventListener('scroll', handleScroll);
    return () => window.removeEventListener('scroll', handleScroll);
  }, []);

  return (
    <>
      <motion.nav
        initial={{ y: -100 }}
        animate={{ y: 0 }}
        className={cn(
          "fixed top-0 left-0 right-0 z-50 transition-all duration-500",
          isScrolled ? 'bg-[#0B0B0F]/90 backdrop-blur-lg border-b border-white/5' : 'bg-transparent'
        )}
      >
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex items-center justify-between h-20">
            <Link href="/" className="flex items-center gap-2">
              <motion.div
                whileHover={{ rotate: 180 }}
                transition={{ duration: 0.5 }}
                className="w-10 h-10 rounded-full bg-[#E50914] flex items-center justify-center"
              >
                <Film className="w-5 h-5 text-white" />
              </motion.div>
              <span className="text-xl font-bold text-white tracking-tight">CINEVERSE</span>
            </Link>

            <div className="hidden md:flex items-center gap-8">
              {navItems.map((item) => (
                <Link key={item.href} href={item.href} className="relative group">
                  <span className={cn(
                    "text-sm font-medium transition-colors",
                    pathname === item.href ? 'text-white' : 'text-gray-400 hover:text-white'
                  )}>
                    {item.label}
                  </span>
                  {pathname === item.href && (
                    <motion.div
                      layoutId="nav-underline"
                      className="absolute -bottom-1 left-0 right-0 h-0.5 bg-[#E50914]"
                    />
                  )}
                  <span className="absolute -bottom-1 left-0 w-0 h-0.5 bg-[#E50914] transition-all group-hover:w-full" />
                </Link>
              ))}
            </div>

            <button
              onClick={() => setIsMobileMenuOpen(!isMobileMenuOpen)}
              className="md:hidden p-2 text-white"
            >
              {isMobileMenuOpen ? <X className="w-6 h-6" /> : <Menu className="w-6 h-6" />}
            </button>
          </div>
        </div>
      </motion.nav>

      <AnimatePresence>
        {isMobileMenuOpen && (
          <motion.div
            initial={{ opacity: 0, x: '100%' }}
            animate={{ opacity: 1, x: 0 }}
            exit={{ opacity: 0, x: '100%' }}
            transition={{ type: 'spring', damping: 25, stiffness: 200 }}
            className="fixed inset-0 z-40 bg-[#0B0B0F] md:hidden pt-20"
          >
            <div className="flex flex-col p-6 gap-4">
              {navItems.map((item, i) => (
                <motion.div
                  key={item.href}
                  initial={{ opacity: 0, x: 20 }}
                  animate={{ opacity: 1, x: 0 }}
                  transition={{ delay: i * 0.1 }}
                >
                  <Link
                    href={item.href}
                    onClick={() => setIsMobileMenuOpen(false)}
                    className={cn(
                      "flex items-center gap-3 p-4 rounded-xl transition-colors",
                      pathname === item.href ? 'bg-[#E50914]/20 text-[#E50914]' : 'text-gray-400 hover:bg-white/5'
                    )}
                  >
                    <item.icon className="w-5 h-5" />
                    <span className="text-lg font-medium">{item.label}</span>
                  </Link>
                </motion.div>
              ))}
            </div>
          </motion.div>
        )}
      </AnimatePresence>
    </>
  );
}
EOF

echo "Components created successfully!"