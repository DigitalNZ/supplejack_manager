import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { url: String, refreshInterval: Number }

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
    }, this.refreshIntervalValue)
  }

  stopRefreshing() {
    if (this.refreshTimer) {
      clearInterval(this.refreshTimer)
    }
  }

  load() {
    fetch(this.urlValue, { headers: { 'Turbo-Frame' : this.element.id } })
      .then(response => response.text())
      .then(html => this.element.innerHTML = html)
  }
}
