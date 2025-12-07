import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  // セリフの行 <p> を「targets」として扱う
  static targets = ["line"]

  connect() {
    // 今どの行を表示しているか（0 = 最初の行）
    this.index = 0
  }

  next() {
    // もう次の行が無いときは何もしない
    if (this.index >= this.lineTargets.length - 1) {
      return
    }

    // 今の行を隠す
    this.lineTargets[this.index].classList.add("hidden")

    // 次の行へ
    this.index += 1

    // 次の行を表示する
    this.lineTargets[this.index].classList.remove("hidden")
  }
}