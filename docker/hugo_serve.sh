#!/bin/sh
# hugo serve -D --bind="0.0.0.0"

exec hugo -D --watch=true --bind="0.0.0.0" serve
