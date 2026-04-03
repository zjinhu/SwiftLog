//
//  SwiftLog.swift
//  SwiftLog
//
//  Created by iOS on 2020/4/2.
//  Copyright © 2020 iOS. All rights reserved.
//

import Foundation
import os.log

// MARK: - Constants / 常量定义

/// Cache file name for log storage / 日志缓存文件名
private let kCacheDomainName = "SLog.txt"

/// Cache directory path / 缓存目录路径
private let cachePath = FileManager.default.urls(for: .cachesDirectory,
                                          in: .userDomainMask)[0]

/// Log file URL in cache directory / 缓存目录中的日志文件URL
private let logFileURL = cachePath.appendingPathComponent(kCacheDomainName)

/// Enable logging in DEBUG builds only / 仅在DEBUG模式下启用日志
#if DEBUG
private let shouldLog: Bool = true
#else
private let shouldLog: Bool = false
#endif

// MARK: - Global Log Functions / 全局日志函数

/// Log highest severity level - Critical/Fatal ‼️
/// 最高严重级别日志 - 致命错误 ‼️
@inlinable public func SLogFault(_ message: @autoclosure () -> String,
                       file: StaticString = #file,
                       function: StaticString = #function,
                       line: UInt = #line) {
    SLog.log(message(), type: .fault, file: file, function: function, line: line)
}

/// Log error level ❌
/// 错误级别日志 ❌
@inlinable public func SLogError(_ message: @autoclosure () -> String,
                       file: StaticString = #file,
                       function: StaticString = #function,
                       line: UInt = #line) {
    SLog.log(message(), type: .error, file: file, function: function, line: line)
}

/// Log warning level ⚠️
/// 警告级别日志 ⚠️
@inlinable public func SLogWarning(_ message: @autoclosure () -> String,
                      file: StaticString = #file,
                      function: StaticString = #function,
                      line: UInt = #line) {
    SLog.log(message(), type: .warning, file: file, function: function, line: line)
}

/// Log info level - Important information 🔔
/// 信息级别日志 - 重要信息 🔔
@inlinable public func SLogInfo(_ message: @autoclosure () -> String,
                      file: StaticString = #file,
                      function: StaticString = #function,
                      line: UInt = #line) {
    SLog.log(message(), type: .info, file: file, function: function, line: line)
}

/// Log network level - Can be toggled independently 🌐
/// 网络级别日志 - 可独立开关 🌐
@inlinable public func SLogNet(_ message: @autoclosure () -> String,
                      file: StaticString = #file,
                      function: StaticString = #function,
                      line: UInt = #line) {
    SLog.log(message(), type: .net, file: file, function: function, line: line)
}

/// Log debug level - For development ✅
/// 调试级别日志 - 开发时使用 ✅
@inlinable public func SLogDebug(_ message: @autoclosure () -> String,
                       file: StaticString = #file,
                       function: StaticString = #function,
                       line: UInt = #line) {
    SLog.log(message(), type: .debug, file: file, function: function, line: line)
}

/// Log trace level - Lowest priority, ignorable ⚪
/// 跟踪级别日志 - 最低优先级，可忽略 ⚪
@inlinable public func SLogTrace(_ message: @autoclosure () -> String,
                         file: StaticString = #file,
                         function: StaticString = #function,
                         line: UInt = #line) {
    SLog.log(message(), type: .trace, file: file, function: function, line: line)
}

// MARK: - Log Degree Enum / 日志等级枚举

/// Log severity levels (ordered from lowest to highest)
/// 日志严重级别（从低到高排序）
public enum LogDegree: Int {
    case trace = 0   // Trace: Track program execution / 跟踪程序执行
    case debug = 1   // Debug: Debugging information / 调试信息
    case net = 2     // Network: Network requests/responses, can be toggled independently / 网络报文，可独立关闭
    case info = 3    // Info: Important information, e.g., network layer output / 重要信息，如网络层输出
    case warning = 4 // Warning: Warning messages / 警告信息
    case error = 5   // Error: Error messages / 错误信息
    case fault = 6   // Fault: Critical/fatal errors / 严重错误
}

// MARK: - SLog Main Class / 日志主类

/// Main logging handler class
/// 日志处理主类
public class SLog {
    
    /// Get the log file URL / 获取日志文件URL
    public static var getLogFileURL: URL {
        return logFileURL
    }
    
    /// Minimum log level to print, logs below this level are ignored
    /// 最低日志打印级别，低于此级别的日志将被忽略
    public static var defaultLogDegree: LogDegree = .trace
    
    /// Toggle for network log printing
    /// 网络日志打印开关
    public static var showNetLog: Bool = true
    
