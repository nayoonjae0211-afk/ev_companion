import { createClient } from '@supabase/supabase-js';
import { NextResponse } from 'next/server';

const FALLBACK_CITIES = [
  { id: 1,  name_ko: '서울',   name_en: 'Seoul',     query_en: 'Seoul, Korea',      area_code: '1',  bloom_date: '2026-04-01', peak_date: '2026-04-08', lat: 37.5665, lng: 126.9780 },
  { id: 2,  name_ko: '부산',   name_en: 'Busan',     query_en: 'Busan, Korea',      area_code: '6',  bloom_date: '2026-03-23', peak_date: '2026-03-30', lat: 35.1796, lng: 129.0756 },
  { id: 3,  name_ko: '제주',   name_en: 'Jeju',      query_en: 'Jeju, Korea',       area_code: '39', bloom_date: '2026-03-22', peak_date: '2026-03-29', lat: 33.4996, lng: 126.5312 },
  { id: 4,  name_ko: '대구',   name_en: 'Daegu',     query_en: 'Daegu, Korea',      area_code: '4',  bloom_date: '2026-03-24', peak_date: '2026-03-31', lat: 35.8714, lng: 128.6014 },
  { id: 5,  name_ko: '인천',   name_en: 'Incheon',   query_en: 'Incheon, Korea',    area_code: '2',  bloom_date: '2026-04-04', peak_date: '2026-04-11', lat: 37.4563, lng: 126.7052 },
  { id: 6,  name_ko: '대전',   name_en: 'Daejeon',   query_en: 'Daejeon, Korea',    area_code: '3',  bloom_date: '2026-03-29', peak_date: '2026-04-05', lat: 36.3504, lng: 127.3845 },
  { id: 7,  name_ko: '광주',   name_en: 'Gwangju',   query_en: 'Gwangju, Korea',    area_code: '5',  bloom_date: '2026-03-27', peak_date: '2026-04-03', lat: 35.1595, lng: 126.8526 },
  { id: 8,  name_ko: '수원',   name_en: 'Suwon',     query_en: 'Suwon, Korea',      area_code: '31', bloom_date: '2026-04-03', peak_date: '2026-04-10', lat: 37.2636, lng: 127.0286 },
  { id: 9,  name_ko: '춘천',   name_en: 'Chuncheon', query_en: 'Chuncheon, Korea',  area_code: '32', bloom_date: '2026-04-04', peak_date: '2026-04-11', lat: 37.8748, lng: 127.7342 },
  { id: 10, name_ko: '강릉',   name_en: 'Gangneung', query_en: 'Gangneung, Korea',  area_code: '32', bloom_date: '2026-04-01', peak_date: '2026-04-08', lat: 37.7519, lng: 128.8760 },
];

export async function GET() {
  try {
    const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
    const key = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;
    if (!url || !key) return NextResponse.json(FALLBACK_CITIES);

    const supabase = createClient(url, key);
    const { data, error } = await supabase
      .from('cities')
      .select('*')
      .order('bloom_date', { ascending: true });

    if (error || !data?.length) return NextResponse.json(FALLBACK_CITIES);
    return NextResponse.json(data);
  } catch {
    return NextResponse.json(FALLBACK_CITIES);
  }
}
