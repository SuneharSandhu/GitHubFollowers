import Foundation

enum PersistenceError: String, Error {
    case unableToFavorite = "There was an error favoriting this user. Please try again"
    case alreadyInFavorites = "This user is already in your favorites"
}
