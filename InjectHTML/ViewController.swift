//
//  ViewController.swift
//  InjectHTML
//
//  Created by chouheiwa on 2019/2/22.
//  Copyright © 2019 chouheiwa. All rights reserved.
//

import UIKit
import WebKit
class ViewController: UIViewController {
    var webview: WKWebView!

    static let scriptKey = "InjectHTML"

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "注入", style: .plain, target: self, action: #selector(injectJS))

        //初始化 Configuration
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = WKUserContentController()
        // 给Configuration 增加一个js script处理器
        // 采用了中间层的因素，避免循环引用导致无法释放问题
        configuration.userContentController.add(ScriptHandler(delegate: self), name: ViewController.scriptKey)

        var frame = view.bounds
        // 尺寸不为适配-_-能看见就行
        frame.origin.y += 100
        frame.size.height -= 100

        webview = WKWebView(frame: frame, configuration: configuration)

        view.addSubview(webview)
        // 设置导航处理器
        webview.navigationDelegate = self
        // 我们先从本地读网页方便自我改动测试
//        var fileURL = Bundle.main.url(forResource: "index", withExtension: "html")
        let url = URL(string: "https://juejin.im/")
        // 加载网页
//        webview.loadFileURL(fileURL!, allowingReadAccessTo: fileURL!)
        webview.load(URLRequest(url: url!))
    }

    @objc func injectJS() {
        guard let jsString = try? String(contentsOfFile: Bundle.main.path(forResource: "Inject", ofType: "js") ?? "") else {
            // 没有读取出来则不执行注入
            return
        }
        // 注入语句
        webview.evaluateJavaScript(jsString, completionHandler: { _, _ in
            print("代码注入成功")
        })
    }
}

extension ViewController: WKScriptMessageHandler {
    // 遵守协议
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        // 因html可能传递多种类型名称，我们这里须指定key
        if message.name == ViewController.scriptKey {
            guard let dic = message.body as? [String: String] else {
                return
            }
            // 交给真实处理解析函数
            receiveInputValue(para: dic)
        }
    }
    // 解析函数可以负责更具体的内容，因为demo，故此只是打印
    func receiveInputValue(para: [String: String]) {
        let title = para["title"] ?? "无值"

        let message = para["message"] ?? "无值"

        let `id` = para["id"] ?? "无值"

        print("title: \(title)")
        print("message: \(message)")
        print("id: \(id)")
    }
}
// 遵循导航协议，方便我们知道何时网页加载完成
extension ViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard let jsString = try? String(contentsOfFile: Bundle.main.path(forResource: "Inject", ofType: "js") ?? "") else {
            // 没有读取出来则不执行注入
            return
        }
        // 注入语句
        webView.evaluateJavaScript(jsString, completionHandler: { _, _ in
            print("代码注入成功")
        })
    }
}
