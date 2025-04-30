//
//  DashboardVC.swift
//  CoinRanking
//
//  Created by Kelvin Ofula on 4/30/25.
//

import UIKit

class DashboardVC: UIViewController {

    //MARK: - Properties
    var coordinator: MainCoordinator?
    
    var tabBarView: TabBar = {
        let tabBar = TabBar()
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        return tabBar
    }()
    
    private let pageView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Variables
    var pages = [UIViewController]()
    var viewControllers: [UIViewController]?
    var prevIndex: Int = 0
    var selectedPage: Int?
    
    private var pageController: UIPageViewController?
    
    
    // MARK: - Init
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        navigationController?.isNavigationBarHidden = true
        configureUI()
        selectPage(at: 0)
    }
    
    // MARK: - Visual Setup
    func configureUI() {
        view.backgroundColor = BG_COLOR
        setUpProperties()
        setUpHierarchy()
        setUpAutoLayout()
        loadTabPages()
    }
    
    private func setUpProperties() {
        tabBarView = TabBar(selectedIndex: 1)
        tabBarView.translatesAutoresizingMaskIntoConstraints = false
        tabBarView.btnAction = {
            self.selectedPage = self.tabBarView.selectedIndex
            self.selectPage(at: self.selectedPage ?? 0)
        }
        pageView.backgroundColor = UIColor.white.withAlphaComponent(0)
    }
    
    private func setUpHierarchy() {
        view.addSubview(pageView)
        view.addSubview(tabBarView)
    }
    
    private func setUpAutoLayout() {
        NSLayoutConstraint.activate([
            pageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageView.topAnchor.constraint(equalTo: view.topAnchor),
            pageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            tabBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tabBarView.heightAnchor.constraint(equalToConstant: BOTTOM_SAFEAREA_HEIGHT + 56)
        ])
    }
    
    private func createCenterPageViewController() -> UIPageViewController? {
        
        let coinsPage = CoinsPage()
        let favoritesPage = FavoritesPage()
        
        coinsPage.view.tag = 0
        favoritesPage.view.tag = 1
        
        coinsPage.coordinator = coordinator
        favoritesPage.coordinator = coordinator
        
        pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pages = [coinsPage, favoritesPage]
        pageController?.view.tag = 0
        pageController?.delegate = self
        self.pageController?.view.frame = CGRect(x: 0,y: 0,width: self.pageView.frame.width,height: self.pageView.frame.height)
        pageView.addSubview(self.pageController!.view)
        
        return pageController
    }
    
    private func createPlaceholderViewController(forIndex index: Int) -> UIViewController {
        let emptyViewController = UIViewController()
        emptyViewController.view.tag = index
        return emptyViewController
    }
    
    func loadTabPages() {
        guard let firstPageViewController = createCenterPageViewController() else { return }
        
        var controllers: [UIViewController] = []
        
        controllers.append(firstPageViewController)
        controllers.append(createPlaceholderViewController(forIndex: 1))
        controllers.append(createPlaceholderViewController(forIndex: 2))
        
        viewControllers = controllers
        
        selectMenuPage(at: selectedPage ?? 0)
    }
    
    func pageDidSwipe(to index: Int) {
        debugPrint("1. Selected Index -> ",index)
        self.selectedPage = index
        self.tabBarView.selectedIndex = index
        self.tabBarView.setupButtons()
    }
    
    func selectMenuPage(at index: Int) {
        selectPage(at: index)
    }
    
    func direction(for index: Int) -> UIPageViewController.NavigationDirection {
        return index > self.prevIndex ? .forward : .reverse
    }
    
    func selectPage(at index: Int) {
        self.pageController?.setViewControllers(
            [self.pages[index]],
            direction: self.direction(for: index),
            animated: false,
            completion: nil
        )
        self.prevIndex = index
    }
}

extension DashboardVC: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else { return nil }
        guard pages.count > previousIndex else { return nil }
        
        return pages[previousIndex]
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        let nextIndex = viewControllerIndex + 1
        guard nextIndex < pages.count else { return nil }
        guard pages.count > nextIndex else { return nil }
        
        return pages[nextIndex]
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            guard let currentPageIndex = self.viewControllers?.first?.view.tag else { return }
            self.prevIndex = currentPageIndex
            //pageDidSwipe(to: currentPageIndex)
            if let viewControllers = pageViewController.viewControllers {
                if let viewControllerIndex = self.pages.firstIndex(of: viewControllers[0]) {
                    pageDidSwipe(to: viewControllerIndex)
                }
            }
        }
    }
    
    // Enables pagination dots
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.pages.count
    }
    
    // This only gets called once, when setViewControllers is called
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }

    
}
