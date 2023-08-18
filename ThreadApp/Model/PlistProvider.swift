//
//  PlistProvider.swift
//  ThreadApp
//
//  Created by hong on 2023/08/17.
//

import Foundation

enum DataType {
    case profile(_ profile: Profile? = nil)
    case threads(_ threads: [Thread]? = nil)
    
    var data: Encodable? {
        switch self {
        case .profile(let profile):
            return profile
        case .threads(let threads):
            return threads
        }
    }
    
    var key: String {
        switch self {
        case .profile:
            return "Profile"
        case .threads:
            return "Threads"
        }
    }
}

protocol PlistProviderProtocol {
    func load<T>(_ type: DataType) throws -> T
    func save(_ type: DataType) throws
    func delete(_ type: DataType) throws
}

struct PlistProvider: PlistProviderProtocol {
    
    private enum PlistProviderError: LocalizedError {
        case pathNotFound
        case loadDataFailed
        case profileDataLoadFailed
        case threadsDataLoadFailed
        case typeDeosntExist
        case profileDeosntExist
        case saveDataDeosntExist
    }

    private func plistPath(plistName: String = "Info") throws -> String {
        guard let filePath = Bundle.main.path(forResource: plistName, ofType: "plist") else {
            throw PlistProviderError.pathNotFound
        }
        return filePath
    }
    
    private func loadPlistDatas() throws -> Dictionary<String, Any> {
        do {
            let filePath = try plistPath()
            guard let plistDatas = NSDictionary(contentsOfFile: filePath) as? Dictionary<String, Any> else {
                throw PlistProviderError.loadDataFailed
            }
            return plistDatas
        } catch {
            throw error
        }
    }
    
    func load<T>(_ type: DataType) throws -> T {
        do {
            switch type {
            case .profile:
                return try loadProfile() as! T
            case .threads:
                return try loadThreads() as! T
            }
        } catch {
            throw error
        }
    }

    private func loadProfile() throws -> Profile  {
        do {
            let profileKey = DataType.profile().key
            let loadedDatas = try loadPlistDatas()
            if loadedDatas[profileKey] == nil {
                throw PlistProviderError.profileDeosntExist
            }
            guard let profileData = loadedDatas[profileKey] as? Data,
                  let profile = try? profileData.toObject(Profile.self) else {
                throw PlistProviderError.profileDataLoadFailed
            }
            return profile
        } catch {
            throw error
        }
    }
    
    private func loadThreads() throws -> [Thread] {
        do {
            let threadKey = DataType.threads().key
            let loadedDatas = try loadPlistDatas()
            if loadedDatas[threadKey] == nil {
                return []
            }
            guard let threadsData = loadedDatas[threadKey] as? Data,
                  let threads = try? threadsData.toObject([Thread].self) else {
                throw PlistProviderError.threadsDataLoadFailed
            }
            return threads
        } catch {
            throw error
        }
    }
    
    func save(_ type: DataType) throws {
        do {
            guard let data = type.data else {
                throw PlistProviderError.saveDataDeosntExist
            }
            let filePath = try plistPath()
            var loadedData = try loadPlistDatas()
            let jsonData = try data.toJson()
            loadedData[type.key] = jsonData
            let encodedData = try PropertyListSerialization.data(fromPropertyList: loadedData, format: .xml, options: 0)
            try encodedData.write(to:  URL(fileURLWithPath: filePath))
        } catch {
            throw error
        }
    }
    
    func delete(_ type: DataType) throws {
        do {
            let filePath = try plistPath()
            var loadedData = try loadPlistDatas()
            loadedData[type.key] = nil
            let data = try PropertyListSerialization.data(fromPropertyList: loadedData, format: .xml, options: 0)
            try data.write(to:  URL(fileURLWithPath: filePath))
        } catch {
            throw error
        }
    }

}

extension Encodable {
    func toJson() throws -> Data {
        do {
            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(self)
            return encodedData
        } catch {
            throw error
        }
    }
}

extension Data {
    func toObject<T: Decodable>(_ type: T.Type) throws -> T {
        do {
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(type, from: self)
            return decodedData
        } catch {
            throw error
        }
    }
}
