import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="rating"
export default class extends Controller {
  static targets = ["1", "2", "3", "4", "5", "currentRating", "valueField"]
  connect() {
  }

  handleRating(event) {
    if (this["1Target"].contains(event.target)) {
      this.grayStars(1)
    } else if (this["2Target"].contains(event.target)) {
      this.grayStars(2)
    } else if (this["3Target"].contains(event.target)) {
      this.grayStars(3)
    } else if (this["4Target"].contains(event.target)) {
      this.grayStars(4)
    } else if (this["5Target"].contains(event.target)) {
      this.grayStars(5)
    }
  }

  grayStars(limit) {
    for (let i = 1; i <= 5; i++) {
      this[`${i}Target`].classList.remove("text-star");
    }
    if (this.currentRatingTarget.value === limit) {
      this.currentRatingTarget.value = 0;
    } else {
      for (let i = 1; i <= limit; i++) {
        this[`${i}Target`].classList.add("text-star");
      }
      this.currentRatingTarget.value = limit;
    }
    this.valueFieldTarget.value = this.currentRatingTarget.value;
  }
}
