
#<------------------------------------------------------->
# xcodebuild + xctool
# 使用注意：项目中必须正确设置证书、描述文件；且必须注意xctool命令书写格式。

pwd

# 脚本配置
# 项目
target_name="testDemo"
scheme_name="$target_name"
workspace_name="${target_name}.xcworkspace"
project_name="${target_name}.xcodeproj"
configurationType="Release"
targetProject_destination="generic/platform=iOS"
# 证书、描述文件
codesignIdentity_name="iPhone Developer: shaoyu zhang (5AB779GQZQ)"
profile_UUID="06a7492b-083c-4313-d633-15bc685929a4"
profile_name="testDemoDevelopProfile"
# 目录
log_path="archive/log.txt"
archive_path="archive/${target_name}.xcarchive"
ipa_path="archive/${target_name}.ipa"
# plist_path="archive/ipaTestExportOptions.plist"


echo "<----------操作plist文件---------->"

plist_name="ipaTestExportOptions.plist"
plist_path="$upload_path/$plist_name"
echo "plist_path文件路径:$plist_path"

rm -rf "$plist_path"

# teamID通过查看证书获取（钥匙串-我的证书-选择开发者帐号证书-显示简介-组织单位），或查看描述文件获取（描述文件-显示简介-teamID）
# method: app-store, package, ad-hoc, enterprise, development, developer-id, and mac-application
team_ID="YA3584AU76" 
file_content="<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
<plist version=\"1.0\">
<dict>
<key>teamID</key>
<string>$team_ID</string>
<key>uploadBitcode</key>
<false/> // uploadBitcode: true,false
<key>method</key>
<string>development</string>
<key>compileBitcode</key>
<false/>
</dict>
</plist>"

if [ -e "$plist_path" ]; then
	#statements
	echo "文件存在"
else
	echo "文件不存在"
	cd "$upload_path";
	pwd
	touch "$plist_name"
	if [ -e "$plist_name" ]; then
		#statements
		echo "文件创建成功"
		# 写文件内容
		echo "$file_content" >> "$plist_name"
	fi
fi

echo "<----------操作plist文件---------->"


echo "<----------开始删除旧文件---------->"

# 1 删除旧文件
rm -rf "$log_path"
rm -rf "$archive_path"
rm -rf "$ipa_path"

echo "<----------成功删除旧文件---------->"

echo "<----------开始清除旧项目---------->"

# 重要，执行xcodebuild命令时，必须进入项目目录
# 2 清空前一次build的项目缓存 
xctool clean -workspace "$workspace_name" -scheme "$scheme_name" -configuration "$configurationType" >> "$log_path"

echo "<----------成功清除旧项目---------->"

echo "<----------开始归档archive包---------->"

# 3 归档（其他参数不指定的话，默认用的是.xcworkspace或.xcodeproj文件里的配置）
# 根据指定的项目、scheme、configuration与输出路径打包出archive文件（注意参数配置顺序）
xctool -workspace "$workspace_name" -scheme "$scheme_name"  -destination "$targetProject_destination" archive -archivePath "$archive_path" >> "$log_path"

echo "<----------成功归档archive包---------->"

echo "<----------开始导出ipa包---------->"

# 4 导出IPA 使用指定的provisioning profile导出ipa
# 方法1（未使用plist文件设置ipa包；需要指定包格式）
# xcodebuild -exportArchive -exportFormat IPA -archivePath "$archive_path" -exportPath "$ipa_path" -exportProvisioningProfile "$profile_name" >> "$log_path"
# 方法2（使用plist配置生成ipa；不需要指定包格式，且生成目录不需要设置文件名称，即只需要"./archive/"，而不是"./archive/test.ipa"）
# plist文件配置说明
# 1 提交App Store的plist文件参数设置，如：AppStoreExportOptions.plist：method＝app-store，uploadBitcode＝YES，uploadSymbols＝YES
# 2 内测的plist文件参数设置，如：TestExportOptions.plist：method＝ad-hoc，compileBitcode＝NO
# 3 method的可选值为：app-store, package, ad-hoc, enterprise, development, developer-id
xcodebuild -exportArchive -archivePath "$archive_path" -exportOptionsPlist "$plist_path" -exportPath archive/ >> "$log_path"

echo "<----------成功导出ipa包---------->"

# 输出总用时
echo "<----------Finished. Total time: ${SECONDS}s---------->"

#<------------------------------------------------------->
