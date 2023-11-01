import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="checkbox-select-all"
export default class extends Controller {
  static targets = ["parent", "child", "actions"]
  connect() {
    // set all to false on page refresh
    this.childTargets.map(x => x.checked = false)
    this.parentTarget.checked = false
  }

  // set all checkboxes to true if select all checkbox is true
  toggleChildren() {
    if (this.parentTarget.checked) {
      this.childTargets.map(x => x.checked = true)
      // this.childTargets.forEach((child) => {
      //   child.checked = true
      // })
    } else {
      this.childTargets.map(x => x.checked = false)
    }
  }

  // set select all checkbox to false if any of child checkbox is true
  toggleParent() {
    if (this.childTargets.map(x => x.checked).includes(false)) {
      this.parentTarget.checked = false
    } else {
      this.parentTarget.checked = true
    }
  }

  // display bulk actions if any of checkbox is true
  toggleActions() {
    if (this.childTargets.map(x => x.checked).includes(true)) {
      this.actionsTarget.className = "";
    } else {
      this.actionsTarget.className = "hidden";
    }
  }
}
