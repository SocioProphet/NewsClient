//
//  NewsController.swift
//  NewsClient
//
//  Created by Taras Didukh on 12.10.2019.
//  Copyright © 2019 Taras Didukh. All rights reserved.
//

import UIKit
import SafariServices

class NewsController: UITableViewController {
    
    var isEnd: Bool {
        set {
            tableView.tableFooterView = newValue ?
                UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 1)) :
                footerView
        }
        get {
            return tableView.tableFooterView != footerView
        }
    }
    var isLoading = false {
        didSet {
            if !isLoading {
                self.searchController.searchBar.isLoading = false
                view.activityIndicator(false)
                refresh.endRefreshing()
            }
        }
    }

    let refresh = UIRefreshControl()
    let searchController = UISearchController(searchResultsController: nil)
    var footerView: UIView?
    
    var newsService: NewsServicing?
    var page = 1
    var news = [Article]()
    
    var searchQuery: String = ""
    var filter = FilterType.all
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "News"
        
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            tableView.tableHeaderView = searchController.searchBar
        }
        
        definesPresentationContext = true
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.scopeButtonTitles = FilterType.allCases.map{$0.rawValue.prefix(1).capitalized + $0.rawValue.dropFirst()}
        searchController.searchBar.delegate = self
        
        footerView = tableView.tableFooterView
        isEnd = true
        
        refreshControl = refresh
        refresh.addTarget(self, action: #selector(refreshNews), for: .valueChanged)
        
        self.view.activityIndicator(true)
        loadNews()
    }
    
    @objc func refreshNews() { self.loadNews() }
    
    func loadNews(update: Bool = true) {
        isLoading = true
        page = update ? 1 : page + 1
        let params = NewsParameters(query: searchQuery, page: page, filter: filter)
        newsService?.fetchNews(params: params, completionHandler: { [weak self] result in
            DispatchQueue.main.async {
                guard let this = self else { return }
                switch result {
                case .success(let news):
                    print("-----------------------\n\(news.totalResults ?? 0)\n-----------------------\n")
                    if this.page == 1 {
                        this.news = news.articles ?? []
                    } else {
                        this.news.append(contentsOf: news.articles ?? [])
                    }
                    this.tableView.reloadData()
                    
                    this.isEnd = news.articles == nil || news.articles!.count < params.pageSize
                    
                    if news.message?.isEmpty == false {
                        this.displayAlert(key: news.code ?? news.message!, message: news.message!)
                    }
                    this.tableView.emptyList(this.news.isEmpty, "News not found")
                case .failure(let error):
                    this.isEnd = true
                    this.handleError(error)
                }
                this.isLoading = false
            }
        })
    }
    
    func handleError(_ error: NetworkError) {
        var title = ""
        var message = ""
        switch error {
        case .clientError:
            title = "Client Error"
            message = "Problem on user side, check if everything is OK"
        case .serverError:
            title = "Server Error"
            message = "Server isn't working correctly, try again later"
        case .parseError:
            title = "Unexpected result"
        case .unexpectedError:
            title = "Unexpected error, try again"
        }
        self.displayAlert(key: title, title: title, message: message)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.reusableIdentifier, for: indexPath) as? NewsCell {
            
            let article = news[indexPath.row]
            cell.lbTitle.text = article.title
            cell.lbDescription.text = article.description
            cell.lbAuthor.text = article.author
            cell.btnSource.setTitle(article.source?.name, for: .normal)
            cell.btnSource.isHidden = article.source?.name?.isEmpty != false
            cell.url = article.urlToImage

            return cell
        }

        return tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .default, reuseIdentifier: "Cell")
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = tableView.contentOffset.y
        let contentHeight = tableView.contentSize.height

        if offsetY > contentHeight - scrollView.frame.size.height && !isLoading && !isEnd {
            loadNews(update: false)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let link = news[indexPath.row].url, let url = URL(string: link) {
            let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            vc.delegate = self

            present(vc, animated: true)
        }
    }
}

extension NewsController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchQuery = searchText
        searchController.searchBar.isLoading = true
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
            self.loadNews()
        })
    }
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filter = FilterType.allCases[selectedScope]
        if !searchQuery.isEmpty {
            searchController.searchBar.isLoading = true
            self.loadNews()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchQuery = ""
        timer?.invalidate()
        self.loadNews()
    }
}

extension NewsController : SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true)
    }
}
