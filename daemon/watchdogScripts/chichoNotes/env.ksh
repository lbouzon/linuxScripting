#!/bin/ksh

var='hola mundo'
function lala {
    person="${1}"
    echo "chau $person"
}

echo "mira que me estoy ejecutando: ${*}"

