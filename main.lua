STI = require("Modulos//sti")
jogo = require("jogo_controle")
i_controle = require "inventario_controle"
local CM = require "lib.CameraMgr".newManager()
player = require("jogador")
enrredo = require("historinha")

play = false
gamestate = "menu"
musica = true

function love.load()

    local menus = ("menu.lua")

    Game_font = love.graphics.newImageFont("Font.png",
    " abcdefghijklmnopqrstuvwxyz" ..
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ0" ..
    "123456789.,!?-+/():;%&`'*#=[]\"")
    love.graphics.setFont(Game_font)

    Musica_menu = love.audio.newSource("Sons//Musicas//Title_music.mp3", "stream")
    Musica_morte = love.audio.newSource("Sons//Musicas//morte.mp3", "stream")
    Musica_ambiente = love.audio.newSource("Sons//Musicas//sons_ambiente.mp3", "stream")

    
    Musica_menu:setVolume(0.01)
    Musica_menu:play()

    menu = carregando_Mapa(menus)
    options = carregando_Mapa("menuOpt.lua")
    pausa = carregando_Mapa("Pause_menu.lua")
    morto = carregando_Mapa("Morte_Menu.lua")

    inventario = carregando_Mapa("Inventario.lua")
    inventario_state = 1

    options.layers.MusicaOff.visible = false
    jogo:load()


end

function love.update()
    
    if play then
        jogo:update()
        
        if musica then
            Musica_menu:stop()
            Musica_ambiente:setVolume(0.01)
            Musica_ambiente:play()
        end
    else
        
        if gamestate == "menu" then
            menu:update()
            
        elseif gamestate == "opt" then
            options:update()

        elseif gamestate == "pause" then
            pausa:update()

        elseif gamestate == "opt_pause" then
            options:update()

        elseif gamestate == "morto" then
            morto:update()
            Musica_ambiente:stop()
            Musica_morte:setVolume(0.01)
            Musica_morte:play()

        elseif gamestate == "opt_morto" then
            morto:update()
            options:update()
        
        elseif gamestate == "inventario" then
            inventario:update()
            i_controle:update()
        elseif gamestate == "enrredo" then
            enrredo:update()
        end
            
    end

end

function love.draw()

    if play then
        jogo:draw()
    else
        if gamestate == "menu" then
            menu:draw()
        elseif gamestate == "opt" then
            menu:draw()
            options:draw()
        elseif gamestate == "pause" then
            pausa:draw()
        elseif gamestate == "opt_pause" then
            pausa:draw()
            options:draw()

        elseif gamestate == "morto" then
            morto:draw()
        elseif gamestate == "opt_morto" then
            morto:draw()
            options:draw()
        elseif gamestate == "inventario" then
            inventario:draw()
            i_controle:draw()
        elseif gamestate == "enrredo" then
            jogo:draw()
            enrredo:draw()
        end
    end

end

function carregando_Mapa(caminho_mapa)
    
    mapa_atual = STI(caminho_mapa,{"box2d"})
    love.physics.setMeter(32)
	world = love.physics.newWorld(0, 0)
	mapa_atual:box2d_init(world)
    return mapa_atual

end

