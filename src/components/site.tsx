'use client';

import { motion, useScroll } from 'framer-motion';
import {
  services,
  socials,
  posts,
  reviews,
  phone,
  email,
} from '@/lib/data';
import {
  Menu,
  Phone,
  MessageCircle,
  ArrowUp,
  Bot,
  Star,
  CheckCircle2,
  Send,
  Upload,
  Calculator,
  ShieldCheck,
  Clock3,
  Sparkles,
  MapPin,
  Wrench,
} from 'lucide-react';
import { useMemo, useState } from 'react';

const wa = `https://wa.me/88${phone}`;
const navigation = ['Services', 'Pricing', 'Booking', 'Reviews'];

export function Site() {
  const { scrollYProgress } = useScroll();
  const [brand, setBrand] = useState('Apple / iPhone');
  const [problem, setProblem] = useState('Display / Glass');
  const price = useMemo(() => {
    const base = brand.includes('Apple') ? 2700 : brand.includes('Samsung') ? 1800 : 900;
    const add = problem.includes('Display') ? 810 : problem.includes('FRP') ? 500 : problem.includes('Battery') ? 350 : 250;
    return `৳${base.toLocaleString()} - ৳${(base + add).toLocaleString()}`;
  }, [brand, problem]);

  return (
    <>
      <motion.div className="progress" style={{ scaleX: scrollYProgress }} />
      <Header />
      <main>
        <Hero />
        <About />
        <Services />
        <CalculatorBox brand={brand} setBrand={setBrand} problem={problem} setProblem={setProblem} price={price} />
        <Booking />
        <Social />
        <Blog />
        <Reviews />
        <FAQ />
        <Contact />
      </main>
      <Footer />
      <Floating />
    </>
  );
}

function Header() {
  return (
    <header className="fixed left-0 right-0 top-4 z-50 mx-auto max-w-7xl px-4">
      <nav className="glass flex items-center justify-between rounded-full px-4 py-3">
        <a href="#home" className="flex items-center gap-3 font-black">
          <span className="grid h-12 w-12 place-items-center rounded-2xl bg-gradient-to-br from-blue-600 to-cyan-400 text-white shadow-lg shadow-blue-500/30">H</span>
          <span>
            Habib <b className="text-blue-600">Mobile</b>
            <small className="block font-medium text-slate-500">হাবিব রহমান · চট্টগ্রাম</small>
          </span>
        </a>
        <div className="hide-sm flex items-center gap-2">
          {navigation.map((item) => (
            <a className="nav-link" href={`#${item.toLowerCase()}`} key={item}>{item}</a>
          ))}
          <a className="btn blue text-xs" href="#booking">অনলাইন বুকিং</a>
          <a className="btn emerald text-xs" href={wa}>WhatsApp</a>
        </div>
        <button aria-label="Open menu" className="rounded-2xl bg-slate-100 p-3 text-slate-700"><Menu size={20} /></button>
      </nav>
    </header>
  );
}

