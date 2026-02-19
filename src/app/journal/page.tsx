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
                <div className={`relative aspect-[4/3] rounded-xl overflow-hidden ${index % 2 === 1 ? 'md:order-2' : ''}`}>
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
                        className={`w-5 h-5 ${likedPosts.includes(entry.id) ? 'fill-[#E50914] text-[#E50914]' : ''}`} 
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
