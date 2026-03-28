'use client';

import { useEffect, useState } from 'react';
import { LocaleContext } from '@/lib/locale-context';
import { CityContext } from '@/lib/city-context';
import { STORAGE_KEYS } from '@/lib/constants';
import type { City } from '@/lib/types';
import type { Locale } from '@/lib/i18n';
import CitySelector from '@/components/ui/CitySelector';
import Navigation from '@/components/ui/Navigation';

export default function Providers({ children }: { children: React.ReactNode }) {
  const [locale, setLocale] = useState<Locale>('ko');
  const [selectedCity, setSelectedCity] = useState<City | null>(null);

  useEffect(() => {
    const savedLocale = localStorage.getItem(STORAGE_KEYS.locale) as Locale | null;
    if (savedLocale === 'ko' || savedLocale === 'en') setLocale(savedLocale);

    const savedCity = localStorage.getItem(STORAGE_KEYS.city);
    if (savedCity) {
      try { setSelectedCity(JSON.parse(savedCity)); } catch { /* ignore corrupt data */ }
    }
  }, []);

  useEffect(() => {
    localStorage.setItem(STORAGE_KEYS.locale, locale);
  }, [locale]);

  useEffect(() => {
    if (selectedCity) localStorage.setItem(STORAGE_KEYS.city, JSON.stringify(selectedCity));
  }, [selectedCity]);

  return (
    <LocaleContext.Provider value={{ locale, setLocale }}>
      <CityContext.Provider value={{ selectedCity, setSelectedCity }}>
        <div className="min-h-screen flex flex-col">
          <header className="sticky top-0 z-40 glass border-b border-white/[0.06]">
            <div className="max-w-2xl mx-auto px-4 h-14 flex items-center justify-between">
              <CitySelector />
              <span className="text-xs text-zinc-500 font-mono">
                {locale === 'ko' ? '🇰🇷' : '🇺🇸'}
              </span>
            </div>
          </header>
          <main className="flex-1 max-w-2xl mx-auto w-full px-4 pb-24">
            {children}
          </main>
          <Navigation />
        </div>
      </CityContext.Provider>
    </LocaleContext.Provider>
  );
}
