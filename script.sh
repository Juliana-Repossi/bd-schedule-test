#!/bin/bash

#subir o container
docker compose up -d

sleep 5

# Dados de conexão com o banco de dados
host="localhost"
port=5310
database="postgres"
user="postgres"
password="123"

# Criação do arquivo .pgpass
echo "$host:$port:$database:$user:$password" > ~/.pgpass
chmod 0600 ~/.pgpass

INC=tests/correct

for infile in $INC/*.sql; do
        
    base=$(basename $infile)
    echo Running $base
    outfile=out_testes/correct.txt

    # Comando psql para executar a consulta
    req_psql="psql -h $host -p $port -d $database -U $user -f $INC/$base"
    $req_psql > /dev/null

    # Comando psql para executar a funcao
    func_psql="psql -h $host -p $port -d $database -U $user -f query_aux/func.sql"
    #redirecionar saida
    $func_psql | diff -w $outfile -

    #limpar a base de schedule
    del_psql="psql -h $host -p $port -d $database -U $user -f query_aux/del.sql"
    $del_psql > /dev/null

    #limpar a base de lock
    del_lock_psql="psql -h $host -p $port -d $database -U $user -f query_aux/del_lock.sql"
    $del_lock_psql > /dev/null

done

INIC=tests/incorrect

for infile in $INIC/*.sql; do
    base=$(basename $infile)
    echo Running $base
    outfile=out_testes/incorrect.txt


    # Comando psql para executar a consulta
    req_psql="psql -h $host -p $port -d $database -U $user -f $INIC/$base"
    $req_psql > /dev/null

    # Comando psql para executar a funcao
    func_psql="psql -h $host -p $port -d $database -U $user -f query_aux/func.sql"
    #redirecionar saida
    $func_psql | diff -w $outfile -

    #limpar a base de schedule
    del_psql="psql -h $host -p $port -d $database -U $user -f query_aux/del.sql"
    $del_psql > /dev/null

    #limpar a base de lock
    del_lock_psql="psql -h $host -p $port -d $database -U $user -f query_aux/del_lock.sql"
    $del_lock_psql > /dev/null
    
done


# Remove o arquivo .pgpass
rm ~/.pgpass

#descer o container
docker compose down 