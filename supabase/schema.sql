-- Cities table: 도시 데이터 (하드코딩 없이 DB로 관리)
CREATE TABLE IF NOT EXISTS cities (
  id          SERIAL PRIMARY KEY,
  name_ko     TEXT NOT NULL,          -- 한국어 이름 (서울)
  name_en     TEXT NOT NULL,          -- 영어 이름 (Seoul)
  query_en    TEXT NOT NULL,          -- WeatherAPI 쿼리용 (Seoul, Korea)
  area_code   TEXT,                   -- 한국 TourAPI 지역코드
  bloom_date  DATE,                   -- 벚꽃 개화일
  peak_date   DATE,                   -- 벚꽃 만개일
  lat         DECIMAL(10, 6),
  lng         DECIMAL(10, 6),
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

-- RLS: 공개 읽기 허용
ALTER TABLE cities ENABLE ROW LEVEL SECURITY;

CREATE POLICY "public_read_cities"
  ON cities FOR SELECT
  USING (true);
