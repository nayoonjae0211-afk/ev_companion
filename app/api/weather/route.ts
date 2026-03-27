import { NextRequest, NextResponse } from 'next/server';

export async function GET(req: NextRequest) {
  const city = req.nextUrl.searchParams.get('city') ?? 'Seoul';
  const apiKey = process.env.WEATHERAPI_KEY;

  if (!apiKey) {
    return NextResponse.json({ error: 'WEATHERAPI_KEY not configured' }, { status: 500 });
  }

  const params = new URLSearchParams({
    key: apiKey,
    q: city,
    lang: 'ko',
    days: '6',
    aqi: 'no',
    alerts: 'no',
  });

  try {
    const res = await fetch(`https://api.weatherapi.com/v1/forecast.json?${params}`, {
      next: { revalidate: 600 },
    });
    const data = await res.json();
    return NextResponse.json(data, { status: res.status });
  } catch (e) {
    const msg = e instanceof Error ? e.message : 'Unknown error';
    return NextResponse.json({ error: msg }, { status: 500 });
  }
}
