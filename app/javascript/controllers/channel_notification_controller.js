import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="channel-notification"
export default class extends Controller {
  static values = { path: String, channel: String }

  connect() {
    if (window.location.href.includes(this.pathValue)) {
      let channel = this.channelValue;
      if (channel) {
        fetch(`/channels/${channel}/mark_as_read`, {
          method: "PUT",
          headers: {
            "Content-Type": "application/json",
            "X-CSRF-Token": document.querySelector("[name='csrf-token']").content,
            "Accept": "application/json"
          }
        })
      }
    } else {
      this.element.classList.add("channel-notification")
    }
  }
}
