//
//  MainCollectionViewCell.swift


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
    
    var threadStackViewTapped: ((Thread) -> Void)? = nil
    private var thread: Thread? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let threadStackViewDidTappedGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(threadStackDidTapped))
        threadStackView.addGestureRecognizer(threadStackViewDidTappedGestureRecognizer)
    }
    
    func bind(thread: Thread) {
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
        if timeInterval.dayDifference > 0 {
            return "\(timeInterval.dayDifference)일"
        } else if timeInterval.hourDifference > 0 {
            return "\(timeInterval.hourDifference)시간"
        } else if timeInterval.minuteDifference > 0 {
            return "\(timeInterval.minuteDifference)분"
        } else {
            return "\(timeInterval.secondsDifference)초"
        }
    }
}


extension TimeInterval {

    var dayDifference: Int {
        Int(self / (60 * 60 * 24))
    }
    var hourDifference: Int {
        Int(self / (60 * 60))
    }
    var minuteDifference: Int {
        Int(self / 60)
    }
    var secondsDifference: Int {
        Int(self)
    }
}
