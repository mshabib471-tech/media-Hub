import { Site } from '@/components/site';
export default function Page(){const jsonLd={ '@context':'https://schema.org', '@type':'LocalBusiness', name:'Habib Mobile Solution', telephone:'01868461577', address:'Chattogram, Bangladesh', url:'https://habib-mobile-solution.vercel.app'};return <><script type="application/ld+json" dangerouslySetInnerHTML={{__html:JSON.stringify(jsonLd)}}/><Site/></>}
