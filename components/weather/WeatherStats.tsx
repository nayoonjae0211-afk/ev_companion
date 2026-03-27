'use client';

import type { WeatherData } from '@/lib/types';
import type { Strings } from '@/lib/i18n';

interface Props {
  weather: WeatherData;
  t: Strings;
}

export default function WeatherStats({ weather, t }: Props) {
  const stats = [
    { label: t.humidity, value: `${weather.humidity}%`, icon: '💧' },
    { label: t.wind, value: `${(weather.windKph).toFixed(1)} km/h`, icon: '🌬️' },
    { label: t.feelsLike, value: `${Math.round(weather.feelsLikeC)}°`, icon: '🌡️' },
  ];

  return (
    <div className="grid grid-cols-3 gap-3">
      {stats.map((s) => (
        <div key={s.label} className="glass rounded-2xl p-4 text-center">
          <div className="text-2xl mb-1">{s.icon}</div>
          <div className="text-white font-semibold text-base">{s.value}</div>
          <div className="text-zinc-500 text-xs mt-0.5">{s.label}</div>
        </div>
      ))}
    </div>
  );
}
