export function weatherBackground(code: number): string {
  if (code === 1000) return 'linear-gradient(180deg, #1e3a8a 0%, #0ea5e9 100%)';           // 맑음
  if (code === 1003) return 'linear-gradient(180deg, #1e3a6e 0%, #38bdf8 100%)';           // 구름 조금
  if (code === 1006 || code === 1009) return 'linear-gradient(180deg, #1f2937 0%, #4b5563 100%)'; // 흐림
  if (code === 1030 || code === 1135 || code === 1147) return 'linear-gradient(180deg, #1c1c2e 0%, #6b7280 100%)'; // 안개
  if (code >= 1273 && code <= 1282) return 'linear-gradient(180deg, #0f0f1a 0%, #312e81 100%)'; // 뇌우
  if (code >= 1210 && code <= 1264) return 'linear-gradient(180deg, #1e3a6e 0%, #93c5fd 100%)'; // 눈
  if (code >= 1063 && code <= 1201) return 'linear-gradient(180deg, #0f172a 0%, #1e3a5f 100%)'; // 비
  return 'linear-gradient(180deg, #1f2937 0%, #374151 100%)';                              // 기본
}

export function conditionEmoji(code: number): string {
  if (code === 1000) return '☀️';
  if (code === 1003) return '🌤️';
  if (code === 1006 || code === 1009) return '☁️';
  if (code === 1030 || code === 1135 || code === 1147) return '🌁';
  if (code >= 1273 && code <= 1282) return '⛈️';
  if (code >= 1210 && code <= 1264) return '🌨️';
  if (code >= 1150 && code <= 1201) return '🌧️';
  if (code >= 1063 && code <= 1072) return '🌦️';
  return '⛅';
}

export function blossomStatus(
  bloomDate: string,
  peakDate: string,
): 'beforeBloom' | 'blooming' | 'peaking' | 'ended' {
  const now = new Date();
  const bloom = new Date(bloomDate);
  const peak = new Date(peakDate);
  const end = new Date(peakDate);
  end.setDate(end.getDate() + 5);

  if (now < bloom) return 'beforeBloom';
  if (now < peak) return 'blooming';
  if (now < end) return 'peaking';
  return 'ended';
}

export function daysUntilBloom(bloomDate: string): number {
  const now = new Date();
  const bloom = new Date(bloomDate);
  return Math.ceil((bloom.getTime() - now.getTime()) / (1000 * 60 * 60 * 24));
}
