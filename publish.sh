#!/bin/sh

git push origin HEAD
ssh gerkules@87.230.14.248 'cd /var/www/blog; git pull;'
