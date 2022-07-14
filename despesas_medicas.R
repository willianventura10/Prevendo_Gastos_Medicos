#Definindo local de trabalho
#setwd("C:/Data_Science/despesas_medicas")

#carregando bibliotecas
library(ggplot2)
library(corrplot)
library(caTools)

#Carregando dataset
df <- read.csv("despesas_medicas.csv")

#Explorando dados
head(df)
summary(df) 
str(df)
any(is.na(df))

#Pré-Processamento
#substituindo 'sim' e 'nao' por 1 e 0 respectivamente na coluna 'fumante'
df$fumante = ifelse(df$fumante == "sim",1,0)
df$fumante = as.numeric(df$fumante)

#Obtendo apenas as colunas numericas
colunas_numericas <- sapply(df, is.numeric)
colunas_numericas

#Filtrando as colunas numericas para análise de correlacão
data_cor <- cor(df[,colunas_numericas])
data_cor
head(data_cor)

# Análise de Correlações e Histograma
# Criando um corrplot
corrplot(data_cor,addCoef.col="black",number.cex=0.75)

#Outras opções
pairs(df[c("idade", "bmi", "filhos","fumante", "gastos")])

library(psych)
#Este gráfico fornece mais informações sobre o relacionamento entre as variáveis
pairs.panels(df[c("idade", "bmi", "filhos","fumante", "gastos")])

#Criando um histograma
ggplot(df, aes(x = gastos)) + 
  geom_histogram(bins = 20, 
                 alpha = 0.5, fill = 'blue') + 
  theme_minimal()

#Construindo Modelo Preditivo (Regressão Linear)

#Criando as amostras de forma randomica
amostra <- sample.split(df$idade, SplitRatio = 0.70)

# Criando dados de treino - 70% dos dados
treino = subset(df, amostra == TRUE)

# Criando dados de teste - 30% dos dados
teste = subset(df, amostra == FALSE)

# Avaliando modelos criados

# Gerando o Modelo (Usando todos os atributos)
modelo_v1 <- lm(gastos ~ ., data = treino)

# Interpretando o Modelo
summary(modelo_v1)

# Visualizando o Modelo e Fazendo Previsoes

# Obtendo os residuos
res <- residuals(modelo_v1)

# Convertendo o objeto para um dataframe
res <- as.data.frame(res)
head(res)

# Histograma dos residuos
ggplot(res, aes(res)) +  
  geom_histogram(bins = 20, 
                 alpha = 0.5, fill = 'blue') 

# Testando Modelo

# Fazendo as predicoes com os dados de teste
prevendo_gastos <- predict(modelo_v1, teste)
prevendo_gastos

# Visualizando os valores previstos e observados
resultados <- cbind(prevendo_gastos, teste$gastos) 
colnames(resultados) <- c('Previsto','Real')
resultados <- as.data.frame(resultados)
resultados
min(resultados)

# Tratando os valores negativos
trata_zero <- function(x){
  if  (x < 0){
    return(0)
  }else{
    return(x)
  }
}

# Aplicando a funcao para tratar valores negativos em nossa previsao
resultados$Previsto <- sapply(resultados$Previsto, trata_zero)
resultados$Previsto

# Calculando o erro medio
# Quao distantes os valores previstos estao dos valores observados
# MSE
mse <- mean((resultados$Real - resultados$Previsto)^2)
print(mse)

# RMSE
rmse <- mse^0.5
rmse

# Calculando R-Squared
SSE = sum((resultados$Previsto - resultados$Real)^2)
SST = sum( (mean(df$gastos) - resultados$Real)^2)

# R-Squared
# Ajuda a avaliar o nivel de precisao do modelo. Quanto maior, melhor, sendo 1 o valor ideal.
R2 = 1 - (SSE/SST)
R2

# Otimizando modelo

# Acrescentando variáveis 'idade2', 'bmi30' e 'fbmi30' aos dados de treino e teste
treino$idade2 <- (treino$idade)^2
teste$idade2 <- (teste$idade)^2
treino$bmi30 <- ifelse(treino$bmi >= 30, 1, 0)
teste$bmi30 <- ifelse(teste$bmi >= 30, 1, 0)
treino$fbmi30 <-treino$bmi30*treino$fumante
teste$fbmi30 <-teste$bmi30*teste$fumante

# Criando o modelo otimizado
modelo_v2 <- lm(gastos ~ ., data = treino)
summary(modelo_v2)

# Obtendo os residuos
res2 <- residuals(modelo_v2)

# Convertendo o objeto para um dataframe
res2 <- as.data.frame(res2)
head(res2)

# Histograma dos residuos
ggplot(res2, aes(res2)) +  
  geom_histogram(bins = 20, 
                 alpha = 0.5, fill = 'blue') 

# Fazendo as predicoes com os dados de teste
prevendo_gastos <- predict(modelo_v2, teste)
prevendo_gastos

# Visualizando os valores previstos e observados
resultados2 <- cbind(prevendo_gastos, teste$gastos) 
colnames(resultados2) <- c('Previsto','Real')
resultados2 <- as.data.frame(resultados2)
resultados2
min(resultados2)

# Tratando os valores negativos
trata_zero <- function(x){
  if  (x < 0){
    return(0)
  }else{
    return(x)
  }
}

# Aplicando a funcao para tratar valores negativos em nossa previsao
resultados2$Previsto <- sapply(resultados2$Previsto, trata_zero)
resultados2$Previsto

# Calculando o erro medio
# MSE
mse <- mean((resultados2$Real - resultados2$Previsto)^2)
print(mse)

# RMSE
rmse <- mse^0.5
rmse

# Calculando R-Squared
SSE = sum((resultados2$Previsto - resultados2$Real)^2)
SST = sum( (mean(df$gastos) - resultados2$Real)^2)

# R-Squared
R2 = 1 - (SSE/SST)
R2

# Comparando versões do Modelo
summary(modelo_v1)
summary(modelo_v2)

