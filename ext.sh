#!/bin/bash

CACHE_FOLDER=./cache
rm -rf $CACHE_FOLDER
mkdir -p $CACHE_FOLDER
ARG1=$1
unzip_zip() {
  name=$(basename $1)
  unzip $1 -d $CACHE_FOLDER/$name
}

detect_ext() {
for mime in $(cat extension.txt | awk '{print $2}');do
  check="$(grep -Ril "$mime" $1)"
  if [[ ! -z $check ]];then
    ext=$(grep "$mime" extension.txt | awk '{print $1}')
    echo $ext | awk '{print $1}'
    break
  fi
done
}

xext() {
  name=$(basename $1)
  found=$(find $CACHE_FOLDER/$name -iname "\[Content_Types\].xml")
  echo $found
  if [[ ! -z $found ]];then
    ext="$(detect_ext $found)"
  fi
  dir_path=$(dirname $1)
  mkdir -p out1
  mkdir -p out1/unknown
  mkdir -p out1/${ext#.}
  OUT_FILE="out1/${ext#.}/$(basename $1 .zip)${ext}"
  if [[ -z $found ]];then
    cp $1 out1/unknown
  else
    cp $1 $OUT_FILE
  fi
  rm -rf $CACHE_FOLDER/$name
}

for i in  $(ls $ARG1);do
  echo $1/$i
  unzip_zip $1/$i
  xext $1/$i
done
