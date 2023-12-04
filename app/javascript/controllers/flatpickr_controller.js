import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr"

// Connects to data-controller="flatpickr"
export default class extends Controller {
  static values = { params: { type: Object, default: {} } }

  connect() {
    flatpickr(this.element, this.paramsValue);
  }
}
