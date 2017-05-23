'use strict'

import './styles/app'
import {main} from '../src/Main.purs'

if (module.hot) {
  let app = main()
  app.state.subscribe(state => { window.lastState = state })
  module.hot.accept()
} else {
  main()
}
