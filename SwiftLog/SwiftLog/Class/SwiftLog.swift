//
//  SwiftLog.swift
//  SwiftLog
//
//  Created by iOS on 2020/4/2.
//  Copyright © 2020 iOS. All rights reserved.
//

import Foundation

#if DEBUG
private let shouldLog: Bool = true
#else
private let shouldLog: Bool = false
#endif
 
/// log等级划分最高级 ❌
@inlinable public func SLogError(_ message: @autoclosure () -> String,
                       file: StaticString = #file,
                       function: StaticString = #function,
                       line: UInt = #line) {
    SLog.log(message(), type: .error, file: file, function: function, line: line)
}

/// log等级划分警告级 ⚠️
@inlinable public func SLogWarn(_ message: @autoclosure () -> String,
                      file: StaticString = #file,
                      function: StaticString = #function,
                      line: UInt = #line) {
    SLog.log(message(), type: .warn, file: file, function: function, line: line)
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
@inlinable public func SLogVerbose(_ message: @autoclosure () -> String,
                         file: StaticString = #file,
                         function: StaticString = #function,
                         line: UInt = #line) {
    SLog.log(message(), type: .verbose, file: file, function: function, line: line)
}

/// log等级
public enum LogDegree : Int{
    case verbose = 0//最低级log
    case debug = 1//debug级别
    case net = 2//用于打印网络报文，可单独关闭
    case info = 3//重要信息级别,比如网络层输出
    case warn = 4//警告级别
    case error = 5//错误级别
}

/// 日志处理
public class SLog {
    
    /// 日志打印级别，小于此级别忽略
    public static var defaultLogDegree : LogDegree = .verbose
    
    /// 用于开关网络日志打印
    public static var showNetLog : Bool = true
    
    /// log等级划分最低级 ⚪ 可忽略
    public static func verbose(_ message: String,
                             file: StaticString = #file,
                             function: StaticString = #function,
                             line: UInt = #line) {
        log(message, type: .verbose, file: file, function: function, line: line)
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
    public static func warn(_ message: String,
                             file: StaticString = #file,
                             function: StaticString = #function,
                             line: UInt = #line) {
        log(message, type: .warn, file: file, function: function, line: line)
    }
    
    /// log等级划分最高级 ❌
    public static func error(_ message: String,
                             file: StaticString = #file,
                             function: StaticString = #function,
                             line: UInt = #line) {
        log(message, type: .error, file: file, function: function, line: line)
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
        guard shouldLog else { return }
        if type.rawValue < defaultLogDegree.rawValue{ return }
        
        if type == .net, !showNetLog{ return }
        
        let fileName = String(describing: file).lastPathComponent
        let formattedMsg = String(format: "所在类:%@ \n 方法名:%@ \n 所在行:%d \n<<<<<<<<<<<<<<<<信息>>>>>>>>>>>>>>>>\n\n %@ \n\n<<<<<<<<<<<<<<<<END>>>>>>>>>>>>>>>>\n\n", fileName, String(describing: function), line, message())
        SLogFormatter.log(message: formattedMsg, type: type)
    }
    
}

/// 日志格式
class SLogFormatter {

    static var dateFormatter = DateFormatter()

    static func log(message logMessage: String, type: LogDegree) {
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss:SSS"
        var logLevelStr: String
        switch type {
        case .error:
            logLevelStr = "❌ Error ❌"
        case .warn:
            logLevelStr = "⚠️ Warning ⚠️"
        case .info:
            logLevelStr = "🔔 Info 🔔"
        case .net:
            logLevelStr = "🌐 Network 🌐"
        case .debug:
            logLevelStr = "✅ Debug ✅"
        case .verbose:
            logLevelStr = "⚪ Ignore ⚪"
        }
        
        let dateStr = dateFormatter.string(from: Date())
        let finalMessage = String(format: "\n%@ | %@ \n %@", logLevelStr, dateStr, logMessage)
        print(finalMessage.replaceUnicode)
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
            debugPrint(error)
        }
        return returnStr.replacingOccurrences(of: "\\r\\n", with: "\n")
    }
}
