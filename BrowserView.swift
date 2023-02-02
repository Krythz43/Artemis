//
//  BrowserView.swift
//  Artemis
//
//  Created by Krithick Santhosh on 01/02/23.
//

import UIKit
import WebKit

class BrowserViewController : UIViewController, WKUIDelegate, webViewDelegate {
    
    private var webView : WKWebView?
    
    override func loadView() {
        let webConfig = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfig)
        webView?.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadWebPage(targetURL:" https://www.espn.com.br/futebol/flamengo/artigo/_/id/11556451/presidente-flamengo-cita-gigante-europeu-tratar-projeto-novo-estadio-2-bilhoes")
    }
    
    func loadWebPage(targetURL: String) {
        guard let urlFormat = URL(string: targetURL) else {
            print("Invlaid URL!")
            return
        }
        let pageRequest = URLRequest(url: urlFormat)
        webView?.load(pageRequest)
    }
}
