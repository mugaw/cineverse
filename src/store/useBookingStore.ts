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
