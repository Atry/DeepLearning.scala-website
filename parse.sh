#!/usr/bin/env bash
ipynb_file=$1
html_file=$2
dest_path=$3
demo_data_path=_data/demo.yml
demo_download_path=demo_download
demo_dir_name=demo

echo "--------------------jupyter convert"
jupyter nbconvert --to html --template basic $ipynb_file
filename=${html_file%.html}

#cp html file which is generated by jupyter to demo dir
mkdir -p ${dest_path}/${demo_dir_name}
{ echo -n "---
layout: demo
title: ${filename}
download_path: ${demo_download_path}
filename: ${ipynb_file}
---"; cat ${html_file}
 } > ${dest_path}/${demo_dir_name}/${html_file}

#cp ipynb file to demo_download dir
mkdir -p ${dest_path}/${demo_download_path}
cp -p ${ipynb_file} ${dest_path}/${demo_download_path}/${ipynb_file}

#make sure the mapping of dir and index is exist
grep -q "text: ${filename}" ${dest_path}/${demo_data_path} ||
{
echo -n "- text: ${filename}
  url: /${demo_dir_name}/${filename}.html
"
} >> ${dest_path}/${demo_data_path}

git --git-dir=${dest_path}/.git/ --work-tree=${dest_path} add ${demo_dir_name}/${html_file}
git --git-dir=${dest_path}/.git/ --work-tree=${dest_path} add ${demo_download_path}/${ipynb_file}
git --git-dir=${dest_path}/.git/ --work-tree=${dest_path} add ${demo_data_path}
