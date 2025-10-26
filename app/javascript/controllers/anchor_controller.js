import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="anchor"
export default class extends Controller {
  header = document.querySelector('header')
  body = document.querySelector('body')
  mobileMenu = document.querySelector('.mobile-menu')

  // Якорь
  anchorScrollBlock(e) {
    const header = document.querySelector('header')

    const scrollTarget = document.querySelector(`#${e.target.getAttribute('data-anchor')}`)
    const topOffset = header.getBoundingClientRect().height
    const elementPosition = scrollTarget.getBoundingClientRect().top + window.scrollY
    const offsetPosition = elementPosition - topOffset - 100

    const customSpeed = e.target.getAttribute('data-scroll-speed')
    if (customSpeed) {
      const duration = parseInt(customSpeed, 10);
      const start = window.scrollX;
      const distance = offsetPosition - start;

      const startTime = performance.now();

      const animateScroll = () => {
        const elapsedTime = performance.now() - startTime;
        const progress = elapsedTime / duration;

        if (progress < 1) {
          window.scrollTo(0, start + distance * progress);
          requestAnimationFrame(animateScroll);
        } else {
          window.scrollTo(0, offsetPosition); // Проверяем и корректируем, чтобы точно достичь целевой позиции
        }
      }

      requestAnimationFrame(animateScroll);
    } else {
      window.scrollBy({
        top: offsetPosition - window.pageYOffset,
        behavior: 'smooth'
      });
    }
  }
}
