local anim8 =require("Modulos//anim8")

slime_azul = {}
slime_azul.__index = slime_azul

slime_azul.spritesheet = "Sprites//Inimigos//blue_slime.png"
imagem_slime_azul = love.graphics.newImage(slime_azul.spritesheet)
slime_azul.grid = anim8.newGrid(64,44, imagem_slime_azul:getWidth(), imagem_slime_azul:getHeight())
slime_azul.walking = anim8.newAnimation(slime_azul.grid('1-8',1), 150)
slime_azul.stop = anim8.newAnimation(slime_azul.grid('1-2',1), 100)

function slime_azul:Create(x1,x2,x3,x4,world,id)

    --print(" ",x1," ",x2," ",x3," ",x4," ",world)
    local this = {}
    x = math.random(x1, x1+x3)
    y = math.random(x2, x2+x4)

    this.colider = world:newCircleCollider(x,y,6)
    this.colider:setCollisionClass('Inimigo')
    this.colider:setType('dynamic')
    
    this.vida = 10
    this.dano = 3
    this.resistencia = 1
    this.id = id
    this.x = 0
    this.y = 0
    this.andar = 0
    this.percp = 100
    this.pers = false
    this.level = 1
    this.xp = 2
    this.current = slime_azul.stop
    this.som_andar = love.audio.newSource("Sons//Slime//slime_andando.mp3", "stream")
    this.som_morte = love.audio.newSource("Sons//Slime//slime_morte.mp3", "stream")

    setmetatable(this, slime_azul)
    return this
end


function slime_azul:load()
 
end

function slime_azul:update()
    if self.vida > 0 then
        
        self:vision()

        if self.pers then
            self:perseguindo()
        else
            self:mov()
        end
        self.current:update(1)
        self:int()
    end
end

function slime_azul:draw()
    local px, py = self.colider:getPosition()
    self.current:draw(imagem_slime_azul,px-16, py-12, 0,1,1)
    love.graphics.print("Slime de Cristal ",px-12, py-35,0,0.5,0.5)
    love.graphics.print("Vida: "..self.vida,px-12, py-30,0,0.5,0.5)
    love.graphics.print("Level ".. self.level,px-12, py-25,0,0.5,0.5)
end

function slime_azul:getPos()
    local px, py = self.colider:getPosition()
    return px, py
end


function slime_azul:mov()

    
    if self.andar > 0 then

        local pxx, pyy = getPosJogador()
        local px, py = self.colider:getPosition()
        
        if px + 200 > pxx then
            if px - 200 < pxx then
                if py + 200 > pyy then
                    if py - 200 < pyy then
                        
                        self.som_andar:setVolume(0.1)
                        self.som_andar:play()
        
                    end
                end
            end
        end

        XMAX, YMAX = getAreaMap(cenario)
        self.andar = self.andar - 1

        

        if px - 10 <= 0 then
            self.x = 1
        elseif px + 10 >= XMAX then
            self.x = -1
        end

        if py + 10 >= YMAX then
            self.y = -1
        elseif py - 10 <= 0 then
            self.y = 1
        end

        self.colider:setLinearVelocity(self.x/150, self.y/150)
    else

        local vectorX = math.random(-1, 1)
        local vectorY = math.random(-1, 1)
        self.x = vectorX
        self.y = vectorY
        self.andar = 200
        if self.x == 0 and self.y == 0 then
            self.current = slime_azul.stop
        else
            self.current = slime_azul.walking
        end

    end



end


function slime_azul:perseguindo()

    local px, py = getPosJogador()
    local x, y = self.colider:getPosition()

        if px > x then
            self.x = 1
        else
            self.x = -1
        end

        if py > y then
            self.y = 1
        else
            self.y = -1
        end

        self.colider:setLinearVelocity(self.x/150, self.y/150)

        self.current = slime_azul.walking

end

function slime_azul:vision()

    local px, py = getPosJogador()
    local x, y = self.colider:getPosition()
    
    if x + self.percp > px then
        if x - self.percp < px then
            if y + self.percp > py then
                if y - self.percp < py then
                    self.pers = true
                else
                    self.pers = false
                end
            else
                self.pers = false
            end
        else
            self.pers = false
        end
    else
        self.pers = false
    end
        
end

function slime_azul:int()

    if self.colider:enter('Player') then
        getDamage(self.dano, "fisico")
    end

    if self.colider:enter('Ataque_Player') then
        self.vida = self.vida - (Jogador.Dano - self.resistencia) 
        if(Jogador.dirr == "Cima")then
            self.colider:setLinearVelocity(0,-1/10)
        elseif(Jogador.dirr == "Baixo")then   
            self.colider:setLinearVelocity(0, 1/10)
        elseif(Jogador.dirr == "Esquerda")then
            self.colider:setLinearVelocity(-1/10, 0)
        elseif(Jogador.dirr == "Direita")then
            self.colider:setLinearVelocity(1/10, 0)
        end
    end

    if self.vida <= 0 then

        self.som_morte:setVolume(1)
        self.som_morte:play()

        getXP(self.xp)
        inimigoMorto(self.id)
        self.colider:destroy()
        
    end

end

