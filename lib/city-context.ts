import { createContext, useContext } from 'react';
import type { City } from './types';

interface CityContextValue {
  selectedCity: City | null;
  setSelectedCity: (city: City) => void;
}

export const CityContext = createContext<CityContextValue>({
  selectedCity: null,
  setSelectedCity: () => {},
});

export function useCity() {
  return useContext(CityContext);
}
