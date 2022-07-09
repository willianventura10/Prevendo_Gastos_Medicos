<h1 align="left">Prevendo despesas Médicas 👩‍⚕️️🏥</h1>

![image](Imagens/IMG1.jpg)
# Índice
* [Sobre o Projeto](#computer-sobre-o-projeto)
* [Descrição Geral do Problema](#gear-descrição-geral-do-problema)
* [Familiarizando-se com o Dataset](#mag-familiarizando-se-com-o-dataset)
  * [Suposições de negócio](#suposições-de-negócio)
  * [Exploração inicial dos dados](#exploração-inicial-dos-dados)
  * [3 relevant insights](#3-relevant-insights)
  * [Financial results](#financial-results)
  * [Conclusion](#conclusion)
* [Technologies](#hammer_and_wrench-technologies)
* [Setup](#rocket-setup)
  * [Requirements](#requirements)
  * [Installation](#wrench-installation)
  * [Executing online](#globe_with_meridians-executing-online)
  * [Executing via cmd](#game_die-executing-via-cmd)
* [Author](#superhero-author)

## :computer: Sobre o Projeto
O objetivo deste projeto é praticar o conhecimento adquirido em Machine Learning. Para o desenvolvimento do projeto foi utilizada linguagem R (versão 4.2.0) juntamente com as bibliotecas 'dplyr' (versão 1.0.9), 'ggplot2' (versão 3.3.6), 'corrplot' (versão 0.92) e 'caTools' (versão 1.18.2). 

## :gear: Descrição Geral do Problema
Para que uma companhia de seguros de saúde possa auferir lucros, ela precisa recolher mais
prêmios anuais do que gasta em cuidados médicos para os seus beneficiários. Como resultado,
as seguradoras investem no desenvolvimento de modelos que possam prever com precisão as 
despesas médicas para a população segurada. As despesas médicas são difíceis de estimar, 
porque os tratamentos mais caros são raros e, aparentemente, ocorrem de maneira aleatória. 
Ainda assim, algumas condições são mais comuns em certos segmentos da população. Por exemplo, 
o câncer de pulmão é mais provável entre fumantes do que não-fumantes e doenças cardíacas podem 
ser mais prováveis entre os obesos. O objetivo desta análise é usar os dados de pacientes para estimar 
as despesas médias de assistência médica a esses segmentos da população. Estas estimativas podem ser utilizadas
para criar tabelas que estabelecem os preços dos prêmios anuais maiores ou menores, dependendo dos custos de tratamento previsto.

## :mag: Familiarizando-se com o Dataset
Para o desenvolvimento do Projeto foram utilizados dados fictícios de 1338 segurados, considerando as seguintes caracterísicas: idade, sexo, 
índice de massa corporal (bmi), número de filhos, se é fumante ou não, e o total anual gasto com despesas médicas.

- [x] **Suposições de negócio**: Trabalharemos inicialmente com a hipótese de que algumas caractéricas dos segurados, como ser fumante e/ou 
possuir um alto índice de massa corporal estão diretamente vinculadas aos gastos anuais com saúde.
- [x] **Exploração inicial dos dados**: Resumo estatístico, Tipos de variáveis e verificação se há valores 'missing'.

![image](Imagens/IMG22.jpg)

![image](Imagens/IMG3.jpg) 

- [x] **Pré-Processamento**: 

Substituindo 'sim' e 'nao' por 1 e 0 respectivamente na coluna 'fumante'.
```
df$fumante = ifelse(df$fumante == "sim",1,0)
df$fumante = as.numeric(df$fumante)
```
Obtendo e filtrando apenas as colunas numéricas para análise de correlacão.
```
colunas_numericas <- sapply(df, is.numeric)
data_cor <- cor(df[,colunas_numericas])
```
- [x] **Análise da Correlação entre as variáveis**: 

Matriz de Correlação:

![image](Imagens/IMG5.jpeg)

```
corrplot(data_cor, method = 'color')
```

![image](Imagens/IMG4.jpeg)

Como podemos observar, existe correlação entre a variável "gastos" e as demais variáveis, sendo a correlação com a variável "fumante" a mais forte. **Isso confirma a hipótese inicial de que algumas características dos segurados podem influenciar em seu gasto anual com despesas médicas.** 

## :rocket: Solução do Problema
Uma vez que concluímos as etapas de exploração dos dados e pré-processamento, confirmando ainda nossa hipótese inicial de que há correlação entre os atributos dos segurados e o seu gasto anual com despesas médicas, buscaremos agora uma solução para o problema inicialmente proposto: **estimar as despesas médias dos segurados com base nos seus atributos**. Para isso entendemos como necessária a construção de um modelo preditivo, neste caso utilizaremos a **Regressão Linear** para estimar os valores.

### Construindo o Modelo 

Criando as amostras de forma randomica
```
amostra <- sample.split(df$idade, SplitRatio = 0.70)
```
Criando dados de treino - 70% dos dados
```
treino = subset(df, amostra == TRUE)
```
Criando dados de teste - 30% dos dados
```
teste = subset(df, amostra == FALSE)
```
Gerando o Modelo com dados de treino (Usando todos os atributos)
```
modelo_v1 <- lm(gastos ~ ., treino)
```

Podemos observar que o modelo criado apresenta bom desempenho utilizando os dados de treino (tomando como parâmetro o R-squared).

![image](Imagens/IMG7.jpeg)

Obtendo os resíduos (diferenca entre os valores observados de uma variavel e seus valores previstos)
```
res <- residuals(modelo_v1)
res <- as.data.frame(res)
```

Histograma dos resíduos
```
ggplot(res, aes(res)) +  
  geom_histogram(bins = 20, 
                 alpha = 0.5, fill = 'blue')
```

![image](Imagens/IMG8.jpeg)

O Histograma acima nos mostra uma distribuicao normal, o que indica que a média entre os valores previstos e os valores observados é proximo de zero, o que é muito bom.

### Testando e avaliando o Modelo 

Fazendo as predições
```
prevendo_gastos <- predict(modelo_v1, teste)
resultados <- cbind(prevendo_gastos, teste$gastos) 
colnames(resultados) <- c('Previsto','Real')
resultados <- as.data.frame(resultados)
```

Tratando os valores negativos
```
trata_zero <- function(x){
  if  (x < 0){
    return(0)
  }else{
    return(x)
  }
}
resultados$Previsto <- sapply(resultados$Previsto, trata_zero)
```

Cálculo da raiz quadrada do erro quadrático médio
```
mse <- mean((resultados$Real - resultados$Previsto)^2)
rmse <- mse^0.5
```

Cálculo do R-squared
```
SSE = sum((resultados$Previsto - resultados$Real)^2)
SST = sum( (mean(df$gastos) - resultados$Real)^2)
R2 = 1 - (SSE/SST)
```

![image](Imagens/IMG9.jpeg)

Analisando as métricas calculadas, entendemos que o modelo apresenta bom desempenho nas predições. Sendo que o R-squared ajuda a avaliar o nivel de precisão modelo, quanto maior, melhor, sendo 1 o valor ideal.

