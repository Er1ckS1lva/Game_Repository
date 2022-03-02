function love.conf(tela)

    tela.identity = nil
    tela.console = true
    tela.width = 800
    tela.height = 800

    tela.window.title = "Rankers Guild"
    tela.window.icon = nil
    tela.window.resizable = false
    tela.window.fullscreen = false
    tela.window.fullscreentype = "desktop"

    tela.modules.audio = true
    tela.modules.event = true
    tela.modules.graphics = true
    tela.modules.keyboard = true
    tela.modules.physics = true

end