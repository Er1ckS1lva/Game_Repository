itens = {}



itens_table = {

    id = nil,
    tipo = nil,
    nome = nil,
    image = nil,
    valor_venda = nil,
    valor_compra = nil,
    descricao = nil
}


function itens:load()

    itens_table[1] = {

        id = 1,
        tipo = "moeda",
        nome = "Merito",
        image = "Sprites//Itens//Merito.png",
        valor_venda = nil,
        valor_compra = nil,
        descricao = "A moeda da ilha, a quantidade\n de merito define o quanto você fez pela\n comunidade, pode ser usado em trocas \ne \
        para subir de ranking na guilda."
    }

    itens_table[2] = {

        id = 2,
        tipo = "Usavel",
        nome = "Pocao de Vida",
        image = "Sprites//Itens//Pocao_Vida.png",
        valor_venda = 50,
        valor_compra = 80,
        descricao = "Restaura 20 \npontos de Vida. " 
        --[[descricao = "Uma mistura alquimica de \nbaixa qualidade a base de ervas\n e geleia de slime, pode curar \ninstantaneamente \
        pequenas feridas. \nUsa-lo restaura 20 pontos de vida."]]--
    }

    itens_table[3] = {

        id = 3,
        tipo = "Usavel",
        nome = "Pao",
        image = "Sprites//Itens//Pao.png",
        valor_venda = 3,
        valor_compra = 5,
        descricao = "Restaura 3 \npontos de Vida. " 
        --[[descricao = "Um pao duro feito com trigo\n da regiao. Come-lo restaura \n3 pontos de vida."]]--
    }

    itens_table[4] = {

        id = 4,
        tipo = "Drop",
        nome = "Núcle de Slime",
        image = "Sprites//Itens//Nucleo_Slime_Verde.png",
        valor_venda = 20,
        valor_compra = nil,
        descricao = "Uma pequena joia mágica deixada por um slime verde, possui pouco poder mágico dentro e raramente fica intacta \
        com a morte do monstro. Usada em Craft de itens de baixa de qualidade."
    }

    itens_table[5] = {

        id = 5,
        tipo = "Drop",
        nome = "Geleia de Slime Verde",
        image = "Sprites//Itens//Geleia_Slime_Verde.png",
        valor_venda = 4,
        valor_compra = nil,
        descricao = "Uma gosma deixada por um slime verde. Pode ser usada em Craft de Poções de baixa qualidade."
    }

    itens_table[6] = {

        id = 6,
        tipo = "Drop",
        nome = "Carne de Lobo",
        image = "Sprites//Itens//Carne_Crua_Lobo.png",
        valor_venda = 4,
        valor_compra = nil,
        descricao = "Carne de Lobo Selvagem, não é muito saborosa."
    }

    itens_table[7] = {

        id = 7,
        tipo = "Drop",
        nome = "Couro de Lobo Selvagem",
        image = "Sprites//Itens//Couro_Lobo.png",
        valor_venda = 6,
        valor_compra = nil,
        descricao = "Couro retirado de um Lobo Selvagem, não é um material de alto nível."
    }

    itens_table[8] = {

        id = 8,
        tipo = "Drop",
        nome = "Presa de Lobo Selvagem",
        image = "Sprites//Itens//Presa_Lobo.png",
        valor_venda = 8,
        valor_compra = nil,
        descricao = "Uma presa afiada de um Lobo Selvagem, não é um material de alto nível."
    }

    itens_table[9] = {

        id = 9,
        tipo = "Equipamento",
        nome = "Anel de Dano",
        image = "Sprites//Itens//Anel.png",
        valor_venda = 50,
        valor_compra = 250,
        descricao = "Um Anel com propriedades mágicas capaz de dobra a quantidade de dano em monstros."
    }

end

return itens