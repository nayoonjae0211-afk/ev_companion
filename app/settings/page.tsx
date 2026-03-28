'use client';

import { useLocale } from '@/lib/locale-context';
import { strings } from '@/lib/i18n';
import { weatherBackground } from '@/lib/weather-utils';

export default function SettingsPage() {
  const { locale, setLocale } = useLocale();
  const t = strings[locale];

  const code = typeof window !== 'undefined'
    ? parseInt(localStorage.getItem('lastConditionCode') ?? '1000', 10)
    : 1000;
  const bg = weatherBackground(code);

  return (
    <div className="-mx-4 px-4 min-h-screen pt-6 space-y-4 animate-fade-in" style={{ background: bg }}>
      <h1 className="text-xl font-bold text-white">{t.settings}</h1>

      {/* Language */}
      <div className="glass rounded-2xl overflow-hidden">
        <div className="px-4 py-3 border-b border-white/[0.06]">
          <p className="text-xs text-white/70 font-medium tracking-wider uppercase">{t.language}</p>
        </div>
        <div className="flex">
          {(['ko', 'en'] as const).map((l) => (
            <button
              key={l}
              onClick={() => setLocale(l)}
              className={`flex-1 py-4 text-sm font-medium transition-colors ${
                locale === l
                  ? 'text-sakura-400 bg-sakura-500/10'
                  : 'text-white/80 hover:text-zinc-200'
              }`}
            >
              {l === 'ko' ? '🇰🇷  한국어' : '🇺🇸  English'}
            </button>
          ))}
        </div>
      </div>

      {/* Data sources */}
      <div className="glass rounded-2xl overflow-hidden">
        <div className="px-4 py-3 border-b border-white/[0.06]">
          <p className="text-xs text-white/70 font-medium tracking-wider uppercase">{t.dataSource}</p>
        </div>
        {[
          { name: 'WeatherAPI', desc: 'Real-time weather & forecast', icon: '🌤️' },
          { name: 'Korea Tour API', desc: '한국 벚꽃 명소 데이터', icon: '🌸' },
          { name: 'Supabase', desc: '도시 데이터 관리', icon: '🗄️' },
        ].map((src) => (
          <div key={src.name} className="flex items-center gap-3 px-4 py-3.5 border-b border-white/[0.04] last:border-0">
            <span className="text-xl">{src.icon}</span>
            <div>
              <p className="text-sm font-medium text-white">{src.name}</p>
              <p className="text-xs text-white/70">{src.desc}</p>
            </div>
          </div>
        ))}
      </div>

      {/* Version */}
      <div className="glass rounded-2xl px-4 py-4 flex items-center justify-between">
        <p className="text-sm text-white/80">{t.version}</p>
        <p className="text-sm font-medium text-white/70 font-mono">1.0.0</p>
      </div>
    </div>
  );
}
