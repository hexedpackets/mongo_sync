FROM hexedpackets/elixir
MAINTAINER William Huba <hexedpackets@gmail.com>

ENV MIX_ENV prod

ADD . /opt/mongo_sync/
WORKDIR /opt/mongo_sync
RUN mix do deps.get, deps.compile, compile

CMD mix run --no-halt
