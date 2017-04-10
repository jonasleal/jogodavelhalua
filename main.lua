-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
widget = require("widget")
jogo = require("logica")
centerX = display.contentCenterX
centerY = display.contentCenterY
tamnahoTabuleiro = 150
tamanhoCelula = 50
centroCelula = {}
vezDe = "O"

function desenhaCirculo(linha , coluna)
	local x = centroCelula[linha][coluna].x
	local y = centroCelula[linha][coluna].y

	local raio = tamanhoCelula/2
	local circulo = display.newCircle(x , y , raio)
	circulo.strokeWidth = 5
	circulo:setFillColor(0)
	circulo:setStrokeColor(1)

	centroCelula[linha][coluna].circulo = circulo
end


function desenhaX( linha, coluna )
	local x = centroCelula[linha][coluna].x
	local y = centroCelula[linha][coluna].y

	local barra1 = display.newLine(x - tamanhoCelula /2, y - tamanhoCelula /2, x + tamanhoCelula /2, y + tamanhoCelula /2)
	local barra2 = display.newLine(x + tamanhoCelula /2, y - tamanhoCelula /2, x - tamanhoCelula /2, y + tamanhoCelula /2)
	barra1.strokeWidth = 5
	barra2.strokeWidth = 5

	centroCelula[linha][coluna].xis = {barra1,barra2}
end


function calcCentCelulas( linhaVertEsq, linhaVertDir, linhaHoriSup, linhaHoriInf)
	local int1 = { x= linhaVertEsq.x, y = linhaHoriSup.y}
	local int2 = { x= linhaVertDir.x, y = linhaHoriSup.y}
	local int3 = { x= linhaVertEsq.x, y = linhaHoriInf.y}
	local int4 = { x= linhaVertDir.x, y = linhaHoriInf.y}
	
	centroCelula = {
	{
	{ x = int1.x - tamanhoCelula, y = int1.y - tamanhoCelula},
	{ x = int2.x - tamanhoCelula, y = int2.y - tamanhoCelula},
	{ x = int2.x + tamanhoCelula, y = int2.y - tamanhoCelula}
	},

	{
	{ x = int1.x - tamanhoCelula, y = int1.y + tamanhoCelula},
	{ x = int2.x - tamanhoCelula, y = int2.y + tamanhoCelula},
	{ x = int2.x + tamanhoCelula, y = int2.y + tamanhoCelula}
	},

	{
	{ x = int3.x - tamanhoCelula, y = int3.y + tamanhoCelula},
	{ x = int4.x - tamanhoCelula, y = int4.y + tamanhoCelula},
	{ x = int4.x + tamanhoCelula, y = int4.y + tamanhoCelula}
	}
	
	}
end

function desenhaTabuleiro()
	local linhaVertEsq = display.newLine(centerX - tamanhoCelula, centerY - tamnahoTabuleiro, centerX - tamanhoCelula, centerY + tamnahoTabuleiro)
	linhaVertEsq.strokeWidth = 5
	local linhaVertDir =  display.newLine(centerX + tamanhoCelula, centerY - tamnahoTabuleiro, centerX + tamanhoCelula, centerY + tamnahoTabuleiro)
	linhaVertDir.strokeWidth = 5
	local linhaHoriSup =  display.newLine(centerX - tamnahoTabuleiro, centerY - tamanhoCelula, centerX + tamnahoTabuleiro, centerY - tamanhoCelula)
	linhaHoriSup.strokeWidth = 5
	local linhaHoriInf =  display.newLine(centerX + tamnahoTabuleiro, centerY + tamanhoCelula, centerX - tamnahoTabuleiro, centerY + tamanhoCelula)
	linhaHoriInf.strokeWidth = 5
	calcCentCelulas(linhaVertEsq,linhaVertDir,linhaHoriSup, linhaHoriInf)
	texto = display.newText({x = centerX , y = 20 , text = "", width = 300 , height = 30, align = "center"})
	texto.size = 20
end

function jogada( e )
	if(e.phase == "ended") then
			if vezDe == "O" then
				if proximaJogada(e.target.coluna, e.target.linha) then
					desenhaCirculo(e.target.linha,e.target.coluna)	
				end
			elseif vezDe == "X" then
				if proximaJogada(e.target.coluna, e.target.linha) then
					desenhaX(e.target.linha,e.target.coluna)
				end
			end

			
	end

end
 
