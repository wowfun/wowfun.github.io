#! /bin/bash
# Author: Sinputer

# Create a new named .md post and init it. Like YYYY-MM-DD-POSTNAME
# $1: post name without date. Default post date is the exec date of this script.
# eg. ./tools/create_init_new_post.sh "Hello World"
# [$2]: optional, custom this post's date
# eg. ./tools/create_init_new_post.sh "Hello World" "1970-01-01"

function main(){
  cd `dirname $0`
  # Upper case to lower case and replace spaces with '-'
  post_name=`echo "$1" |sed 's/[A-Z]/\l&/g' |sed s'/ /-/g'`
  date_name="$2"
  if [[ -z "$date_name" ]];then
    date_name=`date "+%Y-%m-%d"`
  fi
  if [[ ! -e "../_drafts/" ]];then
    mkdir "../_drafts/"
  fi
  post_file_path="../_drafts/"$date_name"-"$post_name".md"

  fm_layout="post"
  fm_title="$1"
  fm_date="$date_name"
  fm_author="Sinputer"

  echo "---" > $post_file_path
  echo "layout: "$fm_layout"" >> $post_file_path
  echo "title: \"$fm_title\"" >> $post_file_path
  echo "subtitle: \"\"" >> $post_file_path
  echo "date: "$fm_date"" >> $post_file_path
  echo "author: \"$fm_author\"" >> $post_file_path
  echo "catalog: true" >> $post_file_path
  echo "tags: " >> $post_file_path
  echo "    - " >> $post_file_path
  echo "---" >> $post_file_path
}

main "$1" "$2"