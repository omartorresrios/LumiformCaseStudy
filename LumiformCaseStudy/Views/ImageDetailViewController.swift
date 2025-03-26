//
//  ImageDetailViewController.swift
//  LumiformCaseStudy
//
//  Created by Omar Torres on 3/25/25.
//

import UIKit

final class ImageDetailViewController: UIViewController {
	private let viewModel: ImageQuestionViewModel
	private let imageView = UIImageView()
	private let titleLabel = UILabel()
	private let scrollView = UIScrollView()
	
	init(viewModel: ImageQuestionViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		loadImage()
	}
	
	private func setupUI() {
		view.backgroundColor = .white
		
		titleLabel.text = viewModel.question.title
		titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
		titleLabel.numberOfLines = 0
		titleLabel.textAlignment = .center
		
		scrollView.minimumZoomScale = 1.0
		scrollView.maximumZoomScale = 3.0
		scrollView.delegate = self
		
		imageView.contentMode = .scaleAspectFit
		imageView.clipsToBounds = true
		
		view.addSubview(titleLabel)
		view.addSubview(scrollView)
		scrollView.addSubview(imageView)
		
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		imageView.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
			titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
			titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
			
			scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
			scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			
			imageView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
			imageView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
			imageView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
			imageView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
			imageView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
		])
		
		let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
		doubleTapGesture.numberOfTapsRequired = 2
		scrollView.addGestureRecognizer(doubleTapGesture)
	}
	
	private func loadImage() {
		viewModel.onImageLoaded = { [weak self] data in
			DispatchQueue.main.async {
				guard let normalImage = UIImage(data: data) else { return }
				self?.updateImage(normalImage)
			}
		}
		viewModel.loadImage(fullSize: true)
	}
	
	private func updateImage(_ image: UIImage) {
		imageView.image = image
		imageView.sizeToFit()
		scrollView.contentSize = imageView.bounds.size
	}
	
	@objc private func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
		if scrollView.zoomScale == 1.0 {
			scrollView.setZoomScale(2.0, animated: true)
		} else {
			scrollView.setZoomScale(1.0, animated: true)
		}
	}
}

extension ImageDetailViewController: UIScrollViewDelegate {
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		return imageView
	}
}
