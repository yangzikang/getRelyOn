#! /bin/bash

#结果路径
resultPath="$1"
dirName=`basename $resultPath`
cd $resultPath
cd ..

mkdir revert
pwdPath=`pwd`
savePath=$pwdPath"/revert" #全局

dependRevert(){
    local dirName=$1
    cd $dirName

    local list=`ls`
    for file in $list
    do
      if [ -d $file ]
      then 
        echo "dir "$file
        dependRevert $file
      else
        echo "file "$file
        fileRevert $file
      fi
    done
    cd ..
}

#去掉/符号 xxxx/result/event/event -> /event/event -> com.paic.wallet.activity.event
removePathLabel() {
    local path=$1
    local inResultPath=${path#*"result"}
    local arr=(${inResultPath//// })
    if [ ${arr[0]} == "modules" ] 
    then
        echo "com.paic.zhifu.wallet.activity.modules."${arr[1]}
    elif  [ ${arr[0]} == "outerapp" ]
    then 
        echo "com.paic.zhifu.wallet.activity.outerapp."${arr[1]}
    else
        echo "com.paic.zhifu.wallet.activity."${arr[0]}
    fi
}

#文件存入
fileRevert(){
    local filePath=$1
    for  line  in  `cat $filePath`
    do
        local arr=(${line//./ })
        if [ ${#arr[@]} -gt 4 ]
        then
            if [ ${arr[5]} == "modules" ]
            then
                local finalSavePath=$savePath"/com.paic.zhifu.wallet.activity.modules."${arr[6]}
                touch $finalSavePath
                removePathLabel `pwd`"/"$filePath >> $finalSavePath 2>&1  #现在保存的是带activity下的相对路径 例如/event/event
            elif [ ${arr[5]} == "outerapp" ]
            then 
                local finalSavePath=$savePath"/com.paic.zhifu.wallet.activity.outerapp."${arr[6]}
                touch $finalSavePath
                removePathLabel `pwd`"/"$filePath >> $finalSavePath 2>&1
            else
                local finalSavePath=$savePath"/com.paic.zhifu.wallet.activity."${arr[5]}
                touch $finalSavePath
                removePathLabel `pwd`"/"$filePath >> $finalSavePath 2>&1
            fi    
        fi
    done
}

dependRevert $dirName

rm -rf $pwdPath"/result"
