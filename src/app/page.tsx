'use client';

import { useEffect } from 'react';
import { motion } from 'framer-motion';
import { CinemaReel } from '@/components/3d/CinemaReel';
import { MovieCard } from '@/components/ui/MovieCard';
import { TextReveal } from '@/components/animations/TextReveal';
import { StaggerContainer, StaggerItem } from '@/components/animations/StaggerContainer';
import { movies, getTrendingMovies, getNowShowing } from '@/data/movies';
import { useLenis } from '@/hooks/useLenis';
import { Sparkles, TrendingUp, Play } from 'lucide-react';
import { Button } from '@/components/ui/button';
import Link from 'next/link';

export default function Home() {
  useLenis();

  const trending = getTrendingMovies();
  const nowShowing = getNowShowing();

  return (
    <main className="min-h-screen bg-[#0B0B0F]">
      {/* Hero Section */}
      <section className="relative h-screen flex items-center justify-center overflow-hidden">
        <div className="absolute inset-0 bg-gradient-to-b from-transparent via-[#0B0B0F]/50 to-[#0B0B0F] z-10" />
        
        <div className="absolute inset-0 z-0">
          <CinemaReel />
        </div>

        <div className="relative z-20 text-center px-4 max-w-5xl mx-auto">
          <motion.div
            initial={{ opacity: 0, y: 30 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 1, delay: 0.5 }}
          >
            <TextReveal 
              text="Experience Cinema Like Never Before" 
              className="text-4xl md:text-6xl lg:text-7xl font-bold text-white mb-6 leading-tight"
            />
          </motion.div>
          
          <motion.p
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ delay: 1.2 }}
            className="text-lg md:text-xl text-gray-400 mb-8 max-w-2xl mx-auto"
          >
            Immerse yourself in the magic of movies with our premium theater experience. 
            Book your seats in our state-of-the-art 3D cinema halls.
          </motion.p>

          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 1.5 }}
            className="flex flex-col sm:flex-row gap-4 justify-center"
          >
            <Link href="/book">
              <Button 
                size="lg" 
                className="bg-[#E50914] hover:bg-[#b20710] text-white px-8 py-6 text-lg rounded-full group"
              >
                <Play className="w-5 h-5 mr-2 group-hover:scale-110 transition-transform" />
                Book Now
              </Button>
            </Link>
            <Link href="/galleries">
              <Button 
                size="lg" 
                variant="outline" 
                className="border-white/20 text-white hover:bg-white/10 px-8 py-6 text-lg rounded-full"
              >
                Explore Gallery
              </Button>
            </Link>
          </motion.div>
        </div>

        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ delay: 2, duration: 1 }}
          className="absolute bottom-10 left-1/2 -translate-x-1/2 z-20"
        >
          <div className="w-6 h-10 rounded-full border-2 border-white/30 flex justify-center pt-2">
            <motion.div
              animate={{ y: [0, 8, 0] }}
              transition={{ repeat: Infinity, duration: 1.5 }}
              className="w-1 h-2 bg-white/60 rounded-full"
            />
          </div>
        </motion.div>
      </section>

      {/* Trending Section */}
      <section className="py-20 px-4 md:px-8 max-w-7xl mx-auto">
        <div className="flex items-center gap-3 mb-12">
          <TrendingUp className="w-6 h-6 text-[#E50914]" />
          <h2 className="text-3xl md:text-4xl font-bold text-white">Trending Now</h2>
        </div>
        
        <StaggerContainer className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {trending.slice(0, 3).map((movie) => (
            <StaggerItem key={movie.id}>
              <MovieCard movie={movie} variant="featured" />
            </StaggerItem>
          ))}
        </StaggerContainer>
      </section>

      {/* Now Showing Grid */}
      <section className="py-20 px-4 md:px-8 max-w-7xl mx-auto bg-[#0f0f13]">
        <div className="flex items-center justify-between mb-12">
          <div className="flex items-center gap-3">
            <Sparkles className="w-6 h-6 text-[#E50914]" />
            <h2 className="text-3xl md:text-4xl font-bold text-white">Now Showing</h2>
          </div>
          <Link href="/book" className="text-[#E50914] hover:underline">
            View All
          </Link>
        </div>

        <StaggerContainer className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 xl:grid-cols-5 gap-4 md:gap-6">
          {nowShowing.map((movie) => (
            <StaggerItem key={movie.id}>
              <MovieCard movie={movie} />
            </StaggerItem>
          ))}
        </StaggerContainer>
      </section>

      {/* Stats Section */}
      <section className="py-20 px-4 md:px-8 border-t border-white/5">
        <div className="max-w-7xl mx-auto grid grid-cols-2 md:grid-cols-4 gap-8">
          {[
            { value: '100+', label: 'Movies' },
            { value: '12', label: 'Theaters' },
            { value: '50K+', label: 'Happy Viewers' },
            { value: '4K', label: 'Ultra HD' },
          ].map((stat, i) => (
            <motion.div
              key={stat.label}
              initial={{ opacity: 0, scale: 0.5 }}
              whileInView={{ opacity: 1, scale: 1 }}
              viewport={{ once: true }}
              transition={{ delay: i * 0.1 }}
              className="text-center"
            >
              <div className="text-4xl md:text-5xl font-bold text-[#E50914] mb-2">{stat.value}</div>
              <div className="text-gray-400">{stat.label}</div>
            </motion.div>
          ))}
        </div>
      </section>
    </main>
  );
}
