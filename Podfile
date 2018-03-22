source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '8.0'
inhibit_all_warnings!

#指定Workspace
workspace 'SocketIMDemo'

#基础组件
target 'Common' do
    xcodeproj 'Common/Common.xcodeproj'
    pod 'Realm', '~> 2.8.1'  #realm数据库
    pod 'MJExtension'
end

#请求组件
target 'HttpServer' do
    xcodeproj 'HttpServer/HttpServer.xcodeproj'
    
end

#聊天组件
target 'IMServer' do
   xcodeproj 'IMServer/IMServer.xcodeproj'
   pod 'Realm', '~> 2.8.1'  #realm数据库
   pod 'MJExtension'
   pod 'CocoaAsyncSocket', '~> 7.6.2'
end

#数据库模型组件
target 'ModelManager' do
    xcodeproj 'ModelManager/ModelManager.xcodeproj'
    pod 'MJExtension'
    pod 'Realm', '~> 2.8.1'  #realm数据库
    pod 'CocoaAsyncSocket', '~> 7.6.2'
end

#主项目
target 'SocketIMDemo' do
   pod 'MJExtension'
   pod 'Realm', '~> 2.8.1'  #realm数据库
   pod 'CocoaAsyncSocket', '~> 7.6.2'
   pod 'SDAutoLayout'       #自动布局
   pod 'MJRefresh'          #上/下拉刷新/加载
   pod 'SDWebImage'         #加载网络图片
end

#假设项目 A 引用了静态库 B(或者是动态库，也是一样)，那么 A 编译后得到的静态库中，并不含有静态库 B 的目标文件。如果有人拿到这样的静态库 A，就必须补齐静态库 B，否则就会遇到 “Undefined symbol” 错误。
