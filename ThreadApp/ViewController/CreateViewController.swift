//
//  CreateViewController.swift
//  ThreadApp
//
//  Created by cheshire on 2023/08/14.
//

import UIKit



class CreateViewController: UIViewController, UITextViewDelegate {
    
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var threadText: UITextView!
    
    @IBOutlet weak var threadTitle: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rightButton = UIBarButtonItem(title: "게시", style: .plain, target: self, action: #selector(yourFunction))
        self.navigationItem.rightBarButtonItem = rightButton
        
        // UITextViewDelegate 설정
        threadText.delegate = self
        
        // 키보드 관련 Notification 설정
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), // 왼쪽에 공간을 만들어서 버튼을 오른쪽으로 밀어줍니다.
            UIBarButtonItem(title: "게시", style: .done, target: self, action: #selector(createButton(_:)))
        ]
        threadText.inputAccessoryView = toolbar
        // 사용자 이름 불러오기
        let userNameText = loadUserName()
        
        // 사용자 이름을 라벨에 표시
        userName.text = userNameText
    }
    
    deinit {
        // Notification 제거
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func yourFunction(){
        print("안녕")
    }
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createButton(_ sender: UIBarButtonItem) {
        // 사용자 이름 불러오기
        let userNameText = loadUserName()
        print(userNameText)
        
        
        
        let title = threadTitle.text ?? ""
        let text = threadText.text ?? ""
        let currentDateTime = Date()
        
        // 사용자 이름을 불러옵니다.
        let authorName = loadUserName()
        
        let author = Profile(photoData: nil, name: authorName, bio: "UserBio")
        let newThread = Thread(title: title, createdAt: currentDateTime, content: text, photoData: nil, authorProfile: author, comments: nil)
        
        ThreadStore.shared.addThread(thread: newThread)
        
        print("게시되었습니다.")
        printStoredThreads()
        
        // 게시글 게시 후 모달 내리기
        self.dismiss(animated: true, completion: nil)
    }
    
    // UITextViewDelegate 메소드
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "스레드를 시작하세요..." { // 플레이스 홀더 체크
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "여기에 내용을 입력하세요."
            textView.textColor = .lightGray
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        // 필요한 경우 뷰를 올리는 로직 추가
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height / 3  // 뷰를 키보드 높이의 1/3만큼 위로 이동
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        // 필요한 경우 뷰를 원래 위치로 내리는 로직 추가
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func printStoredThreads() {
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
    func loadUserName() -> String {
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
    
}

