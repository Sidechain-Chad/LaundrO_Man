import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "items", "template", "item", "itemType", "quantity", "price",
    "destroyField", "total", "totalInput"
  ]

  connect() {
    this.prices = {
      "T-Shirt": 25, "Shirt": 28, "Blouse": 32, "Polo Shirt": 26, "Chinos": 38,
      "Dress Pants": 45, "Jeans": 40, "Shorts": 30, "Jacket": 65, "Hoodie": 60,
      "Sweater": 55, "Tracksuit": 70, "Underpants": 12, "Boxers": 14, "Briefs": 12,
      "Bra": 15, "Socks (Pair)": 8, "Undershirt": 15, "Silk Blouse": 45,
      "Lace Dress": 60, "Wool Sweater": 50, "Scarf": 18, "Suit (2-piece)": 130,
      "Suit (3-piece)": 150, "Evening Gown": 170, "Coat": 95, "Blazer": 70,
      "Skirt": 45, "Dress": 55, "Curtains": 65, "Bed Sheet": 40, "Duvet Cover": 60,
      "Pillow Case": 18, "Blanket": 75, "Comforter": 90, "Mattress Cover": 85,
      "Tablecloth": 35, "Rug (Small)": 110, "Rug (Large)": 180
    }

    // Prepopulate and update prices for existing items (edit mode)
    this.itemTargets.forEach(item => {
      const itemType = item.querySelector('[data-order-items-target="itemType"]')
      if (itemType) {
        const event = new Event('change', { bubbles: true })
        itemType.dispatchEvent(event)
      }
    })

    this.updateTotal()
  }

  add() {
    const html = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, Date.now())
    this.itemsTarget.insertAdjacentHTML("beforeend", html)

    const row = this.itemsTarget.lastElementChild
    if (!row) return

    row.classList.add("new-item")

    row.addEventListener("animationend", () => {
      row.classList.remove("new-item")
    })

    const itemTypeSel = row.querySelector('[data-order-items-target="itemType"]')
    const quantityInput = row.querySelector('[data-order-items-target="quantity"]')

    if (itemTypeSel && !itemTypeSel.value) itemTypeSel.value = "T-Shirt"
    if (quantityInput && !quantityInput.value) quantityInput.value = 1

    this.updateItemPrice({ target: itemTypeSel || quantityInput })
    this.updateTotal()
  }

  remove(event) {
    const item = event.target.closest("[data-order-items-target='item']")
    const destroyField = item.querySelector("input[name*='_destroy']")

    item.classList.add("removing")

    item.addEventListener("animationend", () => {
      if (destroyField) {
        destroyField.value = "1"
        item.style.display = "none"
      } else {
        item.remove()
      }
      this.updateTotal()
    }, { once: true })
  }

  updateItemPrice(event) {
    const item = event.target.closest("[data-order-items-target='item']")
    const itemType = item.querySelector('[data-order-items-target="itemType"]')?.value
    const quantity = parseInt(item.querySelector('[data-order-items-target="quantity"]')?.value || 1)
    const priceField = item.querySelector('[data-order-items-target="price"]')

    const unitPrice = this.prices[itemType] || 0
    const total = unitPrice * quantity

    if (priceField) priceField.value = total.toFixed(2)

    this.updateTotal()
  }

  updateTotal() {
    let total = 0.0

    this.itemTargets.forEach((item) => {
      const destroyField = item.querySelector('[data-order-items-target="destroyField"]')
      if (destroyField && destroyField.value === "1") return

      const priceInput = item.querySelector('[data-order-items-target="price"]')
      if (priceInput && priceInput.value) {
        total += parseFloat(priceInput.value)
      }
    })

    if (this.hasTotalTarget) {
      this.totalTarget.textContent = total.toFixed(2)
    }

    if (this.hasTotalInputTarget) {
      this.totalInputTarget.value = total.toFixed(2)
    }
  }

  preventSubmit(event) {
    const visibleItems = this.itemTargets.filter((item) => {
      const destroyField = item.querySelector('[data-order-items-target="destroyField"]')
      return !destroyField || destroyField.value !== "1"
    })

    if (visibleItems.length === 0) {
      event.preventDefault()
      alert("Please add at least one item to your order.")
    }
  }
}
