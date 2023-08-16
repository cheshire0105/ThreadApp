//
//  ViewController.swift
//  ThreadApp
//
//  Created by cheshire on 2023/08/14.
//

import UIKit

class ViewController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 탭 바 컨트롤러의 델리게이트로 현재 뷰 컨트롤러를 설정
        self.delegate = self
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        // 중간의 탭 바 아이템이 선택되었을 경우
        if viewController is CreateViewController {  // 여기서 'YourTargetViewController'는 중간 탭의 뷰 컨트롤러 타입입니다.
            
            // 원하는 스토리보드의 뷰 컨트롤러를 로드
            let storyboard = UIStoryboard(name: "Create", bundle: nil)
            if let modalViewController = storyboard.instantiateInitialViewController() {
                present(modalViewController, animated: true, completion: nil)
                return false  // 탭 변경을 방지
            }
        }
        return true
    }
    
    
}

