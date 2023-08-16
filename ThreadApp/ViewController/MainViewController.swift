//
//  MainViewController.swift
//  ThreadApp
//
//  Created by hong on 2023/08/14.
//

import UIKit

final class MainViewController: UIViewController {
    
    @IBOutlet weak var threadsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        threadsCollectionConfigure()
    }
    
    private func threadsCollectionConfigure() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 300)
        threadsCollectionView.collectionViewLayout = layout
        threadsCollectionView.register(
            UINib(nibName: MainCollectionViewCell.identifier, bundle: nil),
            forCellWithReuseIdentifier: MainCollectionViewCell.identifier
        )
        threadsCollectionView.delegate = self
        threadsCollectionView.dataSource = self
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
        cell.bind(thread: .init(title: "테스트", createdAt: .init(), content: "wetweatewatwea", photoData: UIImage(systemName: "pencil")?.pngData(), authorProfile: .init(photoData: UIImage(systemName: "pencil")?.pngData(), name: "반가워", bio: "정보")))
        return cell
    }
    
}

