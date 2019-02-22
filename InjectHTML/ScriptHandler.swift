//
//  ScriptHandler.swift
//  InjectHTML
//
//  Created by chouheiwa on 2019/2/22.
//  Copyright © 2019 chouheiwa. All rights reserved.
//

import Foundation
import WebKit
// 这里我们使用一个中间层来解除循环WebView和Controller间的循环引用问题
class ScriptHandler: NSObject, WKScriptMessageHandler {

    weak var delegate: WKScriptMessageHandler?

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        delegate?.userContentController(userContentController, didReceive: message)
    }

    init(delegate: WKScriptMessageHandler? = nil) {
        self.delegate = delegate
    }
}
