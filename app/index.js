'use strict'

import './styles/app'
import {debug, main, init} from '../src/Main'

const devMode = process.env.NODE_ENV === 'development'

if (module.hot) {
  let app = (devMode ? debug : main)(window.lastState || init)()
  app.state.subscribe(state => { window.lastState = state })
  module.hot.accept()
} else {
  (devMode ? debug : main)(init)()
}
