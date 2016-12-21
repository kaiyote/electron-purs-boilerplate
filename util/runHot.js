const waitOn = require('wait-on')
const electron = require('electron')
const join = require('path').join

const main = join(__dirname, '../main.development.js')

console.log(main)

const waitOpts = {
  resources: [
    main,
    'http-get://localhost:3000/dist/bundle.js'
  ]
}

waitOn(waitOpts, err => {
  if (err) return console.error(err)
  require('spawn-auto-restart')({
    proc: {
      command: electron,
      args: `-r babel-register ${main}`
    },
    watch: [main]
  })
})
