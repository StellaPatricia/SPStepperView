# SPStepperView

`SPStepperView` is a **customizable stepper view** for iOS that allows you to easily create and manage step-based interfaces. This library provides a user-friendly way to incorporate step-by-step navigation in your applications, with support for custom images and step progress tracking.

## Features

- **Customizable Design**: Tailor the stepper view with images and text.
- **Progress Tracking**: Display progress as a percentage.
- **Easy Integration**: Simple setup and use in iOS projects.

## Installation

### CocoaPods

To integrate `SPStepperView` into your project using CocoaPods, add the following line to your `Podfile`:

```ruby
pod 'SPStepperView', '~> 1.0.5'
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
        completedImage: "ImageName",
        incompleteImage: "ImageName"
    )
    stepperView.translatesAutoresizingMaskIntoConstraints = false
    return stepperView
}()
```

### 3. Add the Stepper View to Your View

Add `stepperView` to your view and set up constraints:

```swift
view.addSubview(stepperView)

NSLayoutConstraint.activate([
    stepperView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
    stepperView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
    stepperView.widthAnchor.constraint(equalToConstant: 300),
    stepperView.heightAnchor.constraint(equalToConstant: 50)
])
```

### 4. Update Progress

To set the current step:

```swift
stepperView.setCurrentStep(2) // Sets the current step to Step 2
```

To update the progress percentage:

```swift
stepperView.setProgress(50) // Sets the progress to 50%
```

### 5. Customize Appearance

You can further customize the appearance of the stepper view by modifying its properties, such as step text, images, and progress indicators.
```

This Markdown section should fit nicely into your `README.md` file.
