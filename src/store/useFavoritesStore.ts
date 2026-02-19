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
