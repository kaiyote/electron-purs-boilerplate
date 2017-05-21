'use strict'

import './styles/app'
import {main, init} from '../src/Main.purs'

const devMode = process.env.NODE_ENV === 'development'

if (module.hot) {
  let app = main(window.lastState || init)()
  app.state.subscribe(state => { window.lastState = state })
  module.hot.accept()
} else {
  main(init)()
}
