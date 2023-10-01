import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="files"
export default class extends Controller {
  static targets = ["input"]

  checkFiles() {
    if (this.inputTarget.files.length > 5) {
      alert("Solo se permiten 5 archivos adjuntos.")
      this.inputTarget.value = ""
    }
  }
}
