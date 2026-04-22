import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["audio", "button", "volume"]

  connect() {
    this.enabled = localStorage.getItem("bgm") !== "off"

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
    this.enabled = !this.enabled
    localStorage.setItem("bgm", this.enabled ? "on" : "off")

    if (this.enabled) {
      this.play()
    } else {
      this.pause()
    }

    this.syncState()
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

  play() {
    if (!this.audio) return
    if (!this.enabled) return
    if (!this.audio.paused) return

    this.audio.play().catch(() => {})
  }

  pause() {
    if (!this.audio) return
    this.audio.pause()
  }

  syncState() {
    if (this.hasButtonTarget) {
      this.buttonTarget.textContent = this.enabled ? "♪ ON" : "♪ OFF"
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