#<------------------------------------------------------->

# xcodebuild + xcrun
# 使用注意：项目必须设置好证书、描述文件；其次ipa包的生成路径必须是绝对的全路径


pwd

# 脚本配置
# 项目
target_name="VSTECS_demo"
scheme_name="$target_name"
workspace_name="${target_name}.xcworkspace"
project_name="${target_name}.xcodeproj"
configurationType="Release"
targetProject_destination="generic/platform=iOS"
# 证书、描述文件
codesignIdentity_name="iPhone Developer: shaoyu zhang (5CD881EFZQ)"
profile_UUID="a4741133-0eb1-4a82-8df8-dabe11f7c3f4"
profile_name="VSTECS_demo_DevelopmentProfile"
# 文件路径
upload_path="/Users/zhangshaoyu/Desktop/uploadIPA"
target_path="/Users/zhangshaoyu/Desktop/fastlane_demo/VSTECS_demo"
log_path="$upload_path/log.txt"
archive_path="$upload_path/${target_name}.xcarchive"
ipa_path="$upload_path/${target_name}.ipa"

# 1 删除旧文件
rm -rf "$log_path"
rm -rf "$archive_path"
rm -rf "$ipa_path"

# 打开项目目录
cd "$target_path"
pwd

# 2 清理旧项目
xcodebuild clean -configuration "$configurationType" -alltargets >> "$log_path"

# 3 归档（其他参数不指定的话，默认用的是.xcworkspace或.xcodeproj文件里的配置）
xcodebuild archive -workspace "$workspace_name" -scheme "$scheme_name" -destination "$targetProject_destination" -configuration "$configurationType" -archivePath "$archive_path" CODE_SIGN_IDENTITY="$codesignIdentity_name" PROVISIONING_PROFILE="$profile_UUID" >> "$log_path"


# 4 导出IPA xcrun（注意：导出包必须使用绝对的全路径）
# 注意：新版Xcode（如 8.3.3）因没有文件"PackageApplication"会报错，这时候需要手动添加文件"PackageApplication"到新版Xcode的相应目录下
xcrun -sdk iphoneos PackageApplication -v "$archive_path" -o "$ipa_path" >> "$log_path"

#<------------------------------------------------------->
