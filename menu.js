function toggleMenu() {
    const menu = document.getElementById('menu');
    if (!menu) return;
    const opening = menu.classList.toggle('open');
    const button = document.querySelector('.menu-toggle');
    if (button) button.setAttribute('aria-expanded', opening ? 'true' : 'false');
}
