import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="new-notification"
export default class extends Controller {
  static values = { path: String, notification: String }

  connect() {
    if (window.location.href.includes(this.pathValue)) {
      let notification = this.notificationValue;
      if (notification) {
        fetch(`/notifications/${notification}/mark_as_read`, {
          method: "PUT",
          headers: {
            "Content-Type": "application/json",
            "X-CSRF-Token": document.querySelector("[name='csrf-token']").content,
            "Accept": "application/json"
          }
        })
      }
    } else {
      this.element.classList.add("dot-notification")
    }
  }
}
