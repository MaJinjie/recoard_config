#!/bin/env zsh

function error() { print -P "%F{160}[ERROR] ---%f%b $1" >&2 && exit 1; }

function info() { print -P "%F{34}[INFO] ---%f%b $1"; }
