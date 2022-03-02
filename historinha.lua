historinha = {}

Tela = love.graphics.newImage( "Elements//Log.png" )

--Mensagem_Enrredo = "..."
Mensagem_Enrredo = "O que ... Oque aconteceu ?? ... Onde estou ??"
Num_Msg = 1



function historinha:update()

    love.keyreleased(key)

end


function historinha:draw()

    local px, py = Jogador.Collider:getPosition()
    love.graphics.draw( Tela, px+50,py+220,0,4,6)
    love.graphics.print(Mensagem_Enrredo,px + 70, py + 250,0,1,1)
    love.graphics.print("Precione Espaco para Continuar",px+160, py + 380,0,1,1)

end


function love.keyreleased(key)

    if key == "space" then
        print(Num_Msg)
        if Num_Msg == 1 then
            Num_Msg = 2
            Mensagem_Enrredo = "O que ... Oque aconteceu ?? ... Onde estou ??"
        end

        if Num_Msg == 2 then
            Num_Msg = 3
            Mensagem_Enrredo = "Não consigo me lembrar de nada ... \nNao posso ficar parado, preciso achar um abrigo."
        end

        if Num_Msg == 3 then
            Num_Msg = 4
            play = true
            Log_Visible = true
            Jogador.Historia = 2
        end
    end

end


return historinha