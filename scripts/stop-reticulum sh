#!/bin/bash

echo "STARTING RETICULUM SERVER"
export PATH=$PATH:/home/lonycell/.asdf/shims
echo $PATH

cd /home/lonycell/metabooth/reticulum
git pull
(lsof -ti:4000) && kill -9 $(lsof -ti:4000)
sleep 1
(lsof -ti:4000) && echo "Server stoped"