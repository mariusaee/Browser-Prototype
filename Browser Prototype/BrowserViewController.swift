//
//  BrowserViewController.swift
//  Browser Prototype
//
//  Created by Marius Malyshev on 10.06.2023.
//

import UIKit
import WebKit

final class BrowserViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureWebView()
        configureTextField()
    }
    
    @IBAction func historyButtonTapped() {
        // open HistoryVC
        print(webView.backForwardList)
        let historyVC = HistoryViewController()
        navigationController?.present(historyVC, animated: true)
    }
}

extension BrowserViewController: WKNavigationDelegate {
    private func configureWebView() {
        webView.navigationDelegate = self
        webView.backgroundColor = .white
        webView.allowsBackForwardNavigationGestures = true
    }
}

extension BrowserViewController: UITextFieldDelegate {
    private func configureTextField() {
        textField.delegate = self
        textField.placeholder = "Enter website"
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
        guard let searchUrl = URL(string: "https://www.google.com/search?q=\(text)".encodeUrl) else { return }
        openURL(searchUrl)
    }
}



