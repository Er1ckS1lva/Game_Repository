log = {}
imagem_log = love.graphics.newImage( "Elements//Log.png" )


log_msg_1 = nil
log_msg_2 = nil
log_msg_3 = nil

mensagens = {}
quantidade_msg = 1

timer = 100

function log:load()
end

function log:update()

    if timer <= 0  then
        
        log_msg_1 = log_msg_2

        log_msg_2 = log_msg_3
        
        if table.getn(mensagens) > 1 then
            print(table.getn(mensagens))
            log_msg_3 = mensagens[1]

            quantidade_msg = quantidade_msg - 1
            for i in ipairs(mensagens) do
                if mensagens[i+1] == nil then
                     mensagens[i] = nil
                else
                    mensagens[i] = mensagens [i+1]
                end

            end

        else
            log_msg_3 = nil
        end

    end

    if log_msg_1 == nil  then
        
        log_msg_1 = log_msg_2

    end

    if log_msg_2 == nil   then
        
        log_msg_2 = log_msg_3
        
    end

    if timer <= 0 then
        timer = 100
    else
        timer = timer - 1
    end
end

function log:draw()
    local px, py = Jogador.Collider:getPosition()
    love.graphics.draw( imagem_log, px-250,py-180,0,2.5,1.5)

    if log_msg_1 ~= nil  then
        love.graphics.print(log_msg_1,px-240, py-175,0,0.5,0.5)
    end

    if log_msg_2 ~= nil  then
        love.graphics.print(log_msg_2,px-240, py-165,0,0.5,0.5)
    end

    if log_msg_3 ~= nil  then
        love.graphics.print(log_msg_3,px-240, py-155,0,0.5,0.5)
    end
    
end


function newLog( mensagem)
    mensagens[quantidade_msg] = mensagem
    quantidade_msg = quantidade_msg + 1
end


return log