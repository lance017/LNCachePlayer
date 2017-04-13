//
//  Theme.swift
//  Music
//
//  Created by WangPengHui on 16/10/26.
//  Copyright © 2016年 美鲜冻品商城. All rights reserved.
//

import UIKit

public let LNScreenWidth: CGFloat = UIScreen.main.bounds.size.width

public let LNScreenHeight: CGFloat = UIScreen.main.bounds.size.height

public let LNScreenBounds: CGRect = UIScreen.main.bounds

public let LNVideoWidth: CGFloat = UIScreen.main.bounds.size.width

public let LNVideoHeight: CGFloat = 420 / 750 * LNScreenWidth
//swift版
public func DLog<T>(_ message: T, file: String = #file, method: String = #function, line: Int = #line) {
    #if DEBUG
        print("<\((file as NSString).lastPathComponent) : \(line)>, \(method)  \(message)")
    #endif
}
