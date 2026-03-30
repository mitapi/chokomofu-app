import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["image"]
  static values = { expressions: Object }

  change(event) {
    const expressionKey = event.detail.expressionKey
    const nextImagePath = this.expressionsValue[expressionKey]

    if (!nextImagePath) return

    this.imageTarget.src = nextImagePath
  }
}