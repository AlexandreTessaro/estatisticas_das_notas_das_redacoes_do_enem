if (!require("data.table")) install.packages("data.table")
if (!require("DescTools")) install.packages("DescTools")
if (!require("writexl")) install.packages("writexl")

library(data.table)
library(DescTools)
library(writexl)

caminho_filtrados <- "C:\\Users\\richa\\OneDrive\\Área de Trabalho\\matematica\\Dados filtrados\\DadosFiltrados\\"

caminho_saida_excel <- "C:\\Users\\richa\\OneDrive\\Área de Trabalho\\matematica\\Dados filtrados\\Media\\Metricas_Notas_Redacao_por_Estado.xlsx"

anos <- 2019:2023

resultados <- data.table(Ano = integer(), Estado = character(), Quantidade = numeric(), 
                         Media = numeric(), Mediana = numeric(), Moda = character())

for (ano in anos) {
  arquivo <- sprintf("dados_filtrados_%s.csv", ano)
  caminho_completo <- file.path(caminho_filtrados, arquivo)

  dados <- fread(caminho_completo)
  dados <- dados[!is.na(NU_NOTA_REDACAO), ]

  dados_agregados <- dados[, .(
    Quantidade = as.numeric(.N),
    Media = as.numeric(mean(NU_NOTA_REDACAO, na.rm = TRUE)),
    Mediana = as.numeric(median(NU_NOTA_REDACAO, na.rm = TRUE)),
    Moda = as.character(Mode(NU_NOTA_REDACAO))
  ), by = SG_UF_PROVA]

  dados_agregados[, Ano := as.integer(ano)]
  setnames(dados_agregados, "SG_UF_PROVA", "Estado")
 
  resultados <- rbindlist(list(resultados, dados_agregados), use.names = TRUE, fill = TRUE)
}

write_xlsx(resultados, caminho_saida_excel)

cat("Os resultados foram salvos em:", caminho_saida_excel)
