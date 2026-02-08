import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  close(event) {
    console.log("[diary-modal] close")
    event?.preventDefault()

    const frame = document.getElementById("diary_modal")
    if (frame) frame.innerHTML = ""
  }

  stop(event) {
    event.stopPropagation()
  }
}