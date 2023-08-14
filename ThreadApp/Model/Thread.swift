//
//  Thread.swift
//  ThreadApp
//
//  Created by cheshire on 2023/08/14.
//

import Foundation

struct Thread {
    var title: String
    var createdAt: Date
    var content: Int
    var photoData: Data?
    let authorProfile: Profile
    var comments: [Comment]?
}
