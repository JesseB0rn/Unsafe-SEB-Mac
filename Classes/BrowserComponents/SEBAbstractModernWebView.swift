//
//  SEBAbstractModernWebView.swift
//  SafeExamBrowser
//
//  Created by Daniel R. Schneider on 03.03.21.
//

import Foundation

@objc public class SEBAbstractModernWebView: NSObject, SEBAbstractBrowserControllerDelegate, SEBAbstractWebViewNavigationDelegate {
    
    public var wkWebViewConfiguration: WKWebViewConfiguration {
        let webViewConfiguration = navigationDelegate!.wkWebViewConfiguration
        let userContentController = WKUserContentController()
        let jsCode = """
var SafeExamBrowser = function() {}; \
SafeExamBrowser.security = function() {}; \
var newSecurity = new SafeExamBrowser.security(); \
var SafeExamBrowser = new SafeExamBrowser(); \
SafeExamBrowser.security = newSecurity; \
SafeExamBrowser.security.browserExamKey = {};
SafeExamBrowser.security.configKey = {};
SafeExamBrowser.security.appVersion = {};
"""
        let userScript = WKUserScript(source: jsCode, injectionTime: WKUserScriptInjectionTime.atDocumentStart, forMainFrameOnly: false)
        userContentController.addUserScript(userScript)
        webViewConfiguration.userContentController = userContentController
        return webViewConfiguration
    }
    
    public var customSEBUserAgent: String {
        return navigationDelegate!.customSEBUserAgent!
    }
    

    @objc public var browserControllerDelegate: SEBAbstractBrowserControllerDelegate?
    @objc weak public var navigationDelegate: SEBAbstractWebViewNavigationDelegate?


    @objc public override init() {
        super.init()
        let sebWKWebViewController = SEBiOSWKWebViewController()
        sebWKWebViewController.navigationDelegate = self
        self.browserControllerDelegate = sebWKWebViewController
    }
    
    public func loadView() {
        browserControllerDelegate?.loadView?()
    }
    
    public func didMoveToParentViewController() {
        browserControllerDelegate?.didMoveToParentViewController?()
    }
    
    public func viewDidLayoutSubviews() {
        browserControllerDelegate?.viewDidLayoutSubviews?()
    }
    
    public func viewWillTransitionToSize() {
        browserControllerDelegate?.viewWillTransitionToSize?()
    }
    
    public func viewWillAppear(_ animated: Bool) {
        browserControllerDelegate?.viewWillAppear?(animated)
    }
    
    public func viewDidAppear(_ animated: Bool) {
        browserControllerDelegate?.viewDidAppear?(animated)
    }
    
    public func viewWillDisappear(_ animated: Bool) {
        browserControllerDelegate?.viewWillDisappear?(animated)
    }
    
