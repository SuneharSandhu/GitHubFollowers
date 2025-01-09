import Foundation

struct User: Codable {
    let login: String
    let avatarUrl: String
    let publicRepos: Int
    let publicGists: Int
    let htmlUrl: String
    let following: Int
    let followers: Int
    let createdAt: Date
    
    var name: String?
    var location: String?
    var bio: String?
}
