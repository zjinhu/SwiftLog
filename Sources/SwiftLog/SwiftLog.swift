//
//  SwiftLog.swift
//  SwiftLog
//
//  Created by iOS on 2020/4/2.
//  Copyright © 2020 iOS. All rights reserved.
//

import Foundation

private let kCacheDomainName = "SLog.txt"

private let cachePath = FileManager.default.urls(for: .cachesDirectory,
                                          in: .userDomainMask)[0]
private let logFileURL = cachePath.appendingPathComponent(kCacheDomainName)

#if DEBUG
private let shouldLog: Bool = true
#else
private let shouldLog: Bool = false
#endif

/// log等级划分最高级 ‼️
@inlinable public func SLogFault(_ message: @autoclosure () -> String,
                       file: StaticString = #file,
                       function: StaticString = #function,
                       line: UInt = #line) {
    SLog.log(message(), type: .fault, file: file, function: function, line: line)
}

/// log等级划分最高级 ❌
@inlinable public func SLogError(_ message: @autoclosure () -> String,
                       file: StaticString = #file,
                       function: StaticString = #function,
                       line: UInt = #line) {
    SLog.log(message(), type: .error, file: file, function: function, line: line)
}

/// log等级划分警告级 ⚠️
@inlinable public func SLogWarning(_ message: @autoclosure () -> String,
                      file: StaticString = #file,
                      function: StaticString = #function,
                      line: UInt = #line) {
    SLog.log(message(), type: .warning, file: file, function: function, line: line)
}

/// log等级划分信息级 🔔
@inlinable public func SLogInfo(_ message: @autoclosure () -> String,
                      file: StaticString = #file,
                      function: StaticString = #function,
                      line: UInt = #line) {
    SLog.log(message(), type: .info, file: file, function: function, line: line)
}

/// 专门打印网络日志，可以单独关闭 🌐
@inlinable public func SLogNet(_ message: @autoclosure () -> String,
                      file: StaticString = #file,
                      function: StaticString = #function,
                      line: UInt = #line) {
    SLog.log(message(), type: .net, file: file, function: function, line: line)
}

/// log等级划分开发级 ✅
@inlinable public func SLogDebug(_ message: @autoclosure () -> String,
                       file: StaticString = #file,
                       function: StaticString = #function,
                       line: UInt = #line) {
    SLog.log(message(), type: .debug, file: file, function: function, line: line)
}
 
/// log等级划分最低级 ⚪ 可忽略
@inlinable public func SLogTrace(_ message: @autoclosure () -> String,
                         file: StaticString = #file,
                         function: StaticString = #function,
                         line: UInt = #line) {
    SLog.log(message(), type: .trace, file: file, function: function, line: line)
}

/// log等级
public enum LogDegree : Int{
    case trace = 0//跟踪程序的执行
    case debug = 1//调试程序
    case net = 2//用于打印网络报文，可单独关闭
    case info = 3//重要信息级别,比如网络层输出
    case warning = 4//警告级别
    case error = 5//错误级别
    case fault = 6//严重错误
}

/// 日志处理
public class SLog {
    
    /// 获取日志日志
    public static var getLogFileURL: URL{
        return logFileURL
    }
    
    /// 日志打印级别，小于此级别忽略
    public static var defaultLogDegree : LogDegree = .verbose
    
    /// 用于开关网络日志打印
    public static var showNetLog : Bool = true
    
    ///缓存保存最长时间///如果需要自定义时间一定要在addFileLog之前
    public static var maxLogAge : TimeInterval? = 60 * 60 * 24 * 7
    /// log是否写入文件
    public static var addFileLog : Bool = false{
        didSet{
            if addFileLog {
                deleteOldFiles()
            }
        }
    }
 
    private static func deleteOldFiles() {
        let url = getLogFileURL
        if !FileManager.default.fileExists(atPath: url.path) {
            return
        }
        guard let age : TimeInterval = maxLogAge, age != 0 else {
            return
        }
        let expirationDate = Date(timeIntervalSinceNow: -age)
        let resourceKeys: [URLResourceKey] = [.isDirectoryKey, .contentModificationDateKey, .totalFileAllocatedSizeKey]
        var resourceValues: URLResourceValues
        
        do {
            resourceValues = try url.resourceValues(forKeys: Set(resourceKeys))
            if let modifucationDate = resourceValues.contentModificationDate {
                if modifucationDate.compare(expirationDate) == .orderedAscending {
                    try? FileManager.default.removeItem(at: url)
                }
            }
        } catch let error {
            debugPrint("SLog error: \(error.localizedDescription)")
        }
        
    }
    
    /// log等级划分最低级 ⚪ 可忽略
    public static func trace(_ message: String,
                             file: StaticString = #file,
                             function: StaticString = #function,
                             line: UInt = #line) {
        log(message, type: .trace, file: file, function: function, line: line)
    }
    
