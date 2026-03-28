'use client';

import { conditionEmoji } from '@/lib/weather-utils';
import type { ForecastDay } from '@/lib/types';
import type { Strings, Locale } from '@/lib/i18n';

interface Props {
  forecast: ForecastDay[];
  t: Strings;
  locale: Locale;
}

const DAY_LABELS_KO = ['일', '월', '화', '수', '목', '금', '토'];
const DAY_LABELS_EN = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

export default function DailyForecast({ forecast, t, locale }: Props) {
  if (!forecast.length) return null;

  return (
    <div className="glass rounded-2xl overflow-hidden">
      <p className="text-xs text-white/70 font-medium tracking-wider uppercase px-4 pt-4 pb-2">
        {t.dailyForecast}
      </p>
      <div className="divide-y divide-white/[0.06]">
        {forecast.map((day, i) => {
          const date = new Date(day.date);
          const dayLabels = locale === 'ko' ? DAY_LABELS_KO : DAY_LABELS_EN;
          const label =
            i === 0
              ? t.today
              : i === 1
                ? t.tomorrow
                : dayLabels[date.getDay()];

          const maxAll = Math.max(...forecast.map((d) => d.tempMaxC));
          const minAll = Math.min(...forecast.map((d) => d.tempMinC));
          const range = maxAll - minAll || 1;
          const barLeft = ((day.tempMinC - minAll) / range) * 100;
          const barWidth = ((day.tempMaxC - day.tempMinC) / range) * 100;

          return (
            <div key={day.date} className="flex items-center gap-3 px-4 py-3">
              <span className="w-10 text-sm text-white/90">{label}</span>
              <span className="text-xl w-7">{conditionEmoji(day.conditionCode)}</span>
              <span className="w-8 text-right text-sm text-white/70">
                {Math.round(day.tempMinC)}°
              </span>
              <div className="flex-1 relative h-1.5 bg-white/10 rounded-full overflow-hidden">
                <div
                  className="absolute h-full rounded-full bg-gradient-to-r from-sakura-400 to-sakura-500"
                  style={{ left: `${barLeft}%`, width: `${Math.max(barWidth, 8)}%` }}
                />
              </div>
              <span className="w-8 text-sm font-medium text-white">
                {Math.round(day.tempMaxC)}°
              </span>
            </div>
          );
        })}
      </div>
    </div>
  );
}
