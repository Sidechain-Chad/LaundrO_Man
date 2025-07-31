import { Controller } from "@hotwired/stimulus"
// This is the correct Stimulus controller that will make the stars interactive.
export default class extends Controller {
  // It connects to the HTML elements with `data-star-rating-target`
  static targets = ["input", "star"]
  // This is called when a star is clicked
  select(event) {
    const newRating = event.currentTarget.dataset.value
    // Update the hidden form field's value (e.g., to 3)
    this.inputTarget.value = newRating
    // Call the function to redraw the stars
    this.updateStars()
  }
  // This function redraws the stars to be solid yellow or empty gray
  updateStars() {
    const rating = this.inputTarget.value || 0
    this.starTargets.forEach((star, index) => {
      if (index < rating) {
        star.classList.remove("far") // 'far' is an empty star icon
        star.classList.add("fas")   // 'fas' is a solid star icon
      } else {
        star.classList.remove("fas")
        star.classList.add("far")
      }
    })
  }
  // This handles the temporary hover effect
  hover(event) {
    const hoverRating = event.currentTarget.dataset.value
    this.starTargets.forEach((star, index) => {
      if (index < hoverRating) {
        star.classList.add("hover-active")
      }
    })
  }
  // This resets the hover effect when the mouse leaves
  resetHover() {
    this.starTargets.forEach(star => star.classList.remove("hover-active"))
  }
}
