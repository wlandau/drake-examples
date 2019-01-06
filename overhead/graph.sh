#!/bin/bash
mkdir -p pdf
for file in $(ls *.proto)
do
  pprof --output pdf/$(basename "$file" .html).pdf -pdf $file
done
