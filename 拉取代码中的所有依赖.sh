#! /bin/bash

#输入的目录
dirPath="$1"
#输入的最后一级目录
dirName=`basename $dirPath`
mkdir $2"/result"
#存储文件夹
saveDir=$2"/result" 
#进入上级目录
cd $dirPath
cd ..


checkImport(){
    local name=$1
    local path=$2

    local tempFile=$path"/temp"
    local saveFile=$path"/"$name
     
    touch $tempFile
    touch $saveFile

    cd $name
    local filelist=`ls`
    for file in $filelist
    do 
        local isFile=`echo $file | grep -e "\.java" -e "\.kt" -e "\.aidl"`
        
        #检查是否有.java .kt .aidl
        if [[ "$isFile" != "" ]]
        then
            echo "file "$file
            awk '/import com\.paic\.zhifu\.wallet/' $file  >> $tempFile 2>&1
        else
            echo "dir "$file
            local sonSaveDir=$path"/"$file
            mkdir $sonSaveDir
            checkImport $file $sonSaveDir
        fi
    done
    sort -k2n  $tempFile| uniq > $saveFile
    rm -rf $tempFile
    cd ..
}
checkImport $dirName $saveDir





