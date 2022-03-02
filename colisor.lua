player = require("jogador")
inimigos = require("inimigos")
windfield =require("Modulos//windfield")

local colisor = {
    mapa = nil,
    Jx = 0,
    Jy = 0
}

stop = {}
inte = {}
maps={}
enemy={}
function colisor.load()

end

function colisor.update()
    inimigos:update()
    player:update()
    world:update(100)
end

function colisor.draw()
    inimigos:draw()
    player:draw()
    world:draw()
end

function colisor_init( mapa, aux)

    log:load()

    MapaX = mapa.width * mapa.tilewidth
    MapaY = mapa.height * mapa.tileheight

    setMap( MapaX,MapaY)

    world = windfield.newWorld()
    world:addCollisionClass('Player')
    world:addCollisionClass('Solido')
    world:addCollisionClass('Inimigo')
    world:addCollisionClass('Inimigos_Spawn',{ignores = {'Player','Inimigo'}})
    world:addCollisionClass('Mapa_Novo',{ignores = {'Player'}})
    world:addCollisionClass('Interacao',{ignores = {'Player'}})
    world:addCollisionClass('Ataque_Player',{ignores = {'All'}})
    world:addCollisionClass('Ataque_Inimigo',{ignores = {'Inimigo'}})
    world:addCollisionClass('Inimigo_Percepcao',{ignores = {'All'}})

    if aux then
        posxx, posyy = Jogador.JogadorX, Jogador.JogadorY
        player:load()
        player.Collider = world:newCircleCollider(posxx,posyy,18)
        player.Collider:setCollisionClass('Player')
        player.Collider:setType('dynamic')
    else 
        posxx = mapa.layers.Personagem.objects[1].x
        posyy = mapa.layers.Personagem.objects[1].y
        player:load()
        setPosJogador(posxx, posyy)
        player.Collider = world:newCircleCollider(posxx,posyy,18)
        player.Collider:setCollisionClass('Player')
        player.Collider:setType('dynamic')
    end
    
    mapa.layers.Personagem.visible = false
    
    if mapa.layers.Solido ~= nil then
        Barreiras = {}
       
        for i in ipairs(mapa.layers.Solido.objects) do
            mapa.layers.Solido.objects[i].visible = false
            Barreiras[i] = {
            name = mapa.layers.Solido.objects[i].name,
            altura_t = mapa.layers.Solido.objects[i].height,
            largura_t = mapa.layers.Solido.objects[i].width,
            x_t = mapa.layers.Solido.objects[i].x,
            y_t = mapa.layers.Solido.objects[i].y
            }
        end

        for i in ipairs(Barreiras) do
            aux = world:newRectangleCollider(Barreiras[i].x_t+8,Barreiras[i].y_t+16,Barreiras[i].largura_t,Barreiras[i].altura_t)
            aux:setType('static')
            aux:setCollisionClass('Solido')
            stop[i] = aux
        end
    
    end

    if mapa.layers.Interacao ~= nil then
        Interacoes = {}
        for i in ipairs(mapa.layers.Interacao.objects) do
            mapa.layers.Interacao.objects[i].visible = false
            Interacoes[i] = {
            altura_t = mapa.layers.Interacao.objects[i].height,
            largura_t = mapa.layers.Interacao.objects[i].width,
            x_t = mapa.layers.Interacao.objects[i].x,
            y_t = mapa.layers.Interacao.objects[i].y
            }
        end

        for i in ipairs(Interacoes) do
            aux = world:newRectangleCollider(Interacoes[i].x_t+8,Interacoes[i].y_t+16,Interacoes[i].largura_t,Interacoes[i].altura_t)
            aux:setType('static')
            aux:setCollisionClass('Interacao')
            inte[i] = aux
        end
    
    end

    if mapa.layers.Mapa ~= nil then
        Mapas = {}
        for i in ipairs(mapa.layers.Mapa.objects) do
            mapa.layers.Mapa.objects[i].visible = false
            Mapas[i] = {
            altura_t = mapa.layers.Mapa.objects[i].height,
            largura_t = mapa.layers.Mapa.objects[i].width,
            x_t = mapa.layers.Mapa.objects[i].x,
            y_t = mapa.layers.Mapa.objects[i].y,
            name = mapa.layers.Mapa.objects[i].name
            }
        end

        for i in ipairs(Mapas) do
            aux = world:newRectangleCollider(Mapas[i].x_t+8,Mapas[i].y_t+16,Mapas[i].largura_t,Mapas[i].altura_t)
            aux:setType('static')
            aux:setCollisionClass('Mapa_Novo')
            maps[i] = {
                colisor = aux,
                name = Mapas[i].name
            }
        end
        
    end

    if mapa.layers.Inimigos ~= nil then
        --print("tem inimigos")
        Inimigos_spawn = {}
        for i in ipairs(mapa.layers.Inimigos.objects) do
            mapa.layers.Inimigos.objects[i].visible = false
            Inimigos_spawn[i] = {
            name = mapa.layers.Inimigos.objects[i].name,
            altura_t = mapa.layers.Inimigos.objects[i].height,
            largura_t = mapa.layers.Inimigos.objects[i].width,
            x_t = mapa.layers.Inimigos.objects[i].x,
            y_t = mapa.layers.Inimigos.objects[i].y
            }
            --print(mapa.layers.Inimigos.objects[i].name)
        end

        for i in ipairs(Inimigos_spawn) do
        
            enemy[i] = {type = Inimigos_spawn[i].name}
            addNovoInimigo(enemy[i].type, world, Inimigos_spawn[i].x_t+8, Inimigos_spawn[i].y_t+16,Inimigos_spawn[i].largura_t,Inimigos_spawn[i].altura_t)
        end

    end

end

return colisor