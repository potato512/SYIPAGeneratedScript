
#<------------------------------------------------------->

# 张绍裕的脚本（区分是否从SVN更新源码）
# 实现步骤：删除旧源码目录->新建源码目录->从svn导出最新代码->清理旧文件->清除旧项目->打包->上传

pwd

# 名称配置
checkout_name="checkout"
project_name="zhangshaoyuDemo"
# 配置项目版本
# targetProject_sdk="iphoneos8.0"
targetProject_destination="generic/platform=iOS"
configuration="Release"
scheme="$project_name"
workspace_name="${project_name}.xcworkspace"
# 目录配置
save_path="/Users/zhangshaoyu/Desktop/uploadIPA"
archive_path="$save_path/${project_name}.xcarchive"
ipa_path="$save_path/${project_name}.ipa"
log_path="$save_path/log.txt"
# svn配置
svn_path="http://192.168.3.3:8000/svn/zhangshaoyuDemo/trunk/iOS/zhangshaoyuDemo"
checkout_path="$save_path/$checkout_name"
svn_name="zhangshaoyu"
svn_password="123456"
# 配置签名证书、描述文件
codeSignIdentity="iPhone Developer: shaoyu zhang (5BE779GQZQ)"
provision_UUID="06b7492c-083f-4313-b633-15bc685929a4"
provisoning_profile="zhangshaoyuDemoDevelopProfile"
# 配置蒲公英
upload_path="$save_path/${project_name}.ipa"
pgy_userKey="a512b58c56285d23456e011fgh706509"
pgy_apiKey="ab9c240d2efg9hi17j9642k3l5mnop5q"



echo "正在删除旧源码"
# 删除旧源码目录
rm -rf "$checkout_path" >> $log_path

echo "正在创建新的源码目录"
# 新建源码目录
cd "$save_path" >> $log_path
pwd
mkdir "$checkout_name" >> $log_path

echo "正在从svn下载最新的源码"
# 从svn导出最新代码
svn checkout "$svn_path" "$checkout_path" --username "$svn_name" --password "$svn_password" >> $log_path

echo "正在删除旧文件"
# 删除旧文件
rm -rf "$log_path" >> $log_path
rm -rf "$archive_path" >> $log_path
rm -rf "$ipa_path" >> $log_path

echo "正在清除构建项目缓存"
# 重要，执行xcodebuild命令时，必须进入项目目录
cd "$checkout_path" >> $log_path
pwd
# 清理构建目录
xcodebuild clean -configuration "$configuration" -alltargets >> $log_path

echo "正在打包"
# 归档（其他参数不指定的话，默认用的是.xcworkspace或.xcodeproj文件里的配置）
xcodebuild archive -workspace "$workspace_name" -scheme "$scheme" -destination "$targetProject_destination" -configuration "$configuration" -archivePath "$archive_path" CODE_SIGN_IDENTITY="$codeSignIdentity" PROVISIONING_PROFILE="$provision_UUID" >> $log_path

echo "正在导出ipa包"
# 导出IPA
xcodebuild -exportArchive -exportFormat IPA -archivePath "$archive_path" -exportPath "$ipa_path" -exportProvisioningProfile "$provisoning_profile" >> $log_path

echo "正在上传ipa到蒲公英"
# 上传IPA到蒲公英
curl -F "file=@$upload_path" -F "uKey=$pgy_userKey" -F "_api_key=$pgy_apiKey" https://www.pgyer.com/apiv1/app/upload

#<------------------------------------------------------->



