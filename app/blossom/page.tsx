'use client';

import { useEffect, useState } from 'react';
import dynamic from 'next/dynamic';
import { useLocale } from '@/lib/locale-context';
import { strings } from '@/lib/i18n';
import { blossomStatus, daysUntilBloom } from '@/lib/weather-utils';
import type { City, BlossomCity } from '@/lib/types';
import SpotSheet from '@/components/blossom/SpotSheet';

const PetalCanvas = dynamic(() => import('@/components/blossom/PetalCanvas'), { ssr: false });

const STATUS_STYLE: Record<string, { badge: string; ring: string }> = {
  beforeBloom: { badge: 'bg-pink-100 text-pink-600',   ring: 'ring-pink-200' },
  blooming:    { badge: 'bg-pink-200 text-pink-700',   ring: 'ring-pink-300' },
  peaking:     { badge: 'bg-pink-300 text-pink-800',   ring: 'ring-pink-400' },
  ended:       { badge: 'bg-zinc-200 text-zinc-500',   ring: 'ring-zinc-300' },
};

export default function BlossomPage() {
  const { locale } = useLocale();
  const t = strings[locale];

  const [cities, setCities] = useState<BlossomCity[]>([]);
  const [selected, setSelected] = useState<BlossomCity | null>(null);

  useEffect(() => {
    fetch('/api/cities')
      .then((r) => r.json())
      .then((data: City[]) => {
        const mapped: BlossomCity[] = data
          .filter((c) => c.bloom_date && c.peak_date)
          .map((c) => ({
            ...c,
            status: blossomStatus(c.bloom_date!, c.peak_date!),
            daysUntilBloom: daysUntilBloom(c.bloom_date!),
          }));
        setCities(mapped);
      })
      .catch(() => {});
  }, []);

  const statusLabel = (city: BlossomCity) => {
    if (city.status === 'beforeBloom') {
      return city.daysUntilBloom > 0 ? t.daysUntil(city.daysUntilBloom) : t.blooming;
    }
    return { blooming: t.blooming, peaking: t.peaking, ended: t.ended }[city.status];
  };

  return (
    <div
      className="relative min-h-screen -mx-4 px-4"
      style={{ background: 'linear-gradient(180deg, #fce7f3 0%, #fdf2f8 50%, #fff5fb 100%)' }}
    >
      <PetalCanvas />

      <div className="relative z-10 pt-4 pb-8">
        <h1 className="text-xl font-bold text-zinc-800 mb-1">{t.blossomForecast}</h1>
        <p className="text-sm text-pink-400 mb-5">2026 벚꽃 개화 예측</p>

        <div className="grid grid-cols-2 gap-3">
          {cities.map((city) => {
            const style = STATUS_STYLE[city.status];
            const name = locale === 'ko' ? city.name_ko : city.name_en;
            const date = city.bloom_date
              ? new Date(city.bloom_date).toLocaleDateString(locale === 'ko' ? 'ko-KR' : 'en-US', {
                  month: 'short',
                  day: 'numeric',
                })
              : '';

            return (
              <button
                key={city.id}
                onClick={() => setSelected(city)}
                className={`bg-white/70 backdrop-blur-sm rounded-2xl p-4 text-left ring-1 ${style.ring} hover:bg-white/90 transition-all active:scale-95 shadow-sm`}
              >
                <div className="flex items-start justify-between mb-3">
                  <span className="text-2xl">🌸</span>
                  <span className={`text-[10px] font-medium px-2 py-0.5 rounded-full ${style.badge}`}>
                    {statusLabel(city)}
                  </span>
                </div>
                <p className="text-sm font-semibold text-zinc-800">{name}</p>
                <p className="text-xs text-zinc-500 mt-0.5">{date}</p>
              </button>
            );
          })}
        </div>
      </div>

      {selected && (
        <SpotSheet
          city={selected}
          t={t}
          locale={locale}
          onClose={() => setSelected(null)}
        />
      )}
    </div>
  );
}
