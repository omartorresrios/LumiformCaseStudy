//
//  RootPageViewController.swift
//  LumiformCaseStudy
//
//  Created by Omar Torres on 3/25/25.
//

import UIKit

final class RootPageViewController: UIPageViewController {
	private var pages: [PageViewController] = []
	private let repository: GenericItemRepositoryProtocol

	private let pageControl: UIPageControl = {
		let pc = UIPageControl()
		pc.translatesAutoresizingMaskIntoConstraints = false
		pc.currentPageIndicatorTintColor = .black
		pc.pageIndicatorTintColor = .gray
		pc.backgroundStyle = .minimal
		pc.isOpaque = true
		return pc
	}()

	init(repository: GenericItemRepositoryProtocol) {
		self.repository = repository
		super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		fetchPages()
		dataSource = self
		delegate = self
	}

	private func setupUI() {
		view.backgroundColor = .white
		
		view.addSubview(pageControl)
		NSLayoutConstraint.activate([
			pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
		])
	}

	private func fetchPages() {
		repository.fetchItem { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let item):
				DispatchQueue.main.async {
					if let rootPage = item.asPage {
						let topLevelPages = self.extractTopLevelPages(from: rootPage)
						self.pages = topLevelPages.map { PageViewController(viewModel: PageViewModel(page: $0)) }
						if let firstPage = self.pages.first {
							self.setViewControllers([firstPage], direction: .forward, animated: false, completion: nil)
							self.updateTitle(for: firstPage)
						}
						
						self.pageControl.numberOfPages = self.pages.count
						self.pageControl.currentPage = 0
					}
				}
			case .failure(let error):
				print("Error fetching pages: \(error)")
			}
		}
	}

	private func extractTopLevelPages(from page: Page) -> [Page] {
		var topLevelPages: [Page] = [page]
		for item in page.items {
			if let nestedPage = item.asPage {
				topLevelPages.append(nestedPage)
			}
		}
		return topLevelPages
	}
	
	private func updateTitle(for pageVC: PageViewController) {
		title = pageVC.viewModel.title
	}
}

extension RootPageViewController: UIPageViewControllerDataSource {
	func pageViewController(_ pageViewController: UIPageViewController, 
							viewControllerBefore viewController: UIViewController) -> UIViewController? {
		guard let currentPage = viewController as? PageViewController,
			  let currentIndex = pages.firstIndex(of: currentPage),
			  currentIndex > 0 else { return nil }
		return pages[currentIndex - 1]
	}

	func pageViewController(_ pageViewController: UIPageViewController, 
							viewControllerAfter viewController: UIViewController) -> UIViewController? {
		guard let currentPage = viewController as? PageViewController,
			  let currentIndex = pages.firstIndex(of: currentPage),
			  currentIndex < pages.count - 1 else { return nil }
		return pages[currentIndex + 1]
	}

	func presentationCount(for pageViewController: UIPageViewController) -> Int {
		return pages.count
	}

	func presentationIndex(for pageViewController: UIPageViewController) -> Int {
		guard let currentVC = viewControllers?.first as? PageViewController,
			  let currentIndex = pages.firstIndex(of: currentVC) else { return 0 }
		return currentIndex
	}
}

extension RootPageViewController: UIPageViewControllerDelegate {
	func pageViewController(_ pageViewController: UIPageViewController, 
							didFinishAnimating finished: Bool,
							previousViewControllers: [UIViewController],
							transitionCompleted completed: Bool) {
		if completed, let currentVC = viewControllers?.first as? PageViewController {
			let currentIndex = pages.firstIndex(of: currentVC) ?? 0
			pageControl.currentPage = currentIndex
			currentVC.viewModel.fetchItems()
			updateTitle(for: currentVC)
		}
	}
}
