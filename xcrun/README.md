# SYIPAGeneratedScript
make a ipa by script——使用脚本生成ipa包

# 脚本功能说明
# 在终端，使用**xcodebuild + xcrun**脚本进行自动生成ipa，及脚本自动上传蒲公英平台

# 脚本执行方法：终端-sh 脚本文件-回车。

脚本运行时，错误
```
unable to find utility "PackageApplication", not a developer tool or in PATH
```

![PackageApplication异常报错](./xcrun/PackageApplication异常报错.png)

错误修正
错误产生原因，是因为新版本的Xcode已经没有**PackageApplication**，需要从老版本里复制一份到新版本的相应目录下。
目录，注意Applications可以是程序安装后的目录，也可以是未安装时的其他目录。
```
/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/
```
执行相应的脚本
```
sudo xcode-select -switch /Applications/Xcode.app/Contents/Developer/

chmod +x /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/PackageApplication
```

![PackageApplication异常修正](./xcrun/PackageApplication异常修正.png)





