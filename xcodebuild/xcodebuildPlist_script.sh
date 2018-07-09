
#<------------------------------------------------------->

# xcodebuild

# pwd

# 脚本配置
# 项目
target_name="SXMapsEducation"
scheme_name="$target_name"
workspace_name="${target_name}.xcworkspace"
project_name="${target_name}.xcodeproj"
configurationType="Release"
# 证书、描述文件
# 开发
# codesign_name="iPhone Developer: 学 升 (XLP2M8HM7Z)"
# profile_UUID="604c3f11-7199-4051-9cf7-e5bbfc1705c4"
# profile_name="newSxmapsEducationZSYInit"
# 发布
codesign_name="iPhone Distribution: Sxmaps Co,Ltd. (56P78W32BT)"
profile_UUID="10344d85-efac-4561-be01-cf6c9a8b2370"
profile_name="newSxmapsEducationDist"
# 目录
upload_path="/Users/zhangshaoyu/Desktop/build"
target_path="${upload_path}/${target_name}"
log_path="${upload_path}/uploadIPA/log.txt"
archive_path="${upload_path}/uploadIPA/${target_name}.xcarchive"
# ipa_path="${upload_path}/uploadIPA/${target_name}.ipa" # 未使用plist文件打包时
ipa_path="${upload_path}/uploadIPA/ipa/" # 使用plist文件打包时
plist_path="${upload_path}/xcodebuildPlist_script.plist"

cd "$target_path"
pwd

# 1 删除旧文件
rm -rf "$log_path"
rm -rf "$archive_path"
rm -rf "$ipa_path"

# 2 清除旧项目
xcodebuild clean \
-workspace "$workspace_name" \
-scheme "$scheme_name" \
-configuration "$configurationType" -quiet >> "$log_path"

# 3 归档（其他参数不指定的话，默认用的是.xcworkspace或.xcodeproj文件里的配置）
# -workspace/-project
xcodebuild archive \
-workspace "$workspace_name" \
-scheme "$scheme_name" \
-archivePath "$archive_path" -quiet >> "$log_path"


# 4 导出IPA xcodebuild
# 方法（使用plist配置生成ipa；不需要指定包格式，且生成目录不需要设置文件名称，即只需要"./archive/"，而不是"./archive/test.ipa"）
# plist文件配置说明
# 1 提交App Store的plist文件参数设置，如：method＝app-store，uploadBitcode＝YES，uploadSymbols＝YES
# 2 内测的plist文件参数设置，如：method＝ad-hoc，compileBitcode＝NO
# 3 method的可选值为：app-store, package, ad-hoc, enterprise, development, developer-id
xcodebuild -exportArchive \
-archivePath "$archive_path" \
-exportPath "$ipa_path" \
-exportOptionsPlist "$plist_path" -quiet >> "$log_path"

#<------------------------------------------------------->

