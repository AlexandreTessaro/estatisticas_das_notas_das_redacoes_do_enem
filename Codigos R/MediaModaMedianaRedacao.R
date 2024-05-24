if (!require("data.table")) install.packages("data.table")
if (!require("DescTools")) install.packages("DescTools")
if (!require("writexl")) install.packages("writexl")

library(data.table)
library(DescTools)
library(writexl)

caminho_filtrados <- "C:\\Users\\richa\\OneDrive\\Área de Trabalho\\matematica\\Dados filtrados\\DadosFiltrados\\"
caminho_saida_excel <- "C:\\Users\\richa\\OneDrive\\Área de Trabalho\\matematica\\Dados filtrados\\Media\\Metricas_Redacao.xlsx"

anos <- 2019:2023

resultados <- data.frame(Ano = integer(), Media = numeric(), Mediana = numeric(), Moda = numeric())

for (ano in anos) {
  arquivo <- sprintf("dados_filtrados_%s.csv", ano)
  caminho_completo <- file.path(caminho_filtrados, arquivo)
  
  dados <- fread(caminho_completo)
  
  setorder(dados, NU_NOTA_REDACAO) 
  
  media <- mean(dados$NU_NOTA_REDACAO, na.rm = TRUE)
  mediana <- median(dados$NU_NOTA_REDACAO, na.rm = TRUE)
  moda <- Mode(dados$NU_NOTA_REDACAO)
  
  resultados <- rbind(resultados, data.frame(Ano = ano, Media = media, Mediana = mediana, Moda = moda))
}

write_xlsx(resultados, caminho_saida_excel)

cat("Os resultados foram salvos em:", caminho_saida_excel)

