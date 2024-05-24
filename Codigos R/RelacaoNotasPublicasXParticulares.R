if (!require("data.table")) install.packages("data.table")
if (!require("DescTools")) install.packages("DescTools")
if (!require("writexl")) install.packages("writexl")

library(data.table)
library(DescTools)
library(writexl)

caminho_filtrados <- "C:\\Users\\richa\\OneDrive\\Área de Trabalho\\matematica\\Dados filtrados\\DadosFiltrados\\"

caminho_saida_excel <- "C:\\Users\\richa\\OneDrive\\Área de Trabalho\\matematica\\Dados filtrados\\Media\\Metricas_Escola_Publica_Particular.xlsx"

anos <- 2019:2023

colunas_notas <- c("NU_NOTA_COMP1", "NU_NOTA_COMP2", "NU_NOTA_COMP3", "NU_NOTA_COMP4", "NU_NOTA_COMP5", "NU_NOTA_REDACAO")

tipos_escola <- c(2, 3)  

resultados <- data.frame(Ano = integer(), Tipo_Escola = character(), Componente = character(),
                         Media = numeric(), Mediana = numeric(), Moda = character())

for (ano in anos) {
  arquivo <- sprintf("dados_filtrados_%s.csv", ano)
  caminho_completo <- file.path(caminho_filtrados, arquivo)

  dados <- fread(caminho_completo)

  for (tipo in tipos_escola) {
    for (coluna in colunas_notas) {
      dados_tipo_escola <- dados[TP_ESCOLA == tipo]
      
      media <- mean(dados_tipo_escola[[coluna]], na.rm = TRUE)
      mediana <- median(dados_tipo_escola[[coluna]], na.rm = TRUE)
      moda <- Mode(dados_tipo_escola[[coluna]])

      tipo_texto <- ifelse(tipo == 2, "Pública", "Particular")

      resultados <- rbind(resultados, data.frame(Ano = ano, Tipo_Escola = tipo_texto, Componente = coluna,
                                                 Media = media, Mediana = mediana, Moda = moda))
    }
  }
}

write_xlsx(resultados, caminho_saida_excel)

cat("Os resultados foram salvos em:", caminho_saida_excel)
