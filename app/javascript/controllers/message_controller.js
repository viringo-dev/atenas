import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="message"
export default class extends Controller {
  connect() {
    let parentElement = this.element.parentElement;
    if (parentElement.scrollTop + parentElement.clientHeight + this.element.clientHeight * 2 >= parentElement.scrollHeight) {
      parentElement.scrollTop = parentElement.scrollHeight
    }
  }
}
