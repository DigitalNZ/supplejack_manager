import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { url: String, refreshInterval: Number, turboFrameId: String }

  connect() {
    this.load()

    if (this.hasRefreshIntervalValue) {
      this.startRefreshing()
    }
    $(this.element).parents('.reveal').on('closed.zf.reveal', () => {
      this.stopRefreshing()
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
