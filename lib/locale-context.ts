import { createContext, useContext } from 'react';
import type { Locale } from './i18n';

interface LocaleContextValue {
  locale: Locale;
  setLocale: (l: Locale) => void;
}

export const LocaleContext = createContext<LocaleContextValue>({
  locale: 'ko',
  setLocale: () => {},
});

export function useLocale() {
  return useContext(LocaleContext);
}
