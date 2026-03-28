'use client';

import { conditionEmoji } from '@/lib/weather-utils';
import type { HourlyForecast as HourlyType } from '@/lib/types';
import type { Strings } from '@/lib/i18n';

interface Props {
  hourly: HourlyType[];
  t: Strings;
}

export default function HourlyForecast({ hourly, t }: Props) {
  if (!hourly.length) return null;

  return (
    <div className="glass rounded-2xl p-4">
      <p className="text-xs text-white/70 font-medium tracking-wider uppercase mb-3">
        {t.hourlyForecast}
      </p>
      <div className="flex justify-between">
        {hourly.map((h, i) => (
          <div key={i} className="flex flex-col items-center gap-1.5">
            <span className="text-xs text-white/70">{h.label}</span>
            <span className="text-xl">{conditionEmoji(h.conditionCode)}</span>
            <span className="text-sm font-medium text-white">{Math.round(h.tempC)}°</span>
          </div>
        ))}
      </div>
    </div>
  );
}
