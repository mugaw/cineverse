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
            className={`w-5 h-5 ${isFavorite(movie.id) ? 'fill-[#E50914] text-[#E50914]' : 'text-white'}`} 
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
