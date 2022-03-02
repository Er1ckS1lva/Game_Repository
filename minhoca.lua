minhoca = {}
minhoca.__index = minhoca

minhoca.spritesheet = "Sprites//Inimigos//minhoca.png"
imagem_minhoca = love.graphics.newImage(minhoca.spritesheet)
minhoca.grid = anim8.newGrid(16,24, imagem_minhoca:getWidth(), imagem_minhoca:getHeight())

minhoca.walking_horizontal = anim8.newAnimation(minhoca.grid('1-7',1), 60)
minhoca.walking_vertical = anim8.newAnimation(minhoca.grid('10-28',1), 60)


function minhoca:Create(x1,x2,x3,x4,world,id)
    print("Uer")
    print(" ",x1," ",x2," ",x3," ",x4," ",world,"   ", id)
    local this = {}
    x = math.random(x1, x1+x3)
    y = math.random(x2, x2+x4)

    this.colider = world:newCircleCollider(x,y,16)
    this.colider:setCollisionClass('Inimigo')
    this.colider:setType('dynamic')

    local levell = math.random(3, 8)
   
    this.vida = 10 * levell
    this.resistencia = 1 * levell
    this.dano = 2 *  levell
    this.id = id
    this.x = 0
    this.y = 0
    this.andar = 0
    this.percp = 150
    this.pers = false
    this.level = levell
    this.xp = 5
    this.current = minhoca.walking_horizontal

    setmetatable(this, minhoca)
    return this
end


function minhoca:load()
end

function minhoca:update()
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

function minhoca:draw()
    local px, py = self.colider:getPosition()
    self.current:draw(imagem_lobo,px-16, py-20, 0,0.6,0.6)
    love.graphics.print("Minhoca Gigante",px-12, py-35,0,0.5,0.5)
    love.graphics.print("Vida: "..self.vida,px-12, py-30,0,0.5,0.5)
    love.graphics.print("Level ".. self.level,px-12, py-25,0,0.5,0.5)
end

function minhoca:getPos()
    local px, py = self.colider:getPosition()
    return px, py
end

function minhoca:mov()

    if self.andar > 0 then

        XMAX, YMAX = getAreaMap(cenario)
        self.andar = self.andar - 1

        local pxx, pyy = getPosJogador()
        local px, py = self.colider:getPosition()
        
        if px + 300 > pxx then
            if px - 300 < pxx then
                if py + 300 > pyy then
                    if py - 300 < pyy then
                        
        
                    end
                end
            end
        end

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

        self.colider:setLinearVelocity(self.x/80, self.y/80)

    else

        local vectorX = math.random(-1, 1)
        local vectorY = math.random(-1, 1)
        self.x = vectorX
        self.y = vectorY
        self.andar = 200

        if self.x == 1 and self.y == 0 then
            self.current = minhoca.walking_horizontal
        elseif self.x == 0 and self.y == 1 then
            self.current = minhoca.walking_vertical
        elseif self.x == 0 and self.y == -1 then
            self.current = minhoca.walking_vertical
        elseif self.x == -1 and self.y == 0 then
            self.current = minhoca.walking_horizontal
        end

        

    end

end


function minhoca:perseguindo()

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

        self.colider:setLinearVelocity(self.x/80, self.y/80)
        if self.x == 1 and self.y == 0 then
            self.current = minhoca.walking_horizontal
        elseif self.x == 0 and self.y == 1 then
            self.current = minhoca.walking_vertical
        elseif self.x == 0 and self.y == -1 then
            self.current = minhoca.walking_vertical
        elseif self.x == -1 and self.y == 0 then
            self.current = minhoca.walking_horizontal
        end
        
end

function minhoca:vision()

    local px, py = getPosJogador()
    local x, y = self.colider:getPosition()
    
    if x + self.percp > px then
        if x - self.percp < px then
            if y + self.percp > py then
                if y - self.percp < py then
                    if self.pers == false then
                        self.som_raiva:setVolume(1)
                        self.som_raiva:play()
                    end
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

function minhoca:int()
    
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

        getXP(self.xp)
        inimigoMorto(self.id)
        self.colider:destroy()
    end

end

