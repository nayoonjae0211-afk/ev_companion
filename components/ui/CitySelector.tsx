'use client';

import { useEffect, useRef, useState } from 'react';
import { useCity } from '@/lib/city-context';
import { useLocale } from '@/lib/locale-context';
import type { City } from '@/lib/types';

export default function CitySelector() {
  const { selectedCity, setSelectedCity } = useCity();
  const { locale } = useLocale();
  const [cities, setCities] = useState<City[]>([]);
  const [open, setOpen] = useState(false);
  const ref = useRef<HTMLDivElement>(null);

  useEffect(() => {
    fetch('/api/cities')
      .then((r) => r.json())
      .then((data: City[]) => {
        setCities(data);
        if (!selectedCity && data.length > 0) {
          const seoul = data.find((c) => c.name_ko === '서울') ?? data[0];
          setSelectedCity(seoul);
        }
      })
      .catch((err) => console.error('Failed to fetch cities:', err));
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  useEffect(() => {
    const handler = (e: MouseEvent) => {
      if (ref.current && !ref.current.contains(e.target as Node)) setOpen(false);
    };
    document.addEventListener('mousedown', handler);
    return () => document.removeEventListener('mousedown', handler);
  }, []);

  const cityName = selectedCity
    ? locale === 'ko' ? selectedCity.name_ko : selectedCity.name_en
    : '...';

  return (
    <div ref={ref} className="relative">
      <button
        onClick={() => setOpen((o) => !o)}
        className="flex items-center gap-1.5 text-sm font-semibold text-white hover:text-sakura-300 transition-colors"
      >
        {cityName}
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5">
          <path d="M6 9l6 6 6-6" />
        </svg>
      </button>

      {open && (
        <div className="absolute top-full left-0 mt-2 w-44 glass rounded-xl shadow-2xl shadow-black/60 overflow-hidden z-50">
          <div className="max-h-72 overflow-y-auto py-1">
            {cities.map((city) => (
              <button
                key={city.id}
                onClick={() => { setSelectedCity(city); setOpen(false); }}
                className={`w-full text-left px-4 py-2.5 text-sm transition-colors ${
                  selectedCity?.id === city.id
                    ? 'text-sakura-400 bg-sakura-500/10'
                    : 'text-zinc-300 hover:bg-white/5'
                }`}
              >
                {locale === 'ko' ? city.name_ko : city.name_en}
              </button>
            ))}
          </div>
        </div>
      )}
    </div>
  );
}
