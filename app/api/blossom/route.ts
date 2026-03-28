import { NextRequest, NextResponse } from 'next/server';

export async function GET(req: NextRequest) {
  const areaCode = req.nextUrl.searchParams.get('areaCode') ?? '1';
  const apiKey = process.env.TOUR_API_KEY;

  if (!apiKey) {
    return NextResponse.json({ error: 'TOUR_API_KEY not configured' }, { status: 500 });
  }

  const params = new URLSearchParams({
    numOfRows: '10',
    pageNo: '1',
    MobileOS: 'ETC',
    MobileApp: 'EVCompanion',
    _type: 'json',
    areaCode,
    keyword: '벚꽃',
  });

  try {
    const res = await fetch(
      `https://apis.data.go.kr/B551011/KorService1/searchKeyword1?serviceKey=${apiKey}&${params}`,
      { next: { revalidate: 3600 } },
    );
    const data = await res.json();
    return NextResponse.json(data);
  } catch (e) {
    const msg = e instanceof Error ? e.message : 'Unknown error';
    return NextResponse.json({ error: msg }, { status: 500 });
  }
}
