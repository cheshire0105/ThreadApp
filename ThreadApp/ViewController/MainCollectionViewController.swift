//
//  MainCollectionViewCell.swift
//  ThreadApp
//
//  Created by hong on 2023/08/14.
//

import UIKit

final class MainCollectionViewCell: UICollectionViewCell {

    static let identifier = String(describing: MainCollectionViewCell.self)
    
    @IBOutlet weak var authorProfileImageView: UIImageView!
    @IBOutlet weak var authorProfileNameLabel: UILabel!
    @IBOutlet weak var threadWrittenDateLabel: UILabel!
    @IBOutlet weak var threadContentLabel: UILabel!
    @IBOutlet weak var threadImageView: UIImageView!
    @IBOutlet weak var threadCommentCountLabel: UILabel!
    @IBOutlet weak var threadStackView: UIStackView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    var threadStackViewTapped: ((Thread) -> Void)? = nil
    private var thread: Thread? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let threadStackViewDidTappedGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(threadStackDidTapped))
        threadStackView.addGestureRecognizer(threadStackViewDidTappedGestureRecognizer)
    }

    func bind(thread: Thread) {
        titleLabel.text = thread.title

        if let authorProfileImageData = thread.authorProfile.photoData {
            authorProfileImageView.image = UIImage(data: authorProfileImageData)
        }
        if let threadImageData = thread.photoData {
            threadImageView.image = UIImage(data: threadImageData)
        }
        authorProfileNameLabel.text = thread.authorProfile.name
        threadWrittenDateLabel.text = Date.difference(of: thread.createdAt)
        threadContentLabel.text = thread.content
        if let threadComments = thread.comments {
            threadCommentCountLabel.text = "댓글 개수 \(threadComments.count)개 "
        } else {
            threadCommentCountLabel.text = "댓글 개수 0 개"
        }
        self.thread = thread

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        authorProfileImageView.image = nil
        threadImageView.image = nil
        authorProfileNameLabel.text = ""
        threadWrittenDateLabel.text = ""
        threadContentLabel.text = ""
        threadCommentCountLabel.text = ""
        thread = nil
    }
    
    @objc private func threadStackDidTapped(_ sender: UIGestureRecognizer) {
        guard let thread,
              let threadStackViewTapped else {return}
        threadStackViewTapped(thread)
    }

}

extension Date {
    enum formatType: String {
        case second = "ss"
        case minute = "mm"
        case hour = "hh"
        case date = "dd"
        case yearMonthDate = "yyyy-MM-dd"
    }
    
    static func difference(of date: Date) -> String {
        let timeInterval = Date().timeIntervalSince(date)
        if timeInterval.secondsDifference >= 0 {
            return "\(timeInterval.secondsDifference)초"
        } else if timeInterval.minuteDifference > 0 {
            return "\(timeInterval.minuteDifference)분"
        } else if timeInterval.hourDifference > 0 {
            return "\(timeInterval.hourDifference)시간"
        } else {
            return "\(timeInterval.dayDifference)일"
        }
    }
}


extension TimeInterval {
    var dayDifference: Int {
        Int(self / 150.0)
    }
    var hourDifference: Int {
        Int(self / 3600.0)
    }
    var minuteDifference: Int {
        Int(self) % 3600 / 60
    }
    var secondsDifference: Int {
        Int(self) % 60
    }
}
