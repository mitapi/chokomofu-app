import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["line", "nextIndicator", "closer", "choices"]

  connect() {
    // 今どの行を表示しているか（0 = 最初の行）
    this.index = 0
    this.total = this.lineTargets.length
    this.updateUI()
  }

  next() {
    // もう次の行が無いときは何もしない
    if (this.index >= this.total - 1) {
      return
    }

    // 今の行を隠す
    this.lineTargets[this.index].classList.add("hidden")

    // 次の行へ
    this.index += 1

    // 次の行を表示する
    this.lineTargets[this.index].classList.remove("hidden")

    this.updateUI()
  }

  updateUI() {
   const isLast = this.index >= this.total - 1

    // ▼ の表示／非表示（最後のページでは消す）
    if (this.hasNextIndicatorTarget) {
      this.nextIndicatorTarget.classList.toggle("hidden", isLast || this.total <= 1)
    }

    if (this.hasChoicesTarget) {
      this.choicesTarget.classList.toggle("hidden", !isLast)
    }

    // 「会話をとじる」の表示／非表示（最後のページだけ出す）
    if (this.hasCloserTarget) {
      this.closerTarget.classList.toggle("hidden", !isLast)
    }
  }
}
