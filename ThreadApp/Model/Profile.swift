//
//  Profile.swift
//  ThreadApp
//
//  Created by cheshire on 2023/08/14.
//

import Foundation

struct Profile : Codable, Hashable {
    var photoData: Data?
    var name: String
    var bio: String
}
