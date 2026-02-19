'use client';

import { motion } from 'framer-motion';

export function TextReveal({ 
  text, 
  className = "" 
}: { 
  text: string; 
  className?: string 
}) {
  const words = text.split(" ");

  return (
    <motion.div className={className}>
      {words.map((word, i) => (
        <motion.span
          key={i}
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{
            duration: 0.5,
            delay: i * 0.05,
            ease: [0.22, 1, 0.36, 1] as any,
          }}
          className="inline-block mr-[0.25em]"
        >
          {word}
        </motion.span>
      ))}
    </motion.div>
  );
}
