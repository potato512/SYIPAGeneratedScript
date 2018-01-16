# AutoBuild-ipa
自动打包（需在项目中配置好描述文件、开发者证书）

使用方式:

先配置DevelopmentExportOptionsPlist文件中的信息(解包方法，标识符及对应的描述文件名称)

将xcodebuild.sh中appName置换为项目工程名

将文件放置于项目文件中和*.xcodeproj平级

在终端中进入*.xcodeproj上级目录

输入`./xcodebuild.sh`即可自动打包、如无执行权限则先执行`chmod +x xcodebuild.sh`
