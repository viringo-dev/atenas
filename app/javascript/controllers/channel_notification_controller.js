import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="channel-notification"
export default class extends Controller {
  connect() {
    if (!window.location.href.includes(this.element.dataset.path)) {
      this.element.classList.add("channel-notification")
    }
  }
}
