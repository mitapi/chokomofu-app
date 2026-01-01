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
      const prevOff = (this.index === 0)
      this.prevButtonTarget.classList.toggle("invisible", prevOff)
      this.prevButtonTarget.classList.toggle("pointer-events-none", prevOff)
    }

    if (this.hasNextButtonTarget) {
      const nextOff = (this.index === this.total - 1)
      this.nextButtonTarget.classList.toggle("invisible", nextOff)
      this.nextButtonTarget.classList.toggle("pointer-events-none", nextOff)
    }
  }
}