module.exports = async function handler(req, res) {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS');
  if (req.method === 'OPTIONS') {
    res.status(200).end();
    return;
  }

  const { areaCode, keyword, type } = req.query;
  const apiKey = process.env.TOUR_API_KEY;

  if (!apiKey) {
    res.status(500).json({ error: 'TOUR_API_KEY not configured' });
    return;
  }

  const base = 'https://apis.data.go.kr/B551011/KorService2';
  const endpoint = type === 'keyword' ? 'searchKeyword2' : 'areaBasedList2';

  const params = new URLSearchParams({
    serviceKey: apiKey,
    numOfRows: '10',
    pageNo: '1',
    MobileOS: 'AND',
    MobileApp: 'EvCompanion',
    _type: 'json',
    areaCode: areaCode || '',
    contentTypeId: '12',
  });

  if (type === 'keyword' && keyword) {
    params.set('keyword', keyword);
  } else {
    params.set('cat2', 'A0101');
  }

  try {
    const response = await fetch(`${base}/${endpoint}?${params}`);
    const data = await response.json();
    res.status(200).json(data);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
};
