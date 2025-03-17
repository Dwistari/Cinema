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
    private var activityIndicator: UIActivityIndicatorView!
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)
    private var isInternetIssues = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupWebView()
        setupActivityIndicator()
        checkInternetAndLoadPage()
    }
    
    private func checkInternetAndLoadPage() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                if path.status == .satisfied {
                    self.loadMoviePage()
                } else {
                    self.isInternetIssues = true
                    self.showErrorAlert(message: "No Internet Connection. Please check your network and try again.")
                }
            }
        }
        monitor.start(queue: queue)
    }

    private func setupWebView() {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.websiteDataStore = WKWebsiteDataStore.nonPersistent() // Use non-persistent session
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
        guard let imdbId = imdbId, let url = URL(string: UrlConstants.imdbUrl + imdbId) else {
            showErrorAlert(message: "Invalid IMDb ID. Unable to load the page.")
            return
        }
        let request = URLRequest(url: url)
        webView.load(request)
    }

    private func showErrorAlert(message: String? = nil) {
        let alert = UIAlertController(
            title: "Error",
            message: message ?? "Something went wrong.",
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
        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet:
                showErrorAlert(message: "No Internet Connection. Please check your network and try again.")
            case .timedOut:
                showErrorAlert(message: "The request timed out. Please try again later.")
            default:
                showErrorAlert(message: "Failed to load the page. Please try again.")
            }
        } else {
            showErrorAlert(message: "An unexpected error occurred.")
        }
    }
}
