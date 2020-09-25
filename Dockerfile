ARG CONTAINER_CURRENT_IMAGE
FROM ${CONTAINER_CURRENT_IMAGE}-frontend-builder AS frontend-builder

FROM elixir:1.10-alpine

RUN apk add --no-cache git make g++
RUN mix do local.hex --force, local.rebar --force

ENV MIX_ENV=prod

WORKDIR /opt/app

COPY mix.exs mix.lock ./
RUN mix do deps.get --only $MIX_ENV, deps.compile

COPY config ./config
COPY lib ./lib
COPY priv ./priv

COPY --from=frontend-builder /app/build/ ./priv/static/

RUN mix phx.digest
RUN mix release
