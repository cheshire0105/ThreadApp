//
//  ThreadDataSingleton.swift
//  ThreadApp
//
//  Created by cheshire on 2023/08/14.
//

import Foundation

class ThreadStore {
    static let shared = ThreadStore() // 싱글톤 패턴
    private init() {} // 외부에서 직접 인스턴스화를 방지하기 위해 private로 설정
    
    var threads: [Thread] = [] // Thread 객체들을 저장할 배열
    private let threadsKey = "savedThreads"
    private let profileKey = "profile"
    
}

extension ThreadStore {
    
    // UserDefaults에 모든 Thread 저장
    func saveThreads() {
        do {
            let encoder = JSONEncoder()
            let encodedThreads = try encoder.encode(threads)
            UserDefaults.standard.set(encodedThreads, forKey: threadsKey)
        } catch {
            print("Failed to encode threads: \(error)")
        }
    }
    
    func loadProfile() -> Profile?  {
        do {
            guard let savedProfileData = UserDefaults.standard.data(forKey: profileKey) else { return nil }
            let profileData = try JSONDecoder().decode(Profile.self, from: savedProfileData)
            return profileData
        } catch {
            return nil
        }
    }
    
    // UserDefaults에서 모든 Thread 로드
    func loadThreads() {
        guard let savedThreads = UserDefaults.standard.data(forKey: threadsKey) else { return }
        do {
            let decoder = JSONDecoder()
            threads = try decoder.decode([Thread].self, from: savedThreads)
        } catch {
            print("Failed to decode threads: \(error)")
        }
    }
    
    // 추가된 스레드를 UserDefaults에 저장
    func addThread(thread: Thread) {
        threads.insert(thread, at: 0) // 맨 앞에 삽입
        saveThreads()
        NotificationCenter.default.post(name: Notification.Name("ThreadDataChanged"), object: nil)
    }

    
    func deleteThread(at index: Int) {
        if index >= 0 && index < threads.count {
            threads.remove(at: index)
            saveThreads()
            NotificationCenter.default.post(name: Notification.Name("ThreadDataChanged"), object: nil)
        } else {
            print("Invalid index: \(index)")
        }
    }

    
 
}

