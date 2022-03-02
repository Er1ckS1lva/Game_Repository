anim8 = require("Modulos//anim8")
local CM = require "lib.CameraMgr".newManager()
log = require("Log")
inventario_jogador = require "Inventario_controle"

Jogador = {}
Jogador.Level = 1
Jogador.VidaAtual = 50
Jogador.VidaMax = 50 
Jogador.JogadorX = 16 
Jogador.JogadorY = 16 
Jogador.JogadorAltura = 32
Jogador.JogadorLargura = 16
Jogador.Velocidade = 20
Jogador.XP_Atual = 0
Jogador.XP_Level = 20 
Jogador.Dano = 3 
Jogador.Defesa = 1
Jogador.Collider = nil
Jogador.ATKCollider = nil
Jogador.AtaqueCD = 0
Jogador.Andar_Grama = love.audio.newSource("Sons//Jogador//grama.mp3", "static")
Jogador.Ataque_Som = love.audio.newSource("Sons//Jogador//espadada.mp3", "stream")

Jogador.itens = {

    id = nil,
    quantidade = nil,

}

Jogador.itens[1] = {

    id = 2,
    quantidade = 500,

}

Jogador.itens[2] = {

    id = 3,
    quantidade = 57,

}

Jogador.Historia = 1

Jogador.meritos = 100000
Jogador.Ranking = "Unranked"

image_Int = love.graphics.newImage( "Elements//intera.png" )
interacao = false
intpx, intpy = 1,1

Jogador.spritesheet = "Sprites//Personagens//personagem.png"
imagem_Jogador = love.graphics.newImage(Jogador.spritesheet)
Jogador.grid = anim8.newGrid(50,89, imagem_Jogador:getWidth(), imagem_Jogador:getHeight())

Jogador.walking_direita = anim8.newAnimation(Jogador.grid('1-3',4), 5)
Jogador.walking_esquerda = anim8.newAnimation(Jogador.grid('1-3',3), 5)
Jogador.walking_cima = anim8.newAnimation(Jogador.grid('1-3',2), 5)
Jogador.walking_baixo = anim8.newAnimation(Jogador.grid('1-3',1), 5)

Jogador.parado_baixo = anim8.newAnimation(Jogador.grid(2,1), 5)
Jogador.parado_esq = anim8.newAnimation(Jogador.grid(2,3), 5)
Jogador.parado_direi = anim8.newAnimation(Jogador.grid(2,4), 5)
Jogador.parado_cima = anim8.newAnimation(Jogador.grid(2,2), 5)

Jogador.spritesheet_ataque = "Sprites//Personagens//personagem_ataque2.png"
imagem_Jogador_ataque = love.graphics.newImage(Jogador.spritesheet_ataque)
Jogador.grid = anim8.newGrid(600,480, imagem_Jogador_ataque:getWidth(), imagem_Jogador_ataque:getHeight())

Jogador.ataque_direita = anim8.newAnimation(Jogador.grid('1-3',4), 5)
Jogador.ataque_esquerda = anim8.newAnimation(Jogador.grid('1-3',3), 5)
Jogador.ataque_cima = anim8.newAnimation(Jogador.grid('1-3',2), 5)
Jogador.ataque_baixo = anim8.newAnimation(Jogador.grid('1-3',1), 5)

Jogador.dirr = ''
Jogador.Current_Anim = Jogador.parado_baixo

colisor_mapa = nil
Log_Visible = true

function Jogador:load(mapa)
    
end

function Jogador:update(dt)

    if Jogador.Historia == 1 then
        gamestate = "enrredo"
        play = false
        Log_Visible = false
    end

    if Log_Visible then
        log:update()
    end

    Jogador.Current_Anim:update(1)
    if Jogador.Collider:enter('Inimigo') then
        print('DAMAGEEEEEEEEE !!!!!!!')
    end

    Interagir()
    Jogador_movimentacao()
    ataque()

    if Jogador.AtaqueCD > 0 then
        Jogador.AtaqueCD = Jogador.AtaqueCD - 1
    elseif Jogador.AtaqueCD == 0 then
        if Jogador.ATKCollider ~= nil then
            Jogador.ATKCollider:destroy()
            Jogador.ATKCollider = nil
        end
    end
    
