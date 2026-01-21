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

  hideBase() {
    if (this.hasBaseTarget) this.baseTarget.classList.add("opacity-0")
    if (this.hasMenuTarget) this.menuTarget.classList.add("opacity-0")
  }

  showBase() {
    if (this.hasBaseTarget) this.baseTarget.classList.remove("opacity-0")
    if (this.hasMenuTarget) this.menuTarget.classList.remove("opacity-0")
  }
}