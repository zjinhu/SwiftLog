![](Image/logo.png)

[![Version](https://img.shields.io/cocoapods/v/Swift_Log.svg?style=flat)](http://cocoapods.org/pods/Swift_Log)
[![SPM](https://img.shields.io/badge/SPM-supported-DE5C43.svg?style=flat)](https://swift.org/package-manager/)
![Xcode 9.0+](https://img.shields.io/badge/Xcode-9.0%2B-blue.svg)
![iOS 9.0+](https://img.shields.io/badge/iOS-9.0%2B-blue.svg)
![Swift 4.0+](https://img.shields.io/badge/Swift-4.0%2B-orange.svg)
[![Swift 5.0](https://img.shields.io/badge/Swift-5.0-green.svg?style=flat)](https://developer.apple.com/swift/)

A lightweight, level-based logging utility for Swift with bilingual (Chinese/English) documentation.

Supports multiple log levels with emoji indicators, configurable output levels, Unicode decoding for network payloads, and optional file logging with automatic LRU expiration (default: 7 days).

## Installation

### CocoaPods

1. Add `pod 'Swift_Log'` to your Podfile
2. Run `pod install` or `pod update`
3. Import with `import Swift_Log`

### Swift Package Manager

SwiftLog supports SPM. In Xcode: `File > Swift Packages > Add Package Dependency`, then enter:

`https://github.com/zjinhu/SwiftLog`

### Manual Integration

Drag the `Sources/SwiftLog` folder into your project.

## Usage

### Log Levels

```swift
public enum LogDegree: Int {
    case trace = 0   // Trace: Track program execution
    case debug = 1   // Debug: Debugging information
    case net = 2     // Network: Network requests/responses (toggle independently)
    case info = 3    // Info: Important information
    case warning = 4 // Warning: Warning messages
    case error = 5   // Error: Error messages
    case fault = 6   // Fault: Critical/fatal errors
}
```

### Configuration

```swift
// Set minimum log level (logs below this are ignored)
SLog.defaultLogDegree = .debug

// Toggle network logs independently
SLog.showNetLog = false

// Set max log file age (in seconds), must be set before enabling addFileLog
// Default: 7 days
SLog.maxLogAge = 60 * 60 * 24 * 7

// Enable file logging
SLog.addFileLog = true

// Get log file URL for upload/sharing
SLog.getLogFileURL
```

### Global Functions (Recommended)

```swift
SLogTrace("Trace level - ignorable details")
SLogDebug("Debug level - development info")
SLogNet("Network payload with \\u6253\\u5370 unicode support")
SLogInfo("Info level - important information")
SLogWarning("Warning level - potential issues")
SLogError("Error level - errors occurred")
SLogFault("Fault level - critical/fatal errors")
```

### Class Methods

```swift
SLog.trace("Trace message")
SLog.debug("Debug message")
SLog.net("Network message")
SLog.info("Info message")
SLog.warning("Warning message")
SLog.error("Error message")
SLog.fault("Fault message")
```

## Output Format

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

## AI Skills Integration

SwiftLog provides an AI Skills file for seamless integration with AI coding assistants. See [Skills Usage Guide](#skills-usage-guide) below.

### Skills Usage Guide

The `.skills` file contains structured metadata about SwiftLog's API, enabling AI assistants to:

1. **Auto-suggest correct log functions** - AI knows to use `SLogTrace/SLogDebug/SLogNet/SLogInfo/SLogWarning/SLogError/SLogFault` instead of generic `print()`
2. **Apply proper configuration** - AI understands `defaultLogDegree`, `showNetLog`, `maxLogAge`, and `addFileLog` settings
3. **Generate context-aware log messages** - AI includes file, function, and line info automatically

#### Example AI Prompts

When working on a Swift project with SwiftLog installed, you can prompt your AI assistant:

```
Use SwiftLog to add error handling logs in this function
```

The AI will automatically generate:

```swift
SLogError("Failed to fetch user data: \(error.localizedDescription)")
```

Or for network debugging:

```
Add network logging to track this API request
```

The AI will generate:

```swift
SLogNet("API Request: \(url) | Method: \(method) | Body: \(body)")
```

#### Installing Skills

Place the `SwiftLog.skills` file in your project's `.opencode/skills/` directory or your global AI assistant skills folder.
