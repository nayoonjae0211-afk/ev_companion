'use client';

import { useEffect, useState } from 'react';
import Image from 'next/image';
import type { BlossomCity, TouristSpot } from '@/lib/types';
import type { Strings, Locale } from '@/lib/i18n';

interface Props {
  city: BlossomCity;
  t: Strings;
  locale: Locale;
  onClose: () => void;
}

export default function SpotSheet({ city, t, locale, onClose }: Props) {
  const [spots, setSpots] = useState<TouristSpot[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (!city.area_code) { setLoading(false); return; }
    fetch(`/api/blossom?areaCode=${city.area_code}`)
      .then((r) => r.json())
      .then((data) => {
        const items = data?.response?.body?.items?.item ?? [];
        const list = (Array.isArray(items) ? items : [items]).map(
          (item: Record<string, unknown>) => ({
            title: (item.title as string) ?? '',
            address: `${item.addr1 ?? ''}${item.addr2 ? ' ' + item.addr2 : ''}`,
            imageUrl: (item.firstimage as string) || null,
            lat: item.mapy ? parseFloat(item.mapy as string) : null,
            lng: item.mapx ? parseFloat(item.mapx as string) : null,
            contentId: String(item.contentid ?? ''),
          }),
        );
        setSpots(list);
      })
      .catch(() => {})
      .finally(() => setLoading(false));
  }, [city]);

  const openMap = (spot: TouristSpot) => {
    if (spot.lat && spot.lng) {
      window.open(
        `https://map.kakao.com/link/map/${encodeURIComponent(spot.title)},${spot.lat},${spot.lng}`,
        '_blank',
      );
    }
  };

  return (
    <div className="fixed inset-0 z-50 flex items-end" onClick={onClose}>
      <div className="sheet-overlay absolute inset-0" />
      <div
        className="relative w-full max-w-2xl mx-auto bg-zinc-900 rounded-t-3xl max-h-[80vh] flex flex-col border border-white/10"
        onClick={(e) => e.stopPropagation()}
      >
        {/* Handle */}
        <div className="flex justify-center pt-3 pb-1">
          <div className="w-10 h-1 bg-zinc-700 rounded-full" />
        </div>

        <div className="px-5 py-3 border-b border-white/[0.06]">
          <h2 className="text-base font-semibold text-white">
            {locale === 'ko' ? city.name_ko : city.name_en} {t.touristSpots}
          </h2>
        </div>

        <div className="overflow-y-auto flex-1 p-4 space-y-3">
          {loading ? (
            <div className="flex justify-center py-12">
              <div className="w-6 h-6 border-2 border-sakura-400 border-t-transparent rounded-full animate-spin" />
            </div>
          ) : spots.length === 0 ? (
            <p className="text-center text-zinc-500 py-12 text-sm">{t.noSpots}</p>
          ) : (
            spots.map((spot) => (
              <button
                key={spot.contentId}
                onClick={() => openMap(spot)}
                className="w-full flex items-center gap-3 glass rounded-xl p-3 text-left hover:bg-white/[0.06] transition-colors"
              >
                <div className="w-14 h-14 rounded-lg overflow-hidden bg-zinc-800 flex-shrink-0">
                  {spot.imageUrl ? (
                    <Image
                      src={spot.imageUrl}
                      alt={spot.title}
                      width={56}
                      height={56}
                      className="w-full h-full object-cover"
                    />
                  ) : (
                    <div className="w-full h-full flex items-center justify-center text-2xl">🌸</div>
                  )}
                </div>
                <div className="flex-1 min-w-0">
                  <p className="text-sm font-medium text-white truncate">{spot.title}</p>
                  <p className="text-xs text-zinc-500 mt-0.5 truncate">{spot.address}</p>
                </div>
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#a1a1aa" strokeWidth="2">
                  <path d="M9 18l6-6-6-6" />
                </svg>
              </button>
            ))
          )}
        </div>
      </div>
    </div>
  );
}
