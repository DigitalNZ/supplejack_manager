import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { url: String, refreshInterval: Number, turboFrameId: String }
  static targets = [ 'resume' ]

  connect() {
    if (this.hasRefreshIntervalValue) {
      this.startRefreshing()
    }
    $(this.element).parents('.reveal').on('closed.zf.reveal', () => {
      this.stopRefreshing()
    })
  }

  resumeTargetConnected(element) {
    element.addEventListener('click', () => {
      setTimeout(() => this.startRefreshing(), 2000)
    })
  }

  disconnect() {
    this.stopRefreshing();
  }

  startRefreshing() {
    this.refreshTimer = setInterval(() => {
      this.load()
      if (this.element.querySelector('[data-active]').dataset['active'] == 'false') {
        this.stopRefreshing()
      }
    }, this.refreshIntervalValue)
  }

  stopRefreshing() {
    if (this.refreshTimer) {
      clearInterval(this.refreshTimer)
    }
  }

  load() {
    const frame = document.getElementById(this.turboFrameIdValue);
    frame.src = this.urlValue;
  }
}
