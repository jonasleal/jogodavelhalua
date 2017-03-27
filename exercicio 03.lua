function inicializaTabuleiro()
	tabuleiro = {{"X","O","X"},{"O","X","O"},{"X","O"," "}}
	vezDe = "O"
end

function mostrarTabuleiro()
	local saida = "  1 2 3\n"
	for i = 1 , 3 , 1 do
		for j = 1, 3 ,1 do
			if j == 1 then
				saida = saida .. "1 "
			end
			saida = saida .. tabuleiro[i][j]
			if j < 3 then
				saida = saida .. "|"
			end
			
		end
		saida = saida .."\n"
		if i < 3 then

			saida = saida .. "  -----\n"
		end
	end
	print(saida)
end

function jogada(x, y)

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

function proximaJogada()
	print("Vez do jogador " .. vezDe)
	repeat
		print("Digite uma linha")
		local x = io.read("*number")
		
		print("Digite uma coluna")
		local y = io.read("*number")
		
		local realizada = jogada(x,y)
		
		if not realizada then
			print("Jogada invalida, tente novamente!")
		end
	until(realizada)
end

function fimJogo()
	a = verificaVencedor()
	if a ~= false then
		print("              -------------Jogador '" .. a .."' venceu!-------------" )
		return true
	end
	if	verificaEmpate() then
		print("                -------------Jogo terminou em empate.-------------")
		return true
	end
	return false
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
				return tabuleiro[i][j]
			end
			if i == 1 then
				if tabuleiro[i][j] ~= " " and tabuleiro[i][j] == tabuleiro[i+1][j] and tabuleiro[i][j] == tabuleiro[i+2][j] then
					return tabuleiro[i][j] 
				end
			end
		end
		
		
	end
	
	if tabuleiro[1][1] ~= " " and tabuleiro[1][1] == tabuleiro[2][2] and tabuleiro[1][1] == tabuleiro[3][3] then
			return tabuleiro[1][1] 
	end
	
	if tabuleiro[3][3] ~= " " and tabuleiro[3][3] == tabuleiro[2][2] and tabuleiro[3][3] == tabuleiro[1][1] then
			return tabuleiro[3][3] 
	end
	
	return false
	
end

function partida()

	inicializaTabuleiro()
	repeat
		mostrarTabuleiro()
		proximaJogada()
		
	until(fimJogo())
end

--repeat
partida()
--[[
print("Jogar novamente?\n 1 - SIM , 2 - Não")

local novoJogo = io.read("*number")

until(novoJogo == "2")
]]