'use strict'

import './styles/app'
import Main from '../src/Main'
import { init } from '../src/Layout'

const debug = process.env.NODE_ENV === 'development'

if (module.hot) {
  let app = Main[debug ? 'debug' : 'main'](window.lastState || init)()
  app.state.subscribe(state => window.lastState = state)
  module.hot.accept()
} else {
  Main[debug ? 'debug' : 'main'](init)()
}
