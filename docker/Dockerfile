FROM hexpm/elixir:1.16.3-erlang-26.2.5-alpine-3.20.0

RUN apk add --no-cache inotify-tools

# Set user permissions
ARG user_id=1000
ENV user_id $user_id

# Create required dirs
RUN mkdir -p /app /home/app_user
RUN chown $user_id /app /home/app_user
USER $user_id
ENV HOME /home/app_user

# Install hex and rebar
RUN mix local.hex --force
RUN mix local.rebar --force

# Set /app as workdir
WORKDIR /app