# Instalar pacotes necessários
if (!require("data.table")) install.packages("data.table")
if (!require("bit64")) install.packages("bit64")

# Carregar pacotes
library(data.table)
library(bit64)

# Definição dos anos e caminhos base
anos <- 2019:2023
caminho_originais <- "C:\\Users\\richa\\OneDrive\\Área de Trabalho\\matematica\\Dados originais\\"
caminho_filtrados <- "C:\\Users\\richa\\OneDrive\\Área de Trabalho\\matematica\\Dados filtrados\\"

# Processar cada arquivo
for (ano in anos) {
  arquivo_original <- sprintf("MICRODADOS_ENEM_%s.csv", ano)
  caminho_completo_original <- file.path(caminho_originais, arquivo_original)
  
  # Leitura do arquivo CSV
  dados <- fread(caminho_completo_original)
  
  # Filtrar dados onde NU_NOTA_REDACAO > 599
  dados_filtrados <- dados[NU_NOTA_REDACAO > 0, .(NU_INSCRICAO, TP_SEXO, TP_ESCOLA ,SG_UF_PROVA, NU_NOTA_COMP1, NU_NOTA_COMP2, NU_NOTA_COMP3, NU_NOTA_COMP4, NU_NOTA_COMP5, NU_NOTA_REDACAO)]
  
  # Nome do arquivo de saída
  nome_saida <- sprintf("dados_filtrados_%s.csv", ano)
  caminho_saida <- file.path(caminho_filtrados, nome_saida)
  
  # Salvar os dados filtrados
  fwrite(dados_filtrados, caminho_saida, sep = ";")
}
