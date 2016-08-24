# 脚本功能说明
# 在终端，使用xcodebuild脚本进行自动打包，及脚本自动上传蒲公英平台
#
# 
# 使用步骤（注意：xcodebuild命令执行打包时，必须在项目目录下进行）：
# 1 目录配置（打包上传目录、项目目录）
# 2 项目配置（版本、名称、证书、描述文件UUID、描述文件、archive保存目录、ipa保存目录）
# 3 删除旧文件
# 4 清除旧项目
# 5 生成archive
# 6 生成ipa
# 7 上传ipa到蒲公英
#
# 
# 使用注意事项（根据实际情况修改参数）
# 1 修改路径：upload_path路径；target_path路径；蒲公英上传文件路径。
# 2 项目配置：tagert_name项目名称；codecodeSignIdentity证书；provision_UUID描述文件UUID；provisoning_profile描述文件名称。
# 3 蒲公英上传：user_key；api_key。
#
#
# 技巧
# 获取证书名称：Launchpad->其他->钥匙串访问->选择证书->鼠标右击->显示简介->细节->常用名称->复制
# 获取描述文件UUID：打开Xcode->菜单栏->Preferences->Accounts->Apple IDs->帐号->show Details->Provisioning Profiles->选择项目中使用的描述文件->鼠标右击->show in Finder
# 获取target/schemes：终端->cd 项目目录->进入项目目录后，执行命令"xcodebuild -list"
#
#
# plist配置文件说明（四个参数：method、teamID、uploadSymbols、uploadBitcode）
# 测试用时，仅使用method-development/ad-hoc、uploadBitcode-NO
# 
# plist文件配置说明
# 1 提交App Store的plist文件参数设置，如：AppStoreExportOptions.plist：method＝app-store，uploadBitcode＝YES，uploadSymbols＝YES
# 2 内测的plist文件参数设置，如：TestExportOptions.plist：method＝ad-hoc，compileBitcode＝NO
# 3 method的可选值为：app-store, package, ad-hoc, enterprise, development, developer-id
# 
# The Export Options Plist
# method: (String) The method of distribution, which can be set as any of the following:
# app-store
# enterprise
# ad-hoc
# development
# teamID: (String) The development program team identifier.
# uploadSymbols: (Boolean) Option to include symbols in the generated ipa file.
# uploadBitcode: (Boolean) Option to include Bitcode.
# 
#
# xcodebuild：https://developer.apple.com/legacy/library/documentation/Darwin/Reference/ManPages/man1/xcodebuild.1.html
# xcrun：
# xctool：https://github.com/facebook/xctool
# 蒲公英：https://www.pgyer.com
# 
# 
# 脚本执行方法：终端-sh 脚本文件-回车
#
# 

#<----------------------------------------------------------------->

#脚本配置项目（根据实际情况修改）
# 配置路径
saveAndUpload_path="/Users/zhangshaoyu/Desktop/uploadIPA"
targetProject_path="/Users/zhangshaoyu/Desktop/zhangshaoyuDemo/zhangshaoyuDemo/20160729/iOS/zhangshaoyuDemo"
# 配置项目名称
targetProject_name="zhangshaoyuDemo"
# 配置项目版本
# targetProject_sdk="iphoneos8.0"
targetProject_destination="generic/platform=iOS"
# 配置签名证书、描述文件
targetProject_codesign="iPhone Developer: shaoyu zhang (5BE779GQZQ)"
targetProject_profileUUID="06a7492b-083c-4313-d633-15ef685929g4"
targetProject_profile="zhangshaoyuDemoDevelopProfile"
# 配置plist文件
targetProject_list="ipaTestExportOptions"
# 配置蒲公英
pgy_userKey="5ab7550c93596d480459218ef0gbba9f"
pgy_apiKey="ab6cd6b2998f55d827a9dd3fc25779cf"

#<----------------------------------------------------------------->

# 1 目录（打包上传目录；项目目录）
upload_path="$saveAndUpload_path"
target_path="$targetProject_path"

echo "upload_path打包路径:$upload_path"
echo "target_path项目路径:$target_path"

# 2 配置信息 
# 配置打包版本类型Release版本
configuration="Release"

echo "configuration配置:$configuration"

# 项目名称
# target_name="VSTSUPPORT"
target_name="$targetProject_name"
project_name="${project_name}.xcodeproj"
workspace_name="${target_name}.xcworkspace"
scheme="$target_name"

