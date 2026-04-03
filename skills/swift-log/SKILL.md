---
name: swift-log
description: A lightweight, level-based Swift logging utility with emoji indicators, Unicode decoding for network payloads, configurable log levels, and optional file logging with LRU expiration. Use when adding logs, debugging network requests, configuring log output levels, or writing logs to files in Swift/iOS projects.
license: MIT
compatibility: Requires Swift 4.0+, iOS 9.0+, Xcode 9.0+
metadata:
  author: zjinhu
  version: "1.0"
  github: https://github.com/zjinhu/SwiftLog
---

# SwiftLog - Level-Based Swift Logging

## When to Use

- Adding log statements to Swift code
- Debugging network requests with Unicode payload support
- Configuring log output levels (trace/debug/net/info/warning/error/fault)
- Writing logs to files with automatic expiration
- Replacing `print()` statements with structured logging

## Quick Start

### Import

```swift
import SwiftLog
// or if using CocoaPods:
import Swift_Log
```

### Configuration (App Delegate / Entry Point)

```swift
// Set minimum log level (logs below this are ignored)
SLog.defaultLogDegree = .debug

// Toggle network logs independently
SLog.showNetLog = false

// Set max log file age in seconds (default: 7 days)
// Must be set BEFORE enabling addFileLog
SLog.maxLogAge = 60 * 60 * 24 * 7

// Enable file logging
SLog.addFileLog = true

// Get log file URL for upload/sharing
let logURL = SLog.getLogFileURL
```

### Log Levels (Lowest → Highest)

| Level | Function | Emoji | Use Case |
|-------|----------|-------|----------|
| trace | `SLogTrace()` | ⚪ | Ignorable details, verbose tracing |
| debug | `SLogDebug()` | ✅ | Development/debugging info |
| net | `SLogNet()` | 🌐 | Network requests/responses (toggleable) |
| info | `SLogInfo()` | 🔔 | Important information |
| warning | `SLogWarning()` | ⚠️ | Potential issues |
| error | `SLogError()` | ❌ | Errors that occurred |
| fault | `SLogFault()` | ‼️ | Critical/fatal errors |

### Global Functions (Recommended)

```swift
SLogTrace("User tapped button, current state: \(state)")
SLogDebug("Parsing JSON response: \(jsonString)")
SLogNet("POST /api/users | Body: {\"name\":\"John\"} | \\u8bf7\\u6c42\\u6210\\u529f")
SLogInfo("User logged in successfully: \(userId)")
SLogWarning("Disk space running low: \(availableSpace)MB")
SLogError("Failed to fetch data: \(error.localizedDescription)")
SLogFault("Database corruption detected in table: \(tableName)")
```

### Class Methods (Alternative)

```swift
SLog.trace("Trace message")
SLog.debug("Debug message")
SLog.net("Network message")
SLog.info("Info message")
SLog.warning("Warning message")
SLog.error("Error message")
SLog.fault("Fault message")
```

## LogDegree Enum

```swift
public enum LogDegree: Int {
    case trace = 0   // Track program execution
    case debug = 1   // Debugging information
    case net = 2     // Network requests/responses
    case info = 3    // Important information
    case warning = 4 // Warning messages
    case error = 5   // Error messages
    case fault = 6   // Critical/fatal errors
}
```

## Key Features

### Unicode Decoding
Network logs automatically decode Unicode escape sequences:
```swift
SLogNet("\\u6253\\u5370\\u6d88\\u606f")
// Output: 打印消息
```

### File Logging
- Logs written to Caches directory (`SLog.txt`)
- Automatic LRU expiration (default: 7 days)
- Access via `SLog.getLogFileURL`

### DEBUG-Only Output
Logs only print to console in DEBUG builds. Release builds skip console output but can still write to files.

### Auto-Captured Context
Every log automatically captures:
- Source file name
- Function name  
- Line number

## Output Format

```
🌐 Network 🌐 | 2021-03-05 15:27:33:609 
 所在类:ViewController.swift 
 方法名:viewDidLoad() 
 所在行:31 
<<<<<<<<<<<<<<<<信息>>>>>>>>>>>>>>>>

 POST /api/users | Body: {"name":"John"}

<<<<<<<<<<<<<<<<END>>>>>>>>>>>>>>>>
```

## Common Patterns

### Error Handling

```swift
do {
    let data = try fetchData()
    SLogInfo("Fetched \(data.count) records")
} catch {
    SLogError("Fetch failed: \(error.localizedDescription)")
    SLogFault("Critical: Data fetch failed at \(#function)")
}
```

### Network Requests

```swift
SLogNet("Request: \(request.httpMethod ?? "GET") \(url)")
SLogNet("Response: \(response.statusCode) | Body: \\(responseBody)")
```

### State Transitions

```swift
SLogTrace("State transition: \(oldState) -> \(newState)")
SLogDebug("ViewModel updated with \(items.count) items")
```

### Warnings & Errors

```swift
guard let user = currentUser else {
    SLogWarning("No current user found, using guest session")
    return
}

SLogError("Failed to save user: \(error)")
```

## Best Practices

1. **Use appropriate levels**: Don't use `.error` for informational messages
2. **Network logs**: Use `SLogNet()` for all API traffic; toggle with `showNetLog`
3. **File logging**: Enable in production for crash reporting; set `maxLogAge` appropriately
4. **Unicode**: Network logs auto-decode `\uXXXX` sequences - no manual conversion needed
5. **Performance**: `@autoclosure` ensures message is only evaluated if log level passes
