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
