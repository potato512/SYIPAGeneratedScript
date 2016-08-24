
#<------------------------------------------------------->

# xcodebuild + xcrun
# 使用注意：项目必须设置好证书、描述文件；其次ipa包的生成路径必须是绝对的全路径


pwd

# 脚本配置
# 项目
target_name="VSTSUPPORT"
scheme_name="$target_name"
workspace_name="${target_name}.xcworkspace"
project_name="${target_name}.xcodeproj"
configurationType="Release"
targetProject_destination="generic/platform=iOS"
# 证书、描述文件
codesignIdentity_name="iPhone Developer: junjie cai (5BE779GQZQ)"
profile_UUID="06b7492c-083f-4313-b633-15bc685929a4"
profile_name="vstsupportDevelopProfile"
# 目录
log_path="archive/log.txt"
archive_path="archive/${target_name}.xcarchive"
ipa_path="archive/${target_name}.ipa"

# 1 删除旧文件
rm -rf "$log_path"
rm -rf "$archive_path"
rm -rf "$ipa_path"

# 2 清理旧项目
xcodebuild clean -configuration "$configurationType" -alltargets >> "$log_path"

# 3 归档（其他参数不指定的话，默认用的是.xcworkspace或.xcodeproj文件里的配置）
xcodebuild archive -workspace "$workspace_name" -scheme "$scheme_name" -destination "$targetProject_destination" -configuration "$configurationType" -archivePath "$archive_path" CODE_SIGN_IDENTITY="$codesignIdentity_name" PROVISIONING_PROFILE="$profile_UUID" >> "$log_path"


# 4 导出IPA xcrun（注意：导出包必须使用绝对的全路径）
pwd
ipa_path="`pwd`/archive/${target_name}.ipa"
xcrun -sdk iphoneos PackageApplication -v archive/VSTSUPPORT.xcarchive -o "$ipa_path" >> "$log_path"

#<------------------------------------------------------->
