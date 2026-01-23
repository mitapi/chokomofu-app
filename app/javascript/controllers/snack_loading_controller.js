import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["text"]

  connect() {
    if (!this.hasTextTarget) return
    this.originalText = this.textTarget.textContent
    this.inFlight = false
    this.timer = null
  }

  start() {
    if (!this.hasTextTarget) return
    if (this.inFlight) return
    this.inFlight = true

    // form内の実buttonを無効化
    const btn = this.element.querySelector("button")
    if (btn) btn.disabled = true

    this.timer = window.setTimeout(() => {
      if (!this.inFlight) return
      this.textTarget.textContent = "おやつ準備中…"
    }, 200)
  }

  end() {
    if (!this.hasTextTarget) return
    this.inFlight = false

    if (this.timer) {
      window.clearTimeout(this.timer)
      this.timer = null
    }

    const btn = this.element.querySelector("button")
    if (btn) btn.disabled = false

    this.textTarget.textContent = this.originalText
  }
}
