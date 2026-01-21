console.log("[snack-reaction] file loaded")
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
      this.frame3Target.classList.remove("hidden")
    }, 400)

    // 数秒後にセリフへ
    const ms = this.durationValue || 8000
    this._timeoutId = setTimeout(() => {
      clearInterval(this._intervalId)
      this.animationTarget.classList.add("hidden")
      this.messageTarget.classList.remove("hidden")
    }, ms)
  }

  close() {
    window.dispatchEvent(new Event("snack:show-base"))

    const frame = document.getElementById("snack_result")
    if (frame) frame.innerHTML = ""
  }

  disconnect() {
    if (this._intervalId) clearInterval(this._intervalId)
    if (this._timeoutId) clearTimeout(this._timeoutId)
    window.dispatchEvent(new Event("snack:show-base"))
  }
}
