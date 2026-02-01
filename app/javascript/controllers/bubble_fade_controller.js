import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // 初期状態 → 次フレームで解除して発火
    requestAnimationFrame(() => {
      this.element.classList.remove("opacity-0", "translate-y-2", "scale-95")
    })
  }
}