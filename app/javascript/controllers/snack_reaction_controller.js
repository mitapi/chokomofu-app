import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["animation", "message", "frame1", "frame2", "frame3"]
  static values = { duration: Number }

  connect() {
    window.dispatchEvent(new Event("snack:hide-base"))

    // false= frame1 表示、true= frame2 表示
    console.log("[snack-reaction] connected")
    this._tick = false
    this._intervalId = setInterval(() => {
      this._tick = !this._tick
      this.frame1Target.classList.toggle("hidden", this._tick)
      this.frame2Target.classList.toggle("hidden", !this._tick)
    }, 400)

    // 数秒後にセリフへ
    const ms = this.durationValue || 4000
    this._timeoutId = setTimeout(() => {
      clearInterval(this._intervalId)
      this.frame1Target.classList.add("hidden")
      this.frame2Target.classList.add("hidden")
      this.frame3Target.classList.remove("hidden")
      this.messageTarget.classList.remove("hidden")
    }, ms)
  }

  close(event) {
    event?.preventDefault()
    event?.stopPropagation()

    console.log("[snack-reaction] close clicked")

    // ★先に止める（安全）
    if (this._intervalId) {
      window.clearInterval(this._intervalId)
      this._intervalId = null
    }
    if (this._timeoutId) {
      window.clearTimeout(this._timeoutId)
      this._timeoutId = null
    }

    window.dispatchEvent(new CustomEvent("snack:show-base"))

    const frame = document.getElementById("snack_result")
    if (frame) {
      frame.replaceChildren()
      return
    }

    this.element.remove()
  }

  disconnect() {
    if (this._intervalId) clearInterval(this._intervalId)
    if (this._timeoutId) clearTimeout(this._timeoutId)
    window.dispatchEvent(new Event("snack:show-base"))
  }
}
