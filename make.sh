#!/bin/sh

input="md"
output="docs"

if [ ! -d "${input}" ]; then
	echo "input error, ${input}"
	exit 1
fi

for file in `cd ${input}; find . -name "*.md" -type f`; do
  base=`basename ${file}`
  path=`dirname ${file}`
  echo ${base}
  name=${base%.md}.html
  write="${output}/${path}/${name}"
  pandoc -s -f markdown -t html -o ${write} ${input}/${file}
  if [ $? -ne 0 ]; then
    echo "pandoc error"
    exit 1
  fi
done

exit 0

