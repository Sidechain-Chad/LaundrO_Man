import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { timeout: Number }

  connect() {
    setTimeout(() => {
      this.element.classList.remove("show")
      this.element.classList.add("fade")
      setTimeout(() => this.element.remove(), 500)
    }, this.timeoutValue || 5000)
  }
}

