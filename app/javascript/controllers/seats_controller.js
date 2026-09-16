import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["count"]

  connect() {
    this.update()
  }

  update() {
    const n = this.picked()
    if (!this.hasCountTarget) return
    if (n === 0) {
      this.countTarget.textContent = "tick open seats. yellow is held, grey is booked."
    } else {
      this.countTarget.textContent = n === 1 ? "1 seat selected" : `${n} seats selected`
    }
  }

  requirePick(event) {
    if (this.picked() > 0) return
    event.preventDefault()
    if (this.hasCountTarget) this.countTarget.textContent = "tick at least one seat"
  }

  picked() {
    return this.element.querySelectorAll("input[type=checkbox]:checked").length
  }
}
