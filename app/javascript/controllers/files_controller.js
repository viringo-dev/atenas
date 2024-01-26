import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="files"
export default class extends Controller {
  static targets = ["input"]
  static values = { maxAttachmentSize: Number }

  checkFiles() {
    if (this.inputTarget.files.length > 5) {
      alert("Solo se permiten 5 archivos adjuntos.")
      this.inputTarget.value = ""
    }
    this.checkFilesSize()
  }

  checkFilesSize() {
    let files = this.inputTarget.files
    for (let i = 0; i < files.length; i++) {
      if (files[i].size > this.maxAttachmentSizeValue * 1024 * 1024) {
        alert(`El límite de tamaño por archivo es de ${this.maxAttachmentSizeValue}MB.`)
        this.inputTarget.value = ""
        return
      }
    }
  }
}
