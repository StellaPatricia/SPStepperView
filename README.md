# SPStepperView

`SPStepperView` is a **customizable stepper view** for iOS that allows you to easily create and manage step-based interfaces. This library provides a user-friendly way to incorporate step-by-step navigation in your applications, with support for custom images and step progress tracking.

## Features

- **Customizable Design**: Tailor the stepper view with images, fonts and colors.
- **Progress Tracking**: Move to a step by index, or set progress as a percentage.
- **Accessible**: Each step is read by VoiceOver with its title and whether it is completed.
- **Easy Integration**: Simple setup and use in iOS projects.

## Requirements

- iOS 12.0+
- Swift 5.5+

## Installation

### CocoaPods

To integrate `SPStepperView` into your project using CocoaPods, add the following line to your `Podfile`:

```ruby
pod 'SPStepperView', '~> 1.2'
```

## How To Use

### 1. Setup and Initialization

Import `SPStepperView` into your file:

```swift
import SPStepperView
```

### 2. Create a Stepper View

Initialize `StepperView` with your steps and images:

```swift
private let stepperView: StepperView = {
    let stepperView = StepperView(
        steps: [
            "Target 1",
            "Target 2",
            "Target 3",
            "Target 4",
        ],
        completedImage: UIImage(named: "CompletedImageName"),
        incompleteImage: UIImage(named: "IncompleteImageName")
    )
    stepperView.translatesAutoresizingMaskIntoConstraints = false
    return stepperView
}()
```

### 3. Add the Stepper View to Your View

Add `stepperView` to your view and set up constraints:

```swift
contentView.addSubview(stepperView)

NSLayoutConstraint.activate([
    stepperView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
    stepperView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
    stepperView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
    stepperView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
    stepperView.heightAnchor.constraint(equalToConstant: 80)
])
```

### 4. Update Progress

Move to a step by its index (zero-based). Out-of-range values are clamped:

```swift
stepperView.setCurrentStep(2) // third step
```

Or set progress as a percentage from 0 to 1. Step `i` sits at `i / (steps.count - 1)`, so with 4 steps, `0.4` fills the bar to 40 % and marks the first two steps as completed:

```swift
stepperView.setCurrentStepPercentage(0.4)
stepperView.setCurrentStepPercentage(1, animated: false)
```

Read the current state with `currentStepIndex` and `currentStepPercentage`.

### 5. Customize

All properties can be changed at any time, including the steps themselves:

```swift
stepperView.steps = ["Cart", "Shipping", "Payment"]
stepperView.completedImage = UIImage(named: "check")
stepperView.incompleteImage = UIImage(named: "circle")

stepperView.indicatorSize = 32
stepperView.stepSpacing = 20

stepperView.progressHeight = 10
stepperView.progressTintColor = .systemBlue
stepperView.progressTrackColor = .lightGray

stepperView.labelFont = .systemFont(ofSize: 12)
stepperView.completedLabelColor = .darkGray
stepperView.incompleteLabelColor = .lightGray
```

## Migrating from 1.0.x

- `colorAchived` is now `completedLabelColor`, and `colorNotAchived` is now `incompleteLabelColor`. The old names still work but are deprecated.
- `setCurrentStepPercentage(_:)` now clamps values outside 0–1 instead of ignoring them.
- The progress bar now runs from the centre of the first indicator to the centre of the last, so its fill lines up with the steps.

## License

`SPStepperView` is available under the MIT license. See the [LICENSE](LICENSE) file for details.
