#! /bin/bash
project_dir_path=$1 #传入工程目录

wallet_dir_path=$project_dir_path"/src/com/paic/zhifu/wallet/activity"
this_script_dir_path=$(cd $(dirname $0); pwd)
source $this_script_dir_path"/拉取代码中的所有依赖.sh" $wallet_dir_path $this_script_dir_path
source $this_script_dir_path"/依赖换被依赖.sh" $this_script_dir_path"/result"

cd $this_script_dir_path
java Translate $this_script_dir_path

source $this_script_dir_path"/去重复.sh" $this_script_dir_path"/revert"