end

function Jogador:draw()

    if Log_Visible then
        log:draw()
    end

    local px, py = Jogador.Collider:getPosition()

    if interacao then
        love.graphics.draw( image_Int, px+8,py-55,0,2,2)
    end

    if Jogador.AtaqueCD == 0 then
        if  Jogador.Current_Anim ~= Jogador.ataque_direita and Jogador.Current_Anim ~= Jogador.ataque_esquerda and Jogador.Current_Anim ~= Jogador.ataque_cima and Jogador.Current_Anim ~= Jogador.ataque_baixo then
            Jogador.Current_Anim:draw(imagem_Jogador,px-10, py-25, 0,0.5,0.5)
           -- love.graphics.print(Jogador.JogadorX.." | "..Jogador.JogadorY,px-12, py-70,0,0.5,0.5)
            --love.graphics.print(Jogador.XP_Atual.." | "..Jogador.XP_Level,px-12, py-50,0,0.5,0.5)
            love.graphics.print("Vida: "..Jogador.VidaAtual,px-12, py-45,0,0.5,0.5)
            love.graphics.print("Level ".. Jogador.Level,px-12, py-35,0,0.5,0.5)
        end
    else
        Jogador.Current_Anim:draw(imagem_Jogador_ataque,px-35, py-25, 0,0.108,0.108)
        --love.graphics.print(Jogador.JogadorX.." | "..Jogador.JogadorY,px-12, py-70,0,0.5,0.5)
        --love.graphics.print(Jogador.XP_Atual.." | "..Jogador.XP_Level,px-12, py-50,0,0.5,0.5)
        love.graphics.print("Vida: "..Jogador.VidaAtual,px-12, py-45,0,0.5,0.5)
        love.graphics.print("Level ".. Jogador.Level,px-12, py-35,0,0.5,0.5)
    end
end

function Jogador_movimentacao()

    local vectorX = 0
    local vectorY = 0

    if Jogador.Collider:enter('Mapa_Novo') then
        colisor_mapa = Jogador.Collider:getEnterCollisionData('Mapa_Novo')
        reset_Data()
        change_mapa()
        
    end

    if Jogador.Collider:enter('Solido') then
        print('Collision entered!')
        if(Jogador.dirr == "Cima")then
            Jogador.Current_Anim = Jogador.parado_cima
        elseif(Jogador.dirr == "Baixo")then
            Jogador.Current_Anim = Jogador.parado_baixo
        elseif(Jogador.dirr == "Esquerda")then           
            Jogador.Current_Anim = Jogador.parado_esq
        elseif(Jogador.dirr == "Direita")then
            Jogador.Current_Anim = Jogador.parado_direi
        end
    else
        local px, py = Jogador.Collider:getPosition()
        if Jogador.AtaqueCD == 0 then
            if Jogador.Collider:enter('Interacao') then
                print('Interacao entered!')
                interacao = true
                intpx, intpy = px, py
            elseif intpx+32 <= px or  intpx-32 >= px  or intpy+32 <= py or intpy-32 >= py then
                interacao = false
            end

            if love.keyboard.isDown("a","left") then
            
                if px-16 - Jogador.Velocidade >= 0 then
                    Jogador.dirr = "Esquerda"
                    Jogador.Current_Anim = Jogador.walking_esquerda
                    vectorX = -1
                    Jogador.Andar_Grama:setVolume(0.2)
                    Jogador.Andar_Grama:play()
                end
            end
            if love.keyboard.isDown("d","right") then
            
                if px-16 + Jogador.Velocidade + Jogador.JogadorLargura <= MapaX then
                    Jogador.dirr = "Direita"
                    Jogador.Current_Anim = Jogador.walking_direita
                    vectorX = 1
                    Jogador.Andar_Grama:setVolume(0.2)
                    Jogador.Andar_Grama:play()
                end 
            end
            if love.keyboard.isDown("w","up") then
            
                if py-32 - Jogador.Velocidade >= 0 then
                    Jogador.dirr = "Cima"
                    Jogador.Current_Anim = Jogador.walking_cima
                    vectorY = -1
                    Jogador.Andar_Grama:setVolume(0.2)
                    Jogador.Andar_Grama:play()
                end
            end
            if love.keyboard.isDown("s","down") then
                
                if py-32 + Jogador.Velocidade + Jogador.JogadorLargura*2<= MapaY then
                    Jogador.dirr = "Baixo"
                    Jogador.Current_Anim = Jogador.walking_baixo
                    vectorY = 1
                    Jogador.Andar_Grama:setVolume(0.2)
                    Jogador.Andar_Grama:play()
                end
            end
        
            Jogador.Collider:setLinearVelocity(vectorX/Jogador.Velocidade, vectorY/Jogador.Velocidade )
            local px, py = Jogador.Collider:getPosition()
            --print("Posição Jogador : ",px, py)
            Jogador.JogadorX = px
            Jogador.JogadorY = py
        end

    end

    if Jogador.AtaqueCD == 0 then
        if vectorX == 0 and vectorY == 0 then
            if(Jogador.dirr == "Cima")then
                Jogador.Current_Anim = Jogador.parado_cima
            elseif(Jogador.dirr == "Baixo")then
                Jogador.Current_Anim = Jogador.parado_baixo
            elseif(Jogador.dirr == "Esquerda")then           
                Jogador.Current_Anim = Jogador.parado_esq
            elseif(Jogador.dirr == "Direita")then
                Jogador.Current_Anim = Jogador.parado_direi
            end
        end
    end
