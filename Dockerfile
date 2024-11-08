# Use a imagem base Ruby
FROM ruby:3.3.0-slim

# Defina o diretório de trabalho
WORKDIR /app

# Instale as dependências básicas do sistema
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    curl \
    libjemalloc2 \
    libvips \
    postgresql-client \
    build-essential \
    git \
    libpq-dev \
    nodejs \
    npm && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Instale o Yarn
RUN npm install -g yarn

# Copie o Gemfile e o Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Instale as gems
RUN gem install bundler -v 2.3.14 && bundle install --jobs 4 --retry 3

# Copie o código da aplicação para o diretório de trabalho
COPY . .

# Copie o script entrypoint
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

# Garanta que o script de entrypoint tenha permissões de execução
RUN chmod +x /usr/local/bin/entrypoint.sh

# Compile os assets
RUN bundle exec rails assets:precompile

# Exponha a porta que a aplicação irá rodar
EXPOSE 3000

# Defina o entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Remova o pid do servidor Rails, se houver, e rode o servidor
CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0"]
