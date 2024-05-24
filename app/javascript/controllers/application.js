import { Application } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

Turbo.start()

const application = Application.start()
application.debug = false
window.Stimulus = application

export { application }

