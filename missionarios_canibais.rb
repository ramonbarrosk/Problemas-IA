#!/usr/bin/env ruby
def ehSolucao(estado, quantidade)
  if estado[:qtd_canibaisA] == 0 && estado[:qtd_missionariosA] == 0 && estado[:qtd_missionariosB] == quantidade && estado[:qtd_canibaisB] == quantidade && estado[:posicao_barco] == 'B'
    return true
  end

  return false
end

def ehValido(estado)
  return false if ((estado[:qtd_missionariosA] < estado[:qtd_canibaisA]) && estado[:qtd_missionariosA] > 0) || ((estado[:qtd_missionariosB] < estado[:qtd_canibaisB]) && estado[:qtd_missionariosB] > 0)
  return false if estado[:qtd_missionariosA] < 0 ||  estado[:qtd_missionariosB] < 0 || estado[:qtd_canibaisA] < 0 || estado[:qtd_canibaisB] < 0

  return true
end

def geraFilhos(hash)
  filhos = []

  if hash[:posicao_barco] == 'A'
    (0..2).each do |missionario|
      (0..2).each do |canibal|
        next if (missionario + canibal > 2 || missionario + canibal == 0)

        estado = {}
        estado[:qtd_missionariosA] = hash[:qtd_missionariosA] - missionario
        estado[:qtd_canibaisA] = hash[:qtd_canibaisA] - canibal

        estado[:qtd_missionariosB] = hash[:qtd_missionariosB] + missionario
        estado[:qtd_canibaisB] = hash[:qtd_canibaisB] + canibal
        estado[:posicao_barco] = 'B'
        filhos << estado if ehValido(estado)
      end
    end

  else
    (0..2).each do |missionario|
      (0..2).each do |canibal|
        next if (missionario + canibal > 2 || missionario + canibal == 0)

        estado = {}
        estado[:qtd_missionariosA] = hash[:qtd_missionariosA] + missionario
        estado[:qtd_canibaisA] = hash[:qtd_canibaisA] + canibal

        estado[:qtd_missionariosB] = hash[:qtd_missionariosB] - missionario
        estado[:qtd_canibaisB] = hash[:qtd_canibaisB] - canibal
        estado[:posicao_barco] = 'A'
        filhos << estado if ehValido(estado)
      end
    end
  end

  filhos
end

def bfs(quantidade)
  estado_inicial = {
    qtd_canibaisA: quantidade,
    qtd_missionariosA: quantidade,
    qtd_canibaisB: 0,
    qtd_missionariosB: 0,
    posicao_barco: 'A'
  }

  fila = [[estado_inicial]]
  visitados = []

  while fila
    sequencia = fila[0]

    final = fila.size - 1
    fila = fila.slice(1, final)
    no = sequencia[-1]

    next if visitados.include?(no)

    filhos = geraFilhos(no)

    filhos.each do |filho|
      next if visitados.include?(filho)

      fila.unshift(sequencia + [filho])
    end
    visitados << no
    break if ehSolucao(no, quantidade)
  end

  sequencia
end

if __FILE__ == $0
  p 'Insira a quantidade de canibais e missionarios (1 a 3):'
  quantidade = gets.chomp
  resultado = bfs(quantidade.to_i)
  movimento = 0
  resultado.each do |estado|
    p "------------------------- Movimento: #{movimento}"
    p "Quantidade de missionários em A: #{estado[:qtd_missionariosA]}"
    p "Quantidade de canibais em A: #{estado[:qtd_canibaisA]}"
    p "Quantidade de missionários em B: #{estado[:qtd_missionariosB]}"
    p "Quantidade de canibais em B: #{estado[:qtd_canibaisB]}"
    p "Barco está no Lado: #{estado[:posicao_barco]}"
    movimento+=1
  end
end