    /// Maximum age for cached log files (in seconds)
    /// Set this before enabling `addFileLog` if you want to customize the duration
    /// Default: 7 days (60 * 60 * 24 * 7)
    /// 缓存日志文件的最大保存时间（秒）
    /// 如需自定义时间，请在启用 `addFileLog` 之前设置
    /// 默认：7天 (60 * 60 * 24 * 7)
    public static var maxLogAge: TimeInterval? = 60 * 60 * 24 * 7
    
    /// Enable/disable writing logs to file
    /// 启用/禁用将日志写入文件
    public static var addFileLog: Bool = false {
        didSet {
            if addFileLog {
                deleteOldFiles()
            }
        }
    }
    
    /// Delete log files older than `maxLogAge`
    /// 删除超过 `maxLogAge` 的旧日志文件
    private static func deleteOldFiles() {
        let url = getLogFileURL
        if !FileManager.default.fileExists(atPath: url.path) {
            return
        }
        guard let age: TimeInterval = maxLogAge, age != 0 else {
            return
        }
        let expirationDate = Date(timeIntervalSinceNow: -age)
        let resourceKeys: [URLResourceKey] = [.isDirectoryKey, .contentModificationDateKey, .totalFileAllocatedSizeKey]
        var resourceValues: URLResourceValues
        
        do {
            resourceValues = try url.resourceValues(forKeys: Set(resourceKeys))
            if let modificationDate = resourceValues.contentModificationDate {
                if modificationDate.compare(expirationDate) == .orderedAscending {
                    try? FileManager.default.removeItem(at: url)
                }
            }
        } catch let error {
            debugPrint("SLog error: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Instance Methods / 实例方法
    
    /// Log trace level - Lowest priority ⚪
    /// 跟踪级别日志 - 最低优先级 ⚪
    public static func trace(_ message: String,
                             file: StaticString = #file,
                             function: StaticString = #function,
                             line: UInt = #line) {
        log(message, type: .trace, file: file, function: function, line: line)
    }
    
    /// Log debug level ✅
    /// 调试级别日志 ✅
    public static func debug(_ message: String,
                             file: StaticString = #file,
                             function: StaticString = #function,
                             line: UInt = #line) {
        log(message, type: .debug, file: file, function: function, line: line)
    }
    
    /// Log network level - Can be toggled independently 🌐
    /// 网络级别日志 - 可独立开关 🌐
    public static func net(_ message: String,
                           file: StaticString = #file,
                           function: StaticString = #function,
                           line: UInt = #line) {
        log(message, type: .net, file: file, function: function, line: line)
    }
    
    /// Log info level 🔔
    /// 信息级别日志 🔔
    public static func info(_ message: String,
                            file: StaticString = #file,
                            function: StaticString = #function,
                            line: UInt = #line) {
        log(message, type: .info, file: file, function: function, line: line)
    }
    
    /// Log warning level ⚠️
    /// 警告级别日志 ⚠️
    public static func warning(_ message: String,
                               file: StaticString = #file,
                               function: StaticString = #function,
                               line: UInt = #line) {
        log(message, type: .warning, file: file, function: function, line: line)
    }
    
    /// Log error level ❌
    /// 错误级别日志 ❌
    public static func error(_ message: String,
                             file: StaticString = #file,
                             function: StaticString = #function,
                             line: UInt = #line) {
        log(message, type: .error, file: file, function: function, line: line)
    }
    
    /// Log fault level - Highest severity ‼️
    /// 致命错误级别日志 - 最高严重级别 ‼️
    public static func fault(_ message: String,
                             file: StaticString = #file,
                             function: StaticString = #function,
                             line: UInt = #line) {
        log(message, type: .fault, file: file, function: function, line: line)
    }
    
    // MARK: - Core Log Method / 核心日志方法
    
    /// Core logging method - formats and dispatches log messages
    /// 核心日志方法 - 格式化并分发日志消息
    /// - Parameters:
    ///   - message: The log message body / 日志消息内容
    ///   - type: Log severity level / 日志级别
    ///   - file: Source file name / 源文件名
    ///   - function: Source function name / 源函数名
    ///   - line: Source line number / 源行号
    public static func log(_ message: @autoclosure () -> String,
                           type: LogDegree,
                           file: StaticString,
                           function: StaticString,
                           line: UInt) {
        
        // Skip if log level is below threshold / 如果日志级别低于阈值则跳过
        if type.rawValue < defaultLogDegree.rawValue { return }
        
        // Skip network logs if disabled / 如果网络日志已禁用则跳过
        if type == .net, !showNetLog { return }
        
        let fileName = String(describing: file).lastPathComponent
      
        // Format: class name, function name, line number, and message
        // 格式：类名、函数名、行号和消息内容
        let formattedMsg = String(format: "所在类:%@ \n 方法名:%@ \n 所在行:%d \n<<<<<<<<<<<<<<<<信息>>>>>>>>>>>>>>>>\n\n %@ \n\n<<<<<<<<<<<<<<<<END>>>>>>>>>>>>>>>>\n\n", fileName, String(describing: function), line, message())
        
        SLogFormatter.log(message: formattedMsg, type: type, addFileLog: addFileLog)
    }
}

// MARK: - Log Formatter / 日志格式化器

/// Handles log formatting and output (console + file)
/// 处理日志格式化和输出（控制台 + 文件）
class SLogFormatter {

    /// Date formatter for log timestamps / 日志时间戳格式化器
    static var dateFormatter = DateFormatter()
  
    /// OSLog instance for unified logging system / 统一日志系统的OSLog实例
    static let log = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "SLog")
  
    /// Format and output log message to console and optionally to file
    /// 格式化日志消息并输出到控制台，可选写入文件
    /// - Parameters:
    ///   - logMessage: The formatted log message / 格式化后的日志消息
    ///   - type: Log severity level / 日志级别
    ///   - addFileLog: Whether to write to file / 是否写入文件
    static func log(message logMessage: String, type: LogDegree, addFileLog: Bool) {
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss:SSS"
        var logLevelStr: String
        var level: OSLogType
        
        // Map LogDegree to OSLogType and generate display string
        // 将LogDegree映射为OSLogType并生成显示字符串
        switch type {
        case .fault:
            level = .fault
            logLevelStr = "‼️ Fault ‼️"
        case .error:
            level = .error
            logLevelStr = "❌ Error ❌"
        case .warning:
            level = .error
            logLevelStr = "⚠️ Warning ⚠️"
        case .info:
            level = .info
            logLevelStr = "🔔 Info 🔔"
        case .net:
            level = .info
            logLevelStr = "🌐 Network 🌐"
        case .debug:
            level = .debug
            logLevelStr = "✅ Debug ✅"
        case .trace:
            level = .`default`
            logLevelStr = "⚪ Trace ⚪"
        }
        
        let dateStr = dateFormatter.string(from: Date())
        let finalMessage = String(format: "\n%@ | %@ \n %@", logLevelStr, dateStr, logMessage)
        
        // Write to log file if enabled (Caches directory)
        // 如果启用则写入日志文件（Caches目录）
        if addFileLog {
            appendText(fileURL: logFileURL, string: "\(finalMessage.replaceUnicode)")
        }
        
        guard shouldLog else { return }
        
        // Output to OSLog unified logging system
        // 输出到OSLog统一日志系统
        os_log("%{public}@", log: log, type: level, finalMessage.replaceUnicode)
    }
    
    /// Append text to the end of a file
    /// 在文件末尾追加文本内容
    /// - Parameters:
    ///   - fileURL: Target file URL / 目标文件URL
    ///   - string: Text to append / 要追加的文本
    static func appendText(fileURL: URL, string: String) {
        do {
            // Create file if it doesn't exist / 如果文件不存在则创建
            if !FileManager.default.fileExists(atPath: fileURL.path) {
                FileManager.default.createFile(atPath: fileURL.path, contents: nil)
            }
             
            let fileHandle = try FileHandle(forWritingTo: fileURL)
            let stringToWrite = "\n" + string
             
            // Seek to end and append / 定位到文件末尾并追加
            fileHandle.seekToEndOfFile()
            fileHandle.write(stringToWrite.data(using: String.Encoding.utf8)!)
             
        } catch let error as NSError {
            print("failed to append: \(error)")
        }
    }
}

// MARK: - String Extensions / 字符串扩展

/// String utilities for file path handling and Unicode decoding
/// 字符串工具扩展，用于文件路径处理和Unicode解码
private extension String {

    /// Convert string path to URL / 将字符串路径转换为URL
    var fileURL: URL {
        return URL(fileURLWithPath: self)
    }

    /// Get file extension from path / 获取路径的文件扩展名
    var pathExtension: String {
        return fileURL.pathExtension
    }

    /// Get last path component (file/directory name) / 获取路径的最后一个组件（文件/目录名）
    var lastPathComponent: String {
        return fileURL.lastPathComponent
    }

    /// Decode Unicode escape sequences to readable text
    /// Example: "\u6253\u5370" -> "打印"
    /// 将Unicode转义序列解码为可读文本
    /// 示例："\u6253\u5370" -> "打印"
    var replaceUnicode: String {
        let tempStr1 = self.replacingOccurrences(of: "\\u", with: "\\U")
        let tempStr2 = tempStr1.replacingOccurrences(of: "\"", with: "\\\"")
        let tempStr3 = "\"".appending(tempStr2).appending("\"")
        guard let tempData = tempStr3.data(using: String.Encoding.utf8) else {
            return "Unicode decoding failed"
        }
        var returnStr: String = ""
        do {
            returnStr = try PropertyListSerialization.propertyList(from: tempData, options: [.mutableContainers], format: nil) as! String
        } catch {
            print(error)
        }
        return returnStr.replacingOccurrences(of: "\\r\\n", with: "\n")
    }
}
