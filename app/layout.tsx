import './globals.css';
import Providers from '@/components/Providers';

export const metadata = {
  title: 'Blossom Weather',
  description: 'Korean cherry blossom forecast & weather',
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
