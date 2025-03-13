//
//  WebViewViewController.swift
//  Cinema
//
//  Created by Dwistari on 13/03/25.
//

import UIKit
import WebKit
import Network

class WebViewController: UIViewController, WKNavigationDelegate {

    var webView: WKWebView!
    var imdbId: String?
    private let baseURL = "https://www.imdb.com/title/"
    private var activityIndicator: UIActivityIndicatorView!
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)
    private var isInternetIssues = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupWebView()
        setupActivityIndicator()
        checkInternetAndLoadPage()
        
        // Add Refresh Button only if inside NavigationController
        if navigationController != nil {
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .refresh,
                target: self,
                action: #selector(refreshPage)
            )
        }
    }
    
    private func checkInternetAndLoadPage() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                if path.status == .satisfied {
                    self.loadMoviePage()
                } else {
                    self.isInternetIssues = true
                    self.showErrorAlert()
                }
            }
        }
        monitor.start(queue: queue)
    }

    private func setupWebView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)

        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }

    private func loadMoviePage() {
        guard let imdbId = imdbId, let url = URL(string: baseURL + imdbId) else {
            showErrorAlert()
            return
        }
        webView.load(URLRequest(url: url))
    }
    
    @objc func refreshPage() {
        webView.reload()
    }

    private func showErrorAlert() {
        let alert = UIAlertController(
            title: isInternetIssues ? "No Internet Connection" :  "Error",
            message: isInternetIssues ?  "Please check your network and try again." : "Invalid IMDb ID. Unable to load the page.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
              self.navigationController?.popViewController(animated: true)
          }))
        present(alert, animated: true)
    }


   // MARK: - WKNavigationDelegate Methods
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityIndicator.startAnimating()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
        showErrorAlert()
    }
}
