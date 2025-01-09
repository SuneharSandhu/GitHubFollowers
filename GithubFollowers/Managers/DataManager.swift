import Foundation

enum PersistenceActionType {
    case add, remove
}

enum DataManager {
    
    static private let defaults = UserDefaults.standard
    
    private enum Keys {
        static let favorites = "favorites"
    }
    
    static func update(with favorite: Follower, actionType: PersistenceActionType) async throws {
        var favorites = try await retrieveFavorites()
        
        switch actionType {
        case .add:
            guard !favorites.contains(favorite) else {
                throw PersistenceError.alreadyInFavorites
            }
            favorites.append(favorite)
        case .remove:
            favorites.removeAll(where: { $0.login == favorite.login })
        }
        
        try await save(favorites: favorites)
    }
    
    static func retrieveFavorites() async throws -> [Follower] {
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
            return []
        }
        
        do {
            let favorites = try JSONDecoder().decode([Follower].self, from: favoritesData)
            return favorites
        } catch {
            throw PersistenceError.unableToFavorite
        }
    }
    
    static func save(favorites: [Follower]) async throws {
        do {
            let encodedFavorites = try JSONEncoder().encode(favorites)
            defaults.set(encodedFavorites, forKey: Keys.favorites)
        } catch {
            throw PersistenceError.unableToFavorite
        }
    }
}
