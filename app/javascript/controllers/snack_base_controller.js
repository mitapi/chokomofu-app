import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["base", "menu"]

  connect() {
    this.hideBase = this.hideBase.bind(this)
    this.showBase = this.showBase.bind(this)

    window.addEventListener("snack:hide-base", this.hideBase)
    window.addEventListener("snack:show-base", this.showBase)
  }

  disconnect() {
    window.removeEventListener("snack:hide-base", this.hideBase)
    window.removeEventListener("snack:show-base", this.showBase)
  }

  // snack_result（演出）を出す時：メインぽめ＆メニューを無効化
  hideBase() {
    if (this.hasBaseTarget) {
      this.baseTarget.classList.add("opacity-0", "pointer-events-none")
    }
    if (this.hasMenuTarget) {
      this.menuTarget.classList.add("opacity-0", "pointer-events-none")
    }
  }

  // 演出を閉じる時：元に戻す
  showBase() {
    if (this.hasBaseTarget) {
      this.baseTarget.classList.remove("opacity-0", "pointer-events-none")
    }

    if (this.hasMenuTarget) {
      this.menuTarget.classList.remove("opacity-0", "pointer-events-none")
    }
  }
}
