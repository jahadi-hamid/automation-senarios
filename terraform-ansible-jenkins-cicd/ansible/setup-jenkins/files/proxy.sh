#!/bin/bash

tmux new-session -d -s proxy -n PortForwarder

tmux send-keys "while true; do ssh -N  -p 4202 hamidj@185.202.113.174 -L 3128:localhost:3128; done" C-m

tmux send-keys "echo reserved" C-m