    public  func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        browserControllerDelegate?.viewWillTransitionToSize?()
    }
    
    public func nativeWebView() -> Any {
        return browserControllerDelegate?.nativeWebView() as Any
    }
    
    public func url() -> URL? {
        return browserControllerDelegate?.url()
    }
    
    public func pageTitle() -> String? {
        return browserControllerDelegate?.pageTitle()
    }
    
    public func canGoBack() -> Bool {
        return browserControllerDelegate?.canGoBack() ?? false
    }
    
    public func canGoForward() -> Bool {
        return browserControllerDelegate?.canGoForward() ?? false
    }
    
    public func goBack() {
        browserControllerDelegate?.goBack()
    }
    
    public func goForward() {
        browserControllerDelegate?.goForward()
    }
    
    public func reload() {
        browserControllerDelegate?.reload()
    }
    
    public func load(_ url: URL) {
        browserControllerDelegate?.load(url)
    }
    
    public func stopLoading() {
        browserControllerDelegate?.stopLoading()
    }

    public func toggleScrollLock() {
        browserControllerDelegate?.toggleScrollLock?()
    }
    
    public func isScrollLockActive() -> Bool {
        return browserControllerDelegate?.isScrollLockActive?() ?? false
    }
    
    public func loadWebPageOrSearchResult(with webSearchString: String) {
        browserControllerDelegate?.loadWebPageOrSearchResult?(with: webSearchString)
    }
    
    public func openCloseSliderForNewTab() {
        browserControllerDelegate?.openCloseSliderForNewTab?()
    }
    
    public func switchToTab(_ sender: Any?) {
        browserControllerDelegate?.switchToTab?(sender)
    }
    
    public func switchToNextTab() {
        browserControllerDelegate?.switchToNextTab?()
    }
    
    public func switchToPreviousTab() {
        browserControllerDelegate?.switchToPreviousTab?()
    }
    
    public func closeTab() {
        browserControllerDelegate?.closeTab?()
    }
    
    public func conditionallyDownloadAndOpenSEBConfig(from url: URL) {
        browserControllerDelegate?.conditionallyDownloadAndOpenSEBConfig?(from: url)
    }
    
    public func conditionallyOpenSEBConfig(from sebConfigData: Data) {
        browserControllerDelegate?.conditionallyOpenSEBConfig?(from: sebConfigData)
    }
    
    public func shouldStartLoadFormSubmittedURL(_ url: URL) {
        browserControllerDelegate?.shouldStartLoadFormSubmittedURL?(url)
    }
    
    public func sessionTaskDidCompleteSuccessfully(_ task: URLSessionTask) {
        browserControllerDelegate?.sessionTaskDidCompleteSuccessfully?(task)
    }
    
    /// SEBAbstractWebViewNavigationDelegate Methods

    public func setLoading(_ loading: Bool) {
        navigationDelegate?.setLoading(loading)
    }
    
    public func setCanGoBack(_ canGoBack: Bool, canGoForward: Bool) {
        navigationDelegate?.setCanGoBack(canGoBack, canGoForward: canGoForward)
    }
    
    public func openNewTab(with url: URL) {
        navigationDelegate?.openNewTab(with: url)
    }
    
    public func examine(_ cookies: [HTTPCookie]) {
        navigationDelegate?.examine(cookies)
    }
    
    public func sebWebViewDidStartLoad() {
        navigationDelegate?.sebWebViewDidStartLoad?()
    }
    
    public func sebWebViewDidFinishLoad() {
        navigationDelegate?.sebWebViewDidFinishLoad?()
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation) {
        let browserExamKey = navigationDelegate?.browserExamKey?(for: webView.url!)
        let configKey = navigationDelegate?.configKey?(for: webView.url!)
        let appVersion = navigationDelegate?.appVersion?()

        webView.evaluateJavaScript("SafeExamBrowser.security.browserExamKey = '\(browserExamKey ?? "")';SafeExamBrowser.security.configKey = '\(configKey ?? "")';SafeExamBrowser.security.appVersion = '\(appVersion ?? "")'") { (response, error) in
            if let _ = error {
                print(error as Any)
            }
        }
        navigationDelegate?.sebWebViewDidFinishLoad?()
    }
    
    public func sebWebViewDidFailLoadWithError(_ error: Error) {
        navigationDelegate?.sebWebViewDidFailLoadWithError?(error)
    }
    
    public func sebWebViewShouldStartLoad(with request: URLRequest, navigationAction: WKNavigationAction, newTab: Bool) -> Bool {
        return (navigationDelegate?.sebWebViewShouldStartLoad?(with: request, navigationAction: navigationAction, newTab: newTab) ?? false)
    }
    
    public func sebWebViewDidUpdateTitle(_ title: String?) {
        navigationDelegate?.sebWebViewDidUpdateTitle?(title)
    }
    
    public func sebWebViewDidUpdateProgress(_ progress: Double) {
        navigationDelegate?.sebWebViewDidUpdateProgress?(progress)
    }
    
    public func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        navigationDelegate?.webView?(webView, runJavaScriptAlertPanelWithMessage: message, initiatedByFrame: frame, completionHandler: completionHandler)
    }
    
    public func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        navigationDelegate?.webView?(webView, runJavaScriptConfirmPanelWithMessage: message, initiatedByFrame: frame, completionHandler: completionHandler)
    }
    
    private func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        navigationDelegate?.webView?(webView, runJavaScriptTextInputPanelWithPrompt: prompt, defaultText: defaultText, initiatedByFrame: frame, completionHandler: completionHandler)
    }

    public func modifyRequest(_ request: URLRequest) -> URLRequest {
        return (navigationDelegate?.modifyRequest?(request)) ?? request
    }
    
    public func browserExamKey(for url: URL) -> String {
        return (navigationDelegate?.browserExamKey?(for: url) ?? "")
    }
    
    public func configKey(for url: URL) -> String {
        return (navigationDelegate?.configKey?(for: url) ?? "")
    }
    
    public func appVersion() -> String {
        return (navigationDelegate?.appVersion?() ?? "")
    }
    
    public func setTitle(_ title: String) {
        navigationDelegate?.setTitle(title)
    }
    
    public func backgroundTintStyle () -> SEBBackgroundTintStyle {
        return navigationDelegate?.backgroundTintStyle?() ?? SEBBackgroundTintStyleDark
    }
    
    public var uiAlertController: Any?
    
    
}
