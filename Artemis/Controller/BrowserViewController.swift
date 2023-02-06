//
//  BrowserView.swift
//  Artemis
//
//  Created by Krithick Santhosh on 01/02/23.
//

import UIKit
import WebKit

class BrowserViewController : UIViewController {
    private var webView : WKWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}


private typealias setupBrowserViewFunctions = BrowserViewController
extension setupBrowserViewFunctions: WKUIDelegate{
    override func loadView() {
        let webConfig = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfig)
        webView?.uiDelegate = self
        view = webView
    }
}

private typealias loadWebPageOnBroswer = BrowserViewController
extension loadWebPageOnBroswer: webViewDelegate{
    func loadWebPage(targetURL: String) {
        guard let urlFormat = URL(string: targetURL) else {
            print("Invlaid URL!")
            return
        }
        let pageRequest = URLRequest(url: urlFormat)
        webView?.load(pageRequest)
    }
}
