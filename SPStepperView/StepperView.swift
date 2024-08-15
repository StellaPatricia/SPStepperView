//
//  StepperView.swift
//  StepperView
//
//  Created by Stella Patricia on 15/08/24.
//

import UIKit

public class StepperView: UIView {
    private let stackView = UIStackView()
    private let progressView = UIProgressView(progressViewStyle: .default)
    private var steps: [String] = []
    private var currentStepPercentage: Float = 0.0
    private var completedImage: UIImage?
    private var incompleteImage: UIImage?
    private let stepSpacing: CGFloat = 20
    private let indicatorSize: CGFloat = 32
    private let progressHeight: CGFloat = 10
    
    init(steps: [String], completedImage: UIImage?, incompleteImage: UIImage?) {
        self.steps = steps
        self.completedImage = completedImage
        self.incompleteImage = incompleteImage
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        stackView.axis = .horizontal
        stackView.spacing = stepSpacing
        stackView.distribution = .fillEqually
        
        progressView.progressTintColor = .blue
        progressView.trackTintColor = .lightGray
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(progressView)
        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            progressView.heightAnchor.constraint(equalToConstant: progressHeight),
            progressView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            progressView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            progressView.centerYAnchor.constraint(equalTo: centerYAnchor) // Center progress view vertically
        ])
        
        updateSteps()
    }
    
    private func updateSteps() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let totalSteps = steps.count
        let percentageProgress = currentStepPercentage
        progressView.setProgress(percentageProgress, animated: true)
        
        for (index, step) in steps.enumerated() {
            let container = UIView()
            container.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(container)
            
            let indicatorImageView = UIImageView(image: index <= Int(percentageProgress * Float(totalSteps - 1)) ? completedImage : incompleteImage)
            indicatorImageView.contentMode = .scaleAspectFit
            indicatorImageView.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(indicatorImageView)
            
            let label = UILabel()
            label.text = step
            label.numberOfLines = 2
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 12)
            label.textColor = index <= Int(percentageProgress * Float(totalSteps - 1)) ? .blue : .black
            label.adjustsFontSizeToFitWidth = true // Adjust font size to fit width
            label.minimumScaleFactor = 0.5 // Allow scaling to half size
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
    
    func setCurrentStepPercentage(_ percentage: Float) {
        guard percentage >= 0.0 && percentage <= 1.0 else { return }
        currentStepPercentage = percentage
        updateSteps()
    }
}
