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
caminho_saida_excel <- "C:\\Users\\richa\\OneDrive\\Área de Trabalho\\matematica\\Dados filtrados\\Media\\Metricas_Sexo.xlsx"

# Lista dos anos dos arquivos
anos <- 2019:2023

# Preparar um data.frame para armazenar os resultados
resultados <- data.frame(Ano = integer(), Moda = character(), Percentual_Homens = numeric(), Percentual_Mulheres = numeric())

# Processar cada arquivo
for (ano in anos) {
  arquivo <- sprintf("dados_filtrados_%s.csv", ano)
  caminho_completo <- file.path(caminho_filtrados, arquivo)
  
  # Ler o arquivo CSV
  dados <- fread(caminho_completo)
  
  # Calcular a moda de TP_SEXO
  moda <- Mode(dados$TP_SEXO)
  
  # Calcular percentuais de homens e mulheres
  total <- nrow(dados)
  n_homens <- sum(dados$TP_SEXO == "M", na.rm = TRUE)
  n_mulheres <- sum(dados$TP_SEXO == "F", na.rm = TRUE)
  percentual_homens <- (n_homens / total) * 100
  percentual_mulheres <- (n_mulheres / total) * 100
  
  # Armazenar os resultados no data.frame
  resultados <- rbind(resultados, data.frame(Ano = ano, Moda = moda, Percentual_Homens = percentual_homens, Percentual_Mulheres = percentual_mulheres))
}

# Exportar os resultados para um arquivo Excel
write_xlsx(resultados, caminho_saida_excel)

# Mensagem de conclusão
cat("Os resultados foram salvos em:", caminho_saida_excel)
