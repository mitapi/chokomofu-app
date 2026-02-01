import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["pre", "main", "message", "messageUnit", "frame1", "frame2", "frame3"]
  static values = {
    duration: Number,
    expressionMap: Object,
    expressionWidthMap: Object
  }

  connect() {
    window.dispatchEvent(new Event("snack:hide-base"))

    this._closing = false
    this._tick = false

    // ✅ step:change を受けて frame3 を切替
    this._onStepChange = (e) => {
      const key = e.detail?.expressionKey
      if (key) this.updateExpressionByKey(key)
    }

    // ★Turbo差し替え後でも確実に拾うため、document で受ける（安定版）
    document.addEventListener("conversation-step:change", this._onStepChange)

    // ✅ 前段 → 本編への切替
    this._preTimeoutId = window.setTimeout(() => {
      this.preTarget?.classList.add("hidden")
      this.mainTarget?.classList.remove("hidden")
      this.startMain()
    }, 1200)
  }

  startMain() {
    // 初期状態
    this.frame1Target?.classList.remove("hidden")
    this.frame2Target?.classList.add("hidden")
    this.frame3Target?.classList.add("hidden")
    this.messageTarget?.classList.add("hidden")
    this.messageUnitTarget?.classList.add("opacity-0", "translate-y-3", "scale-95")

    // frame1/frame2 の切替開始
    this._intervalId = window.setInterval(() => {
      this._tick = !this._tick
      this.frame1Target?.classList.toggle("hidden", this._tick)
      this.frame2Target?.classList.toggle("hidden", !this._tick)
    }, 400)

    // duration 後に frame3 + message
    const ms = this.durationValue || 2800
    this._timeoutId = window.setTimeout(() => {
      if (this._intervalId) {
        window.clearInterval(this._intervalId)
        this._intervalId = null
      }

      this.frame1Target?.classList.add("hidden")
      this.frame2Target?.classList.add("hidden")

      // frame3 表示（ここで表情も初期化）
      this.frame3Target?.classList.remove("hidden")

      const currentLine =
        document.querySelector('[data-conversation-step-target="line"]:not(.hidden)')
      const key = currentLine?.dataset?.expressionKey || "face_idle"
      this.updateExpressionByKey(key)

      this.messageTarget?.classList.remove("hidden")

      const unit = this.messageUnitTarget
      if (unit) {
        unit.classList.add("opacity-0", "translate-y-3", "scale-95")
        unit.getBoundingClientRect()
        requestAnimationFrame(() => {
          unit.classList.remove("opacity-0", "translate-y-3", "scale-95")
        })
      }
    }, ms)
  }

  updateExpressionByKey(key) {
    const map = this.expressionMapValue || {}
    const url = map[key]

    const wmap = this.expressionWidthMapValue || {}
    const w = wmap[key]

    console.log("[snack-reaction] updateExpressionByKey", key, "=>", url, "width=", w)

    if (url && this.frame3Target) {
      this.frame3Target.src = url

      if (w) {
        this.frame3Target.style.width = `${w}px`
        this.frame3Target.setAttribute("width", String(w))
      }
    }
  }

  close(event) {
    event?.preventDefault()
    event?.stopPropagation()

    if (this._closing) return
    this._closing = true
    console.log("[snack-reaction] close clicked")

    // タイマー停止
    if (this._preTimeoutId) { window.clearTimeout(this._preTimeoutId); this._preTimeoutId = null }
    if (this._intervalId) { window.clearInterval(this._intervalId); this._intervalId = null }
    if (this._timeoutId) { window.clearTimeout(this._timeoutId); this._timeoutId = null }

    // フェードアウト
    const el = this.element
    el.classList.add("transition-opacity", "duration-200", "opacity-0")

    window.setTimeout(() => {
      window.dispatchEvent(new CustomEvent("snack:show-base"))

      const frame = document.getElementById("snack_result")
      if (frame) frame.replaceChildren()
      else el.remove()

      this._closing = false
    }, 200)
  }

  disconnect() {
    if (this._preTimeoutId) window.clearTimeout(this._preTimeoutId)
    if (this._intervalId) window.clearInterval(this._intervalId)
    if (this._timeoutId) window.clearTimeout(this._timeoutId)

    if (this._onStepChange) document.removeEventListener("conversation-step:change", this._onStepChange)

    window.dispatchEvent(new Event("snack:show-base"))
  }
}
