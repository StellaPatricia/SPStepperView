//
//  StepperView.swift
//  StepperView
//
//  Created by Stella Patricia on 15/08/24.
//

import UIKit

public class StepperView: UIView {
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = stepSpacing
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var progressView: UIProgressView = {
        let progress = UIProgressView(progressViewStyle: .default)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    private var steps: [String]
    private var completedImage: UIImage?
    private var incompleteImage: UIImage?
    private var currentStepPercentage: Float = 0.0
    private let stepSpacing: CGFloat = 20
    
    public var indicatorSize: CGFloat = 32 {
        didSet {
            updateSteps()
        }
    }
    public var progressHeight: CGFloat = 10 {
        didSet {
            setupProgressViewConstraints()
        }
    }
    public var progressTintColor: UIColor = .blue {
        didSet {
            progressView.progressTintColor = progressTintColor
        }
    }
    public var progressTrackColor: UIColor = .lightGray {
        didSet {
            progressView.trackTintColor = progressTrackColor
        }
    }
    public var labelFont: UIFont = .systemFont(ofSize: 12) {
        didSet {
            updateSteps()
        }
    }
    public var colorAchived: UIColor = .gray {
        didSet {
            updateSteps()
        }
    }
    public var colorNotAchived: UIColor = .gray {
        didSet {
            updateSteps()
        }
    }
    
    public init(steps: [String], completedImage: UIImage?, incompleteImage: UIImage?) {
        self.steps = steps
        self.completedImage = completedImage
        self.incompleteImage = incompleteImage
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        self.steps = []
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addSubview(progressView)
        addSubview(stackView)
        
        setupStackViewConstraints()
        setupProgressViewConstraints()
        
        updateSteps()
    }
    
    private func setupStackViewConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func setupProgressViewConstraints() {
        NSLayoutConstraint.activate([
            progressView.heightAnchor.constraint(equalToConstant: progressHeight),
            progressView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            progressView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            progressView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func updateSteps() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let totalSteps = steps.count
        let stepIndex = Int(currentStepPercentage * Float(totalSteps - 1))
        
        progressView.setProgress(currentStepPercentage, animated: true)
        
        for (index, step) in steps.enumerated() {
            let container = UIView()
            container.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(container)
            
            let indicatorImageView = UIImageView(image: index <= stepIndex ? completedImage : incompleteImage)
            indicatorImageView.contentMode = .scaleAspectFit
            indicatorImageView.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(indicatorImageView)
            
            let label = UILabel()
            label.text = step
            label.numberOfLines = 0
            label.textAlignment = .center
            label.font = labelFont
            label.textColor = index <= stepIndex ? colorAchived : colorNotAchived
            label.adjustsFontSizeToFitWidth = true
            label.minimumScaleFactor = 0.5
            label.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(label)
            
            NSLayoutConstraint.activate([
                indicatorImageView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
                indicatorImageView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
                indicatorImageView.widthAnchor.constraint(equalToConstant: indicatorSize),
                indicatorImageView.heightAnchor.constraint(equalToConstant: indicatorSize),
                
                label.topAnchor.constraint(equalTo: indicatorImageView.bottomAnchor, constant: 5),
                label.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                label.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                label.bottomAnchor.constraint(equalTo: container.bottomAnchor)
            ])
        }
    }
    
    public func setCurrentStepPercentage(_ percentage: Float) {
        guard percentage >= 0.0 && percentage <= 1.0 else { return }
        currentStepPercentage = percentage
        updateSteps()
    }
}
