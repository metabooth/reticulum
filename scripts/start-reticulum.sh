#!/bin/bash

echo "STARTING RETICULUM SERVER"
export PATH=$PATH:/home/lonycell/.asdf/shims
echo $PATH

cd /home/lonycell/metabooth/reticulum
git pull
(lsof -ti:4000) && kill -9 $(lsof -ti:4000)
MIX_ENV=prod mix release --overwrite
PORT=4000 MIX_ENV=prod elixir --erl "-detached" -S mix phx.server
sudo systemctl start hubs-postgrest

sleep 3

(lsof -ti:4000) && echo "Server started"