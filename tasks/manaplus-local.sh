#!/bin/bash

gp await-port 6080
gp preview $(gp url 6080)

manaplus -s 127.0.0.1 -p 6901 -y tmwa \
  -u -d /workspace/tmwa-gitpod/.legacy/tmwa-server-data/client-data
rm -f core.manaplus*
