import { NextRequest, NextResponse } from 'next/server';

export async function GET(req: NextRequest) {
  const areaCode = req.nextUrl.searchParams.get('areaCode') ?? '1';
  const apiKey = process.env.TOUR_API_KEY;

  if (!apiKey) {
    return NextResponse.json({ error: 'TOUR_API_KEY not configured' }, { status: 500 });
  }

  const params = new URLSearchParams({
    numOfRows: '20',
    pageNo: '1',
    MobileOS: 'ETC',
    MobileApp: 'EVCompanion',
    _type: 'json',
    areaCode,
    keyword: '벚꽃',
  });

  // encodeURIComponent handles decoded key (plain text from 공공데이터포털)
  const url = `https://apis.data.go.kr/B551011/KorService2/searchKeyword1?serviceKey=${encodeURIComponent(apiKey)}&${params}`;

  try {
    const res = await fetch(url, { cache: 'no-store' });
    const data = await res.json();

    // API error check
    const header = data?.response?.header ?? data?.response?.body;
    const resultCode = data?.response?.header?.resultCode;
    if (resultCode && resultCode !== '0000') {
      return NextResponse.json(
        { error: data?.response?.header?.resultMsg ?? 'API error', resultCode },
        { status: 502 },
      );
    }

    return NextResponse.json(data);
  } catch (e) {
    const msg = e instanceof Error ? e.message : 'Unknown error';
    return NextResponse.json({ error: msg }, { status: 500 });
  }
}
