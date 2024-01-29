import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="read-more"
export default class extends Controller {
  static targets = ["shortText", "longText"]

  handle() {
    this.shortTextTarget.classList.toggle("hidden")
    this.longTextTarget.classList.toggle("hidden")
  }
}
