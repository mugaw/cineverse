#!/bin/bash

# Create page files
mkdir -p src/app/galleries src/app/journal src/app/book

# Home Page
cat > src/app/page.tsx << 'EOF'
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
EOF

# Galleries Page
cat > src/app/galleries/page.tsx << 'EOF'
'use client';

import { useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import Image from 'next/image';
import { X, ChevronLeft, ChevronRight, MapPin, Camera } from 'lucide-react';
import { useLenis } from '@/hooks/useLenis';
import { TextReveal } from '@/components/animations/TextReveal';

const galleryItems = [
  {
    id: '1',
    title: 'Neon Nights',
    description: 'Capturing the vibrant energy of midnight premieres and the glow of marquee lights against the urban landscape.',
    imageUrl: 'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?w=1200&auto=format&fit=crop&q=80',
    category: 'Urban',
    location: 'New York City'
  },
  {
    id: '2',
    title: 'The Projectionist',
    description: 'A intimate look at the art of film projection in the digital age, preserving the magic of analog cinema.',
    imageUrl: 'https://images.unsplash.com/photo-1478720568477-152d9b164e26?w=1200&auto=format&fit=crop&q=80',
    category: 'Portrait',
    location: 'Los Angeles'
  },
  {
    id: '3',
    title: 'Silver Screen Dreams',
    description: 'Abstract interpretations of classic cinema moments, reimagined through modern lens.',
    imageUrl: 'https://images.unsplash.com/photo-1517604931442-7e0c8ed2963c?w=1200&auto=format&fit=crop&q=80',
    category: 'Abstract',
    location: 'London'
  },
  {
    id: '4',
    title: 'Behind the Velvet Rope',
    description: 'Exclusive access to red carpet events and the glamour of film premieres.',
    imageUrl: 'https://images.unsplash.com/photo-1536440136628-849c177e76a1?w=1200&auto=format&fit=crop&q=80',
    category: 'Event',
    location: 'Cannes'
  },
  {
    id: '5',
    title: 'The Last Reel',
    description: 'Documenting the endangered art of film preservation and archive restoration.',
    imageUrl: 'https://images.unsplash.com/photo-1440404653325-ab127d49abc1?w=1200&auto=format&fit=crop&q=80',
    category: 'Documentary',
    location: 'Berlin'
  },
  {
    id: '6',
    title: 'Cinema Architecture',
    description: 'Exploring the grand theaters and art deco palaces of cinema\'s golden age.',
    imageUrl: 'https://images.unsplash.com/photo-1518676590629-3dcbd9c5a5c9?w=1200&auto=format&fit=crop&q=80',
    category: 'Architecture',
    location: 'Paris'
  }
];

export default function GalleriesPage() {
  useLenis();
  const [selectedImage, setSelectedImage] = useState<typeof galleryItems[0] | null>(null);
  const [currentIndex, setCurrentIndex] = useState(0);

  const openLightbox = (item: typeof galleryItems[0], index: number) => {
    setSelectedImage(item);
    setCurrentIndex(index);
  };

  const navigate = (direction: 'prev' | 'next') => {
    const newIndex = direction === 'next' 
      ? (currentIndex + 1) % galleryItems.length
      : (currentIndex - 1 + galleryItems.length) % galleryItems.length;
    setCurrentIndex(newIndex);
    setSelectedImage(galleryItems[newIndex]);
  };

  return (
    <main className="min-h-screen bg-[#0B0B0F] pt-20">
      <section className="relative h-[60vh] flex items-center justify-center overflow-hidden">
        <div className="absolute inset-0">
          <Image
            src="https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?w=1920&auto=format&fit=crop&q=80"
            alt="Gallery Hero"
            fill
            className="object-cover opacity-40"
          />
          <div className="absolute inset-0 bg-gradient-to-b from-[#0B0B0F] via-transparent to-[#0B0B0F]" />
        </div>
        
        <div className="relative z-10 text-center px-4">
          <TextReveal 
            text="Key Photography Works" 
            className="text-4xl md:text-6xl font-bold text-white mb-6"
          />
          <p className="text-gray-400 max-w-2xl mx-auto text-lg">
            A curated collection of cinematic photography capturing the essence of film culture, 
            theater architecture, and the magic of the movies.
          </p>
        </div>
      </section>

      <section className="py-20 px-4 md:px-8 max-w-7xl mx-auto">
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {galleryItems.map((item, index) => (
            <motion.div
              key={item.id}
              initial={{ opacity: 0, y: 20 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }}
              transition={{ delay: index * 0.1 }}
              className="group cursor-pointer"
              onClick={() => openLightbox(item, index)}
            >
              <div className="relative aspect-[4/5] overflow-hidden rounded-xl bg-[#1a1a2e]">
                <Image
                  src={item.imageUrl}
                  alt={item.title}
                  fill
                  className="object-cover transition-transform duration-700 group-hover:scale-110"
                />
                <div className="absolute inset-0 bg-gradient-to-t from-[#0B0B0F] via-transparent to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300" />
                
                <div className="absolute bottom-0 left-0 right-0 p-6 translate-y-full group-hover:translate-y-0 transition-transform duration-300">
                  <span className="text-[#E50914] text-sm font-medium uppercase tracking-wider">
                    {item.category}
                  </span>
                  <h3 className="text-xl font-bold text-white mt-2">{item.title}</h3>
                  <div className="flex items-center gap-2 text-gray-400 text-sm mt-2">
                    <MapPin className="w-4 h-4" />
                    {item.location}
                  </div>
                </div>
              </div>
            </motion.div>
          ))}
        </div>
      </section>

      <AnimatePresence>
        {selectedImage && (
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            className="fixed inset-0 z-50 bg-black/95 backdrop-blur-xl flex items-center justify-center"
            onClick={() => setSelectedImage(null)}
          >
            <button
              onClick={() => setSelectedImage(null)}
              className="absolute top-6 right-6 p-2 text-white/70 hover:text-white transition-colors"
            >
              <X className="w-8 h-8" />
            </button>

            <button
              onClick={(e) => { e.stopPropagation(); navigate('prev'); }}
              className="absolute left-6 p-3 rounded-full bg-white/10 hover:bg-white/20 text-white transition-colors"
            >
              <ChevronLeft className="w-6 h-6" />
            </button>

            <button
              onClick={(e) => { e.stopPropagation(); navigate('next'); }}
              className="absolute right-6 p-3 rounded-full bg-white/10 hover:bg-white/20 text-white transition-colors"
            >
              <ChevronRight className="w-6 h-6" />
            </button>

            <motion.div
              initial={{ scale: 0.9, opacity: 0 }}
              animate={{ scale: 1, opacity: 1 }}
              exit={{ scale: 0.9, opacity: 0 }}
              className="max-w-5xl w-full mx-4"
              onClick={(e) => e.stopPropagation()}
            >
              <div className="relative aspect-[16/9] rounded-xl overflow-hidden">
                <Image
                  src={selectedImage.imageUrl}
                  alt={selectedImage.title}
                  fill
                  className="object-cover"
                />
              </div>
              
              <div className="mt-6 text-center">
                <span className="text-[#E50914] text-sm font-medium uppercase tracking-wider">
                  {selectedImage.category}
                </span>
                <h2 className="text-3xl font-bold text-white mt-2">{selectedImage.title}</h2>
                <p className="text-gray-400 mt-3 max-w-2xl mx-auto">{selectedImage.description}</p>
                <div className="flex items-center justify-center gap-2 text-gray-500 text-sm mt-4">
                  <Camera className="w-4 h-4" />
                  <span>Shot on location in {selectedImage.location}</span>
                </div>
              </div>
            </motion.div>
          </motion.div>
        )}
      </AnimatePresence>
    </main>
  );
}
EOF

# Journal Page
cat > src/app/journal/page.tsx << 'EOF'
'use client';

import { useState } from 'react';
import { motion } from 'framer-motion';
import Image from 'next/image';
import { Heart, Clock, ArrowRight, Calendar } from 'lucide-react';
import { useLenis } from '@/hooks/useLenis';
import { TextReveal } from '@/components/animations/TextReveal';
import { JournalEntry } from '@/types';

const journalEntries: JournalEntry[] = [
  {
    id: '1',
    title: 'The Art of Cinematography in Modern Film',
    date: '2024-02-15',
    content: 'Exploring how contemporary directors are pushing the boundaries of visual storytelling. From the neon-drenched streets of Blade Runner 2049 to the intimate 35mm grain of Licorice Pizza, modern cinematography continues to evolve while honoring its roots.',
    imageUrl: 'https://images.unsplash.com/photo-1485846234645-a62644f84728?w=800&auto=format&fit=crop&q=80',
    category: 'Analysis',
    likes: 234
  },
  {
    id: '2',
    title: 'Why Film Festivals Still Matter in the Streaming Age',
    date: '2024-02-10',
    content: 'In an era where any film can be released directly to millions of homes, the theatrical experience of film festivals offers something irreplaceable: community, curation, and the collective gasp of an audience experiencing art together.',
    imageUrl: 'https://images.unsplash.com/photo-1517604931442-7e0c8ed2963c?w=800&auto=format&fit=crop&q=80',
    category: 'Opinion',
    likes: 189
  },
  {
    id: '3',
    title: 'Restoring Classics: The Digital vs. Analog Debate',
    date: '2024-02-05',
    content: 'As more classic films receive 4K restorations, purists argue about the authenticity of digital intermediates. We examine both sides of the preservation argument and what it means for cinema history.',
    imageUrl: 'https://images.unsplash.com/photo-1440404653325-ab127d49abc1?w=800&auto=format&fit=crop&q=80',
    category: 'Technical',
    likes: 156
  },
  {
    id: '4',
    title: 'A Day in the Life: IMAX Projection Booth',
    date: '2024-01-28',
    content: 'Behind the massive screen lies a world of precision engineering and passionate technicians. We spent 24 hours in an IMAX booth to understand what it takes to deliver those crystal-clear images.',
    imageUrl: 'https://images.unsplash.com/photo-1478720568477-152d9b164e26?w=800&auto=format&fit=crop&q=80',
    category: 'Behind the Scenes',
    likes: 312
  },
  {
    id: '5',
    title: 'The Return of Practical Effects',
    date: '2024-01-20',
    content: 'After years of CGI dominance, filmmakers are returning to practical effects. From Dune\'s sandworms to Mission Impossible\'s stunts, physical filmmaking is experiencing a renaissance.',
    imageUrl: 'https://images.unsplash.com/photo-1536440136628-849c177e76a1?w=800&auto=format&fit=crop&q=80',
    category: 'Trends',
    likes: 278
  }
];

export default function JournalPage() {
  useLenis();
  const [likedPosts, setLikedPosts] = useState<string[]>([]);

  const toggleLike = (id: string) => {
    setLikedPosts(prev => 
      prev.includes(id) ? prev.filter(p => p !== id) : [...prev, id]
    );
  };

  return (
    <main className="min-h-screen bg-[#0B0B0F] pt-20">
      <section className="relative py-20 px-4 md:px-8 border-b border-white/5">
        <div className="max-w-4xl mx-auto text-center">
          <motion.div
            initial={{ opacity: 0, scale: 0.9 }}
            animate={{ opacity: 1, scale: 1 }}
            className="inline-block p-3 rounded-full bg-[#E50914]/10 mb-6"
          >
            <Calendar className="w-6 h-6 text-[#E50914]" />
          </motion.div>
          <TextReveal 
            text="Daily Photo Works" 
            className="text-4xl md:text-6xl font-bold text-white mb-6"
          />
          <p className="text-gray-400 text-lg max-w-2xl mx-auto">
            Thoughts, stories, and behind-the-scenes glimpses from the world of cinema. 
            A daily journal of film culture and photography.
          </p>
        </div>
      </section>

      <section className="py-20 px-4 md:px-8 max-w-4xl mx-auto">
        <div className="space-y-16">
          {journalEntries.map((entry, index) => (
            <motion.article
              key={entry.id}
              initial={{ opacity: 0, y: 30 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true, margin: "-100px" }}
              transition={{ duration: 0.6, delay: index * 0.1 }}
              className="group"
            >
              <div className="grid md:grid-cols-2 gap-8 items-center">
                <div className={\`relative aspect-[4/3] rounded-xl overflow-hidden \${index % 2 === 1 ? 'md:order-2' : ''}\`}>
                  <Image
                    src={entry.imageUrl}
                    alt={entry.title}
                    fill
                    className="object-cover transition-transform duration-700 group-hover:scale-105"
                  />
                  <div className="absolute top-4 left-4">
                    <span className="px-3 py-1 bg-[#E50914] text-white text-xs font-medium rounded-full">
                      {entry.category}
                    </span>
                  </div>
                </div>

                <div className={index % 2 === 1 ? 'md:order-1' : ''}>
                  <div className="flex items-center gap-4 text-sm text-gray-500 mb-3">
                    <span className="flex items-center gap-1">
                      <Clock className="w-4 h-4" />
                      {new Date(entry.date).toLocaleDateString('en-US', { 
                        month: 'long', 
                        day: 'numeric', 
                        year: 'numeric' 
                      })}
                    </span>
                  </div>
                  
                  <h2 className="text-2xl md:text-3xl font-bold text-white mb-4 group-hover:text-[#E50914] transition-colors">
                    {entry.title}
                  </h2>
                  
                  <p className="text-gray-400 leading-relaxed mb-6 line-clamp-3">
                    {entry.content}
                  </p>

                  <div className="flex items-center justify-between">
                    <button className="flex items-center gap-2 text-white font-medium group/btn">
                      Read More 
                      <ArrowRight className="w-4 h-4 group-hover/btn:translate-x-1 transition-transform" />
                    </button>
                    
                    <button 
                      onClick={() => toggleLike(entry.id)}
                      className="flex items-center gap-2 text-gray-400 hover:text-[#E50914] transition-colors"
                    >
                      <Heart 
                        className={\`w-5 h-5 \${likedPosts.includes(entry.id) ? 'fill-[#E50914] text-[#E50914]' : ''}\`} 
                      />
                      <span>{entry.likes + (likedPosts.includes(entry.id) ? 1 : 0)}</span>
                    </button>
                  </div>
                </div>
              </div>
            </motion.article>
          ))}
        </div>
      </section>
    </main>
  );
}
EOF

# Booking Page
cat > src/app/book/page.tsx << 'EOF'
'use client';

import { useState, useMemo } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import * as z from 'zod';
import { format } from 'date-fns';
import { 
  Calendar, 
  Clock, 
  Armchair, 
  CreditCard, 
  Check, 
  ChevronLeft, 
  ChevronRight,
  Ticket,
  Popcorn
} from 'lucide-react';
import { useLenis } from '@/hooks/useLenis';
import { useBookingStore } from '@/store/useBookingStore';
import { movies } from '@/data/movies';
import { Seat, Movie } from '@/types';
import { SeatGrid } from '@/components/ui/SeatGrid';
import { CinemaHall } from '@/components/3d/CinemaHall';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Dialog, DialogContent, DialogHeader, DialogTitle } from '@/components/ui/dialog';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { TextReveal } from '@/components/animations/TextReveal';

const bookingSchema = z.object({
  name: z.string().min(2, 'Name must be at least 2 characters'),
  email: z.string().email('Invalid email address'),
  date: z.string().min(1, 'Please select a date'),
  showtime: z.string().min(1, 'Please select a showtime'),
});

type BookingFormData = z.infer<typeof bookingSchema>;

const showtimes = ['10:00 AM', '1:30 PM', '5:00 PM', '8:30 PM', '11:00 PM'];

export default function BookPage() {
  useLenis();
  const [step, setStep] = useState(1);
  const [isSuccess, setIsSuccess] = useState(false);
  const [searchQuery, setSearchQuery] = useState('');
  
  const { 
    selectedMovie, 
    setSelectedMovie, 
    selectedSeats, 
    toggleSeat, 
    clearSeats,
    setBookingDate,
    setShowtime,
    totalPrice 
  } = useBookingStore();

  const { register, handleSubmit, formState: { errors }, setValue, watch } = useForm<BookingFormData>({
    resolver: zodResolver(bookingSchema),
  });

  const seats = useMemo(() => {
    const rows = 'ABCDEFGHIJ'.split('');
    const seatsPerRow = 12;
    const generatedSeats: Seat[] = [];
    
    rows.forEach((row, rowIndex) => {
      for (let i = 1; i <= seatsPerRow; i++) {
        const isVIP = rowIndex < 2;
        const isReserved = Math.random() < 0.2;
        
        generatedSeats.push({
          id: \`\${row}\${i}\`,
          row,
          number: i,
          status: isReserved ? 'reserved' : isVIP ? 'vip' : 'available',
          price: isVIP ? 20 : 12.99,
        });
      }
    });
    return generatedSeats;
  }, [selectedMovie]);

  const filteredMovies = movies.filter(m => 
    m.title.toLowerCase().includes(searchQuery.toLowerCase()) ||
    m.genre.some(g => g.toLowerCase().includes(searchQuery.toLowerCase()))
  );

  const onSubmit = (data: BookingFormData) => {
    setBookingDate(data.date);
    setShowtime(data.showtime);
    setIsSuccess(true);
  };

  const handleMovieSelect = (movie: Movie) => {
    setSelectedMovie(movie);
    clearSeats();
    setStep(2);
  };

  const handleSeatConfirm = () => {
    if (selectedSeats.length > 0) {
      setStep(3);
    }
  };

  return (
    <main className="min-h-screen bg-[#0B0B0F] pt-20">
      <div className="sticky top-20 z-30 bg-[#0B0B0F]/95 backdrop-blur-lg border-b border-white/5">
        <div className="max-w-7xl mx-auto px-4 md:px-8 py-4">
          <div className="flex items-center justify-center gap-4 md:gap-8">
            {[
              { num: 1, label: 'Select Movie', icon: Ticket },
              { num: 2, label: 'Choose Seats', icon: Armchair },
              { num: 3, label: 'Payment', icon: CreditCard },
            ].map((s, i) => (
              <div key={s.num} className="flex items-center">
                <div className={\`flex items-center gap-2 px-4 py-2 rounded-full \${
                  step >= s.num ? 'bg-[#E50914]/20 text-[#E50914]' : 'bg-white/5 text-gray-500'
                }\`}>
                  <s.icon className="w-4 h-4" />
                  <span className="hidden md:inline text-sm font-medium">{s.label}</span>
                  <span className="md:hidden text-sm font-medium">{s.num}</span>
                </div>
                {i < 2 && (
                  <ChevronRight className="w-4 h-4 text-gray-600 mx-2 md:mx-4" />
                )}
              </div>
            ))}
          </div>
        </div>
      </div>

      <div className="max-w-7xl mx-auto px-4 md:px-8 py-8">
        <AnimatePresence mode="wait">
          {step === 1 && (
            <motion.div
              key="step1"
              initial={{ opacity: 0, x: 20 }}
              animate={{ opacity: 1, x: 0 }}
              exit={{ opacity: 0, x: -20 }}
            >
              <div className="text-center mb-12">
                <TextReveal 
                  text="Select Your Movie" 
                  className="text-3xl md:text-5xl font-bold text-white mb-4"
                />
                <p className="text-gray-400">Choose from our collection of premium films</p>
              </div>

              <div className="max-w-md mx-auto mb-8">
                <Input
                  placeholder="Search movies or genres..."
                  value={searchQuery}
                  onChange={(e) => setSearchQuery(e.target.value)}
                  className="bg-white/5 border-white/10 text-white placeholder:text-gray-500"
                />
              </div>

              <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4 md:gap-6">
                {filteredMovies.slice(0, 12).map((movie, index) => (
                  <motion.div
                    key={movie.id}
                    initial={{ opacity: 0, y: 20 }}
                    animate={{ opacity: 1, y: 0 }}
                    transition={{ delay: index * 0.05 }}
                    onClick={() => handleMovieSelect(movie)}
                    className={\`cursor-pointer group relative rounded-xl overflow-hidden aspect-[2/3] border-2 transition-all \${
                      selectedMovie?.id === movie.id 
                        ? 'border-[#E50914] ring-2 ring-[#E50914]/50' 
                        : 'border-transparent hover:border-white/20'
                    }\`}
                  >
                    <img 
                      src={movie.posterUrl} 
                      alt={movie.title}
                      className="w-full h-full object-cover"
                    />
                    <div className="absolute inset-0 bg-gradient-to-t from-black via-transparent to-transparent opacity-0 group-hover:opacity-100 transition-opacity" />
                    <div className="absolute bottom-0 left-0 right-0 p-4 translate-y-full group-hover:translate-y-0 transition-transform">
                      <p className="text-white font-semibold truncate">{movie.title}</p>
                      <p className="text-[#E50914]">\${movie.price}</p>
                    </div>
                    {selectedMovie?.id === movie.id && (
                      <div className="absolute top-2 right-2 w-8 h-8 bg-[#E50914] rounded-full flex items-center justify-center">
                        <Check className="w-5 h-5 text-white" />
                      </div>
                    )}
                  </motion.div>
                ))}
              </div>
            </motion.div>
          )}

          {step === 2 && selectedMovie && (
            <motion.div
              key="step2"
              initial={{ opacity: 0, x: 20 }}
              animate={{ opacity: 1, x: 0 }}
              exit={{ opacity: 0, x: -20 }}
              className="grid lg:grid-cols-3 gap-8"
            >
              <div className="lg:col-span-2">
                <div className="bg-[#1a1a2e] rounded-2xl p-6 md:p-8">
                  <div className="flex items-center justify-between mb-6">
                    <div>
                      <h2 className="text-2xl font-bold text-white">{selectedMovie.title}</h2>
                      <p className="text-gray-400">Select your preferred seats</p>
                    </div>
                    <Button variant="outline" onClick={() => setStep(1)} className="border-white/10">
                      <ChevronLeft className="w-4 h-4 mr-2" />
                      Back
                    </Button>
                  </div>

                  <SeatGrid
                    seats={seats}
                    selectedSeats={selectedSeats.map(s => s.id)}
                    onSeatClick={(seat) => toggleSeat(seat)}
                  />
                </div>

                <div className="mt-8">
                  <h3 className="text-lg font-semibold text-white mb-4">3D Hall Preview</h3>
                  <CinemaHall 
                    selectedSeats={selectedSeats.map(s => s.id)}
                    onSeatClick={(seatId) => {
                      const seat = seats.find(s => s.id === seatId);
                      if (seat) toggleSeat(seat);
                    }}
                  />
                </div>
              </div>

              <div className="lg:col-span-1">
                <div className="sticky top-40 bg-[#1a1a2e] rounded-2xl p-6 border border-white/5">
                  <h3 className="text-xl font-bold text-white mb-6">Booking Summary</h3>
                  
                  <div className="space-y-4 mb-6">
                    <div className="flex justify-between text-sm">
                      <span className="text-gray-400">Movie</span>
                      <span className="text-white font-medium truncate max-w-[150px]">{selectedMovie.title}</span>
                    </div>
                    <div className="flex justify-between text-sm">
                      <span className="text-gray-400">Date</span>
                      <span className="text-white">{format(new Date(), 'MMM dd, yyyy')}</span>
                    </div>
                    <div className="flex justify-between text-sm">
                      <span className="text-gray-400">Seats</span>
                      <span className="text-white">{selectedSeats.length > 0 ? selectedSeats.map(s => s.id).join(', ') : 'None selected'}</span>
                    </div>
                  </div>

                  <div className="border-t border-white/10 pt-4 mb-6">
                    <div className="flex justify-between items-center">
                      <span className="text-gray-400">Total</span>
                      <span className="text-2xl font-bold text-[#E50914]">\${totalPrice().toFixed(2)}</span>
                    </div>
                  </div>

                  <Button 
                    onClick={handleSeatConfirm}
                    disabled={selectedSeats.length === 0}
                    className="w-full bg-[#E50914] hover:bg-[#b20710] text-white py-6 disabled:opacity-50"
                  >
                    Continue to Payment
                  </Button>

                  <p className="text-xs text-gray-500 text-center mt-4">
                    {selectedSeats.length} seats selected • Max 8 seats per booking
                  </p>
                </div>
              </div>
            </motion.div>
          )}

          {step === 3 && selectedMovie && (
            <motion.div
              key="step3"
              initial={{ opacity: 0, x: 20 }}
              animate={{ opacity: 1, x: 0 }}
              exit={{ opacity: 0, x: -20 }}
              className="max-w-2xl mx-auto"
            >
              <div className="bg-[#1a1a2e] rounded-2xl p-8 border border-white/5">
                <div className="flex items-center justify-between mb-8">
                  <h2 className="text-2xl font-bold text-white">Complete Your Booking</h2>
                  <Button variant="ghost" onClick={() => setStep(2)} className="text-gray-400">
                    <ChevronLeft className="w-4 h-4 mr-2" />
                    Back
                  </Button>
                </div>

                <form onSubmit={handleSubmit(onSubmit)} className="space-y-6">
                  <div className="grid md:grid-cols-2 gap-6">
                    <div className="space-y-2">
                      <Label htmlFor="name" className="text-white">Full Name</Label>
                      <Input
                        id="name"
                        {...register('name')}
                        className="bg-white/5 border-white/10 text-white"
                        placeholder="John Doe"
                      />
                      {errors.name && (
                        <p className="text-[#E50914] text-sm">{errors.name.message}</p>
                      )}
                    </div>

                    <div className="space-y-2">
                      <Label htmlFor="email" className="text-white">Email</Label>
                      <Input
                        id="email"
                        type="email"
                        {...register('email')}
                        className="bg-white/5 border-white/10 text-white"
                        placeholder="john@example.com"
                      />
                      {errors.email && (
                        <p className="text-[#E50914] text-sm">{errors.email.message}</p>
                      )}
                    </div>
                  </div>

                  <div className="grid md:grid-cols-2 gap-6">
                    <div className="space-y-2">
                      <Label htmlFor="date" className="text-white">Date</Label>
                      <div className="relative">
                        <Calendar className="absolute left-3 top-3 w-4 h-4 text-gray-400" />
                        <Input
                          id="date"
                          type="date"
                          {...register('date')}
                          className="bg-white/5 border-white/10 text-white pl-10"
                          min={format(new Date(), 'yyyy-MM-dd')}
                        />
                      </div>
                      {errors.date && (
                        <p className="text-[#E50914] text-sm">{errors.date.message}</p>
                      )}
                    </div>

                    <div className="space-y-2">
                      <Label className="text-white">Showtime</Label>
                      <Select onValueChange={(value) => setValue('showtime', value)}>
                        <SelectTrigger className="bg-white/5 border-white/10 text-white">
                          <SelectValue placeholder="Select time" />
                        </SelectTrigger>
                        <SelectContent className="bg-[#1a1a2e] border-white/10">
                          {showtimes.map((time) => (
                            <SelectItem key={time} value={time} className="text-white">
                              {time}
                            </SelectItem>
                          ))}
                        </SelectContent>
                      </Select>
                      {errors.showtime && (
                        <p className="text-[#E50914] text-sm">{errors.showtime.message}</p>
                      )}
                    </div>
                  </div>

                  <div className="bg-white/5 rounded-xl p-6 space-y-3">
                    <div className="flex justify-between text-sm">
                      <span className="text-gray-400">Movie</span>
                      <span className="text-white">{selectedMovie.title}</span>
                    </div>
                    <div className="flex justify-between text-sm">
                      <span className="text-gray-400">Seats</span>
                      <span className="text-white">{selectedSeats.map(s => s.id).join(', ')}</span>
                    </div>
                    <div className="flex justify-between text-sm">
                      <span className="text-gray-400">Tickets</span>
                      <span className="text-white">x{selectedSeats.length}</span>
                    </div>
                    <div className="border-t border-white/10 pt-3 flex justify-between items-center">
                      <span className="text-white font-medium">Total</span>
                      <span className="text-2xl font-bold text-[#E50914]">\${totalPrice().toFixed(2)}</span>
                    </div>
                  </div>

                  <Button 
                    type="submit"
                    className="w-full bg-[#E50914] hover:bg-[#b20710] text-white py-6 text-lg"
                  >
                    <CreditCard className="w-5 h-5 mr-2" />
                    Complete Booking
                  </Button>
                </form>
              </div>
            </motion.div>
          )}
        </AnimatePresence>
      </div>

      <Dialog open={isSuccess} onOpenChange={setIsSuccess}>
        <DialogContent className="bg-[#1a1a2e] border-white/10 text-white max-w-md">
          <DialogHeader>
            <DialogTitle className="text-center text-2xl">Booking Confirmed!</DialogTitle>
          </DialogHeader>
          <div className="text-center py-6">
            <motion.div
              initial={{ scale: 0 }}
              animate={{ scale: 1 }}
              className="w-20 h-20 bg-green-500/20 rounded-full flex items-center justify-center mx-auto mb-4"
            >
              <Check className="w-10 h-10 text-green-500" />
            </motion.div>
            <p className="text-gray-400 mb-2">Your tickets have been booked successfully!</p>
            <p className="text-sm text-gray-500">A confirmation email has been sent to your inbox.</p>
            
            <div className="mt-6 p-4 bg-white/5 rounded-lg text-left space-y-2">
              <p className="text-sm"><span className="text-gray-400">Movie:</span> {selectedMovie?.title}</p>
              <p className="text-sm"><span className="text-gray-400">Seats:</span> {selectedSeats.map(s => s.id).join(', ')}</p>
              <p className="text-sm"><span className="text-gray-400">Total:</span> \${totalPrice().toFixed(2)}</p>
            </div>

            <Button 
              onClick={() => {
                setIsSuccess(false);
                setStep(1);
                clearSeats();
                setSelectedMovie(null);
              }}
              className="mt-6 bg-[#E50914] hover:bg-[#b20710]"
            >
              Book Another Movie
            </Button>
          </div>
        </DialogContent>
      </Dialog>
    </main>
  );
}
EOF

# Create layout.tsx
cat > src/app/layout.tsx << 'EOF'
import type { Metadata } from 'next';
import { Inter } from 'next/font/google';
import './globals.css';
import { Navigation } from '@/components/ui/Navigation';
import { PageTransition } from '@/components/animations/PageTransition';
import { Toaster } from '@/components/ui/sonner';

const inter = Inter({ subsets: ['latin'] });

export const metadata: Metadata = {
  title: 'Cineverse - Premium Cinema Experience',
  description: 'Book tickets for the latest movies in our state-of-the-art theaters',
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en" className="dark">
      <body className={\`\${inter.className} bg-[#0B0B0F] text-white antialiased\`}>
        <Navigation />
        <PageTransition>
          {children}
        </PageTransition>
        <Toaster />
      </body>
    </html>
  );
}
EOF

# Create globals.css
cat > src/app/globals.css << 'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;

@layer base {
  :root {
    --background: 0 0% 4%;
    --foreground: 0 0% 98%;
    --card: 240 10% 8%;
    --card-foreground: 0 0% 98%;
    --popover: 240 10% 8%;
    --popover-foreground: 0 0% 98%;
    --primary: 0 84% 50%;
    --primary-foreground: 0 0% 98%;
    --secondary: 240 4% 16%;
    --secondary-foreground: 0 0% 98%;
    --muted: 240 4% 16%;
    --muted-foreground: 240 5% 65%;
    --accent: 240 4% 16%;
    --accent-foreground: 0 0% 98%;
    --destructive: 0 84% 60%;
    --destructive-foreground: 0 0% 98%;
    --border: 240 4% 16%;
    --input: 240 4% 16%;
    --ring: 0 84% 50%;
    --radius: 0.75rem;
  }
}

@layer base {
  * {
    @apply border-border;
  }
  body {
    @apply bg-background text-foreground;
  }
}

::-webkit-scrollbar {
  width: 8px;
  height: 8px;
}

::-webkit-scrollbar-track {
  background: #0B0B0F;
}

::-webkit-scrollbar-thumb {
  background: #333;
  border-radius: 4px;
}

::-webkit-scrollbar-thumb:hover {
  background: #E50914;
}

::selection {
  background: rgba(229, 9, 20, 0.3);
  color: white;
}

html {
  scroll-behavior: smooth;
}

.grain {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  pointer-events: none;
  z-index: 1000;
  opacity: 0.03;
  background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 200 200' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='noiseFilter'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23noiseFilter)'/%3E%3C/svg%3E");
}
EOF

# Create tailwind.config.ts
cat > tailwind.config.ts << 'EOF'
import type { Config } from "tailwindcss";

const config: Config = {
  darkMode: ["class"],
  content: [
    "./src/pages/**/*.{js,ts,jsx,tsx,mdx}",
    "./src/components/**/*.{js,ts,jsx,tsx,mdx}",
    "./src/app/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  theme: {
    extend: {
      colors: {
        border: "hsl(var(--border))",
        input: "hsl(var(--input))",
        ring: "hsl(var(--ring))",
        background: "hsl(var(--background))",
        foreground: "hsl(var(--foreground))",
        primary: {
          DEFAULT: "hsl(var(--primary))",
          foreground: "hsl(var(--primary-foreground))",
        },
        secondary: {
          DEFAULT: "hsl(var(--secondary))",
          foreground: "hsl(var(--secondary-foreground))",
        },
        destructive: {
          DEFAULT: "hsl(var(--destructive))",
          foreground: "hsl(var(--destructive-foreground))",
        },
        muted: {
          DEFAULT: "hsl(var(--muted))",
          foreground: "hsl(var(--muted-foreground))",
        },
        accent: {
          DEFAULT: "hsl(var(--accent))",
          foreground: "hsl(var(--accent-foreground))",
        },
        popover: {
          DEFAULT: "hsl(var(--popover))",
          foreground: "hsl(var(--popover-foreground))",
        },
        card: {
          DEFAULT: "hsl(var(--card))",
          foreground: "hsl(var(--card-foreground))",
        },
      },
      borderRadius: {
        lg: "var(--radius)",
        md: "calc(var(--radius) - 2px)",
        sm: "calc(var(--radius) - 4px)",
      },
      animation: {
        "fade-in": "fadeIn 0.5s ease-out",
        "slide-up": "slideUp 0.5s ease-out",
        "pulse-glow": "pulseGlow 2s ease-in-out infinite",
      },
      keyframes: {
        fadeIn: {
          "0%": { opacity: "0" },
          "100%": { opacity: "1" },
        },
        slideUp: {
          "0%": { transform: "translateY(20px)", opacity: "0" },
          "100%": { transform: "translateY(0)", opacity: "1" },
        },
        pulseGlow: {
          "0%, 100%": { boxShadow: "0 0 20px rgba(229, 9, 20, 0.3)" },
          "50%": { boxShadow: "0 0 40px rgba(229, 9, 20, 0.6)" },
        },
      },
    },
  },
  plugins: [require("tailwindcss-animate")],
};

export default config;
EOF

# Create next.config.js
cat > next.config.js << 'EOF'
/** @type {import('next').NextConfig} */
const nextConfig = {
  images: {
    remotePatterns: [
      {
        protocol: 'https',
        hostname: 'images.unsplash.com',
      },
    ],
  },
  typescript: {
    ignoreBuildErrors: false,
  },
};

module.exports = nextConfig;
EOF

echo "All page files and configuration files created successfully!"
echo "Project is now complete. Run 'npm run dev' to start development server."