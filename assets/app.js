const menuData = {
  business: [
    ['Video Downloader', 'video', '#video-downloader'],
    ['Service Booking', 'calendar-check', '#booking'],
    ['Price List', 'badge-dollar-sign', '#price-list'],
    ['Download Center', 'download-cloud', '#download-center'],
  ],
  info: [
    ['FAQ', 'circle-help', '#faq'],
    ['Lost & Found', 'search-check', '#lost-found'],
    ['Photo Gallery', 'images', '#photo-gallery'],
    ['Video Gallery', 'clapperboard', '#video-gallery'],
    ['Privacy Policy', 'shield-check', '#privacy-policy'],
    ['Terms & Conditions', 'file-text', '#terms-conditions'],
    ['Admin Portal', 'lock-keyhole', '#admin'],
  ],
};

const select = (query) => document.querySelector(query);
const selectAll = (query) => [...document.querySelectorAll(query)];
const sidebar = select('#sidebar');
const scrim = select('#scrim');
const openButton = select('#menuOpen');
const closeButton = select('#menuClose');

function icon(name, className = '') {
  return `<i class="${className}" data-lucide="${name}" aria-hidden="true"></i>`;
}

function buildMenuItem([label, itemIcon, href], index) {
  const isActive = index === 0;
  return `<a class="menu-item ripple ${isActive ? 'active' : ''}" href="${href}">
    <span class="mi-icon">${icon(itemIcon)}</span>
    <strong>${label}</strong>
    ${icon('chevron-right', 'arrow')}
  </a>`;
}

function renderMenus() {
  select('#businessMenu').innerHTML = menuData.business.map(buildMenuItem).join('');
  select('#infoMenu').innerHTML = menuData.info.map(buildMenuItem).join('');
}

function openSidebar() {
  sidebar.classList.add('open');
  scrim.classList.add('show');
  sidebar.setAttribute('aria-hidden', 'false');
  openButton.setAttribute('aria-expanded', 'true');
  document.body.style.overflow = 'hidden';
}

function closeSidebar() {
  sidebar.classList.remove('open');
  scrim.classList.remove('show');
  sidebar.setAttribute('aria-hidden', 'true');
  openButton.setAttribute('aria-expanded', 'false');
  document.body.style.overflow = '';
}

function attachRipple() {
  selectAll('.ripple').forEach((element) => {
    element.addEventListener('click', (event) => {
      const oldWave = element.querySelector('.ripple-wave');
      if (oldWave) oldWave.remove();
      const wave = document.createElement('span');
      const rect = element.getBoundingClientRect();
      const size = Math.max(rect.width, rect.height);
      wave.className = 'ripple-wave';
      wave.style.width = `${size}px`;
      wave.style.height = `${size}px`;
      wave.style.left = `${event.clientX - rect.left - size / 2}px`;
      wave.style.top = `${event.clientY - rect.top - size / 2}px`;
      element.appendChild(wave);
    });
  });
}

function initAiChat() {
  const button = select('#aiButton');
  const chat = select('#aiChat');
  select('#aiClose').addEventListener('click', () => chat.classList.remove('open'));
  button.addEventListener('click', () => {
    chat.classList.toggle('open');
    chat.setAttribute('aria-hidden', String(!chat.classList.contains('open')));
  });
}

function initReveal() {
  const observer = new IntersectionObserver((entries) => {
    entries.forEach((entry) => {
      if (entry.isIntersecting) entry.target.classList.add('in');
    });
  }, { threshold: 0.16 });
  selectAll('.reveal-up').forEach((element) => observer.observe(element));
}

renderMenus();
lucide.createIcons();
attachRipple();
initAiChat();
initReveal();
openButton.addEventListener('click', openSidebar);
closeButton.addEventListener('click', closeSidebar);
scrim.addEventListener('click', closeSidebar);
window.addEventListener('keydown', (event) => {
  if (event.key === 'Escape') closeSidebar();
});
selectAll('.menu-item').forEach((item) => item.addEventListener('click', closeSidebar));
if ('serviceWorker' in navigator) navigator.serviceWorker.register('sw.js').catch(() => undefined);
