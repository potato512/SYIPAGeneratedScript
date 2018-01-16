#工程名
project_name=appName

#打包模式 Debug/Release
development_mode=appName

#scheme名
scheme_name=appName

#plist文件所在路径
exportOptionsPlistPath=./DevelopmentExportOptionsPlist.plist

#导出.ipa文件所在路径
exportFilePath=~/Desktop/$project_name-ipa

echo '*** 正在 清理工程 ***'
xcodebuild \
clean -configuration ${development_mode} -quiet  || exit 
echo '*** 清理完成 ***'


echo '*** 正在 编译工程 For '${development_mode}
xcodebuild \
archive -workspace ${project_name}.xcworkspace \
-scheme ${scheme_name} \
-configuration ${development_mode} \
-archivePath build/${project_name}.xcarchive -quiet  || exit
echo '*** 编译完成 ***'


echo '*** 正在 打包 ***'
xcodebuild -exportArchive -archivePath build/${project_name}.xcarchive \
-configuration ${development_mode} \
-exportPath ${exportFilePath} \
-exportOptionsPlist ${exportOptionsPlistPath} \
-quiet || exit

# 删除build包
if [[ -d build ]]; then
    rm -rf build -r
fi

if [ -e $exportFilePath/$scheme_name.ipa ]; then
    echo "*** .ipa文件已导出 ***"
    cd ${exportFilePath}
    echo "*** 开始上传.ipa文件 ***"
    #此处上传分发应用
    echo "*** .ipa文件上传成功 ***"
else
    echo "*** 创建.ipa文件失败 ***"
fi
echo '*** 打包完成 ***'

