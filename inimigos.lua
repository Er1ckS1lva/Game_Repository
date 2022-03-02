Slimes = require "slime" 
Wolf = require "wolf"
Minhocas = require "minhoca"
Slimes_Azul = require "slime_azul" 

Inimigo = {}

total = 1
mundo = nil

monstros = {

    exist = false,
    current_World = nil,
    x = 0,
    y = 0,
    alt = 0,
    larg = 0,
    type = " ",
    quantidade = 0

}

entity = {

    type = " ",
    id = " ",
    body = nil,
    persep = nil

}


respawnTime = 20

function Inimigo:load()

    print(Slimes)
    print(Minhocas)

end

function Inimigo:update()

    
    for j in ipairs(entity) do
        entity[j].body:update()
    end
    respawnTime = respawnTime -1
    
    if respawnTime == 0 then
        respawnTime = 50
    
        for i in ipairs(monstros) do
            if monstros[i].exist then 
                if monstros[i].quantidade == 0 then
                  
                    novoMonstro(monstros[i].type)
                    
                end
            end
        end
    end

end

function Inimigo:draw()

    for j in ipairs(entity) do
        entity[j].body:draw()
    end

end


function addNovoInimigo(type,world,x1,x2,x3,x4)

    mundo = world
    monstros[total] = {
        exist = true,
        current_World = world,
        type = type,
        x = x1,
        y = x2,
        larg = x3,
        alt = x4,
    }

    novoMonstro(type)
    total = total + 1

end

function inimigoMorto(id)

    for i in ipairs(monstros) do
        for j in ipairs(entity) do
            if id == entity[j].id then
                if monstros[i].type == entity[j].type then
                    monstros[i].quantidade = monstros[i].quantidade -1
                    table.remove(entity, j)
                end                    
            end
        end
    end
end


function novoMonstro(type)

    quantidade = math.random(5, 15)
    local aux1, aux2, aux1=3, aux4, aux5

    for i in ipairs(monstros) do
        if monstros[i].type == type then
            monstros[i].quantidade = quantidade

            aux1 = monstros[i].x
            aux2 = monstros[i].y
            aux3 = monstros[i].larg
            aux4 = monstros[i].alt
            aux5 = monstros[i].current_World

        end
    end

    tam = table.getn(entity)

    if tam == 0 then
        tam = 1
    else
        tam = tam +1
    end

    for j=tam,quantidade+tam-1 do
        
        if type == "slime" then 
            
            local name = "Earth Slime "..j
            entity[j]={
                type = type,
                id = name,
                percepcao = 20,
                body = slime:Create(aux1,aux2,aux3,aux4,aux5,name)
            }
         
        elseif type == "wolf" then
        
            local name = "Lobo Selvagem "..j
            entity[j]={
                type = type,
                id = name,
                percepcao = 35,
                body = wolf:Create(aux1,aux2,aux3,aux4,aux5,name)
            }
            
        elseif type == "blue_slime" then
           print(" ",aux1," ",aux2," ",aux3," ",aux4," ",aux5,"     ", name)
            local name = "Slime de Cristal "..j
            entity[j]={
                type = type,
                id = name,
                percepcao = 35,
                body = Slimes_Azul:Create(aux1,aux2,aux3,aux4,aux5,name)
            }
            
        elseif type == "minhoca" then
           
            local name = "Minhoca Gigante "..j
            entity[j]={
                type = type,
                id = name,
                percepcao = 35,
                body = Minhocas:Create(aux1,aux2,aux3,aux4,aux5,name)
            }
            
        end 
    end

    tam = table.getn(entity)
end

function reset_Data()
    total = 1
    for k in pairs (monstros) do
        monstros[k] = nil
    end
    for k in pairs (entity) do
        entity[k] = nil
    end
    
end

return Inimigo