function Hero() {
  return (
    <section id="home" className="grad hero-pad overflow-hidden px-4 pt-32">
      <div className="mx-auto grid min-h-screen max-w-7xl grid-cols-[1.05fr_.95fr] items-center gap-10 grid2">
        <motion.div initial={{ opacity: 0, y: 30 }} animate={{ opacity: 1, y: 0 }}>
          <p className="eyebrow"><Sparkles size={16} /> 2026 Premium Repair Experience</p>
          <h1 className="bn mt-5 text-7xl font-black leading-[.95] tracking-tight">মোবাইল সার্ভিসিং এখন আরও <span className="text-gradient">দ্রুত, নিরাপদ, স্মার্ট</span></h1>
          <p className="mt-6 max-w-2xl text-lg leading-8 text-slate-600">দীর্ঘ ৭+ বছরের অভিজ্ঞতায় মোবাইল সফটওয়্যার, হার্ডওয়্যার, অনলাইন সার্ভিস এবং ডিজিটাল ক্রিয়েটিভ কাজ ট্র্যাকিংসহ প্রিমিয়াম কেয়ারে সম্পন্ন করি।</p>
          <div className="mt-8 flex flex-wrap gap-3">
            <a className="btn blue" href="#booking"><Phone size={18} />আমার সাহায্য নিন</a>
            <a className="btn soft" href="#services"><Wrench size={18} />সার্ভিস দেখুন</a>
            <a className="btn soft" href={wa}><MessageCircle size={18} />যোগাযোগ</a>
          </div>
          <div className="mt-10 grid grid-cols-3 gap-3"><Stat v="8,500+" l="সফল সার্ভিস" /><Stat v="7+ Years" l="অভিজ্ঞতা" /><Stat v="99.2%" l="সন্তুষ্টির হার" /></div>
        </motion.div>
        <HeroDevice />
      </div>
    </section>
  );
}

function HeroDevice() {
  return (
    <motion.div initial={{ opacity: 0, scale: .94 }} animate={{ opacity: 1, scale: 1 }} className="relative">
      <div className="orb -left-8 top-8 bg-blue-400" /><div className="orb bottom-10 right-0 bg-cyan-300" />
      <div className="phone-shell mx-auto max-w-[420px]">
        <div className="phone-screen">
          <div className="flex items-center justify-between text-xs text-white/70"><span>9:41</span><span>5G 100%</span></div>
          <div className="mt-10 rounded-3xl bg-white/10 p-5">
            <p className="text-sm text-cyan-200">Live Job Status</p><h3 className="mt-2 text-3xl font-black text-white">Display Repair</h3>
            <div className="mt-5 space-y-3">{['Device checked', 'Parts verified', 'Ready in 45 min'].map((x, i) => <div className="flex items-center gap-3 rounded-2xl bg-white/10 p-3" key={x}><CheckCircle2 className={i === 2 ? 'text-amber-300' : 'text-emerald-300'} /><span>{x}</span></div>)}</div>
          </div>
          <div className="mt-6 grid grid-cols-2 gap-3"><MiniCard icon={<ShieldCheck />} title="Warranty" value="30 Days" /><MiniCard icon={<Clock3 />} title="Pickup" value="Today" /></div>
        </div>
      </div>
    </motion.div>
  );
}

function MiniCard({ icon, title, value }: { icon: React.ReactNode; title: string; value: string }) { return <div className="rounded-3xl bg-white p-4 text-slate-900 shadow-xl shadow-blue-950/10">{icon}<p className="mt-3 text-xs text-slate-500">{title}</p><b>{value}</b></div>; }
function Stat(p: { v: string; l: string }) { return <div className="card p-5"><b className="text-2xl text-blue-700">{p.v}</b><p className="text-xs text-slate-500">{p.l}</p></div>; }

