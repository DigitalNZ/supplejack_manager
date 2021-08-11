/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

require("@rails/ujs").start()

import 'stylesheets/application'
import 'src/application'
import { init as initApm } from '@elastic/apm-rum'

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
const images = require.context('../images', true)
const imagePath = (name) => images(name, true)

if(process.env.RAILS_ENV == 'production') {
  const apm = initApm({
    // Set required service name (allowed characters: a-z, A-Z, 0-9, -, _, and space)
    serviceName: 'Supplejack Manager',

    // Set custom APM Server URL (default: http://localhost:8200)
    serverUrl: process.env.ELASTIC_APM_SERVER_URL,

    // Set service version (required for sourcemap feature)
    serviceVersion: '',

    environment: process.env.RAILS_ENV
  })
}
