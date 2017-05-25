import { app, BrowserWindow } from 'electron'

let mainWindow = null

if (process.env.NODE_ENV === 'development') require('electron-debug')()

app.on('window-all-closed', () => { if (process.platform !== 'darwin') app.quit() })

app.on('ready', () => {
  mainWindow = new BrowserWindow({
    show: false,
    width: 1024,
    height: 728
  })

  mainWindow.loadURL(`file://${__dirname}/app/app.html`)

  mainWindow.webContents.on('did-finish-load', () => {
    mainWindow.show()
    mainWindow.focus()
  })

  mainWindow.on('closed', () => { mainWindow = null })

  if (process.env.NODE_ENV === 'development') mainWindow.openDevTools()
})
