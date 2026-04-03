![](Image/logo.png)

[![Version](https://img.shields.io/cocoapods/v/Swift_Log.svg?style=flat)](http://cocoapods.org/pods/Swift_Log)
[![SPM](https://img.shields.io/badge/SPM-supported-DE5C43.svg?style=flat)](https://swift.org/package-manager/)
![Xcode 9.0+](https://img.shields.io/badge/Xcode-9.0%2B-blue.svg)
![iOS 9.0+](https://img.shields.io/badge/iOS-9.0%2B-blue.svg)
![Swift 4.0+](https://img.shields.io/badge/Swift-4.0%2B-orange.svg)
[![Swift 5.0](https://img.shields.io/badge/Swift-5.0-green.svg?style=flat)](https://developer.apple.com/swift/)

Swift 日志分级打印工具。

支持分不同等级打印log，添加不同emoji方便查阅对应等级，可以设置输出级别，低于该级别的日志不进行打印。

添加专门用于打印网络请求报文的类型unicode转码，方便查看中文日志输出。

支持打印日志到文件，提供文件路径方便上传日志文件，支持文件LRU淘汰，默认七天淘汰一次。用法详见Demo。

## 安装

### CocoaPods

1. 在 Podfile 中添加 `pod 'Swift_Log'`
2. 执行 `pod install` 或 `pod update`
3. 导入 `import Swift_Log`

### Swift Package Manager

从 Xcode 11 开始，集成了 Swift Package Manager，使用起来非常方便。SwiftLog 也支持通过 Swift Package Manager 集成。

在 Xcode 的菜单栏中选择 `File > Swift Packages > Add Package Dependency`，然后在搜索栏输入

`https://github.com/zjinhu/SwiftLog`，即可完成集成

### 手动集成

SwiftLog 也支持手动集成，只需把Sources文件夹中的SwiftLog文件夹拖进需要集成的项目即可

## 使用

### 日志等级

```swift
public enum LogDegree: Int {
    case trace = 0   // 跟踪：跟踪程序执行
    case debug = 1   // 调试：调试信息
    case net = 2     // 网络：网络请求/响应报文，可独立关闭
    case info = 3    // 信息：重要信息
    case warning = 4 // 警告：警告信息
    case error = 5   // 错误：错误信息
    case fault = 6   // 致命：严重错误
}
```

### 配置

```swift
// 设置默认打印Log的等级。低于此等级不做输出
SLog.defaultLogDegree = .debug

// 用于网络日志的开关
SLog.showNetLog = false

// 缓存日志保存最长时间（秒）
// 如果需要自定义时间一定要在addFileLog之前设置，默认七天
SLog.maxLogAge = 60 * 60 * 24 * 7

// 打印日志到文件中
SLog.addFileLog = true

// 获取文件地址URL
SLog.getLogFileURL
```

### 全局函数（推荐）

```swift
SLogTrace("跟踪级别信息，可忽略")
SLogDebug("调试级别信息")
SLogNet("网络报文，支持\\u6253\\u5370 unicode转中文")
SLogInfo("信息级别，重要信息")
SLogWarning("警告级别信息")
SLogError("错误级别信息")
SLogFault("致命错误级别")
```

### 类方法

```swift
SLog.trace("跟踪消息")
SLog.debug("调试消息")
SLog.net("网络消息")
SLog.info("信息消息")
SLog.warning("警告消息")
SLog.error("错误消息")
SLog.fault("致命错误消息")
```

## 输出样式

```
🌐 Network 🌐 | 2021-03-05 15:27:33:609 
 所在类:ViewController.swift 
 方法名:viewDidLoad() 
 所在行:31 
<<<<<<<<<<<<<<<<信息>>>>>>>>>>>>>>>>

 netWork 

<<<<<<<<<<<<<<<<END>>>>>>>>>>>>>>>>
```

```
🔔 Info 🔔 | 2021-03-05 15:27:33:614 
 所在类:ViewController.swift 
 方法名:viewDidLoad() 
 所在行:35 
<<<<<<<<<<<<<<<<信息>>>>>>>>>>>>>>>>

 info 

<<<<<<<<<<<<<<<<END>>>>>>>>>>>>>>>>
```

```
⚠️ Warning ⚠️ | 2021-03-05 15:27:33:615 
 所在类:ViewController.swift 
 方法名:viewDidLoad() 
 所在行:38 
<<<<<<<<<<<<<<<<信息>>>>>>>>>>>>>>>>

 warning 

<<<<<<<<<<<<<<<<END>>>>>>>>>>>>>>>>
```

```
❌ Error ❌ | 2021-03-05 15:27:33:616 
 所在类:ViewController.swift 
 方法名:viewDidLoad() 
 所在行:41 
<<<<<<<<<<<<<<<<信息>>>>>>>>>>>>>>>>

 error 

<<<<<<<<<<<<<<<<END>>>>>>>>>>>>>>>>
```

```
✅ Debug ✅ | 2021-03-05 15:36:57:508 
 所在类:ViewController.swift 
 方法名:viewDidLoad() 
 所在行:28 
<<<<<<<<<<<<<<<<信息>>>>>>>>>>>>>>>>

 debug 

<<<<<<<<<<<<<<<<END>>>>>>>>>>>>>>>>
```

```
⚪ Trace ⚪ | 2021-03-05 15:36:57:505 
 所在类:ViewController.swift 
 方法名:viewDidLoad() 
 所在行:25 
<<<<<<<<<<<<<<<<信息>>>>>>>>>>>>>>>>

 ignore 

<<<<<<<<<<<<<<<<END>>>>>>>>>>>>>>>>
```

## AI Skills 集成

SwiftLog 提供了 AI Skills 文件，方便与 AI 编程助手无缝集成。详见下方 [Skills 使用教程](#skills-使用教程)。

### Skills 使用教程

`.skills` 文件包含了 SwiftLog API 的结构化元数据，使 AI 助手能够：

1. **自动推荐正确的日志函数** - AI 知道应该使用 `SLogTrace/SLogDebug/SLogNet/SLogInfo/SLogWarning/SLogError/SLogFault` 而不是通用的 `print()`
2. **应用正确的配置** - AI 理解 `defaultLogDegree`、`showNetLog`、`maxLogAge` 和 `addFileLog` 等配置项
3. **生成上下文感知的日志消息** - AI 自动包含文件、函数和行号信息

#### AI 提示词示例

在使用了 SwiftLog 的 Swift 项目中，你可以这样提示 AI 助手：

```
使用 SwiftLog 在这个函数中添加错误处理日志
```

AI 将自动生成：

```swift
SLogError("获取用户数据失败: \(error.localizedDescription)")
```

或者用于网络调试：

```
添加网络日志来追踪这个API请求
```

AI 将生成：

```swift
SLogNet("API请求: \(url) | 方法: \(method) | 参数: \(body)")
```

#### 安装 Skills

将 `SwiftLog.skills` 文件放置到你项目的 `.opencode/skills/` 目录中，或者你的全局 AI 助手 skills 文件夹。

#### Skills 文件结构

```
SwiftLog.skills
├── name: SwiftLog
├── description: Swift日志分级工具
├── version: 1.0.0
├── functions: 全局函数列表
│   ├── SLogTrace - 跟踪级别
│   ├── SLogDebug - 调试级别
│   ├── SLogNet - 网络级别（可独立关闭）
│   ├── SLogInfo - 信息级别
│   ├── SLogWarning - 警告级别
│   ├── SLogError - 错误级别
│   └── SLogFault - 致命错误级别
├── class: SLog
│   ├── 类方法: trace/debug/net/info/warning/error/fault
│   └── 配置属性: defaultLogDegree/showNetLog/maxLogAge/addFileLog/getLogFileURL
└── enum: LogDegree
    └── trace/debug/net/info/warning/error/fault
```
