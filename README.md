# SwiftLog
Swift 日志分级打印工具，支持分不同等级打印log，添加专门用于打印网络请求报文的类型unicode转码，方便查看日志输出。用法详见Demo。
## 安装
```
支持ios9以上版本，swift4以上版本都支持
pod ‘SwiftLog’
```
## 使用 

```
/// log等级
public enum LogDegree : Int{
    case ignore = 0//最低级log
    case debug = 1//debug级别
    case netWork = 2//用于打印网络报文，可单独关闭
    case info = 3//重要信息级别
    case warning = 4//警告级别
    case error = 5//错误级别
}
```

```
// 设置默认打印Log的等级。低于此等级不做输出
        SLog.defaultLogDegree = .debug
// 用于网络日志的开关
        SLog.showNetLog = false
```

```
        SLogIgnore("打印最低级信息可忽视不理会")
        
        SLogDebug("打印Debug级信息")
        
        SLogNet("可单独关闭----\\u6253\\u5370\\u6d88\\u606f print message，可以用于打印类似网络请求报文")
        
        //支持打印时unicode转中文
        SLogInfo("打印Info级信息")
        
        SLogWarn("打印警告级信息")
        
        SLogError("打印Error信息")
```


详细用法参见Demo **ViewController**
