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
O objetivo deste projeto é praticar o conhecimento adquirido em Machine Learning. Para o desenvolvimento do projeto foi utilizada linguagem R (versão 4.2.0) juntamente com as bibliotecas 'dplyr' (versão 1.0.9), 'ggplot2' (versão 3.3.6) e 'corrplot' (versão 0.92).

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

Substituindo 'sim' e 'nao' por 2 e 1 respectivamente na coluna 'fumante'.
```
df$fumante = recode_factor(df$fumante,"sim" = "2")
df$fumante = recode_factor(df$fumante,"nao" = "1")
df$fumante = as.numeric(df$fumante)
```
Obtendo e filtrando apenas as colunas numéricas para correlacão.
```
colunas_numericas <- sapply(df, is.numeric)
data_cor <- cor(df[,colunas_numericas])
```







