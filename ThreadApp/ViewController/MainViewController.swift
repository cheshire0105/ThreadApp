//
//  MainViewController.swift
//  ThreadApp
//
//  Created by hong on 2023/08/14.
//

import UIKit

final class MainViewController: UIViewController {
    
    private enum Section {
        case main
    }
    //    private var mockThreads: [Thread] = [.init(title: "테스트", createdAt: .init(), content: "wetweatewatㄹㄴㅇㅁㄹㅁㅇㄴㅇㄴㄹㄹㅇㄴㅁㅇㄴㄹㅁㅇㄹㄴㅁㄹㅇㄴㄹㅁㅇㄴㄹㅁㅇㄴㄹㅁㅇㄴㄹㅇㄴㅁㄹㅁㄴㅇㄹㄴㅁㅇㄴㅁㄹㅇㄹㅁㄴㅇㅁㄹㄴㅇㅁㄹㄴㅇㅁㄹㄴㅇㅁㄹㄴㅇwea", photoData: UIImage(systemName: "pencil")?.pngData(), authorProfile: .init(photoData: UIImage(systemName: "pencil")?.pngData(), name: "반가워", bio: "정보")),.init(title: "테스트", createdAt: .init(), content: "wetweatewatㄹㄴㅇㅁㄹㅁㅇㄴㅇㄴㄹㄹㅇㄴㅁㅇㄴㄹㅁㅇㄹㄴㅁㄹㅇㄴㄹㅁㅇㄴㄹㅁㅇㄴㄹㅁㅇㄴㄹㅇㄴㅁㄹㅁㄴㅇㄹㄴㅁㅇㄴㅁㄹㅇㄹㅁㄴㅇㅁㄹㄴㅇㅁㄹㄴㅇㅁㄹㄴㅇㅁㄹㄴㅇwea", photoData: UIImage(systemName: "pencil")?.pngData(), authorProfile: .init(photoData: UIImage(systemName: "pencil")?.pngData(), name: "반가워", bio: "정보")),.init(title: "테스트", createdAt: .init(), content: "wetweatewatㄹㄴㅇㅁㄹㅁㅇㄴㅇㄴㄹㄹㅇㄴㅁㅇㄴㄹㅁㅇㄹㄴㅁㄹㅇㄴㄹㅁㅇㄴㄹㅁㅇㄴㄹㅁㅇㄴㄹㅇㄴㅁㄹㅁㄴㅇㄹㄴㅁㅇㄴㅁㄹㅇㄹㅁㄴㅇㅁㄹㄴㅇㅁㄹㄴㅇㅁㄹㄴㅇㅁㄹㄴㅇwea", photoData: UIImage(systemName: "pencil")?.pngData(), authorProfile: .init(photoData: UIImage(systemName: "pencil")?.pngData(), name: "반가워", bio: "정보")),.init(title: "테스트", createdAt: .init(), content: "wetweatewatㄹㄴㅇㅁㄹㅁㅇㄴㅇㄴㄹㄹㅇㄴㅁㅇㄴㄹㅁㅇㄹㄴㅁㄹㅇㄴㄹㅁㅇㄴㄹㅁㅇㄴㄹㅁㅇㄴㄹㅇㄴㅁㄹㅁㄴㅇㄹㄴㅁㅇㄴㅁㄹㅇㄹㅁㄴㅇㅁㄹㄴㅇㅁㄹㄴㅇㅁㄹㄴㅇㅁㄹㄴㅇwea", photoData: UIImage(systemName: "pencil")?.pngData(), authorProfile: .init(photoData: UIImage(systemName: "pencil")?.pngData(), name: "반가워", bio: "정보"))]
    //
    
    @IBOutlet weak var threadsCollectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Thread>!
    private lazy var snapshot = NSDiffableDataSourceSnapshot<Section, Thread>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
        // ThreadStore의 threads 배열에서 초기 데이터를 가져옴
        let initialThreads = ThreadStore.shared.threads
        applySnapshot(items: initialThreads)
        
        // 새로운 스레드가 추가되었을 때의 알림을 받도록 Observer를 추가
        NotificationCenter.default.addObserver(self, selector: #selector(reloadThreads), name: Notification.Name("NewThreadAdded"), object: nil)
    }
    
    @objc private func reloadThreads() {
        // ThreadStore의 threads 배열에서 새로운 데이터를 가져옴
        let newThreads = ThreadStore.shared.threads
        
        // 가져온 데이터를 사용하여 CollectionView를 업데이트
        applySnapshot(items: newThreads)
    }
    
    private func configure() {
        threadsCollectionConfigure()
    }
    
    private func threadsCollectionConfigure() {
        
        threadsCollectionView.collectionViewLayout = createCompositionalLayout()
        threadsCollectionView.register(
            UINib(nibName: MainCollectionViewCell.identifier, bundle: nil),
            forCellWithReuseIdentifier: MainCollectionViewCell.identifier
        )
        configureDataSource()
    }
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(100)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(100)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        
        let compositionalLayout = UICollectionViewCompositionalLayout(section: section)
        return compositionalLayout
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Thread>(
            collectionView: threadsCollectionView
        ) { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MainCollectionViewCell.identifier,
                for: indexPath
            ) as? MainCollectionViewCell else {return UICollectionViewCell()}
            cell.bind(thread: item)
            return cell
        }
    }
    
    private func applySnapshot(items: [Thread]) {
        snapshot.deleteAllItems()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

