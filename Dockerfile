# syntax=docker/dockerfile:1

##
## Common base with OS deps needed to build native gems and run the app
##
FROM ruby:2.7.4-slim AS base

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    git \
    libpq-dev \
    libvips-dev \
    nodejs \
    npm \
    ca-certificates \
  && npm install -g yarn \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app


##
## Dependencies stage (install gems + node modules once)
## RAILS_ENV can be overridden at build time to include dev/test gems.
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

COPY package.json package-lock.json ./
RUN npm install


##
## Build stage (copy app + optionally precompile assets)
##
FROM deps AS build

ARG RAILS_ENV=production
ENV RAILS_ENV=${RAILS_ENV}

COPY . .

# Precompile assets only for production builds
RUN if [ "$RAILS_ENV" = "production" ]; then \
      SECRET_KEY_BASE=placeholder bundle exec rails assets:precompile ; \
    fi


##
## Runtime base (only runtime libs; no build-essential)
##
FROM ruby:2.7.4-slim AS runtime

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    libpq5 \
    libvips42 \
    nodejs \
    npm \
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
