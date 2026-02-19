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
