//
//  StepperView.swift
//  StepperView
//
//  Created by Stella Patricia on 15/08/24.
//

import UIKit

/// A horizontal stepper that shows a list of titled steps on top of a progress bar.
///
/// Steps up to and including the current one use `completedImage` / `completedLabelColor`;
/// the rest use `incompleteImage` / `incompleteLabelColor`. The progress bar runs from the
/// centre of the first indicator to the centre of the last one, so a percentage of
/// `i / (steps.count - 1)` lines up exactly with step `i`.
public class StepperView: UIView {

    // MARK: - Public configuration

    /// Titles of the steps, left to right. Setting this rebuilds the step views.
    public var steps: [String] {
        didSet { rebuildSteps() }
    }

    /// Indicator image for steps that have been reached.
    public var completedImage: UIImage? {
        didSet { refreshSteps() }
    }

    /// Indicator image for steps that have not been reached yet.
    public var incompleteImage: UIImage? {
        didSet { refreshSteps() }
    }

    /// Width and height of each step indicator image.
    public var indicatorSize: CGFloat = 32 {
        didSet { stepItems.forEach { $0.setIndicatorSize(indicatorSize) } }
    }

    /// Height of the progress bar.
    public var progressHeight: CGFloat = 10 {
        didSet { progressHeightConstraint?.constant = progressHeight }
    }

    public var progressTintColor: UIColor = .blue {
        didSet { progressView.progressTintColor = progressTintColor }
    }

    public var progressTrackColor: UIColor = .lightGray {
        didSet { progressView.trackTintColor = progressTrackColor }
    }

    public var labelFont: UIFont = .systemFont(ofSize: 12) {
        didSet { refreshSteps() }
    }

    /// Label color for steps that have been reached.
    public var completedLabelColor: UIColor = .gray {
        didSet { refreshSteps() }
    }

    /// Label color for steps that have not been reached yet.
    public var incompleteLabelColor: UIColor = .gray {
        didSet { refreshSteps() }
    }

    /// Horizontal spacing between step columns.
    public var stepSpacing: CGFloat = 20 {
        didSet { stackView.spacing = stepSpacing }
    }

    /// Current progress, from 0 to 1.
    public private(set) var currentStepPercentage: Float = 0

    /// Index of the last reached step, or `nil` when there are no steps.
    public var currentStepIndex: Int? {
        guard !steps.isEmpty else { return nil }
        // Small epsilon so values like 0.7 * 10 (= 6.9999...) land on the intended step.
        let raw = currentStepPercentage * Float(steps.count - 1) + 0.0001
        return min(Int(raw), steps.count - 1)
    }

    // MARK: - Deprecated

    @available(*, deprecated, renamed: "completedLabelColor")
    public var colorAchived: UIColor {
        get { completedLabelColor }
        set { completedLabelColor = newValue }
    }

    @available(*, deprecated, renamed: "incompleteLabelColor")
    public var colorNotAchived: UIColor {
        get { incompleteLabelColor }
        set { incompleteLabelColor = newValue }
    }