end

function setMap( mx,my)
    MapaX = mx
    MapaY = my
end

function getCollider(colider)
    Jogador.Collider = colider
end

function Interagir()
    
    if love.keyboard.isDown("f") and interacao then
        print("Intergiuuuuuuuuuuuuuuuu")
    end

end

function ataque()

    if love.keyboard.isDown("e") then

        if Jogador.AtaqueCD == 0 then

            if Jogador.ATKCollider ~= nil then
                Jogador.ATKCollider:destroy()
                Jogador.ATKCollider = nil
            end
         
            if(Jogador.dirr == "Cima")then

                local px, py = Jogador.Collider:getPosition()
                Jogador.ATKCollider = world:newRectangleCollider(px-32,py-32,60,12)
                Jogador.ATKCollider:setCollisionClass('Ataque_Player')
                Jogador.ATKCollider:setType('dynamic')
                Jogador.Current_Anim = Jogador.ataque_cima

            elseif(Jogador.dirr == "Baixo")then   

                local px, py = Jogador.Collider:getPosition()
                Jogador.ATKCollider = world:newRectangleCollider(px-32,py+16,60,12)
                Jogador.ATKCollider:setCollisionClass('Ataque_Player')
                Jogador.ATKCollider:setType('dynamic')
                Jogador.Current_Anim = Jogador.ataque_baixo

            elseif(Jogador.dirr == "Esquerda")then

                local px, py = Jogador.Collider:getPosition()
                Jogador.ATKCollider = world:newRectangleCollider(px-32,py-32,12,60)
                Jogador.ATKCollider:setCollisionClass('Ataque_Player')
                Jogador.ATKCollider:setType('dynamic')
                Jogador.Current_Anim = Jogador.ataque_esquerda

            elseif(Jogador.dirr == "Direita")then

                local px, py = Jogador.Collider:getPosition()
                Jogador.ATKCollider = world:newRectangleCollider(px+16,py-32,12,60)
                Jogador.ATKCollider:setCollisionClass('Ataque_Player')
                Jogador.ATKCollider:setType('dynamic')
                Jogador.Current_Anim = Jogador.ataque_direita

            end
            Jogador.Ataque_Som:setVolume(0.8)
            Jogador.Ataque_Som:play()
            Jogador.AtaqueCD = 5
        end 
   end
