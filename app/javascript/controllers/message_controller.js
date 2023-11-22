import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="message"
export default class extends Controller {
  connect() {
    let parentElement = this.element.parentElement;
    if (this.element.clientHeight * 4 > Math.abs(parentElement.scrollTop)) {
      parentElement.scrollTop = -1000000
      parentElement.scrollTop = 0
    }
  }
}
