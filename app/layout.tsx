import './globals.css';
import Providers from '@/components/Providers';

export const metadata = {
  title: '벚꽃 날씨',
  description: '한국 벚꽃 개화 예보와 날씨',
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="ko" suppressHydrationWarning>
      <head>
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <meta name="theme-color" content="#0a0a0b" />
      </head>
      <body>
        <Providers>{children}</Providers>
      </body>
    </html>
  );
}
