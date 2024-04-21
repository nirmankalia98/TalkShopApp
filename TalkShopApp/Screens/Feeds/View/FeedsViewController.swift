//
//  FeedsViewController.swift
//  TalkShopApp
//
//  Created by Nirman Kalia on 18/04/24.
//

import UIKit

/// `FeedsViewController` is a infiniti scroll screen for user to discover posts from other users on the platform

final class FeedsViewController: UIViewController {
    
    
    // MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    weak var feedsViewCoordinator: FeedViewCoordinator?
    private let refreshControl = UIRefreshControl()
    private let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
    private let debouncer = Debouncer(interval: 0.1)
    private let viewModel: FeedsViewModel
    
    init(viewModel: FeedsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: Self.identifier, bundle: nil)
        self.viewModel.viewDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchData()
        self.setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.updateVideoPlayback()
    }
    
       
    private func updateVideoPlayback(forcePause: Bool = false) {
        guard let visibleCells = tableView.visibleCells as? [FeedTableViewCell] else {
            return
        }
        
        var mostVisibleCell: FeedTableViewCell?
        var maxVisibleHeight: CGFloat = 0
        
        let tableViewVisibleRect = CGRect(x: 0, y: tableView.contentOffset.y, width: tableView.bounds.width, height: tableView.bounds.height)
        
        visibleCells.forEach { cell in
            let cellRect = tableView.rectForRow(at: tableView.indexPath(for: cell)!)
            let intersectedRect = tableViewVisibleRect.intersection(cellRect)
            let visibleHeight = intersectedRect.height
            
            if visibleHeight > maxVisibleHeight {
                maxVisibleHeight = visibleHeight
                mostVisibleCell = cell
            }
        }
        
        visibleCells.forEach { cell in
            if cell == mostVisibleCell, !forcePause {
                cell.play()
            } else {
                cell.pause()
            }
        }
    }
    
    func setupUI() {
        self.title = "Talk Shop"
        
        let profileBarItem = UIBarButtonItem(image: UIImage(systemName: "person.circle.fill"), style: .plain, target: self, action: #selector(showUserProfile))
        
        profileBarItem.tintColor = .gray
        self.navigationItem.rightBarButtonItem = profileBarItem
        self.tableView.delegate = self
        self.tableView.dataSource = self
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: self.tableView.bounds.width, height: CGFloat(44))
        spinner.startAnimating()
        self.tableView.tableFooterView = spinner
        self.tableView.tableFooterView?.isHidden = false
        self.registerCells()
    }
    func registerCells() {
        self.tableView.register(cellType: FeedTableViewCell.self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        updateVideoPlayback(forcePause: true)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        self.viewModel.refetchData()
    }
    
    @objc func showUserProfile(_ sender: AnyObject) {
        self.feedsViewCoordinator?.moveToCurrentProfile()
    }
}

extension FeedsViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.debouncer.debounce { [weak self] in
            self?.updateVideoPlayback()
        }
    }
}
extension FeedsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.pushProfile(index: indexPath)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.viewModel.checkToFetchMore(indexPath: indexPath)
        let cell: FeedTableViewCell = self.tableView.dequeueReusableCell(for: indexPath)
        if let data = viewModel.getData(for: indexPath) {
            cell.setupCell(with: data, indexPath: indexPath, delegate: self)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView.frame.height*0.75
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows(for: section)
    }
}

extension FeedsViewController: FeedsViewModelDelegate {
    func setPaginationSate(hide: Bool) {
        DispatchQueue.main.async {
            if hide == false {
                self.spinner.startAnimating()
            }
            self.tableView.tableFooterView?.isHidden = hide
        }
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.setPaginationSate(hide: true)
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
            self.updateVideoPlayback()
        }
    }
    
    func pushProfile(index: IndexPath?) {
        guard let index = index, let data = viewModel.getData(for: index) else { return }
        let profile = ProfileInfo(userId: data.userId, username: data.username, profilePictureURL: data.userImageUrl)
        feedsViewCoordinator?.moveToUserProfile(profile: profile)
    }
}

extension FeedsViewController: FeedTableViewCellDelegate {
    func didTapOnUser(index: IndexPath?) {
        self.pushProfile(index: index)
    }
    
    func didLikePost(didLike: Bool, index: IndexPath?) {
        guard let index = index else {
            debugPrint(#function,"invalid indexpath")
            return
        }
        self.viewModel.sendLike(didLike: didLike, index: index)
    }
    
    func clickOnVideo(index: IndexPath?, seekTime: Double) {
        guard let index = index, let data = viewModel.getData(for: index) else { return }
        feedsViewCoordinator?.moveToPost(data: data, seekTime: seekTime)
    }
}

extension FeedsViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if let cell = self.tableView.cellForRow(at: indexPath) as? FeedTableViewCell, let data = viewModel.getData(for: indexPath) {
                ImageLoader.shared.request(data.thumbnailURL ?? "", completion: {_ in})
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if let cell = self.tableView.cellForRow(at: indexPath) as? FeedTableViewCell, let data = viewModel.getData(for: indexPath) {
                ImageLoader.shared.cancelRequest(data.thumbnailURL ?? "")
            }
        }
    }
}
