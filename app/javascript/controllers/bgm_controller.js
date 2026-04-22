import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["audio", "button", "volume"]

  connect() {
    this.enabled = localStorage.getItem("bgm") !== "off"
    this.needsInteraction = false

    const savedVolume = parseFloat(localStorage.getItem("bgmVolume"))
    const volume = Number.isFinite(savedVolume) ? savedVolume : 0.1

    if (this.audio) {
      this.audio.volume = volume
    }

    if (this.hasVolumeTarget) {
      this.volumeTarget.value = volume
    }

    this.handleVisibilityChange = this.handleVisibilityChange.bind(this)
    document.addEventListener("visibilitychange", this.handleVisibilityChange)

    this.syncState()

    if (this.enabled) {
      this.play()
    } else {
      this.pause()
    }
  }

  disconnect() {
    document.removeEventListener("visibilitychange", this.handleVisibilityChange)
  }

  toggle() {
    if (this.enabled && this.needsInteraction) {
      this.play()
      return
    }

    this.enabled = !this.enabled
    localStorage.setItem("bgm", this.enabled ? "on" : "off")

    if (this.enabled) {
      this.play()
    } else {
      this.pause()
      this.needsInteraction = false
      this.syncState()
    }
  }

  changeVolume() {
    const volume = parseFloat(this.volumeTarget.value)

    if (this.audio) {
      this.audio.volume = volume
    }

    localStorage.setItem("bgmVolume", String(volume))
  }

  handleVisibilityChange() {
    if (document.hidden) {
      this.pause()
    } else if (this.enabled) {
      this.play()
    }
  }

  async play() {
    if (!this.audio) return
    if (!this.enabled) return
    if (!this.audio.paused) return

    try {
      await this.audio.play()
      this.needsInteraction = false
    } catch (_) {
      this.needsInteraction = true
    }

    this.syncState()
  }

  pause() {
    if (!this.audio) return
    this.audio.pause()
  }

  syncState() {
    if (this.hasButtonTarget) {
      if (!this.enabled) {
        this.buttonTarget.textContent = "♪ OFF"
      } else if (this.needsInteraction) {
        this.buttonTarget.textContent = "♪ TAP"
      } else {
        this.buttonTarget.textContent = "♪ ON"
      }
    }

    this.element.classList.toggle("bgm-on", this.enabled)

    if (this.hasVolumeTarget) {
      this.volumeTarget.disabled = !this.enabled
    }
  }

  get audio() {
    if (this.hasAudioTarget) return this.audioTarget
    return document.querySelector("#bgm-audio audio")
  }
}