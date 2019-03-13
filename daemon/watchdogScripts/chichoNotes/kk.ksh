#!/bin/ksh

script_dir=$(cd "$(dirname "${0}")"; pwd)
echo "SCRIPT DIR: $script_dir"
echo "CURRENT DIR: $(pwd)"
echo "SUBSHELL: $(echo 1; echo 2; echo 3)"

. "${script_dir}/env.ksh" primero "${@}"
echo "var = $var"

lala 'armando'
