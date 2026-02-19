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
