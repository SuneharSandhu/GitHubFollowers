import UIKit

enum NetworkError: String, Error {
    case invalidUrl = "Invalid url"
    case badServerResponse = "Bad server response"
    case cannotDecodeData = "Could not decode json data"
}

class NetworkManager {
    
    static let shared = NetworkManager()
    let cache = NSCache<NSString, UIImage>()
    
    private let baseUrl = "https://api.github.com/users"
    
    private init() {}
    
    func getFollowers(for user: String, page: Int) async throws -> [Follower] {
        guard let url = URL(string: "\(baseUrl)/\(user)/followers?per_page=100&page=\(page)") else {
            throw NetworkError.invalidUrl
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw NetworkError.badServerResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let followers = try decoder.decode([Follower].self, from: data)
            return followers
        } catch {
            throw NetworkError.cannotDecodeData
        }
    }
    
    func getUserInfo(for username: String) async throws -> User {
        guard let url = URL(string: "\(baseUrl)/\(username)") else {
            throw NetworkError.invalidUrl
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw NetworkError.badServerResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .iso8601
            let user = try decoder.decode(User.self, from: data)
            return user
        } catch {
            throw NetworkError.cannotDecodeData
        }
    }
    
    func downloadImage(from urlString: String) async -> UIImage? {
        let cacheKey = NSString(string: urlString)
        
        if let image = cache.object(forKey: cacheKey) {
            return image
        }
        
        guard let url = URL(string: urlString) else { return nil }
        
        // No need to handle errors so no need to wrap in do catch block
        guard let (data, response) = try? await URLSession.shared.data(from: url),
              (response as? HTTPURLResponse)?.statusCode == 200,
              let image = UIImage(data: data) else {
            return nil
        }
        
        cache.setObject(image, forKey: cacheKey)
        return image
    }
}
