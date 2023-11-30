import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dot-notification"
export default class extends Controller {
  static values = { path: String }

  connect() {
    if (!window.location.href.includes(this.pathValue)) {
      this.element.classList.add("dot-notification")
    }
  }
}