echo "target_name项目名称:$target_name"
echo "project_name项目名称:$project_name"
echo "workspace_name工作空间名称:$workspace_name"
echo "scheme名称:$scheme"

# archive包时使用证书、描述文件UUID；ipa包时使用描述文件（描述文件名称）
codeSignIdentity="$targetProject_codesign"
provision_UUID="$targetProject_profileUUID"
provisoning_profile="$targetProject_profile"

echo "codeSignIdentity开发证书:$codeSignIdentity"
echo "provision_UUID描述文件UUID:$provision_UUID"
echo "provisoning_profile描述文件:$provisoning_profile"

# 存储目录
cd "$upload_path"
ipa_path="$upload_path/${target_name}.ipa"
archive_path="$upload_path/${target_name}.xcarchive"
log_path="$upload_path/log.txt"
optionsPlist_path="$upload_path/${targetProject_list}.plist"

pwd
echo "ipa_path导出路径:$ipa_path"
echo "archive_path生成路径:$archive_path"
echo "log_path打印路径:$log_path"
echo "optionsPlist_pathlist文件路径:$optionsPlist_path"

echo "<----------开始删除旧文件---------->"

# 3 删除旧文件
rm -rf "$log_path"
rm -rf "$archive_path"
rm -rf "$ipa_path"

echo "<----------成功删除旧文件---------->"


echo "<----------开始清除旧项目---------->"

# 重要，执行xcodebuild命令时，必须进入项目目录
cd "$target_path"
pwd
# 4 清理构建目录
xcodebuild clean -configuration "$configuration" -alltargets >> $log_path

echo "<----------成功清除旧项目---------->"

echo "<----------开始归档archive包---------->"

# 5 归档（其他参数不指定的话，默认用的是.xcworkspace或.xcodeproj文件里的配置）
# 情况一：project
# xcodebuild archive -project "$project_name" -scheme "$scheme" -destination "$targetProject_destination" -configuration "$configuration" -archivePath "$archive_path" CODE_SIGN_IDENTITY="$codeSignIdentity" PROVISIONING_PROFILE="$provision_UUID" >> $log_path
# 情况二：workspace
xcodebuild archive -workspace "$workspace_name" -scheme "$scheme" -destination "$targetProject_destination" -configuration "$configuration" -archivePath "$archive_path" CODE_SIGN_IDENTITY="$codeSignIdentity" PROVISIONING_PROFILE="$provision_UUID" >> $log_path

echo "<----------成功归档archive包---------->"

echo "<----------开始导出ipa包---------->"

# 6 导出IPA
# # 6-1 xcodebuild
# # 方法1（未使用plist配置文件）
# xcodebuild -exportArchive -exportFormat IPA -archivePath "$archive_path" -exportPath "$ipa_path" -exportProvisioningProfile "$provisoning_profile" >> $log_path
# # 方法2（使用plist配置生成ipa；不需要指定包格式，且生成目录不需要设置文件名称，即只需要"./archive/"，而不是"./archive/test.ipa"）
# # plist文件配置说明
# # 1 提交App Store的plist文件参数设置，如：AppStoreExportOptions.plist：method＝app-store，uploadBitcode＝YES，uploadSymbols＝YES
# # 2 内测的plist文件参数设置，如：TestExportOptions.plist：method＝ad-hoc，compileBitcode＝NO
# # 3 method的可选值为：app-store, package, ad-hoc, enterprise, development, developer-id
# xcodebuild -exportArchive -archivePath "$archive_path" -exportOptionsPlist "$optionsPlist_path" -exportPath "$upload_path" >> $log_path
# 6-2 xcrun（注意：导出包必须使用绝对的全路径）
xcrun -sdk iphoneos -v PackageApplication "$archive_path" -o "$ipa_path"

echo "<----------成功导出ipa包---------->"

echo "<----------开始上传ipa到蒲公英---------->"

# 7 上传IPA到蒲公英
# 方法1
# curl -F "file=@/Users/zhangshaoyu/Desktop/uploadIPA/VSTSUPPORT.ipa" \
# -F "uKey=d512b58e56285c23456b011bfc706509" \
# -F "_api_key=bd9e240a2cfb9cf17d9642f3b5ccca5a" \
# https://www.pgyer.com/apiv1/app/upload
# 方法2
curl -F "file=@$upload_path/${target_name}.ipa" -F "uKey=$pgy_userKey" -F "_api_key=$pgy_apiKey" https://www.pgyer.com/apiv1/app/upload

echo "<----------成功上传ipa到蒲公英---------->"

