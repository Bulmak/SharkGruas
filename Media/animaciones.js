(() => {
  const preference = window.matchMedia('(prefers-reduced-motion: reduce)');
  if (preference.matches || !('IntersectionObserver' in window)) return;
  const elements = [...document.querySelectorAll('.section-head, .service, .coverage-grid > div, .regions-card, .faq-layout > div, .cta .wrap')];
  const reveal = element => {
    element.classList.remove('is-waiting');
    element.classList.add('is-visible');
    observer.unobserve(element);
  };
  const observer = new IntersectionObserver(entries => {
    entries.forEach(entry => { if (entry.isIntersecting) reveal(entry.target); });
  }, { threshold: 0, rootMargin: '0px 0px -30px 0px' });
  elements.forEach(element => {
    element.classList.add('reveal');
    if (element.getBoundingClientRect().top < window.innerHeight) return;
    if (element.classList.contains('service')) {
      const index = [...element.parentElement.children].indexOf(element);
      element.style.setProperty('--reveal-delay', `${index * 80}ms`);
    }
    element.classList.add('is-waiting');
    observer.observe(element);
  });
  // Mostrar de inmediato cualquier sección a la que se acceda con el teclado.
  document.addEventListener('focusin', event => {
    const element = event.target.closest('.reveal.is-waiting');
    if (element) reveal(element);
  });
  preference.addEventListener('change', event => {
    if (event.matches) {
      elements.forEach(reveal);
      observer.disconnect();
    }
  });
})();
