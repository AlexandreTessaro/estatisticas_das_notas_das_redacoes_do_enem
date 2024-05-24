if (!require("data.table")) install.packages("data.table")
if (!require("writexl")) install.packages("writexl")

library(data.table)
library(writexl)

caminho_filtrados <- "C:\\Users\\richa\\OneDrive\\Área de Trabalho\\matematica\\Dados filtrados\\DadosFiltrados\\"

caminho_saida_excel <- "C:\\Users\\richa\\OneDrive\\Área de Trabalho\\matematica\\Dados filtrados\\Media\\Metricas_NotaxSexo.xlsx"

anos <- 2019:2023

colunas_notas <- c("NU_NOTA_COMP1", "NU_NOTA_COMP2", "NU_NOTA_COMP3", "NU_NOTA_COMP4", "NU_NOTA_COMP5", "NU_NOTA_REDACAO")

resultados <- data.frame(Ano = integer(), Sexo = character(), Componente = character(), 
                         Media = numeric(), Mediana = numeric(), Moda = character())

for (ano in anos) {
  arquivo <- sprintf("dados_filtrados_%s.csv", ano)
  caminho_completo <- file.path(caminho_filtrados, arquivo)

  dados <- fread(caminho_completo)
  
  for (sexo in c("M", "F")) {
    for (coluna in colunas_notas) {
      dados_sexo <- dados[TP_SEXO == sexo]

      media <- mean(dados_sexo[[coluna]], na.rm = TRUE)
      mediana <- median(dados_sexo[[coluna]], na.rm = TRUE)
      moda <- Mode(dados_sexo[[coluna]])
 
      resultados <- rbind(resultados, data.frame(Ano = ano, Sexo = sexo, Componente = coluna, 
                                                 Media = media, Mediana = mediana, Moda = moda))
    }
  }
}

write_xlsx(resultados, caminho_saida_excel)

cat("Os resultados foram salvos em:", caminho_saida_excel)
