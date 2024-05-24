# Instalar e carregar os pacotes necessários
if (!require("data.table")) install.packages("data.table")
if (!require("DescTools")) install.packages("DescTools")
if (!require("writexl")) install.packages("writexl")

library(data.table)
library(DescTools)
library(writexl)

# Caminho para os arquivos CSV filtrados
caminho_filtrados <- "C:\\Users\\richa\\OneDrive\\Área de Trabalho\\matematica\\Dados filtrados\\DadosFiltrados\\"

# Caminho para salvar o arquivo Excel com as métricas
caminho_saida_excel <- "C:\\Users\\richa\\OneDrive\\Área de Trabalho\\matematica\\Dados filtrados\\Media\\Metricas_TipoEscola.xlsx"

# Lista dos anos dos arquivos
anos <- 2019:2023

# Preparar um data.frame para armazenar os resultados
resultados <- data.frame(Ano = integer(), Moda = character(), Percentual_NaoRespondeu = numeric(), 
                         Percentual_Publica = numeric(), Percentual_Particular = numeric())

# Processar cada arquivo
for (ano in anos) {
  arquivo <- sprintf("dados_filtrados_%s.csv", ano)
  caminho_completo <- file.path(caminho_filtrados, arquivo)
  
  # Ler o arquivo CSV
  dados <- fread(caminho_completo)
  
  # Calcular a moda de TP_ESCOLA e percentuais para todo o conjunto
  moda <- Mode(dados$TP_ESCOLA)
  total <- nrow(dados)
  n_nao_respondeu <- sum(dados$TP_ESCOLA == 1, na.rm = TRUE)
  n_publica <- sum(dados$TP_ESCOLA == 2, na.rm = TRUE)
  n_particular <- sum(dados$TP_ESCOLA == 3, na.rm = TRUE)
  percentual_nao_respondeu <- (n_nao_respondeu / total) * 100
  percentual_publica <- (n_publica / total) * 100
  percentual_particular <- (n_particular / total) * 100
  resultados <- rbind(resultados, data.frame(Ano = ano, Moda = moda, Percentual_NaoRespondeu = percentual_nao_respondeu, 
                                             Percentual_Publica = percentual_publica, Percentual_Particular = percentual_particular))
  
  # Calcular novamente para escolas públicas e particulares somente
  dados_filtrados <- dados[TP_ESCOLA %in% c(2, 3)]
  total_filtrado <- nrow(dados_filtrados)
  n_publica_filtrado <- sum(dados_filtrados$TP_ESCOLA == 2, na.rm = TRUE)
  n_particular_filtrado <- sum(dados_filtrados$TP_ESCOLA == 3, na.rm = TRUE)
  percentual_publica_filtrado <- (n_publica_filtrado / total_filtrado) * 100
  percentual_particular_filtrado <- (n_particular_filtrado / total_filtrado) * 100
  resultados <- rbind(resultados, data.frame(Ano = ano, Moda = moda, Percentual_NaoRespondeu = NA, 
                                             Percentual_Publica = percentual_publica_filtrado, Percentual_Particular = percentual_particular_filtrado))
}

# Exportar os resultados para um arquivo Excel
write_xlsx(resultados, caminho_saida_excel)

# Mensagem de conclusão
cat("Os resultados foram salvos em:", caminho_saida_excel)
