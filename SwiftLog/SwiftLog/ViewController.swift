//
//  ViewController.swift
//  SwiftLog
//
//  Created by iOS on 2020/4/2.
//  Copyright © 2020 iOS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        设置默认打印Log的等级
        SLog.defaultLogDegree = .debug
        /// 用于网络日志的开关
        SLog.showNetLog = false

        SLogIgnore("打印最低级信息可忽视不理会")
        
        SLogDebug("打印Debug级信息")
        
        SLogNet("可单独关闭----\\u6253\\u5370\\u6d88\\u606f print message，可以用于打印类似网络请求报文")
        
        //支持打印时unicode转中文
        SLogInfo("打印Info级信息")
        
        SLogWarn("打印警告级信息")
        
        SLogError("打印Error信息")
    }


}
