#!/bin/csh -f
echo  "Files creator - Tareas-001"

touch $(seq -f "arch-%3g" 1 100)"
