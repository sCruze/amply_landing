import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
    static values = {
        offset: { type: Number, default: 100 },
        speed: Number
    };

    go(e) {
        const id = e.params.id;
        if (!id) return;

        const el = document.getElementById(id);

        if (el) {
            e.preventDefault();
            e.stopPropagation();

            const header = document.querySelector("header");
            const headerH = header ? header.getBoundingClientRect().height : 0;
            const extra = Number(e.params.offset || this.offsetValue || 0);

            const targetY =
                Math.max(0, el.getBoundingClientRect().top + window.scrollY - headerH - extra);

            const mm = document.querySelector(".mobile-menu.is-open");
            if (mm) mm.classList.remove("is-open");

            if (this.hasSpeedValue) {
                this.animateScrollTo(targetY, this.speedValue);
            } else {
                window.scrollTo({ top: targetY, behavior: "smooth" });
            }
            history.replaceState(null, "", `#${id}`);
        }
    }

    animateScrollTo(targetY, duration = 500) {
        const startY = window.scrollY;
        const dist = targetY - startY;
        const t0 = performance.now();

        const step = (now) => {
            const t = Math.min(1, (now - t0) / duration);
            // easeInOutQuad
            const eased = t < 0.5 ? 2 * t * t : -1 + (4 - 2 * t) * t;
            window.scrollTo(0, startY + dist * eased);
            if (t < 1) requestAnimationFrame(step);
        };

        requestAnimationFrame(step);
    }
}
