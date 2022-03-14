//
//  WebView.swift
//  AllYouNeed
//
//  Created by Shubham Kumar on 10/02/22.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    func makeCoordinator() -> Coordinator {
        Coordinator(didStart: {
            showLoading = true
        }, didFinish: {
            showLoading = false
            shouldRefresh = false
        })
    }
    
    //MARK: PROPERTIES
    var url : URL
    @Binding var showLoading:Bool
    @Binding var shouldRefresh: Bool
    
    //MARK: FUNCTIONS
    func makeUIView(context: Context) -> WKWebView {
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = preferences
        let webView = WKWebView(frame: .zero, configuration: config)
        let request = URLRequest(url: url)
        webView.load(request)
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        if shouldRefresh {
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }
    
    //MARK: COORDINATOR
    class Coordinator: NSObject, WKNavigationDelegate {
        var didStart: () -> Void
        var didFinish: () -> Void
        
        init(didStart: @escaping () -> Void = {}, didFinish: @escaping () -> Void = {}) {
            self.didStart = didStart
            self.didFinish = didFinish
        }//:init
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            didStart()
        }//:didStart
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            didFinish()
        }//:didFinish
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            print("Error : ", error.localizedDescription)
        }//:didFail
        
    }
}
