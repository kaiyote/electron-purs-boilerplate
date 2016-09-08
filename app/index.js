'use strict'

import './styles/app'
import Main from '../src/Main'

const debug = process.env.NODE_ENV === 'development'

if (module.hot) {
  let app = Main.main(window.lastState || Main.init)()
  app.state.subscribe(state => window.lastState = state)
  module.hot.accept()
} else {
  Main[debug ? 'debug' : 'main'](init)()
}
