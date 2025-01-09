import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nav1 = UINavigationController(rootViewController: SearchViewController())
        let nav2 = UINavigationController(rootViewController: FavoritesListViewController())
        
        self.viewControllers = [nav1, nav2]
        
        UITabBar.appearance().tintColor = .systemGreen
        UINavigationBar.appearance().tintColor = .systemGreen
        
        nav1.title = "Search"
        nav1.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        
        nav2.title = "Favorites"
        nav2.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
    }
}
