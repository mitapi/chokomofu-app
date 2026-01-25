import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["pre", "main", "message", "frame1", "frame2", "frame3"]
  static values = { duration: Number }

  connect() {
    window.dispatchEvent(new Event("snack:hide-base"))
    console.log("[snack-reaction] connected")

    this._closing = false
    this._tick = false

    // ✅ 前段 → 本編への切替（ふわんが終わったら本編開始）
    this._preTimeoutId = window.setTimeout(() => {
      // 前段を隠して本編を表示
      this.preTarget?.classList.add("hidden")
      this.mainTarget?.classList.remove("hidden")

      this.startMain()
    }, 1200)
  }

  startMain() {
    console.log("[snack-reaction] startMain")

    // 念のため初期状態を整える
    this.frame1Target.classList.remove("hidden")
    this.frame2Target.classList.add("hidden")
    this.frame3Target.classList.add("hidden")
    this.messageTarget.classList.add("hidden")

    // frame1/frame2 の切替開始
    this._intervalId = window.setInterval(() => {
      this._tick = !this._tick
      this.frame1Target.classList.toggle("hidden", this._tick)
      this.frame2Target.classList.toggle("hidden", !this._tick)
    }, 400)

    // ms 後に idle + message へ
    const ms = this.durationValue || 2800
    this._timeoutId = window.setTimeout(() => {
      if (this._intervalId) {
        window.clearInterval(this._intervalId)
        this._intervalId = null
      }

      this.frame1Target.classList.add("hidden")
      this.frame2Target.classList.add("hidden")
      this.frame3Target.classList.remove("hidden")
      this.messageTarget.classList.remove("hidden")
    }, ms)
  }

  close(event) {
    event?.preventDefault()
    event?.stopPropagation()

    if (this._closing) return
    this._closing = true

    console.log("[snack-reaction] close clicked")

    // ★先に止める（安全）
    if (this._preTimeoutId) {
      window.clearTimeout(this._preTimeoutId)
      this._preTimeoutId = null
    }
    if (this._intervalId) {
      window.clearInterval(this._intervalId)
      this._intervalId = null
    }
    if (this._timeoutId) {
      window.clearTimeout(this._timeoutId)
      this._timeoutId = null
    }

    // 1) フェードアウト
    const el = this.element
    el.classList.add("transition-opacity", "duration-200")
    el.classList.add("opacity-0")

    // 2) フェード後に戻す＆クリア
    window.setTimeout(() => {
      window.dispatchEvent(new CustomEvent("snack:show-base"))

      const frame = document.getElementById("snack_result")
      if (frame) {
        frame.replaceChildren()
      } else {
        el.remove()
      }

      this._closing = false
    }, 200)
  }

  disconnect() {
    if (this._preTimeoutId) window.clearTimeout(this._preTimeoutId)
    if (this._intervalId) window.clearInterval(this._intervalId)
    if (this._timeoutId) window.clearTimeout(this._timeoutId)
    window.dispatchEvent(new Event("snack:show-base"))
  }
}