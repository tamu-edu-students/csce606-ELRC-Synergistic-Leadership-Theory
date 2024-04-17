# frozen_string_literal: true

# Pin npm packages by running ./bin/importmap

pin 'application'
pin 'three', to: 'https://cdn.jsdelivr.net/npm/three@0.163.0/build/three.module.js'
pin 'three/addons/', to: 'https://cdn.jsdelivr.net/npm/three@0.163.0/examples/jsm/'
pin 'tetrahedron'
pin '@hotwired/turbo-rails', to: 'turbo.min.js'
pin '@hotwired/stimulus', to: 'stimulus.min.js'
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js'
pin_all_from 'app/javascript/controllers', under: 'controllers'
