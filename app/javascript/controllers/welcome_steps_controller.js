import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["step", "prevButton", "nextButton", "counter"]

  connect() {
    // 今どの行を表示しているか（0 = 最初の行）
    this.index = 0
    this.total = this.stepTargets.length
    this.showOnly(this.index)
    this.updateUI()
  }

  prev() {
    if (this.index <= 0) return
    this.index -= 1
    this.showOnly(this.index)
    this.updateUI()
  }

  next() {
    if (this.index >= this.total - 1) return
    this.index += 1
    this.showOnly(this.index)
    this.updateUI()
  }

  showOnly(activeIndex) {
    this.stepTargets.forEach((el, i) => {
      if (i === activeIndex) {
        el.classList.remove("hidden")
      } else {
        el.classList.add("hidden")
      }
    })
  }

  updateUI() {
    if (this.hasCounterTarget) {
      this.counterTarget.textContent = `${this.index + 1} / ${this.total}`
    }

    if (this.hasPrevButtonTarget) {
      this.prevButtonTarget.disabled = (this.index === 0)
    }
    if (this.hasNextButtonTarget) {
      this.nextButtonTarget.disabled = (this.index === this.total - 1)
    }
  }
}