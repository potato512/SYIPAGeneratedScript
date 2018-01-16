
#<------------------------------------------------------->

# xcodebuild

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
codesignIdentity_name="iPhone Developer: shaoyu zhang (5AB779CDEF)"
profile_UUID="06a7492b-083c-4313-d633-15ef685929g4"
profile_name="testDemoDevelopProfile"
# 目录
log_path="archive/log.txt"
archive_path="archive/${target_name}.xcarchive"
ipa_path="archive/${target_name}.ipa"
plist_path="archive/ipaTestExportOptions.plist"

# 1 删除旧文件
rm -rf "$log_path"
rm -rf "$archive_path"
rm -rf "$ipa_path"

# 2 清除旧项目
xcodebuild clean -configuration "$configurationType" -alltargets  >> "$log_path"

# 3 归档（其他参数不指定的话，默认用的是.xcworkspace或.xcodeproj文件里的配置）
# workspace
xcodebuild archive -workspace "$workspace_name" -scheme "$scheme_name" -destination "$targetProject_destination" -configuration "configurationType" -archivePath "$archive_path" CODE_SIGN_IDENTITY="$codesignIdentity_name" PROVISIONING_PROFILE="$profile_UUID" >> "$log_path"
# project
# xcodebuild archive -project "$project_name" -scheme "$scheme_name" -configuration "$configurationType" -archivePath "$archive_path" CODE_SIGN_IDENTITY="$codesignIdentity_name" PROVISIONING_PROFILE="$profile_UUID" >> "$log_path"

# 4 导出IPA xcodebuild
# 方法1（未使用plist文件设置ipa包；需要指定包格式）
# xcodebuild -exportArchive -exportFormat IPA -archivePath "$archive_path" -exportPath "$ipa_path" -exportProvisioningProfile "$profile_name" >> "$log_path"
# 方法2（使用plist配置生成ipa；不需要指定包格式，且生成目录不需要设置文件名称，即只需要"./archive/"，而不是"./archive/test.ipa"）
# plist文件配置说明
# 1 提交App Store的plist文件参数设置，如：AppStoreExportOptions.plist：method＝app-store，uploadBitcode＝YES，uploadSymbols＝YES
# 2 内测的plist文件参数设置，如：TestExportOptions.plist：method＝ad-hoc，compileBitcode＝NO
# 3 method的可选值为：app-store, package, ad-hoc, enterprise, development, developer-id
xcodebuild -exportArchive -archivePath "$archive_path" -exportOptionsPlist "$plist_path" -exportPath archive/ >> "$log_path"


#<------------------------------------------------------->
