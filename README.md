SPStepperView

SPStepperView is a customizable stepper view for iOS that allows you to easily create and manage step-based interfaces. This library provides a user-friendly way to incorporate step-by-step navigation in your applications with support for custom images and step progress tracking.

Features

Customizable stepper view with support for images and text.
Adjustable step progress displayed in percentage.
Easy integration and usage in iOS projects.
Installation

CocoaPods
Add the following line to your Podfile:

ruby
Copy code
pod 'SPStepperView', '~> 1.0'
Then run:

bash
Copy code
pod install
Swift Package Manager
Add the following dependency to your Package.swift file:

swift
Copy code
.package(url: "https://github.com/StellaPatricia/SPStepperView.git", from: "1.0.0")
Usage

Here’s a basic example of how to use SPStepperView in your project:

swift
Copy code
import SPStepperView

// Initialize the stepper view
let stepperView = SPStepperView()

// Configure the stepper view
stepperView.configure(with: ["Step 1", "Step 2", "Step 3"], images: [image1, image2, image3])

// Add to your view hierarchy
view.addSubview(stepperView)

// Update the current step
stepperView.setCurrentStep(percentage: 50)
Customization

You can customize the SPStepperView by setting various properties:

stepTextNames: Array of step names to be displayed.
images: Array of images to be used for each step.
currentStepPercentage: The progress percentage of the current step.
Example

Contribution

Feel free to open issues or submit pull requests if you have suggestions or improvements for SPStepperView.

License

SPStepperView is licensed under the MIT License. See LICENSE for details.
