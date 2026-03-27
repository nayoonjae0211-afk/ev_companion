module.exports = async function handler(req, res) {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS');
  if (req.method === 'OPTIONS') {
    res.status(200).end();
    return;
  }

  const { city, type } = req.query;
  const apiKey = process.env.WEATHERAPI_KEY;

  if (!apiKey) {
    res.status(500).json({ error: 'WEATHERAPI_KEY not configured' });
    return;
  }

  const base = 'https://api.weatherapi.com/v1';
  const endpoint = type === 'forecast' ? 'forecast.json' : 'forecast.json';

  const params = new URLSearchParams({
    key: apiKey,
    q: city || 'Seoul',
    lang: 'ko',
    days: '6',
    aqi: 'no',
    alerts: 'no',
  });

  try {
    const response = await fetch(`${base}/${endpoint}?${params}`);
    const data = await response.json();
    res.status(response.status).json(data);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};
