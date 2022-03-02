STI = require("Modulos//sti")
local CM = require "lib.CameraMgr".newManager()
colisor = require("colisor")

local joguinho = {}

rodando = true
Escala = 1.5
XMAX = 0
YMAX = 0

planicie = "Estados//Cenarios//Mapas//Mapa_Sul.lua"
vila = "Estados//Cenarios//Mapas//Vila_NPC.lua"
caverna = "Estados//Cenarios//Mapas//Caverna.lua"
taverna = "Estados//Cenarios//Mapas//Taverna.lua"
loja = "Estados//Cenarios//Mapas//Loja.lua"
praia = "Estados//Cenarios//Mapas//Praia.lua"
cenario_atual = praia


function joguinho.load()
  if rodando then
    jogo_init(cenario_atual)
  end
end

function joguinho.update()

 if rodando then
    colisor:update()
    cenario:update()
    Jx, Jy = getPosJogador()
    CM.setTarget(Jx+16/2, Jy+32/2)
    CM.update()
 end

end

function joguinho.draw()
  if rodando then
    CM.attach()

      Jx, Jy = getPosJogador()
      local screen_width  = love.graphics.getWidth()  / Escala
      local screen_height = love.graphics.getHeight() / Escala
      local tx = math.floor(Jx - screen_width  / 2)
      local ty = math.floor(Jy - screen_height / 2)
      cenario:draw(-tx, -ty, Escala)

      --love.graphics.setColor(100,100,100,255)
      --love.graphics.setLineWidth(4)
      --love.graphics.rectangle("line", 8, 16, XMAX, YMAX);
      colisor:draw()

    CM.detach()
    CM.debug()
  end
end

function jogo_init(cenario__)

  cenario_atual = cenario__
  cenario = carregando_Mapa(cenario_atual)
  XMAX, YMAX = getAreaMap(cenario)

  colisor_init(cenario, false)

  CM.setScale(Escala)
  Jx, Jy = cenario.layers.Personagem.objects[1].x, cenario.layers.Personagem.objects[1].y
  CM.setCoords(Jx, Jy)

end

function love.keypressed(key)
  if key == "escape" then
    --print("escape")
    play = false
    gamestate = "pause"
  end

  if key == "i" then
    --print("escape")
    play = false
    gamestate = "inventario"
  end
end

--Funções Locais
function carregando_Mapa(caminho_mapa)
  mapa_atual = STI(caminho_mapa,{"box2d"})
  love.physics.setMeter(32)
  world = love.physics.newWorld(0, 0)
  mapa_atual:box2d_init(world)
  return mapa_atual
end

function getAreaMap(cenario)
  XMAX = cenario.width * cenario.tilewidth
  YMAX = cenario.height * cenario.tileheight
  return XMAX,YMAX
end

--===============================================================================================================================================================================================================================================================================


return joguinho
