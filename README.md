# Habib Mobile Solution

Production-ready Next.js 15 website for Habib Mobile Solution with a premium blue/white mobile-first UI, service catalog, live price calculator, booking form, social links, blog, reviews, FAQ, PWA metadata, SEO, Firebase client integration and an admin dashboard.

## Stack
- Next.js 15 App Router, React 19, TypeScript
- Tailwind CSS, Framer Motion, Lucide React
- Firebase Auth, Firestore and Storage wiring
- Vercel-ready configuration

## Setup
```bash
npm install
cp .env.example .env.local
npm run dev
```

Add Firebase web app values to `.env.local`, enable Email/Password auth in Firebase Authentication, and create Firestore/Storage rules for your production security model.

## Scripts
- `npm run dev` - local development
- `npm run build` - production build
- `npm run start` - serve build
- `npm run typecheck` - TypeScript validation

## Admin
Visit `/admin` and sign in with a Firebase Authentication user. The dashboard is ready for Firestore-backed management collections: services, blogs, customers, bookings, reviews and analytics.
