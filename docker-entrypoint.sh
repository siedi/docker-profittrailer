#!/bin/sh

template="application.template"

#env | sed -r "s/'/\\\'/g" | sed -r "s/^([^=]+=)(.*)\$/\1'\2'/g" > /etc/environment
env > /etc/environment

while IFS='=' read -r key val; do
  if grep -q "\${"${key}"}" $template; then
    sed -i 's/\${'"$key"'}/'"$val"'/g' $template
  fi
done < /etc/environment

sed -i 's/\${\([^}]*\)}//g' $template

cp $template application.properties

touch ProfitTrailerData.json

exec "$@"
