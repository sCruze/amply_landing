import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["item"]
  static values = {
    delay: Number,
    duration: Number,
    once: { type: Boolean, default: true },
    threshold: { type: Number, default: 0.0 },
    rootMargin: { type: String, default: "0px 0px -8% 0px" }
  }
  connect() {
    this._observer = new IntersectionObserver(this._onIntersect, {
      root: null,
      rootMargin: this.rootMarginValue,
      threshold: this.thresholdValue
    })
    this.itemTargets.forEach(el => this._prepare(el))
  }
  disconnect() { this._observer?.disconnect() }
  _prepare(el) {
    const delay = el.dataset.revealDelayValue ?? this.delayValue ?? 0
    const duration = el.dataset.revealDurationValue ?? this.durationValue
    const riseVh = el.dataset.revealRiseVhValue
    const offsetX = el.dataset.revealOffsetXValue
    const scale = el.dataset.revealScaleValue
    const rotate = el.dataset.revealRotateValue
    if (duration) el.style.setProperty("--reveal-duration", `${duration}ms`)
    if (delay) el.style.setProperty("--reveal-delay", `${delay}ms`)
    if (riseVh) el.style.setProperty("--reveal-rise-vh", riseVh)
    if (offsetX) el.style.setProperty("--reveal-offset-x", offsetX)
    if (scale) el.style.setProperty("--reveal-scale", scale)
    if (rotate) el.style.setProperty("--reveal-rotate", rotate)
    const helper = el.dataset.revealHelperClass
    if (helper) el.classList.add(helper)
    this._observer.observe(el)
  }
  _onIntersect = (entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.classList.add("is-visible")
        if (this.onceValue) this._observer.unobserve(entry.target)
      } else if (!this.onceValue) {
        entry.target.classList.remove("is-visible")
      }
    })
  }
}