function love.mousepressed(x, y, istouch)

    if gamestate == "menu" 	 then
        if x >= 313 and x <= 313+170.5 and y >= 290 and y <= 290+54 then
            game_init()
        end

        if x >= 311.5 and x <= 311.5+170.5 and y >= 356.5 and y <= 356.5+54 then
            loadGame()
        end

        if x >= 308.5 and x <= 308.5+177 and y >= 485 and y <= 485+48.5 then
            love.event.quit( 0 )
        end

        if x >= 310 and x <= 310+172.5 and y >= 421 and y <= 421+47.5 then
            gamestate = "opt"
        end
    elseif gamestate == "opt" then

        if x >= 337.333 and x <= 337.333+69.3333 and y >= 112 and y <= 112+68 then
            if musica then
                musica = false
                love.audio.stop(Musica_menu)
                options.layers.MusicaOff.visible = true
                options.layers.MusicaOn.visible = false
            else
                musica = true
                love.audio.play(Musica_menu)
                options.layers.MusicaOff.visible = false
                options.layers.MusicaOn.visible = true
            end
        end

        if x >= 626.667 and x <= 626.667+61.3333 and y >= 98.6667 and y <= 98.6667+50.6667 then
            gamestate = "menu"
        end


    elseif gamestate == "pause" then

        if x >= 313 and x <= 313+170.5 and y >= 290 and y <= 290+54 then
            play = true
        end

        if x >= 311.5 and x <= 311.5+172.5 and y >= 356.5 and y <= 356.5+50 then

            local aux = Jogador.JogadorX .. "," .. Jogador.JogadorY.."," ..cenario_atual.."," ..Jogador.Level..",\
            " ..Jogador.VidaAtual.."," ..Jogador.VidaMax .."," ..Jogador.Velocidade.."," ..Jogador.XP_Atual.."," ..Jogador.XP_Level..",\
            " ..Jogador.Dano.."," ..Jogador.Defesa
            
           
            local success, message =love.filesystem.write( "SavedGame",aux)
            if success then
                print("Salvo")
            else
                print(message)
            end

        end

        if x >= 308.5 and x <= 308.5+177 and y >= 485 and y <= 485+48.5 then
            love.event.quit( 0 )
        end

        if x >= 310 and x <= 310+173.5 and y >= 421 and y <= 421+47.5 then
            gamestate = "opt_pause"
        end
    
    elseif gamestate == "opt_pause" then

        if x >= 337.333 and x <= 337.333+69.3333 and y >= 112 and y <= 112+68 then
            if musica then
                musica = false
                love.audio.stop(Musica_ambiente)
                options.layers.MusicaOff.visible = true
                options.layers.MusicaOn.visible = false
            else
                musica = true
                love.audio.play(Musica_ambiente)
                options.layers.MusicaOff.visible = false
                options.layers.MusicaOn.visible = true
            end
        end

        if x >= 626.667 and x <= 626.667+61.3333 and y >= 98.6667 and y <= 98.6667+50.6667 then
            gamestate = "pause"
        end
        
    elseif gamestate == "morto" then

        if x >= 313 and x <= 313+170.5 and y >= 290 and y <= 290+54 then
            love.audio.stop(Musica_morte)
            reset_Data()
            loadGame()
            play = true
        end

        if x >= 311.5 and x <= 311.5+172.5 and y >= 356.5 and y <= 356.5+50 then
            love.audio.stop(Musica_morte)
            reset_Data()
            loadGame()
            play = true
        

        end

        if x >= 308.5 and x <= 308.5+177 and y >= 485 and y <= 485+48.5 then
            love.event.quit( 0 )
        end

        if x >= 310 and x <= 310+173.5 and y >= 421 and y <= 421+47.5 then
            gamestate = "opt_morto"
        end


    elseif gamestate == "opt_morto" then

        if x >= 337.333 and x <= 337.333+69.3333 and y >= 112 and y <= 112+68 then
            if musica then
                musica = false
                love.audio.stop(Musica_morte)
                options.layers.MusicaOff.visible = true
                options.layers.MusicaOn.visible = false
            else
                musica = true
                love.audio.play(Musica_morte)
                options.layers.MusicaOff.visible = false
                options.layers.MusicaOn.visible = true
            end
        end

        if x >= 626.667 and x <= 626.667+61.3333 and y >= 98.6667 and y <= 98.6667+50.6667 then
            gamestate = "pause"
        end


    elseif gamestate == "inventario" then

        --[[if inventario_state == 1 then
            --Status--
            inventario.layers.Status.visible = true
            inventario.layers.Itens.visible = false
            inventario.layers.Mapa.visible = false
            inventario.layers.Missoes.visible = false
        
        elseif inventario_state == 2 then
            --Itens--
            inventario.layers.Status.visible = false
            inventario.layers.Itens.visible = true
            inventario.layers.Mapa.visible = false
            inventario.layers.Missoes.visible = false

        elseif inventario_state == 3 then
            --Mapa--
            inventario.layers.Status.visible = false
            inventario.layers.Itens.visible = false
            inventario.layers.Mapa.visible = true
            inventario.layers.Missoes.visible = false
        
        elseif inventario_state == 4 then
            --missoes--
            inventario.layers.Status.visible = false
            inventario.layers.Itens.visible = false
            inventario.layers.Mapa.visible = false
            inventario.layers.Missoes.visible = true

        end]]--

        if x >= 720 and x <= 720+70.6667 and y >= 12 and y <= 12+41.3333 then
            play = true
            inventario_state = 1
        end 

        if x >= 38.6667 and x <= 38.6667+164 and y >= 97.3333 and y <= 97.3333+57.3333 then
            inventario_state = 1
        end

        if x >= 229.333 and x <= 229.333+149.333 and y >= 98.6667 and y <= 98.6667+ 57.3333 then
            inventario_state = 2
        end

        if x >= 421.333 and x <= 421.333+118.667 and y >= 96 and y <= 96+60 then
            inventario_state = 3
        end

        if x >= 582.667 and x <= 582.667+180 and y >= 101.333 and y <= 101.333+52 then
            inventario_state = 4
        end

    end
end

function loadGame()

    contents, size = love.filesystem.read( "SavedGame", size )
    saved =  mysplit(contents, ",")

    for i in ipairs(saved) do
        print(saved[i])
    end
    
    local Jx, Jy, mapa , jogador_level = tonumber(saved[1]), tonumber(saved[2]), saved[3], tonumber(saved[4])

    local vida_atual, vida_max, velocidade, xp, xp_total = tonumber(saved[5]), tonumber(saved[6]), tonumber(saved[7]), tonumber(saved[8]), tonumber(saved[9])

    local dano, defesa = tonumber(saved[10]), tonumber(saved[11])


    cenario_atual = mapa
    cenario = carregando_Mapa(cenario_atual)
    XMAX, YMAX = getAreaMap(cenario)
    CM.setScale(Escala)
    CM.setCoords(Jx, Jy)

    Jogador.Level = jogador_level
    Jogador.VidaAtual =vida_atual
    Jogador.VidaMax =vida_max
    Jogador.Velocidade =velocidade
    Jogador.XP_Atual =xp
    Jogador.XP_Level =xp_total
    Jogador.Dano =dano
    Jogador.Defesa =defesa
    
    setPosJogador(Jx, Jy)
    colisor_init(cenario, true)
    play = true

end

function mysplit(inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
end

function game_init()
    play = true
end