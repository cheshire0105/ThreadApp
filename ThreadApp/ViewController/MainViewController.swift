//
//  MainViewController.swift
//  ThreadApp
//
//  Created by hong on 2023/08/14.
//

import UIKit

final class MainViewController: UIViewController {
    
    enum Section {
        case main
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, String>!
    
    
    @IBOutlet weak var threadsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
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
        threadsCollectionView.delegate = self
        threadsCollectionView.dataSource = self

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

}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return 5
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MainCollectionViewCell.identifier,
            for: indexPath
        ) as? MainCollectionViewCell else { return UICollectionViewCell() }
        cell.bind(thread: .init(title: "테스트", createdAt: .init(), content: "wetweatewatㄹㄴㅇㅁㄹㅁㅇㄴㅇㄴㄹㄹㅇㄴㅁㅇㄴㄹㅁㅇㄹㄴㅁㄹㅇㄴㄹㅁㅇㄴㄹㅁㅇㄴㄹㅁㅇㄴㄹㅇㄴㅁㄹㅁㄴㅇㄹㄴㅁㅇㄴㅁㄹㅇㄹㅁㄴㅇㅁㄹㄴㅇㅁㄹㄴㅇㅁㄹㄴㅇㅁㄹㄴㅇwea", photoData: UIImage(systemName: "pencil")?.pngData(), authorProfile: .init(photoData: UIImage(systemName: "pencil")?.pngData(), name: "반가워", bio: "정보")))
        cell.threadStackViewTapped = { thread in
            // 탭 시 행동
        }
        return cell
    }
    
}
