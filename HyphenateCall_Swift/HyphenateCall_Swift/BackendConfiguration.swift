//
//  BackendConfiguration.swift
//  HyphenateCall_Swift
//
//  Created by EaseMob on 2017/5/9.
//  Copyright © 2017年 EaseMob. All rights reserved.
//

import Foundation

final class BackendConfiguration {
    
    let baseURL: NSURL
    init(_ baseURL: NSURL) {
        self.baseURL = baseURL
    }
    static var shared: BackendConfiguration!
}
