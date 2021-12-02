#!/bin/sh

# usage:
# ./setup.sh [year] [day]
# ./setup.sh 2015 1

YEAR=${1}
DAY=${2}

echo "${YEAR}: getting inputs for day ${1}..."

if [ ! -f ./${YEAR}/inputs/day${DAY} ]; then
  curl --cookie session=$(cat .secrets) -o ./${YEAR}/inputs/day${DAY} https://adventofcode.com/${YEAR}/day/${DAY}/input
else
  echo "already downloaded!"
fi
