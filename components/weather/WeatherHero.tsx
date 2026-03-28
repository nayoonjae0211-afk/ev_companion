'use client';

import { conditionEmoji } from '@/lib/weather-utils';
import type { WeatherData } from '@/lib/types';
import type { Strings } from '@/lib/i18n';

interface Props {
  weather: WeatherData;
  t: Strings;
}

export default function WeatherHero({ weather, t }: Props) {
  return (
    <div className="text-center py-8 animate-slide-up">
      <div className="text-6xl mb-3">{conditionEmoji(weather.conditionCode)}</div>
      <div className="text-7xl font-bold tracking-tighter text-white">
        {Math.round(weather.tempC)}°
      </div>
      <div className="text-white/90 text-lg mt-2">{weather.description}</div>
      <div className="flex items-center justify-center gap-4 mt-3 text-sm text-white/70">
        <span>{t.high} {Math.round(weather.tempMaxC)}°</span>
        <span className="w-px h-3 bg-white/30" />
        <span>{t.low} {Math.round(weather.tempMinC)}°</span>
        <span className="w-px h-3 bg-white/30" />
        <span>{t.feelsLike} {Math.round(weather.feelsLikeC)}°</span>
      </div>
    </div>
  );
}
