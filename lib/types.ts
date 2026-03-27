export interface City {
  id: number;
  name_ko: string;
  name_en: string;
  query_en: string;
  area_code: string | null;
  bloom_date: string | null;
  peak_date: string | null;
  lat: number | null;
  lng: number | null;
}

export interface HourlyForecast {
  label: string;
  tempC: number;
  conditionCode: number;
}

export interface ForecastDay {
  date: string;
  tempMaxC: number;
  tempMinC: number;
  conditionCode: number;
  description: string;
}

export interface WeatherData {
  cityName: string;
  tempC: number;
  feelsLikeC: number;
  tempMinC: number;
  tempMaxC: number;
  description: string;
  humidity: number;
  windKph: number;
  conditionCode: number;
  hourly: HourlyForecast[];
  forecast: ForecastDay[];
}

export type BlossomStatus = 'beforeBloom' | 'blooming' | 'peaking' | 'ended';

export interface BlossomCity extends City {
  status: BlossomStatus;
  daysUntilBloom: number;
}

export interface TouristSpot {
  title: string;
  address: string;
  imageUrl: string | null;
  lat: number | null;
  lng: number | null;
  contentId: string;
}
