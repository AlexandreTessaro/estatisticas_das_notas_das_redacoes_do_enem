if (!require("data.table")) install.packages("data.table")
if (!require("DescTools")) install.packages("DescTools")
if (!require("writexl")) install.packages("writexl")

library(data.table)
library(DescTools)
library(writexl)

caminho_filtrados <- "C:\\Users\\richa\\OneDrive\\Área de Trabalho\\matematica\\Dados filtrados\\DadosFiltrados\\"

caminho_saida_excel <- "C:\\Users\\richa\\OneDrive\\Área de Trabalho\\matematica\\Dados filtrados\\Media\\Metricas_Componentes_Redacao.xlsx"

anos <- 2019:2023

colunas <- c("NU_NOTA_COMP1", "NU_NOTA_COMP2", "NU_NOTA_COMP3", "NU_NOTA_COMP4", "NU_NOTA_COMP5")

resultados <- data.frame(Ano = integer(), Componente = character(), Media = numeric(), Mediana = numeric(), Moda = numeric())

for (ano in anos) {
  arquivo <- sprintf("dados_filtrados_%s.csv", ano)
  caminho_completo <- file.path(caminho_filtrados, arquivo)

  dados <- fread(caminho_completo)

  for (coluna in colunas) {
    media <- mean(dados[[coluna]], na.rm = TRUE)
    mediana <- median(dados[[coluna]], na.rm = TRUE)
    moda <- Mode(dados[[coluna]])
 
    resultados <- rbind(resultados, data.frame(Ano = ano, Componente = coluna, Media = media, Mediana = mediana, Moda = moda))
  }
}

write_xlsx(resultados, caminho_saida_excel)

cat("Os resultados foram salvos em:", caminho_saida_excel)