function About() { return <section id="about" className="mx-auto max-w-7xl px-4 py-20"><div className="feature-card p-8"><p className="eyebrow w-fit"><ShieldCheck size={16} /> Trusted workflow</p><h2 className="bn mt-4 text-4xl font-black">ডায়াগনসিস থেকে ডেলিভারি — সবকিছু স্বচ্ছ</h2><p className="mt-3 max-w-3xl text-slate-600">I combine technician-level diagnostics, transparent pricing, secure data handling and premium customer communication for every device.</p><div className="mt-6 grid grid-cols-4 gap-3 grid2">{['Software Expert', 'Hardware Care', 'Design Studio', 'Govt E-Service'].map((x) => <span className="rounded-3xl bg-white/75 p-4 font-bold text-blue-700 shadow-sm" key={x}>{x}</span>)}</div></div></section>; }
function Services() { return <section id="services" className="mx-auto max-w-7xl px-4 py-12"><p className="font-bold text-blue-600">আমাদের বিশেষত্ব</p><h2 className="bn text-4xl font-black">প্রফেশনাল মোবাইল সার্ভিসিং</h2><div className="mt-8 grid grid-cols-2 gap-5 grid2">{services.map((s, i) => <motion.article initial={{ opacity: 0, y: 20 }} whileInView={{ opacity: 1, y: 0 }} viewport={{ once: true }} transition={{ delay: i * .03 }} className="service-card" key={s.title}><s.icon className="mb-4 text-blue-600" /><div className="flex justify-between gap-3"><h3 className="bn text-xl font-black">{s.bn}</h3><span className="rounded-full bg-blue-50 px-3 py-1 text-xs font-bold text-blue-600">{s.time}</span></div><p className="mt-3 text-slate-600">{s.desc}</p><div className="mt-5 flex items-center justify-between"><b>{s.price}</b><a className="font-bold text-blue-600" href="#booking">বুক করুন</a></div></motion.article>)}</div></section>; }
function CalculatorBox({ brand, setBrand, problem, setProblem, price }: any) { return <section id="pricing" className="mx-auto max-w-7xl px-4 py-10"><div className="card p-7"><h2 className="bn flex items-center gap-2 text-2xl font-black"><Calculator className="text-blue-600" />লাইভ সার্ভিস চার্জ ক্যালকুলেটর</h2><div className="mt-5 grid grid-cols-3 gap-4 grid2"><select className="input" value={brand} onChange={(e) => setBrand(e.target.value)}><option>Apple / iPhone</option><option>Samsung</option><option>Xiaomi / Poco / Redmi</option></select><select className="input"><option>iPhone 13 Pro</option><option>Galaxy S22</option><option>Redmi Note</option></select><select className="input" value={problem} onChange={(e) => setProblem(e.target.value)}><option>Display / Glass</option><option>FRP / Google Lock</option><option>Battery Backup</option><option>Software Flash</option></select></div><div className="mt-5 rounded-3xl bg-gradient-to-r from-blue-50 to-cyan-50 p-5"><p className="text-sm text-slate-500">আনুমানিক সার্ভিস চার্জ</p><b className="text-3xl text-blue-600">{price}</b><p className="text-sm text-emerald-600">● আনুমানিক সময়: 1-2 Hours</p></div></div></section>; }
function Booking() { return <section id="booking" className="mx-auto max-w-7xl px-4 py-12"><form className="card p-7"><h2 className="bn text-3xl font-black">অনলাইন মোবাইল সার্ভিস বুকিং</h2><div className="mt-5 grid grid-cols-2 gap-4 grid2">{['আপনার নাম', 'ফোন নাম্বার', 'ডিভাইস ব্র্যান্ড', 'ডিভাইস মডেল', 'পছন্দের তারিখ', 'সময় স্লট', 'ঠিকানা'].map((x) => <input key={x} className="input" placeholder={x} />)}</div><textarea className="input mt-4 min-h-28" placeholder="সমস্যার বিস্তারিত বিবরণ" /><label className="mt-4 grid min-h-32 place-items-center rounded-3xl border border-dashed border-blue-300 bg-blue-50 text-blue-600"><Upload /> ছবি আপলোড করুন<input type="file" className="hidden" /></label><button className="btn blue mt-4 w-full justify-center" type="button"><Send size={18} /> বুকিং জমা দিন</button></form></section>; }
function Social() { return <section className="mx-auto max-w-7xl px-4 py-16 text-center"><h2 className="bn text-3xl font-black">সামাজিক যোগাযোগ মাধ্যমে যুক্ত থাকুন</h2><div className="mt-7 grid grid-cols-4 gap-4 grid2">{socials.map((s) => <a className="card p-5 transition hover:-translate-y-1 hover:border-blue-200" key={s.name}><s.icon className="mx-auto text-blue-600" /><b>{s.name}</b><p className="truncate text-sm text-slate-500">{s.v}</p></a>)}</div></section>; }
function Blog() { return <section className="mx-auto max-w-7xl px-4 py-14"><h2 className="bn text-4xl font-black">সাম্প্রতিক টেক পোস্ট</h2><div className="mt-6 grid grid-cols-3 gap-5 grid3">{posts.map((p, i) => <article className="card overflow-hidden" key={p}><div className="h-44 bg-gradient-to-br from-blue-500 via-cyan-300 to-slate-100" /><div className="p-5"><span className="text-xs font-bold text-blue-600">মোবাইল টিপস · {22 - i} Apr 2026</span><h3 className="mt-2 font-black">{p}</h3><a className="mt-4 block font-bold text-blue-600">বিস্তারিত পড়ুন →</a></div></article>)}</div></section>; }
function Reviews() { return <section id="reviews" className="mx-auto max-w-7xl px-4 py-14 text-center"><p className="font-bold text-emerald-600">গ্রাহকের মতামত</p><h2 className="bn text-3xl font-black">সন্তুষ্ট কাস্টমার রিভিউ</h2><div className="mt-6 grid grid-cols-3 gap-5 grid3">{reviews.map((r) => <div className="card p-6 text-left" key={r}><div className="flex text-amber-400">{[1, 2, 3, 4, 5].map((x) => <Star key={x} fill="currentColor" size={18} />)}</div><p className="my-4">“{r}”</p><b className="flex items-center gap-1">Verified Customer <CheckCircle2 size={16} className="text-blue-600" /></b></div>)}</div></section>; }
function FAQ() { return <section id="faq" className="mx-auto max-w-7xl px-4 py-12"><div className="card p-7"><h2 className="text-3xl font-black">FAQ</h2>{['কত সময় লাগে?', 'ডাটা নিরাপদ থাকবে?', 'ওয়ারেন্টি আছে?'].map((a) => <details className="border-b py-4" key={a}><summary className="font-bold">{a}</summary><p className="text-slate-600">সমস্যা অনুযায়ী সময় ও খরচ জানিয়ে কাজ শুরু করা হয়।</p></details>)}</div></section>; }
function Contact() { return <section id="contact" className="mx-auto max-w-7xl px-4 py-12"><div className="feature-card p-8"><h2 className="text-3xl font-black">Contact</h2><p className="mt-3 flex flex-wrap gap-4 text-slate-700"><span><Phone className="inline" size={16} /> {phone}</span><span>{email}</span><span><MapPin className="inline" size={16} /> Chattogram, Bangladesh</span></p></div></section>; }
function Footer() { return <footer className="bg-slate-950 px-4 py-16 text-slate-300"><div className="mx-auto grid max-w-7xl grid-cols-3 gap-8 grid3"><div><h3 className="text-xl font-black text-white">Habib Mobile Solution</h3><p className="mt-3">Premium trusted mobile servicing, accessories and online service hub.</p></div><div><b className="text-white">Quick Links</b><p>Services · Booking · Blog · FAQ · Contact</p></div><div><b className="text-white">যোগাযোগ</b><p>{phone}<br />{email}</p></div></div><p className="mx-auto mt-10 max-w-7xl border-t border-white/10 pt-6">© 2026 Habib Mobile Solution. All rights reserved.</p></footer>; }
function Floating() { return <><a href={wa} className="float bottom-24 rounded-full bg-emerald-500 p-4 text-white shadow-2xl"><MessageCircle /></a><button onClick={() => scrollTo({ top: 0, behavior: 'smooth' })} className="float bottom-6 rounded-full bg-blue-600 p-4 text-white shadow-2xl"><ArrowUp /></button><button className="float bottom-44 flex items-center gap-2 rounded-full bg-slate-950 px-4 py-3 text-sm font-bold text-white shadow-2xl"><Bot className="text-blue-300" /> Habib AI Assistant</button></>; }
