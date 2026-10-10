(() => {
  const groups = [...document.querySelectorAll('[data-region]')];
  const buttons = [...document.querySelectorAll('[data-region-name]')];
  const status = document.getElementById('region-status');
  const initial = status.textContent;
  function show(id) {
    const button = buttons.find(item => item.dataset.regionName === id);
    groups.forEach(group => group.classList.toggle('is-highlighted', group.dataset.region === id));
    buttons.forEach(item => item.classList.toggle('is-highlighted', item === button));
    status.textContent = button.textContent.trim() + (button.dataset.proposed === 'true' ? ' · Región del recorrido La Serena–Chillán.' : ' · Fuera del recorrido indicado.');
  }
  function reset() {
    groups.forEach(group => group.classList.remove('is-highlighted'));
    buttons.forEach(button => button.classList.remove('is-highlighted'));
    status.textContent = initial;
  }
  buttons.forEach(button => {
    button.addEventListener('pointerenter', () => show(button.dataset.regionName));
    button.addEventListener('focus', () => show(button.dataset.regionName));
    button.addEventListener('click', () => show(button.dataset.regionName));
    button.addEventListener('pointerleave', () => { if (document.activeElement !== button) reset(); });
    button.addEventListener('blur', reset);
  });
  groups.forEach(group => {
    group.addEventListener('pointerenter', () => show(group.dataset.region));
    group.addEventListener('pointerleave', reset);
  });
})();