function preenchetudo()
	for i=1,3 do
		for j=1,3 do
			local botao = widget.newButton({x = centroCelula[i][j].x, y = centroCelula[i][j].y, width = tamanhoCelula*1.9, height = tamanhoCelula *1.9, onEvent = jogada})
			botao.linha = i
			botao.coluna = j
		end
	end
end

function limparTabuleiro()
	for i=1,3 do
		for j=1,3 do
			if centroCelula[i][j].circulo ~= nil then
				display.remove(centroCelula[i][j].circulo)
			end
			if centroCelula[i][j].xis ~= nil then
				display.remove(centroCelula[i][j].xis[1])
				display.remove(centroCelula[i][j].xis[2])
			end
		end
	end
	display.remove(linhaVencedor)
end
function desenhaLinha(inicio, fim)
	linhaVencedor = display.newLine(centroCelula[inicio.x][inicio.y].x, centroCelula[inicio.x][inicio.y].y,
					 centroCelula[fim.x][fim.y].x, centroCelula[fim.x][fim.y].y)
	linhaVencedor.strokeWidth = 5
	linhaVencedor:setStrokeColor (1,0,0)
end
function novoJogo( destruir )

	if destruir ~= nil then
		limparTabuleiro()
		display.remove(destruir.target)
	else
		desenhaTabuleiro()
		preenchetudo()
	end
	inicializaTabuleiro()
	texto.text = "Vez do jogador " .. vezDe
end

---------------------------------------------------------Mudar para require ------------------------------------------
function inicializaTabuleiro()
	tabuleiro = {{" "," "," "},{" "," "," "},{" "," "," "}}
	vezDe = "O"
end

function jogadar(x, y)

	if x < 1 or x > 3 and y < 1 or y > 3 then
		return false
	end
	
	if tabuleiro[x][y] == " " then
		tabuleiro[x][y] = vezDe
		if vezDe == "X" then
			vezDe = "O"
		else
			vezDe = "X"
		end
		return true
	end
	return false
end

function proximaJogada(x,y)
	local realizada = jogadar(x,y)
		
		if not realizada then
			texto.text = "Jogada invalida, tente novamente!"
		end
		if not fimJogo() then
			texto.text = "Vez do jogador " .. vezDe
		end
		return realizada
end


function fimJogo()
	local a = verificaVencedor()
	local fim = false
	if a ~= false then
		texto.text = "'" .. a .."' venceu!"
		fim = true
	end
	if	verificaEmpate() then
		texto.text = "Empate."
		fim = true
	end
	if fim then
		widget.newButton({x = centerX, y = centerY , width = (centerX *2) , height = (centerY * 2), onRelease = novoJogo})
	end
	return fim
end

function verificaEmpate()
	 for i = 1, 3 , 1 do
		for j = 1, 3 , 1 do
			if(tabuleiro[i][j] == " ") then
				return false
			end
		end
	end
	return true
end

function verificaVencedor()
	for i = 1, 3 , 1 do
		for j = 1, 3, 1 do
			if tabuleiro[i][j] ~= " " and tabuleiro[i][j] == tabuleiro[i][j+1] and tabuleiro[i][j] == tabuleiro[i][j+2]   then
				desenhaLinha({x = j,y = i}, {x = j+2, y = i})
				return tabuleiro[i][j]
			end
			if i == 1 then
				if tabuleiro[i][j] ~= " " and tabuleiro[i][j] == tabuleiro[i+1][j] and tabuleiro[i][j] == tabuleiro[i+2][j] then
					desenhaLinha({x = j, y = i}, {x = j, y = i+2})
					return tabuleiro[i][j] 
				end
			end
		end
		
		
	end
	
	if tabuleiro[1][1] ~= " " and tabuleiro[1][1] == tabuleiro[2][2] and tabuleiro[1][1] == tabuleiro[3][3] then
			desenhaLinha({x = 1, y = 1}, {x = 3, y = 3})
			return tabuleiro[1][1] 
	end
	
	if tabuleiro[3][1] ~= " " and tabuleiro[3][1] == tabuleiro[2][2] and tabuleiro[3][1] == tabuleiro[1][3] then
			desenhaLinha({x = 3,y = 1}, {x = 1,y = 3})
			return tabuleiro[3][1] 
	end
	
	return false
	
end


---------------------------------------------------------Mudar para require ------------------------------------------

-- Your code here

novoJogo()
