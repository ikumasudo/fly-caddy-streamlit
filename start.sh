#!/bin/bash
set -e

caddy start --config /etc/caddy/Caddyfile --adapter caddyfile
streamlit run main.py --server.port 8501 --server.address 0.0.0.0