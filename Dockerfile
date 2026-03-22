# syntax=docker/dockerfile:1

##
## Common base with OS deps needed to build native gems and run the app
##
FROM ruby:3.4.7-slim AS base

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    git \
    libpq-dev \
    libvips-dev \
    libyaml-dev \
    ca-certificates \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app


##
## Dependencies stage (install gems once)
##
FROM base AS deps

ARG RAILS_ENV=production
ENV RAILS_ENV=${RAILS_ENV}

COPY Gemfile Gemfile.lock ./
RUN if [ "$RAILS_ENV" = "production" ]; then \
      bundle config set --local without 'development test' ; \
    else \
      bundle config set --local without '' ; \
    fi \
  && bundle install --jobs 4 --retry 3


##
## Build stage (copy app + optionally precompile assets)
##
FROM deps AS build

ARG RAILS_ENV=production
ENV RAILS_ENV=${RAILS_ENV}

COPY . .
RUN cp config/database.yml.example config/database.yml

# Precompile assets only for production builds
RUN --mount=type=secret,id=RAILS_MASTER_KEY \
    if [ "$RAILS_ENV" = "production" ]; then \
      RAILS_MASTER_KEY=$(cat /run/secrets/RAILS_MASTER_KEY) \
      SECRET_KEY_BASE=placeholder \
      bundle exec rails assets:precompile ; \
    fi


##
## Runtime base (only runtime libs; no build-essential)
##
FROM ruby:3.4.7-slim AS runtime

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    imagemagick \
    libpq5 \
    libvips42 \
    ca-certificates \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /app /app

ENV RAILS_LOG_TO_STDOUT=true \
    RAILS_SERVE_STATIC_FILES=true

EXPOSE 3000


##
## Production target
##
FROM runtime AS production
ENV RAILS_ENV=production
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]


##
## Development target
##
FROM runtime AS development
ENV RAILS_ENV=development
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]
