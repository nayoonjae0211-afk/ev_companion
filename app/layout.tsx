'use client';

import './globals.css';
import { useState } from 'react';
import Navigation from '@/components/ui/Navigation';
import CitySelector from '@/components/ui/CitySelector';
import { LocaleContext } from '@/lib/locale-context';
import { CityContext } from '@/lib/city-context';
import type { City } from '@/lib/types';
import type { Locale } from '@/lib/i18n';

export default function RootLayout({ children }: { children: React.ReactNode }) {
  const [locale, setLocale] = useState<Locale>('ko');
  const [selectedCity, setSelectedCity] = useState<City | null>(null);

  return (
    <html lang={locale} suppressHydrationWarning>
      <head>
        <title>벚꽃 날씨</title>
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <meta name="theme-color" content="#0a0a0b" />
      </head>
      <body>
        <LocaleContext.Provider value={{ locale, setLocale }}>
          <CityContext.Provider value={{ selectedCity, setSelectedCity }}>
            <div className="min-h-screen flex flex-col">
              {/* Top bar */}
              <header className="sticky top-0 z-40 glass border-b border-white/[0.06]">
                <div className="max-w-2xl mx-auto px-4 h-14 flex items-center justify-between">
                  <CitySelector />
                  <div className="flex items-center gap-2">
                    <span className="text-xs text-zinc-500 font-mono">
                      {locale === 'ko' ? '🇰🇷' : '🇺🇸'}
                    </span>
                  </div>
                </div>
              </header>

              {/* Page content */}
              <main className="flex-1 max-w-2xl mx-auto w-full px-4 pb-24">
                {children}
              </main>

              {/* Bottom navigation */}
              <Navigation locale={locale} />
            </div>
          </CityContext.Provider>
        </LocaleContext.Provider>
      </body>
    </html>
  );
}
