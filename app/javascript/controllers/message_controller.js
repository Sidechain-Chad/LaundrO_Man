import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="message"
export default class extends Controller {
  static values = { userId: Number }
  static targets = ["input", "form"]

  connect() {
    // Message appearance (sent/received)
    const currentUserId = parseInt(document.body.dataset.currentUserId, 10)
    if (this.userIdValue === currentUserId) {
      this.element.classList.add('sent')
      this.element.classList.remove('received')
    } else {
      this.element.classList.add('received')
      this.element.classList.remove('sent')
    }

    // Scroll message into view
    this.element.scrollIntoView({ behavior: 'smooth' })

    // Setup Enter-to-send
    if (this.hasInputTarget && this.hasFormTarget) {
      this.inputTarget.addEventListener("keydown", (e) => {
        if (e.key === "Enter" && !e.shiftKey) {
          e.preventDefault()
          this.formTarget.requestSubmit()
        }
      })
    }
  }

  // Clears message input after send
  clear() {
    if (this.hasInputTarget) {
      this.inputTarget.value = ""
    }
  }
}
