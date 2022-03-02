ITENS = require "itens"

inv_controle = {}

x1 = 160
y1 = 220

function inv_controle:load()
    ITENS:load()
end

function inv_controle:update()
    use_itens()
end

function inv_controle:draw()

    ITENS:load()
    if inventario_state == 1 then

        

        local x,y =  inventario.layers.Info.objects[1].x,inventario.layers.Info.objects[1].y
        love.graphics.print("Experiencia ---> "..Jogador.XP_Atual .. " / " .. Jogador.XP_Level, x, y-250,0,2,2)

        love.graphics.print("Vida ---> "..Jogador.VidaAtual .. " / " .. Jogador.VidaMax, x, y-200,0,2,2)

        love.graphics.print("Level ---> "..Jogador.Level, x, y-150,0,2,2)

        love.graphics.print("Dano ---> "..Jogador.Dano , x, y-100,0,2,2)

        love.graphics.print("Defesa ---> "..Jogador.Defesa, x, y-50,0,2,2)

        love.graphics.print("Ranking : "..Jogador.Ranking, x, y,0,2,2)

    elseif inventario_state == 2 then

        local x,y =  inventario.layers.Info.objects[1].x,inventario.layers.Info.objects[1].y
        love.graphics.print("Merito : "..Jogador.meritos, x, y,0,2,2)
        love.graphics.draw( love.graphics.newImage(itens_table[1].image), x-50,y,0,1,1)

       

        for i in ipairs(Jogador.itens) do
                local ids = Jogador.itens[i].id
                for j in ipairs(itens_table) do
                    if ids == itens_table[j].id then
                        local xxx, yyy = inventario.layers.Posicoes.objects[i].x,inventario.layers.Posicoes.objects[i].y
                        love.graphics.draw( love.graphics.newImage(itens_table[j].image), xxx,yyy,0,1,1)
                        love.graphics.print("Nome : "..itens_table[j].nome, xxx,yyy+50,0,1,1)
                        love.graphics.print("Quantidade : "..Jogador.itens[i].quantidade, xxx,yyy+65,0,1,1)
                        love.graphics.print(itens_table[j].descricao, xxx,yyy+80,0,1,1)

                    end
                end

            
        end
        
    elseif inventario_state == 3 then
        --Mapa

    elseif inventario_state == 4 then
        --mISSOES

    end
end

function use_itens()


end

return inv_controle