
<h1 align="center" style="font-weight: bold; font-size: 40px">
Tester Escalonamento Estrito
</h1>

<div align="center"  style="display: row">
<img src="https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white" alt="Docker"> 
<img src="https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white" alt="PostgreSQL">
<img src="https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white"
alr="python3">
<img src="https://img.shields.io/badge/Git-E34F26?style=for-the-badge&logo=git&logoColor=white" alt="git">
</div>

<br/>

# 👨🏽‍💻👩🏻‍💻 Autores

* Filipe Gomes Arante de Souza
* Juliana Camilo Repossi

<br/>

# 💻 Pré-requisitos

Para executar a aplicação você precisa:

* [Docker](https://www.docker.com/) 
* Python 3.8

<br/>

# 📃 Sobre

O tester de escalonamento estrito é uma função implementada em sql, disponível na pasta init no arquivo 2-function.sql, para avaliar se uma dada inserção de dados da tabela "Schedule" é um escalonamento de transações estrito no banco de dados.

<br/>

# 🚀 Funcionalidades adicionais 

## Gerador automático de testes

Foi implementado um gerador automático de escalonamentos de transações estritas e não estritas em python no arquivo ``test_generator.py``. Esse gerador cria uma ação de uma transação aleatória dentre um conjunto de valores possíveis de atributos e verifica se ao inserir esta ação num schedule ele continua restrito, no caso de produzir um escalonamento correto. E, para a produção de um escalonamento incorreto, transações aleatórias são geradas sem a necessidade verificação, e ainda inserido um par de transações responsáveis por garantir que esse escalonamento não será estrito, caso todas as outras inserções não o façam.

## Script automático de execução dos testes
Como já mencionado acima, os testes foram separados em **estritos** e **não estritos**. Os estritos são direcionados para a pasta ``tests/correct``, enquanto os não estritos são direcionados para a pasta ``tests/incorrect``. O script faz um diff da saída do teste ou com o arquivo ``out_testes/correct.txt`` ou ``out_testes/incorrect.txt`` de acordo com a sua categoria.

# 🖱️ Executar a aplicação


Para gerar arquivos de teste automaticamente basta executar o comando abaixo passando o número inteiro de testes de exemplos corretos e de exemplos incorretos a serem criados.

```bash
# Gerar escalonamento automaticamente
python3 test_generator.py NUM_TESTES_GERADOS
```

Ou, para inserir escalonamentos de transações já prontas é preciso criar a pasta tests. E dentro dela criar as pastas correct e incorrect. Nelas terão os escalonamentos estritos e não estritos respectivamente.

Depois basta rodar o script abaixo, que sobe o container e testa cada arquivo separadamente, verificando se aqueles internos a pasta correct respondem com 'true', e aqueles internos a pasta incorrect respondem com 'false'.

```bash
# Executar script
./script.sh
```


