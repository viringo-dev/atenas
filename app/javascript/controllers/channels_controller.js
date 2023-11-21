import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="channels"
export default class extends Controller {
  static targets = ["sidebar", "form", "messages"]

  connect() {
    this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight
  }

  toggleSidebar() {
    this.sidebarTarget.classList.toggle("-translate-x-full")
  }

  hideSidebar(event) {
    event.stopPropagation()
    if (!this.sidebarTarget.classList.contains("-translate-x-full")) {
      this.sidebarTarget.classList.add("-translate-x-full")
    }
  }

  resetForm() {
    this.formTarget.reset()
  }

  checkForSubmit(event) {
    if (event.key === "Enter" && !event.shiftKey) {
      event.preventDefault()
      this.formTarget.requestSubmit()
    }
  }
}
