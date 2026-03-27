'use client';

import type { City } from '@/lib/types';
import type { Strings } from '@/lib/i18n';
import { blossomStatus, daysUntilBloom } from '@/lib/weather-utils';

interface Props {
  city: City;
  t: Strings;
}

export default function BlossomBanner({ city, t }: Props) {
  if (!city.bloom_date || !city.peak_date) return null;

  const status = blossomStatus(city.bloom_date, city.peak_date);
  const days = daysUntilBloom(city.bloom_date);

  const config = {
    beforeBloom: {
      label: days > 0 ? t.daysUntil(days) : t.blooming,
      sub: t.beforeBloom,
      color: 'from-pink-500/20 to-rose-500/10',
      border: 'border-pink-500/20',
    },
    blooming: {
      label: '🌸 ' + t.blooming,
      sub: t.blooming,
      color: 'from-pink-500/30 to-rose-400/20',
      border: 'border-pink-400/30',
    },
    peaking: {
      label: '🌸🌸 ' + t.peaking,
      sub: t.peaking,
      color: 'from-pink-400/30 to-fuchsia-500/20',
      border: 'border-pink-400/30',
    },
    ended: {
      label: t.ended,
      sub: t.ended,
      color: 'from-zinc-500/20 to-zinc-600/10',
      border: 'border-zinc-600/30',
    },
  }[status];

  return (
    <div className={`rounded-2xl p-4 bg-gradient-to-r ${config.color} border ${config.border}`}>
      <div className="flex items-center gap-3">
        <span className="text-2xl">🌸</span>
        <div>
          <p className="text-sm font-semibold text-white">{t.blossomForecast}</p>
          <p className="text-xs text-zinc-400 mt-0.5">{config.label}</p>
        </div>
      </div>
    </div>
  );
}
