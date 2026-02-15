import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["line", "nextIndicator", "closer", "choices"]

  connect() {
    // 今どの行を表示しているか（0 = 最初の行）
    this.index = 0
    this.total = this.lineTargets.length
    this.updateUI()
    this.emitStepChange()
  }

  next(event) {
    // 選択肢（a / button / form）を押した時は、会話送り処理をしない
    if (event?.target?.closest("a, button, form")) return

    console.log("[conversation-step] next called")

    if (this.index >= this.total - 1) return

    // 今の行を隠す
    this.lineTargets[this.index].classList.add("hidden")

    // 次の行へ
    this.index += 1

    // 次の行を表示する（←先に表示！）
    this.lineTargets[this.index].classList.remove("hidden")

    // いま表示中の行から expressionKey を取って通知
    const currentLine = this.lineTargets[this.index]
    const expressionKey = currentLine?.dataset?.expressionKey

    this.element.dispatchEvent(
      new CustomEvent("conversation-step:change", {
        bubbles: true,
        detail: { expressionKey }
      })
    )

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

  emitStepChange() {
    this.element.dispatchEvent(
      new CustomEvent("conversation-step:change", {
        bubbles: true,
        detail: { expressionKey: this.lineTargets.find(el => !el.classList.contains("hidden"))?.dataset?.expressionKey }
      })
    )
  }

  stop(event) {
    event.stopPropagation()
  }  
}
