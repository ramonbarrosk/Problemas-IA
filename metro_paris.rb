#!/usr/bin/env ruby
def algoritmo_estrela(no_origem, no_destino, lista_nos, heuristicas)
  @fronteira = [no_origem]

  melhor_rota = []
  visitados = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

  while true
    no = @fronteira.shift

    next if visitados[no[:id]] == 1

    if ehDestino(no, no_destino)

      while (no[:pai] != nil)
        melhor_rota.unshift(no)
        no = no[:pai]
      end
      break
    end

    geraFilhos(no, visitados, lista_nos, heuristicas)

    visitados[no[:id]] = 1
  end

  p "Tempo total (minutos): #{melhor_rota.last[:custo]}"
  p "Distancia total (km): #{30 * (melhor_rota.last[:custo].to_f/60)}"
  p "Melhor rota:"
  melhor_rota.each do |caminho|
    p "Estação: #{caminho[:id]} - Linha #{caminho[:estacao]}"
  end
end

def ehDestino(no_atual, no_destino)
  return true if no_atual[:id] == no_destino[:id]

  return false
end
 
def verificaEstacoes(no, no_pai)
  no[:estacoes].each do |estacao|
    if no_pai[:estacoes].include?(estacao)
      no[:estacao] = estacao
      break
    end
  end

  return 0 if (no[:estacao] == no_pai[:estacao] || no_pai[:estacao] == nil)

  return 4
end

def geraFilhos(no, visitados, lista_nos, heuristicas)
  (0..13).to_a.each do |index|
    if (no[:adj][index] != 0 && visitados[index] == 0)
      current = lista_nos[index]

      custo_baldeacao = verificaEstacoes(current, no)

      current[:custo] = no[:custo] + no[:adj][index] + custo_baldeacao
      current[:peso] = heuristicas[index] + current[:custo]

      current[:pai] = no

      inseriu = false

      (0..@fronteira.size - 1).to_a.each do |j|
        if current[:peso] < @fronteira[j][:peso]
          @fronteira.insert(j, current)
          inseriu = true
          break
        end
      end

      @fronteira << current unless inseriu
    end
  end
end

if __FILE__ == $0
  heuristica = [
    [0, 22, 40, 54, 80, 86, 78, 56, 36, 20, 36, 60, 60, 64],
    [22, 0, 18, 32, 58, 64, 56, 38, 22, 8, 34, 46, 42, 48],
    [40, 18, 0, 14, 40, 44, 38, 30, 20, 22, 42, 42, 26, 36],
    [54, 32, 14, 0, 26, 32, 24, 26, 26, 36, 52, 42, 22, 34],
    [80, 58, 40, 26, 0, 6, 4, 42, 50, 62, 76, 54, 32, 40],
    [86, 64, 44, 32, 6, 0, 8, 46, 56, 66, 82, 60, 34, 40],
    [78, 56, 38, 24, 4, 8, 0, 44, 50, 58, 76, 56, 26, 34],
    [56, 38, 30, 26, 42, 46, 44, 0, 18, 44, 36, 14, 50, 60],
    [36, 22, 20, 26, 50, 56, 50, 18, 0, 26, 24, 24, 46, 56],
    [20, 8, 22, 36, 62, 66, 58, 44, 26, 0, 40, 54, 40, 46],
    [36, 34, 42, 52, 76, 82, 76, 36, 24, 40, 0, 30, 70, 78],
    [60, 46, 42, 42, 54, 60, 56, 14, 24, 54, 30, 0, 62, 74],
    [60, 42, 26, 22, 32, 34, 26, 50, 46, 40, 70, 62, 0, 10],
    [64, 48, 36, 34, 40, 40, 34, 60, 56, 46, 78, 74, 10, 0]
    ]

  adj = [
    [0, 22, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [22, 0, 18, 0, 0, 0, 0, 0, 22, 8, 0, 0, 0, 0],
    [0, 18, 0, 14, 0, 0, 0, 0, 0, 20, 0, 0, 26, 0],
    [0, 0, 14, 0, 26, 0, 0, 26, 0, 0, 0, 0, 22, 0],
    [0, 0, 0, 26, 0, 6, 4, 42, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 6, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 26, 42, 0, 0, 0, 18, 0, 0, 14, 0, 0],
    [0, 22, 20, 0, 0, 0, 0, 18, 0, 0, 24, 0, 0, 0],
    [0, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 24, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 14, 0, 0, 0, 0, 0, 0],
    [0, 0, 26, 22, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 0]
    ]

  p 'Digite a estação de origem:'
  origem = gets.chomp
  p 'Digite a estação de destino:'
  destino = gets.chomp

  lista_nos = []

  (0..13).to_a.each do |index|
    hash = {}

    hash[:id] = index
    hash[:pai] = nil
    hash[:custo] = 0
    hash[:adj] = adj[index]

    lista_nos << hash
  end

  lista_nos[0][:estacoes] = ['Azul']
  lista_nos[1][:estacoes] = ['Azul', 'Amarelo']
  lista_nos[2][:estacoes] = ['Azul', 'Vermelho']
  lista_nos[3][:estacoes] = ['Azul', 'Verde']
  lista_nos[4][:estacoes] = ['Azul', 'Amarelo']
  lista_nos[5][:estacoes] = ['Azul']
  lista_nos[6][:estacoes] = ['Amarelo']
  lista_nos[7][:estacoes] = ['Amarelo', 'Verde']
  lista_nos[8][:estacoes] = ['Amarelo', 'Vermelho']
  lista_nos[9][:estacoes] = ['Amarelo']
  lista_nos[10][:estacoes] = ['Vermelho']
  lista_nos[11][:estacoes] = ['Verde']
  lista_nos[12][:estacoes] = ['Vermelho', 'Verde']
  lista_nos[13][:estacoes] = ['Verde']

  no_origem = lista_nos[origem.to_i - 1]
  no_destino = lista_nos[destino.to_i - 1]

  algoritmo_estrela(no_origem, no_destino, lista_nos, heuristica[destino.to_i - 1])
end
