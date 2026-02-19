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
          id: `${row}${i}`,
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
                <div className={`flex items-center gap-2 px-4 py-2 rounded-full ${
                  step >= s.num ? 'bg-[#E50914]/20 text-[#E50914]' : 'bg-white/5 text-gray-500'
                }`}>
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
                    className={`cursor-pointer group relative rounded-xl overflow-hidden aspect-[2/3] border-2 transition-all ${
                      selectedMovie?.id === movie.id 
                        ? 'border-[#E50914] ring-2 ring-[#E50914]/50' 
                        : 'border-transparent hover:border-white/20'
                    }`}
                  >
                    <img 
                      src={movie.posterUrl} 
                      alt={movie.title}
                      className="w-full h-full object-cover"
                    />
                    <div className="absolute inset-0 bg-gradient-to-t from-black via-transparent to-transparent opacity-0 group-hover:opacity-100 transition-opacity" />
                    <div className="absolute bottom-0 left-0 right-0 p-4 translate-y-full group-hover:translate-y-0 transition-transform">
                      <p className="text-white font-semibold truncate">{movie.title}</p>
                      <p className="text-[#E50914]">${movie.price}</p>
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
                      <span className="text-2xl font-bold text-[#E50914]">${totalPrice().toFixed(2)}</span>
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
                      <span className="text-2xl font-bold text-[#E50914]">${totalPrice().toFixed(2)}</span>
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
              <p className="text-sm"><span className="text-gray-400">Total:</span> ${totalPrice().toFixed(2)}</p>
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