end

function getXP(xp)

    newLog( "RECEBEU "..xp.. " DE XP !")
    Jogador.XP_Atual = Jogador.XP_Atual + xp
    if Jogador.XP_Atual >= Jogador.XP_Level then
        local resto = Jogador.XP_Atual - Jogador.XP_Level
        Jogador.Level = Jogador.Level + 1
        newLog( "NOVO LEVEL ALCANÇADO -> "..Jogador.Level.. " !")
        Jogador.XP_Atual = resto
        Jogador.VidaMax = Jogador.VidaMax*1.5
        Jogador.Dano = Jogador.Dano + 5 
        Jogador.VidaAtual = Jogador.VidaMax
    end

end

function getDamage(damage, type)

    local dano_verd = damage - Jogador.Defesa
    newLog( "RECEBEU "..dano_verd.. " DE DANO!")
    if dano_verd > 0 then
        Jogador.VidaAtual = Jogador.VidaAtual - dano_verd
    end
    if Jogador.VidaAtual <= 0 then
        play = false
        gamestate = "morto"
    end
end

function getPosJogador()
    local px, py = Jogador.Collider:getPosition()
    return px, py
end

function setPosJogador(xx,yy)
    Jogador.JogadorX = xx
    Jogador.JogadorY = yy
end

function change_mapa()

    local name = nil

    if cenario_atual == praia then
        cenario_atual = planicie
        Jx = 3155.5 + 30
        Jy = 3499.5 - 30
        
    elseif cenario_atual == planicie then

        local xx, yy = colisor_mapa.collider:getPosition()
        --print(xx,"  |   ", yy)

        if xx == 3196 and yy == 3525.25 then
            cenario_atual = praia
            Jx = 134.667+30
            Jy = 80
        end

        if xx == 5737.375 and yy == 3216.375 then
            cenario_atual = caverna
            Jx = 4064.5+30
            Jy = 3071.5 - 30
        end
        
        if xx == 1924 and yy == 537.875 then
            cenario_atual = caverna
            Jx = 225.5+30
            Jy = 377.5 - 30
        end

        if xx == 759.5 and yy == 37 then

            cenario_atual = vila
            Jx = 652+30
            Jy = 783.333 - 30
        end
        
        
    elseif cenario_atual == vila then

        local xx, yy = colisor_mapa.collider:getPosition()
        --print(xx,"  |   ", yy)

        if xx == 710.5 and yy == 798 then
            cenario_atual = planicie
            Jx = 706.25+30
            Jy = 50+30
        end

        if xx == 728.6669921875 and yy == 422 then
            cenario_atual = taverna
            Jx = 254.667+30
            Jy = 288-8
        end

        if xx == 152.75 and yy == 541.75 then
            cenario_atual = loja
            Jx = 50.5+30
            Jy = 172.333-32
        end
        
    elseif cenario_atual == caverna then
        --print(" Saindo da Caverna")

        local xx, yy = colisor_mapa.collider:getPosition()

        if xx == 272.125 and yy == 404.25 then
            cenario_atual = planicie
            Jx = 1896.75+30
            Jy = 507.25 + 80
        end

        if xx == 4104.625 and yy == 3095.75 then
            cenario_atual = planicie
            Jx = 5707.75+30
            Jy = 3186 + 80
        end
        
    elseif cenario_atual == loja then

        cenario_atual = vila
        Jx = 134 + 30
        Jy = 519.5 + 50
        
    elseif cenario_atual == taverna then

        cenario_atual = vila
        Jx = 704.667+30
        Jy = 396 +80
        
    end

    cenario = carregando_Mapa(cenario_atual)
    XMAX, YMAX = getAreaMap(cenario)
  
    CM.setScale(1.5)
    CM.setCoords(Jx, Jy)
    setPosJogador(Jx, Jy)
    colisor_init(cenario, true)


end

return Jogador