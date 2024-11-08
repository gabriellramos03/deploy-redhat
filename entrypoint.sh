#!/bin/bash
set -e

# Espera o PostgreSQL estar pronto
until pg_isready -h postgres_container_2 -p 5432 -U "$DB_USER"; do
  echo "Aguardando o banco de dados estar pronto..."
  sleep 2
done

# Cria o banco de dados se não existir
bundle exec rails db:create

# Executa as migrações
bundle exec rails db:migrate

# Executa o servidor Rails
exec bundle exec rails s -b '0.0.0.0'
