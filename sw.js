const CACHE='habib-mobile-solution-v1';
const ASSETS=['./','./index.html','./assets/styles.css','./assets/app.js','./assets/icon.svg','./manifest.webmanifest'];
self.addEventListener('install',event=>event.waitUntil(caches.open(CACHE).then(cache=>cache.addAll(ASSETS))));
self.addEventListener('fetch',event=>event.respondWith(caches.match(event.request).then(cached=>cached||fetch(event.request))));
