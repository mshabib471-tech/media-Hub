import type { Metadata, Viewport } from 'next';
import { Noto_Sans_Bengali } from 'next/font/google';
import './globals.css';
const noto = Noto_Sans_Bengali({ subsets:['bengali'], variable:'--font-noto' });
export const metadata: Metadata = { title:'Habib Mobile Solution | Premium Mobile Servicing', description:'Professional mobile repair, software, FRP, accessories and online services in Chattogram.', manifest:'/manifest.webmanifest', openGraph:{title:'Habib Mobile Solution',description:'Fast, trusted and premium mobile servicing.',type:'website'}, alternates:{canonical:'https://habib-mobile-solution.vercel.app'} };
export const viewport: Viewport = { themeColor:'#2563eb', colorScheme:'light' };
export default function RootLayout({children}:{children:React.ReactNode}){return <html lang="bn" className={noto.variable}><body>{children}</body></html>}