    // MARK: - Private views

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
        progress.progressTintColor = progressTintColor
        progress.trackTintColor = progressTrackColor
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.isAccessibilityElement = false
        return progress
    }()

    private var stepItems: [StepItemView] = []
    private var progressHeightConstraint: NSLayoutConstraint?
    private var progressPositionConstraints: [NSLayoutConstraint] = []

    // MARK: - Init

    public init(steps: [String], completedImage: UIImage?, incompleteImage: UIImage?) {
        self.steps = steps
        self.completedImage = completedImage
        self.incompleteImage = incompleteImage
        super.init(frame: .zero)
        setupView()
    }

    public override convenience init(frame: CGRect) {
        self.init(steps: [], completedImage: nil, incompleteImage: nil)
        self.frame = frame
    }

    public required init?(coder: NSCoder) {
        self.steps = []
        super.init(coder: coder)
        setupView()
    }

    // MARK: - Public API

    /// Sets progress as a fraction from 0 to 1. Values outside that range are clamped.
    public func setCurrentStepPercentage(_ percentage: Float, animated: Bool = true) {
        guard percentage.isFinite else { return }
        currentStepPercentage = min(max(percentage, 0), 1)
        progressView.setProgress(currentStepPercentage, animated: animated)
        refreshSteps()
    }

    /// Moves progress so that the step at `index` (zero-based) is the last reached step.
    public func setCurrentStep(_ index: Int, animated: Bool = true) {
        guard steps.count > 1 else {
            setCurrentStepPercentage(steps.isEmpty || index < 0 ? 0 : 1, animated: animated)
            return
        }
        let clamped = min(max(index, 0), steps.count - 1)
        setCurrentStepPercentage(Float(clamped) / Float(steps.count - 1), animated: animated)
    }

    // MARK: - Setup

    private func setupView() {
        addSubview(progressView)
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])

        let heightConstraint = progressView.heightAnchor.constraint(equalToConstant: progressHeight)
        heightConstraint.isActive = true
        progressHeightConstraint = heightConstraint

        rebuildSteps()
    }

    /// Recreates step views. Only needed when `steps` changes.
    private func rebuildSteps() {
        stepItems.forEach { $0.removeFromSuperview() }
        stepItems = steps.map { title in
            let item = StepItemView(title: title, indicatorSize: indicatorSize)
            stackView.addArrangedSubview(item)
            return item
        }
        pinProgressViewToIndicators()
        refreshSteps()
    }

    /// Stretches the progress bar between the first and last indicator centres.
    private func pinProgressViewToIndicators() {
        NSLayoutConstraint.deactivate(progressPositionConstraints)

        guard let first = stepItems.first, let last = stepItems.last else {
            progressPositionConstraints = []
            progressView.isHidden = true
            return
        }

        progressView.isHidden = false
        progressPositionConstraints = [
            progressView.leadingAnchor.constraint(equalTo: first.indicatorView.centerXAnchor),
            progressView.trailingAnchor.constraint(equalTo: last.indicatorView.centerXAnchor),
            progressView.centerYAnchor.constraint(equalTo: first.indicatorView.centerYAnchor),
        ]
        NSLayoutConstraint.activate(progressPositionConstraints)
    }

    /// Updates images, fonts and colors in place without recreating views.
    private func refreshSteps() {
        let reachedIndex = currentStepIndex ?? -1
        for (index, item) in stepItems.enumerated() {
            let isCompleted = index <= reachedIndex
            item.configure(
                image: isCompleted ? completedImage : incompleteImage,
                font: labelFont,
                color: isCompleted ? completedLabelColor : incompleteLabelColor,
                isCompleted: isCompleted
            )
        }
    }
}

// MARK: - StepItemView

final class StepItemView: UIView {
    let indicatorView = UIImageView()
    let titleLabel = UILabel()

    private var widthConstraint: NSLayoutConstraint!
    private var heightConstraint: NSLayoutConstraint!

    init(title: String, indicatorSize: CGFloat) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false

        indicatorView.contentMode = .scaleAspectFit
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(indicatorView)

        titleLabel.text = title
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)

        widthConstraint = indicatorView.widthAnchor.constraint(equalToConstant: indicatorSize)
        heightConstraint = indicatorView.heightAnchor.constraint(equalToConstant: indicatorSize)

        NSLayoutConstraint.activate([
            indicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            indicatorView.centerYAnchor.constraint(equalTo: centerYAnchor),
            widthConstraint,
            heightConstraint,

            titleLabel.topAnchor.constraint(equalTo: indicatorView.bottomAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])

        isAccessibilityElement = true
        accessibilityLabel = title
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setIndicatorSize(_ size: CGFloat) {
        widthConstraint.constant = size
        heightConstraint.constant = size
    }

    func configure(image: UIImage?, font: UIFont, color: UIColor, isCompleted: Bool) {
        indicatorView.image = image
        titleLabel.font = font
        titleLabel.textColor = color
        accessibilityValue = isCompleted ? "Completed" : "Not completed"
    }
}
