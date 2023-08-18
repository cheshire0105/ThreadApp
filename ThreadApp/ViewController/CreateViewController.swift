//
//  CreateViewController.swift
//  ThreadApp
//
//  Created by cheshire on 2023/08/14.
//

import UIKit



final class CreateViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var threadText: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var threadImageView: UIImageView!
    private var selectedImageData: Data? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureThreadTextView()
        configureKeyboardSetting()
        configureProfileInformationViews()

    }

    deinit {
        // Notification 제거
        NotificationCenter.default.removeObserver(self)
    }
    
    private func configureThreadTextView() {
        threadText.isScrollEnabled = false
        // UITextViewDelegate 설정
        threadText.delegate = self
        threadText.translatesAutoresizingMaskIntoConstraints = false
        threadText.heightAnchor.constraint(equalToConstant: 50).isActive = true
        threadText.layer.borderWidth = 1
        threadText.layer.borderColor = UIColor.black.cgColor
        threadText.text = "여기에 내용을 입력하세요."
        threadText.textColor = .lightGray
        textViewDidChange(threadText)
    }
    
    private func configureKeyboardSetting() {
        // 키보드 관련 Notification 설정
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func configureProfileInformationViews() {
        if let profile = ThreadStore.shared.loadProfile() {
            userName.text = profile.name
            if let profileImageData = profile.photoData {
                profileImageView.image = UIImage(data: profileImageData)
            }
        }
        
        threadImageView.isUserInteractionEnabled = true
        let threadImageViewGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        threadImageView.addGestureRecognizer(threadImageViewGestureRecognizer)
    }

    @IBAction private func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func imageViewTapped(_ sender: UITapGestureRecognizer) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction private func postingButtonTapped(_ sender: Any) {
        // 사용자 이름 불러오기
        let userNameText = loadUserName()
        print(userNameText)
        
        let text = threadText.text ?? ""
        let currentDateTime = Date()
        
        // 사용자 이름을 불러옵니다.
        let authorName = loadUserName()
        
        let authorPhotoData = ThreadStore.shared.loadProfile()?.photoData
        let author = Profile(photoData: authorPhotoData, name: authorName, bio: "UserBio")
        let newThread = Thread(title: "", createdAt: currentDateTime, content: text, photoData: selectedImageData, authorProfile: author, comments: nil)
        
        ThreadStore.shared.addThread(thread: newThread)
        
        print("게시되었습니다.")
        printStoredThreads()
        
        // 게시글 게시 후 모달 내리기
        self.dismiss(animated: true, completion: nil)
        self.view.isUserInteractionEnabled = true
    }
    
    @objc private func printStoredThreads() {
        guard let savedThreadsData = UserDefaults.standard.data(forKey: "savedThreads") else {
            print("No threads saved in UserDefaults.")
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let decodedThreads = try decoder.decode([Thread].self, from: savedThreadsData)
            print(decodedThreads)
        } catch {
            print("Failed to decode saved threads: \(error)")
        }
    }
    
    private func loadUserName() -> String {
        do {
            if let savedProfile = UserDefaults.standard.object(forKey: "profile") as? Data {
                let profile = try JSONDecoder().decode(Profile.self, from: savedProfile)
                return profile.name
            }
        } catch {
            print("Failed to load profile: \(error)")
        }
        return "Unknown User"
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        // 필요한 경우 뷰를 올리는 로직 추가
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            scrollView.contentInset.bottom = keyboardSize.height
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        // 필요한 경우 뷰를 원래 위치로 내리는 로직 추가
        scrollView.contentInset = .zero
    }
    
}

extension CreateViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            selectedImageData = image.pngData()
            DispatchQueue.main.async { [weak self] in
                self?.threadImageView.image = image
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

extension CreateViewController: UITextViewDelegate {
    // UITextViewDelegate 메소드
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "스레드를 시작하세요..." ||
            textView.text == "여기에 내용을 입력하세요." { // 플레이스 홀더 체크
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        view.endEditing(true)
        if textView.text == "" {
            textView.text = "여기에 내용을 입력하세요."
            textView.textColor = .lightGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: view.frame.width-20, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
