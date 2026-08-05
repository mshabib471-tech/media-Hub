import type { Metadata, Viewport } from 'next';
import './globals.css';

export const metadata: Metadata = {
  title: 'Habib Mobile Solution | Premium Mobile Servicing',
  description: 'Professional mobile repair, software, FRP, accessories and online services in Chattogram.',
  manifest: '/manifest.webmanifest',
  openGraph: {
    title: 'Habib Mobile Solution',
    description: 'Fast, trusted and premium mobile servicing.',
    type: 'website',
  },
  alternates: { canonical: 'https://habib-mobile-solution.vercel.app' },
};

export const viewport: Viewport = { themeColor: '#2563eb', colorScheme: 'light' };

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="bn">
      <body>{children}</body>
    </html>
  );
}
