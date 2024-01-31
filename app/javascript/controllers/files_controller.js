import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="files"
export default class extends Controller {
  static targets = ["input", "previewBox", "form"]
  static values = { maxAttachmentSize: Number }

  checkFiles() {
    if (this.inputTarget.files.length > 5) {
      alert("Solo se permiten 5 archivos adjuntos.")
      this.inputTarget.value = ""
    }
    this.checkFilesSize()
    this.previewFiles()
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

  previewFiles() {
    for (let i = 0; i < this.inputTarget.files.length; i++) {
      let file = this.inputTarget.files[i]
      this.insertElement(file)
    }
  }

  insertElement(file) {
    const previewElement = document.createElement("div")
    previewElement.classList.add("preview-attachment")
    previewElement.innerHTML = file.name
    this.previewBoxTarget.appendChild(previewElement)

    const previewDeleteElement = document.createElement("span")
    previewDeleteElement.classList.add("preview-attachment-delete")
    previewDeleteElement.innerHTML = this.deleteSvg()
    previewDeleteElement.addEventListener("click", () => {
      previewElement.remove()
      this.removeFileFromInput(file, this.inputTarget)
    })
    previewElement.appendChild(previewDeleteElement)
  }

  deleteSvg() {
    return `<svg class="w-6 h-6 text-negative" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="currentColor" viewBox="0 0 24 24">
              <path fill-rule="evenodd" d="M2 12a10 10 0 1 1 20 0 10 10 0 0 1-20 0Zm7.7-3.7a1 1 0 0 0-1.4 1.4l2.3 2.3-2.3 2.3a1 1 0 1 0 1.4 1.4l2.3-2.3 2.3 2.3a1 1 0 0 0 1.4-1.4L13.4 12l2.3-2.3a1 1 0 0 0-1.4-1.4L12 10.6 9.7 8.3Z" clip-rule="evenodd"/>
            </svg>`
  }

  removeFileFromInput(file, input) {
    let remainingFiles = Array.from(input.files).filter((f) => f.name !== file.name)
    const dataTransfer = new DataTransfer();
    remainingFiles.forEach((f) => dataTransfer.items.add(f));
    this.inputTarget.files = dataTransfer.files;
  }

  resetForm() {
    this.previewBoxTarget.innerHTML = ""
  }
}
