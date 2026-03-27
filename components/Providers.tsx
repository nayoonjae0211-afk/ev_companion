'use client';

import { useState } from 'react';
import { LocaleContext } from '@/lib/locale-context';
import { CityContext } from '@/lib/city-context';
import type { City } from '@/lib/types';
import type { Locale } from '@/lib/i18n';
import CitySelector from '@/components/ui/CitySelector';
import Navigation from '@/components/ui/Navigation';

export default function Providers({ children }: { children: React.ReactNode }) {
  const [locale, setLocale] = useState<Locale>('ko');
  const [selectedCity, setSelectedCity] = useState<City | null>(null);

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
