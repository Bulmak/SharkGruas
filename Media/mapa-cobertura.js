(() => {
  const config = window.SHARK_COVERAGE;
  const groups = [...document.querySelectorAll('[data-commune]')];
  const available = new Set(groups.map(group => group.dataset.commune));
  const valid = config && Array.isArray(config.communes) && config.communes.every(name => available.has(name));
  const confirmed = valid && config.confirmed === true;
  const covered = new Set(confirmed ? config.communes : []);
  const status = document.getElementById('map-status');
  const baseStatus = confirmed ? 'Cobertura confirmada: ' + covered.size + ' comunas en amarillo.' : 'Cobertura pendiente de confirmación. Ninguna comuna se ha marcado como atendida.';
  status.textContent = baseStatus;
  document.getElementById('map-base-legend').textContent = confirmed ? 'Sin cobertura' : 'Por confirmar';
  document.getElementById('map-desc').textContent = confirmed ? 'Amarillo: comunas atendidas. Azul oscuro: comunas sin cobertura.' : baseStatus;
  groups.forEach(group => {
    const name = group.dataset.commune;
    const state = confirmed ? (covered.has(name) ? 'Con cobertura' : 'Sin cobertura') : 'Por confirmar';
    const description = name + ': ' + state;
    group.classList.toggle('covered', covered.has(name));
    group.setAttribute('aria-label', description);
    group.querySelector('title').textContent = description;
    group.addEventListener('pointerenter', () => { status.textContent = description; });
    group.addEventListener('focus', () => { status.textContent = description; });
    group.addEventListener('pointerleave', () => { status.textContent = baseStatus; });
    group.addEventListener('blur', () => { status.textContent = baseStatus; });
  });
})();
