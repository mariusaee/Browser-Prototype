//
//  BrowserViewController.swift
//  Browser Prototype
//
//  Created by Marius Malyshev on 10.06.2023.
//

import UIKit
import WebKit

protocol HistoryURLSelectionDelegate {
    func openURLFromHistoryVC(_ url: URL)
}

final class BrowserViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var webView: WKWebView!
    
    private var history = [String]()
    private let dataSource = DataService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureWebView()
        configureTextField()
        history = dataSource.loadHistory()
    }
    
    @IBAction func historyButtonTapped() {
        let historyVC = HistoryViewController()
        historyVC.setupViewControllerWith(history)
        historyVC.delegate = self
        navigationController?.present(historyVC, animated: true)
    }
}

extension BrowserViewController: WKNavigationDelegate {
    private func configureWebView() {
        webView.navigationDelegate = self
        webView.backgroundColor = .white
        webView.allowsBackForwardNavigationGestures = true
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let link = webView.url?.absoluteString ?? ""
        
        appendNewLinkToHistory(link)
        
        if navigationAction.navigationType == .linkActivated {
            let link = navigationAction.request.mainDocumentURL?.absoluteString ?? ""
            appendNewLinkToHistory(link)
        }
        
        decisionHandler(.allow)
    }
    
    private func appendNewLinkToHistory(_ link: String) {
        if history.last != link {
            history.append(link)
            dataSource.saveHistory(history)
        }
    }
}

extension BrowserViewController: UITextFieldDelegate {
    private func configureTextField() {
        textField.delegate = self
        textField.placeholder = Constants.Placeholders.browserTextField
        textField.keyboardType = .URL
        textField.autocorrectionType = .no
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return false }
        
        guard let url = URIFixup.getURL(text) else {
            searchText(text)
            return false
        }
        openURL(url)
        return true
    }
    
    private func openURL(_ url: URL) {
        let request = URLRequest(url: url)
        webView.load(request)
        webView.becomeFirstResponder()
    }
    
    private func searchText(_ text: String) {
        guard let searchUrl = URL(string: (Constants.SearchQueries.google + text).encodeUrl) else { return }
        openURL(searchUrl)
    }
}

extension BrowserViewController: HistoryURLSelectionDelegate {
    func openURLFromHistoryVC(_ url: URL) {
        openURL(url)
        textField.text = url.absoluteString
    }
}
