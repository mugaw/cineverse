export interface Movie {
  id: string;
  title: string;
  year: number;
  genre: string[];
  duration: number;
  rating: number;
  posterUrl: string;
  bannerUrl: string;
  description: string;
  price: number;
  isTrending: boolean;
  isNowShowing: boolean;
  director: string;
  cast: string[];
}

export interface Seat {
  id: string;
  row: string;
  number: number;
  status: 'available' | 'reserved' | 'selected' | 'vip';
  price: number;
}

export interface BookingFormData {
  name: string;
  email: string;
  date: string;
  showtime: string;
  seats: string[];
  movieId: string;
  totalPrice: number;
}

export interface JournalEntry {
  id: string;
  title: string;
  date: string;
  content: string;
  imageUrl: string;
  category: string;
  likes: number;
}

export interface GalleryItem {
  id: string;
  title: string;
  description: string;
  imageUrl: string;
  category: string;
  location: string;
}
