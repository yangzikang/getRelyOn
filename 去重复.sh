#! /bin/bash
dir_path=$1 #传入revert
cd $dir_path
cd ..
mkdir 被哪些依赖
save_dir=`pwd`"/被哪些依赖"
cd $dir_path
files=`ls`
for file in $files
do
    echo $file
    sort -k2n  $file| uniq > $save_dir"/"$file
done
rm -rf $dir_path