    /// log等级划分开发级 ✅
    public static func debug(_ message: String,
                             file: StaticString = #file,
                             function: StaticString = #function,
                             line: UInt = #line) {
        log(message, type: .debug, file: file, function: function, line: line)
    }
    
    /// 专门打印网络日志，可以单独关闭 🌐
    public static func net(_ message: String,
                             file: StaticString = #file,
                             function: StaticString = #function,
                             line: UInt = #line) {
        log(message, type: .net, file: file, function: function, line: line)
    }
    
    /// log等级划分信息级 🔔
    public static func info(_ message: String,
                             file: StaticString = #file,
                             function: StaticString = #function,
                             line: UInt = #line) {
        log(message, type: .info, file: file, function: function, line: line)
    }
    
    /// log等级划分警告级 ⚠️
    public static func warning(_ message: String,
                             file: StaticString = #file,
                             function: StaticString = #function,
                             line: UInt = #line) {
        log(message, type: .warning, file: file, function: function, line: line)
    }
    
    /// log等级划分高级 ❌
    public static func error(_ message: String,
                             file: StaticString = #file,
                             function: StaticString = #function,
                             line: UInt = #line) {
        log(message, type: .error, file: file, function: function, line: line)
    }
  /// log等级划分最高级 ‼️
    public static func fault(_ message: String,
                             file: StaticString = #file,
                             function: StaticString = #function,
                             line: UInt = #line) {
        log(message, type: .fault, file: file, function: function, line: line)
    }
    
    /// 打印Log
    /// - Parameters:
    ///   - message: 消息主体
    ///   - type: log级别
    ///   - file: 所在文件
    ///   - function: 所在方法
    ///   - line: 所在行
    public static func log(_ message: @autoclosure () -> String,
                           type: LogDegree,
                           file: StaticString,
                           function: StaticString,
                           line: UInt) {
        
        if type.rawValue < defaultLogDegree.rawValue{ return }
        
        if type == .net, !showNetLog{ return }
        
        let fileName = String(describing: file).lastPathComponent
      
        let formattedMsg = String(format: "所在类:%@ \n 方法名:%@ \n 所在行:%d \n<<<<<<<<<<<<<<<<信息>>>>>>>>>>>>>>>>\n\n %@ \n\n<<<<<<<<<<<<<<<<END>>>>>>>>>>>>>>>>\n\n", fileName, String(describing: function), line, message())
        
        SLogFormatter.log(message: formattedMsg, type: type, addFileLog : addFileLog)
    }
    
}

/// 日志格式
class SLogFormatter {

    static var dateFormatter = DateFormatter()
  
    static let log = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "SLog")
  
    static func log(message logMessage: String, type: LogDegree, addFileLog : Bool) {
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss:SSS"
        var logLevelStr: String
        var level: OSLogType
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
        
        //将内容同步写到文件中去（Caches文件夹下）
        if addFileLog {
            appendText(fileURL: logFileURL, string: "\(finalMessage.replaceUnicode)")
        }
        
        guard shouldLog else { return }
        // print(finalMessage.replaceUnicode)

        os_log("%{public}@", log: log, type: level, finalMessage.replaceUnicode)
    }
    
    //在文件末尾追加新内容
    static func appendText(fileURL: URL, string: String) {
        do {
            //如果文件不存在则新建一个
            if !FileManager.default.fileExists(atPath: fileURL.path) {
                FileManager.default.createFile(atPath: fileURL.path, contents: nil)
            }
             
            let fileHandle = try FileHandle(forWritingTo: fileURL)
            let stringToWrite = "\n" + string
             
            //找到末尾位置并添加
            fileHandle.seekToEndOfFile()
            fileHandle.write(stringToWrite.data(using: String.Encoding.utf8)!)
             
        } catch let error as NSError {
            print("failed to append: \(error)")
        }
    }
}

/// 字符串处理
private extension String {

    var fileURL: URL {
        return URL(fileURLWithPath: self)
    }

    var pathExtension: String {
        return fileURL.pathExtension
    }

    var lastPathComponent: String {
        return fileURL.lastPathComponent
    }

    var replaceUnicode: String {
        let tempStr1 = self.replacingOccurrences(of: "\\u", with: "\\U")
        let tempStr2 = tempStr1.replacingOccurrences(of: "\"", with: "\\\"")
        let tempStr3 = "\"".appending(tempStr2).appending("\"")
        guard let tempData = tempStr3.data(using: String.Encoding.utf8) else {
            return "unicode转码失败"
        }
        var returnStr:String = ""
        do {
            returnStr = try PropertyListSerialization.propertyList(from: tempData, options: [.mutableContainers], format: nil) as! String
        } catch {
            print(error)
        }
        return returnStr.replacingOccurrences(of: "\\r\\n", with: "\n")
    }
}

 
