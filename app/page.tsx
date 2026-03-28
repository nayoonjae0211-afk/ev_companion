'use client';

import { useCallback, useEffect, useState } from 'react';
import { useCity } from '@/lib/city-context';
import { useLocale } from '@/lib/locale-context';
import { strings } from '@/lib/i18n';
import { weatherBackground } from '@/lib/weather-utils';
import type { WeatherData } from '@/lib/types';
import WeatherHero from '@/components/weather/WeatherHero';
import WeatherStats from '@/components/weather/WeatherStats';
import HourlyForecast from '@/components/weather/HourlyForecast';
import DailyForecast from '@/components/weather/DailyForecast';
import BlossomBanner from '@/components/weather/BlossomBanner';

export default function WeatherPage() {
  const { selectedCity } = useCity();
  const { locale } = useLocale();
  const t = strings[locale];

  const [weather, setWeather] = useState<WeatherData | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const fetchWeather = useCallback(async () => {
    if (!selectedCity) return;
    setLoading(true);
    setError(null);
    try {
      const res = await fetch(`/api/weather?city=${encodeURIComponent(selectedCity.query_en)}`);
      if (!res.ok) throw new Error(`${res.status}`);
      const raw = await res.json();

      const current = raw.current;
      const forecastDays = raw.forecast?.forecastday ?? [];

      // Hourly: from current hour
      const nowHour = new Date().getHours();
      const hourlyList: WeatherData['hourly'] = [];
      let foundFirst = false;
      for (let i = 0; i < forecastDays.length; i++) {
        if (hourlyList.length >= 5) break;
        const dayHours = forecastDays[i].hour as Array<{
          time: string; temp_c: number; condition: { code: number };
        }>;
        for (const h of dayHours) {
          if (hourlyList.length >= 5) break;
          const hh = parseInt(h.time.split(' ')[1].split(':')[0], 10);
          if (i === 0 && hh < nowHour) continue;
          hourlyList.push({
            label: foundFirst ? `${hh}시` : t.now,
            tempC: h.temp_c,
            conditionCode: h.condition.code,
          });
          foundFirst = true;
        }
      }

      // Daily forecast (skip today)
      const todayStr = new Date().toISOString().slice(0, 10);
      const forecast: WeatherData['forecast'] = forecastDays
        .filter((d: { date: string }) => d.date !== todayStr)
        .slice(0, 5)
        .map((d: {
          date: string;
          day: { maxtemp_c: number; mintemp_c: number; condition: { code: number; text: string } };
        }) => ({
          date: d.date,
          tempMaxC: d.day.maxtemp_c,
          tempMinC: d.day.mintemp_c,
          conditionCode: d.day.condition.code,
          description: d.day.condition.text,
        }));

      const today = forecastDays[0]?.day;
      const conditionCode = current.condition.code;
      localStorage.setItem('lastConditionCode', String(conditionCode));
      setWeather({
        cityName: selectedCity.name_ko,
        tempC: current.temp_c,
        feelsLikeC: current.feelslike_c,
        tempMinC: today?.mintemp_c ?? current.temp_c - 4,
        tempMaxC: today?.maxtemp_c ?? current.temp_c + 3,
        description: current.condition.text,
        humidity: current.humidity,
        windKph: current.wind_kph,
        conditionCode,
        hourly: hourlyList,
        forecast,
      });
    } catch {
      setError(t.error);
    } finally {
      setLoading(false);
    }
  }, [selectedCity, t]);

  useEffect(() => {
    fetchWeather();
  }, [fetchWeather]);

  if (loading) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="flex flex-col items-center gap-3">
          <div className="w-8 h-8 border-2 border-sakura-400 border-t-transparent rounded-full animate-spin" />
          <p className="text-zinc-500 text-sm">{t.loading}</p>
        </div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="flex flex-col items-center justify-center h-64 gap-4">
        <p className="text-zinc-400">{error}</p>
        <button
          onClick={fetchWeather}
          className="px-4 py-2 rounded-xl bg-sakura-500/20 text-sakura-300 text-sm hover:bg-sakura-500/30 transition-colors"
        >
          {t.retry}
        </button>
      </div>
    );
  }

  if (!weather && !selectedCity) {
    return (
      <div className="flex flex-col items-center justify-center h-64 gap-3">
        <p className="text-4xl">🌸</p>
        <p className="text-zinc-400 text-sm">{t.selectCity}</p>
      </div>
    );
  }

  if (!weather) return null;

  const bg = weatherBackground(weather.conditionCode);

  return (
    <div
      className="flex flex-col gap-4 pt-2 animate-fade-in -mx-4 px-4 min-h-screen"
      style={{ background: bg }}
    >
      <div className="flex justify-end">
        <button
          onClick={fetchWeather}
          className="text-zinc-600 hover:text-zinc-400 transition-colors p-1"
          aria-label={t.refresh}
        >
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
            <path d="M23 4v6h-6M1 20v-6h6" />
            <path d="M3.51 9a9 9 0 0114.85-3.36L23 10M1 14l4.64 4.36A9 9 0 0020.49 15" />
          </svg>
        </button>
      </div>

      <WeatherHero weather={weather} t={t} />

      {selectedCity && <BlossomBanner city={selectedCity} t={t} />}

      <WeatherStats weather={weather} t={t} />
      <HourlyForecast hourly={weather.hourly} t={t} />
      <DailyForecast forecast={weather.forecast} t={t} locale={locale} />
    </div>
  );
}
