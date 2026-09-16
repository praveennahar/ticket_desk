import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { seconds: Number }

  connect() {
    this.left = this.secondsValue
    this.draw()
    this.timer = setInterval(() => this.draw(), 1000)
  }

  disconnect() {
    clearInterval(this.timer)
  }

  draw() {
    if (this.left <= 0) {
      this.element.textContent = "hold expired — pick seats again"
      this.element.classList.add("timer-low")
      clearInterval(this.timer)
      return
    }
    if (this.left < 60) this.element.classList.add("timer-low")
    const min = Math.floor(this.left / 60)
    const sec = String(this.left % 60).padStart(2, "0")
    this.element.textContent = `expires in ${min}:${sec}`
    this.left -= 1
  }
}
