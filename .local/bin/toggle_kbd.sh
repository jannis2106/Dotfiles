#!/bin/bash

case $(setxkbmap -query | grep layout | awk '{ print $2 }') in
    us) setxkbmap de ;;
    de) setxkbmap us ;;
esac
