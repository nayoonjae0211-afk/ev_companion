'use client';

import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { strings } from '@/lib/i18n';
import { useLocale } from '@/lib/locale-context';

export default function Navigation() {
  const pathname = usePathname();
  const { locale } = useLocale();
  const t = strings[locale];

  const tabs = [
    { href: '/', label: t.weather, icon: WeatherIcon },
    { href: '/blossom', label: t.blossom, icon: BlossomIcon },
    { href: '/settings', label: t.settings, icon: SettingsIcon },
  ];

  return (
    <nav className="fixed bottom-0 inset-x-0 z-40 glass border-t border-white/[0.06]">
      <div className="max-w-2xl mx-auto flex">
        {tabs.map(({ href, label, icon: Icon }) => {
          const active = pathname === href;
          return (
            <Link
              key={href}
              href={href}
              className={`flex-1 flex flex-col items-center gap-1 py-3 transition-colors ${
                active ? 'text-sakura-400' : 'text-zinc-500 hover:text-zinc-300'
              }`}
            >
              <Icon active={active} />
              <span className="text-[10px] font-medium tracking-wide">{label}</span>
            </Link>
          );
        })}
      </div>
    </nav>
  );
}

function WeatherIcon({ active }: { active: boolean }) {
  return (
    <svg width="22" height="22" viewBox="0 0 24 24" fill="none" strokeWidth="1.8"
      stroke={active ? '#f472b6' : 'currentColor'}>
      <circle cx="12" cy="12" r="4" />
      <path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41" />
    </svg>
  );
}

function BlossomIcon({ active }: { active: boolean }) {
  return (
    <svg width="22" height="22" viewBox="0 0 24 24" fill={active ? '#f472b6' : 'none'}
      stroke={active ? '#f472b6' : 'currentColor'} strokeWidth="1.8">
      <path d="M12 2C9 2 7 4 7 6c0 1.5.8 2.8 2 3.5C7.8 10.2 7 11.5 7 13c0 2.8 2.2 5 5 5s5-2.2 5-5c0-1.5-.8-2.8-2-3.5 1.2-.7 2-2 2-3.5C17 4 15 2 12 2z" />
    </svg>
  );
}

function SettingsIcon({ active }: { active: boolean }) {
  return (
    <svg width="22" height="22" viewBox="0 0 24 24" fill="none" strokeWidth="1.8"
      stroke={active ? '#f472b6' : 'currentColor'}>
      <circle cx="12" cy="12" r="3" />
      <path d="M19.4 15a1.65 1.65 0 00.33 1.82l.06.06a2 2 0 010 2.83 2 2 0 01-2.83 0l-.06-.06a1.65 1.65 0 00-1.82-.33 1.65 1.65 0 00-1 1.51V21a2 2 0 01-4 0v-.09A1.65 1.65 0 009 19.4a1.65 1.65 0 00-1.82.33l-.06.06a2 2 0 01-2.83-2.83l.06-.06A1.65 1.65 0 004.68 15a1.65 1.65 0 00-1.51-1H3a2 2 0 010-4h.09A1.65 1.65 0 004.6 9a1.65 1.65 0 00-.33-1.82l-.06-.06a2 2 0 012.83-2.83l.06.06A1.65 1.65 0 009 4.68a1.65 1.65 0 001-1.51V3a2 2 0 014 0v.09a1.65 1.65 0 001 1.51 1.65 1.65 0 001.82-.33l.06-.06a2 2 0 012.83 2.83l-.06.06A1.65 1.65 0 0019.4 9a1.65 1.65 0 001.51 1H21a2 2 0 010 4h-.09a1.65 1.65 0 00-1.51 1z" />
    </svg>
  );
}
