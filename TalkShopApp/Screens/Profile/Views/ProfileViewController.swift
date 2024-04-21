//
//  ProfileViewController.swift
//  TalkShopApp
//
//  Created by Nirman Kalia on 20/04/24.
//

import UIKit


class ProfileViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var viewModel: ProfileViewModel
    weak var profileViewCoordinator: ProfileViewCoordinator?

    init(viewModel: ProfileViewModel) {
        self.viewModel =  viewModel
        super.init(nibName: Self.identifier, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(PostLayoutHeader.self, supplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
        collectionView.register(PostViewCollectionCell.self)
        collectionView.registerNib(ProfileUserDetailsViewCell.self)
        collectionView.register(UICollectionViewCell.self)
        collectionView.setCollectionViewLayout(createLayout(), animated: true)
        collectionView.delegate = self
        collectionView.dataSource = self
        viewModel.delegate = self
        self.viewModel.fetchData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.profileViewCoordinator?.coordinatorDidFinish()
    }

}

extension ProfileViewController {
    func createHeaderSection() -> NSCollectionLayoutSection {
        let headerItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        let headerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.15)), subitems: [headerItem])
        
        return NSCollectionLayoutSection(group: headerGroup)
    }
    
    func createPostsSections() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let padding = 2.0
        item.contentInsets = .init(top: padding, leading: padding, bottom: padding, trailing: padding)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(1/3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        
        let section = NSCollectionLayoutSection(group: group)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(40))
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        section.boundarySupplementaryItems = [header]
        return section
    }
    
    func sectionFor(index: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let section = ProfileViewSection(rawValue: index)
        
        switch section {
        case .posts:
            return createPostsSections()
        default:
            return createHeaderSection()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == ProfileViewSection.posts.rawValue {
            guard let post = viewModel.post(at: indexPath.row) else {return}
            let profile = ProfileInfo(userId: nil, username: viewModel.userName, profilePictureURL: viewModel.profileImageUrl)
            self.profileViewCoordinator?.moveToPost(post: post, profile: profile)
        }
    }
    
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [weak self] index, env in
            return self?.sectionFor(index: index, environment: env)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = ProfileViewSection(rawValue: indexPath.section)
        switch section {
        case .posts:
            if kind == UICollectionView.elementKindSectionHeader {
                let headerView: PostLayoutHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, indexPath: indexPath)
                headerView.configure(with: "Posts ( \(viewModel.postCount) )")
                return headerView
            }
        default:
            break
        }
        return UICollectionReusableView()
    }
}

extension ProfileViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItems(for: section)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = ProfileViewSection(rawValue: indexPath.section)
        switch section {
        case .details:
            let cell: ProfileUserDetailsViewCell = self.collectionView.dequeueReusableCell(for: indexPath)
            cell.configure(with: viewModel.userName, imageURL: viewModel.profileImageUrl, badge: viewModel.bio, postCount: viewModel.postCount)
            return cell
        case .posts:
            let cell: PostViewCollectionCell = self.collectionView.dequeueReusableCell(for: indexPath)
            let feed = viewModel.post(at: indexPath.row)
            cell.configure(with: feed?.thumbnailURL ?? "")
                return cell
        default:
            break
        }
        return collectionView.dequeueReusableCell(for: indexPath)
    }
    
    
}

extension ProfileViewController: ProfileViewModelDelegate {
    func reloadData() {
        self.collectionView.reloadData()
    }
}
