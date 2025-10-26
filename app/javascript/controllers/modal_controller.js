import { Controller } from "@hotwired/stimulus"

const LOCK_CLASS = "overflow-hidden"

function lockScroll()  { document.body.classList.add(LOCK_CLASS) }
function unlockScroll(){ document.body.classList.remove(LOCK_CLASS) }

/** Парсит строку времён вида "0s, 0.2s, 150ms" -> максимальная длительность в мс */
function parseTimeListToMs(str) {
    if (!str || str === "0s") return 0
    return String(str)
        .split(",")
        .map(s => s.trim())
        .map(s => s.endsWith("ms") ? parseFloat(s) : parseFloat(s) * 1000)
        .reduce((a, b) => Math.max(a, b), 0)
}

/** Берём максимум по animationDuration и transitionDuration */
function getMaxDurationMs(styles) {
    const ad = parseTimeListToMs(styles.animationDuration)
    const td = parseTimeListToMs(styles.transitionDuration)
    return Math.max(ad, td)
}

export default class extends Controller {
    static targets = ["modalWrapper", "dialog", "pane", "tab", "title"]
    static values = {
        openClass: String,
        closeOnEsc: Boolean,
        closeOnBg: Boolean,
        lockScroll: Boolean,
        autoOpen: Boolean,
        defaultPane: Number,
        activePane: Number
    }

    connect() {
        const initial = this.hasActivePaneValue
            ? this.activePaneValue
            : (this.hasDefaultPaneValue ? this.defaultPaneValue : 1)

        this._hideAllButFirst()
        this.show(initial)

        if (this.autoOpenValue) this.open()
    }

    keydown(e) {
        if (this.closeOnEscValue && e.key === "Escape") this.close()
    }

    open() {
        const root = this._root()
        const openCls = this._openCls()
        if (!root.classList.contains(openCls)) {
            root.classList.remove("hidden")
            // снимаем leaving, если завис прошлый выход
            root.classList.remove("ui-modal--leaving", "modal--leaving")
            root.classList.add(openCls)
        }
        if (this.lockScrollValue) lockScroll()
        this._focusFirst()
    }

    /** ЕДИНСТВЕННЫЙ МЕТОД ЗАКРЫТИЯ */
    close(e) {
        if (e) {
            if (!this._isAllowedCloseTrigger(e)) return
            e.preventDefault()
            e.stopPropagation()
        }

        const root   = this._root()
        const openCls = this._openCls()

        // 1) Подготовка: убираем класс открытия, ставим leaving (с правильным именем)
        root.classList.remove(openCls)
        root.classList.add("ui-modal--leaving") // ← совпадает с CSS

        const finish = () => {
            root.classList.add("hidden")
            root.classList.remove("ui-modal--leaving", "modal--leaving")
            if (this.lockScrollValue) unlockScroll()
            if (this.hasDefaultPaneValue) this.show(this.defaultPaneValue)
        }

        // 2) Ждём конец анимации/перехода, + fallback таймер
        const styles = getComputedStyle(root)
        const maxDur = getMaxDurationMs(styles) || 200 // ожидаем хотя бы .2s как в CSS

        let finished = false
        const once = () => {
            if (finished) return
            finished = true
            root.removeEventListener("animationend", once, true)
            root.removeEventListener("transitionend", once, true)
            finish()
        }

        // слушаем и анимации, и переходы (на всякий случай)
        root.addEventListener("animationend", once, true)
        root.addEventListener("transitionend", once, true)

        // надёжный таймаут (maxDur + запас 100мс)
        setTimeout(once, maxDur + 100)

        // стопим медиа
        this.element.querySelectorAll("video, audio").forEach(m => {
            try {
                m.pause()
                m.currentTime = 0
                const srcWasSet = m.getAttribute("src") || m.querySelector("source")
                if (srcWasSet) {
                    m.removeAttribute("src")
                    m.querySelectorAll("source").forEach(s => s.remove())
                    m.load()
                }
            } catch(_) {}
        })
    }

    activateTab(e) {
        e.preventDefault()
        const idx = Number(e.currentTarget.dataset.modalIndex)
        if (!Number.isNaN(idx)) this.show(idx)
    }

    show(index) {
        const idxStr = String(index)

        if (this.hasPaneTarget) {
            this.paneTargets.forEach(p =>
                p.classList.toggle("hidden", (p.dataset.modalIndex || "") !== idxStr)
            )
        }

        if (this.hasTabTarget) {
            this.tabTargets.forEach((t, i) => {
                const tIdx = t.dataset.modalIndex || String(i + 1)
                const selected = tIdx === idxStr
                t.setAttribute("aria-selected", String(selected))
                t.classList.toggle("is-active", selected)
            })
        }

        if (this.hasTitleTarget) {
            this.titleTargets.forEach((t, i) => {
                const tIdx = t.dataset.modalIndex || String(i + 1)
                t.classList.toggle("hidden", tIdx !== idxStr)
            })
        }

        this.activePaneValue = Number(index)
    }

    // --- helpers ---
    _root() { return this.hasModalWrapperTarget ? this.modalWrapperTarget : this.element }
    _openCls() { return this.hasOpenClassValue ? this.openClassValue : "is-open" }

    _isAllowedCloseTrigger(e) {
        const t = e.target

        const isCloseBtn =
            t.classList?.contains("modal__close") ||
            t.classList?.contains("modal__close--btn") ||
            !!t.closest?.(".modal__close, .modal__close--btn") ||
            t.hasAttribute?.("data-modal-close") ||
            !!t.closest?.("[data-modal-close]")

        if (isCloseBtn) return true
        if (!this.closeOnBgValue) return false

        const root = this._root()
        const insideDialog = this.hasDialogTarget ? this.dialogTarget.contains(t) : false
        const clickedBackdrop = root.contains(t) && !insideDialog
        return clickedBackdrop
    }

    _hideAllButFirst() {
        if (this.hasPaneTarget && this.paneTargets.length > 0) {
            this.paneTargets.forEach((p, i) => p.classList.toggle("hidden", i !== 0))
        }
        if (this.hasTitleTarget && this.titleTargets.length > 0) {
            this.titleTargets.forEach((t, i) => t.classList.toggle("hidden", i !== 0))
        }
        if (this.hasTabTarget && this.tabTargets.length > 0) {
            this.tabTargets.forEach((t, i) => {
                const selected = i === 0
                t.setAttribute("aria-selected", String(selected))
                t.classList.toggle("is-active", selected)
            })
        }
    }

    _focusFirst() {
        const root = this._root()
        const first = root.querySelector('[data-autofocus], input, button, [tabindex]:not([tabindex="-1"])')
        first?.focus?.()
    }
}
