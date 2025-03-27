//
//  RootPageViewController.swift
//  LumiformCaseStudy
//
//  Created by Omar Torres on 3/25/25.
//

import UIKit

final class RootPageViewController: UIPageViewController {
	private let activityIndicator = UIActivityIndicatorView(style: .large)
	private var pages: [PageViewController] = []
	private let viewModel: RootPageViewModel
	private var coordinator: PageCoordinatorProtocol
	private let serviceFactory: ServiceFactory
	
	private let pageControl: UIPageControl = {
		let pc = UIPageControl()
		pc.translatesAutoresizingMaskIntoConstraints = false
		pc.currentPageIndicatorTintColor = .black
		pc.pageIndicatorTintColor = .gray
		pc.backgroundStyle = .minimal
		pc.isOpaque = true
		return pc
	}()
	
	private let errorLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.numberOfLines = 0
		label.textColor = .red
		return label
	}()

	init(viewModel: RootPageViewModel,
		 coordinator: PageCoordinatorProtocol,
		 serviceFactory: ServiceFactory = DependencyFactory()) {
		self.viewModel = viewModel
		self.coordinator = coordinator
		self.serviceFactory = serviceFactory
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
		view.addSubview(errorLabel)
		view.addSubview(activityIndicator)
		
		activityIndicator.translatesAutoresizingMaskIntoConstraints = false
		errorLabel.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
			
			errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
			errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
			
			activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
		])
	}

	private func fetchPages() {
		viewModel.stateDidChange = { [weak self] state in
			guard let self = self else { return }
			
			switch state {
			case .idle:
				self.activityIndicator.stopAnimating()
			case .loading:
				self.activityIndicator.startAnimating()
			case let .loaded(topLevelPages):
				DispatchQueue.main.async {
					self.activityIndicator.stopAnimating()
					self.errorLabel.isHidden = true
					self.pages = self.createPageControllers(from: topLevelPages, coordinator: self.coordinator)
					if let firstPage = self.pages.first {
						self.setViewControllers([firstPage], direction: .forward, animated: false, completion: nil)
						self.coordinator.didSwitchToPage(firstPage)
						self.updateTitle(for: firstPage)
					}
					self.pageControl.numberOfPages = self.pages.count
					self.pageControl.currentPage = 0
				}
			case let .error(error):
				self.activityIndicator.stopAnimating()
				self.errorLabel.isHidden = false
				self.errorLabel.text = error.localizedDescription
			}
		}
		viewModel.fetchTopLevelPages()
	}
	
	private func createPageControllers(from pages: [Page],
									   coordinator: PageCoordinatorProtocol) -> [PageViewController] {
		serviceFactory.createPageControllers(from: pages,
											 coordinator: coordinator)
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
			coordinator.didSwitchToPage(currentVC)
			updateTitle(for: currentVC)
		}
	}
}
