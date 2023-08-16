//
//  Comment.swift
//  ThreadApp
//
//  Created by cheshire on 2023/08/14.
//

import Foundation

struct Comment : Codable {
    var content: String
    let createdAt: Date
    let authorProfile: Profile
}
