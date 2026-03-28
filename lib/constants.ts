export const APP_VERSION = '1.0.0';

export const STORAGE_KEYS = {
  locale: 'ev_locale',
  city: 'ev_city',
  lastConditionCode: 'lastConditionCode',
} as const;

export const STATUS_STYLE: Record<string, { badge: string; ring: string }> = {
  beforeBloom: { badge: 'bg-pink-100 text-pink-600', ring: 'ring-pink-200' },
  blooming:    { badge: 'bg-pink-200 text-pink-700', ring: 'ring-pink-300' },
  peaking:     { badge: 'bg-pink-300 text-pink-800', ring: 'ring-pink-400' },
  ended:       { badge: 'bg-zinc-200 text-zinc-500', ring: 'ring-zinc-300' },
};
