//
//  PlistProvider.swift
//  ThreadApp
//
//  Created by hong on 2023/08/17.
//

import Foundation

protocol PlistProviderProtocol {
    func load<T: Decodable>(_ type: T.Type) throws -> T
    func save<T: Encodable>(data: T) throws
}

struct PlistProvider: PlistProviderProtocol {
    
    enum PlistProviderError: LocalizedError {
        case pathNotFound
        case loadDataFailed
        case profileDataLoadFailed
        case threadsDataLoadFailed
        case typeDeosntExist
        case profileDeosntExist
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
    
    func load<T: Decodable>(_ type: T.Type) throws -> T {
        do {
            if type is Profile.Type {
                return try loadProfile() as! T
            } else if type is [Thread].Type {
                return try loadThreads() as! T
            } else {
                throw PlistProviderError.typeDeosntExist
            }
        } catch {
            throw error
        }
    }

    private func loadProfile() throws -> Profile  {
        do {
            let loadedDatas = try loadPlistDatas()
            if loadedDatas["Profile"] == nil {
                throw PlistProviderError.profileDeosntExist
            }
            guard let profileData = loadedDatas["Profile"] as? Data,
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
            let loadedDatas = try loadPlistDatas()
            if loadedDatas["Threads"] == nil {
                return []
            }
            guard let threadsData = loadedDatas["Threads"] as? Data,
                  let threads = try? threadsData.toObject([Thread].self) else {
                throw PlistProviderError.threadsDataLoadFailed
            }
            return threads
        } catch {
            throw error
        }
    }
    
    func save<T: Encodable>(data: T) throws {
        do {
            let filePath = try plistPath()
            var loadedData = try loadPlistDatas()
            let jsonData = try data.toJson()
            if data is Profile {
                loadedData["Profile"] = jsonData
            } else if let threadData = data as? Thread {
                var threads = try loadThreads()
                threads.append(threadData)
                loadedData["Threads"] = try threads.toJson()
            }
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
