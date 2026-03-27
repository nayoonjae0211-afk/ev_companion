export default async function handler(req, res) {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS');
  if (req.method === 'OPTIONS') {
    res.status(200).end();
    return;
  }

  const { city, type } = req.query;
  const apiKey = process.env.OPENWEATHER_API_KEY;
  const base = 'https://api.openweathermap.org/data/2.5';
  const endpoint = type === 'forecast' ? 'forecast' : 'weather';

  const params = new URLSearchParams({
    q: city || 'Seoul,KR',
    appid: apiKey,
    units: 'metric',
    lang: 'kr',
    ...(type === 'forecast' ? { cnt: '40' } : {}),
  });

  try {
    const response = await fetch(`${base}/${endpoint}?${params}`);
    const data = await response.json();
    res.status(response.status).json(data);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
}
