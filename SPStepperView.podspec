Pod::Spec.new do |spec|
  spec.name         = "SPStepperView"
  spec.version      = "1.0.0"
  spec.summary      = "Simple Stepper View"

  spec.description  = <<-DESC
                   SPStepperView is a UIView subclass that provides a customizable stepper view with percentage-based progress. It allows you to set the current step progress and display images for completed and incomplete steps. This view can be easily integrated into any iOS application to enhance user interaction with a visually appealing stepper control.
                DESC

  spec.homepage     = "https://github.com/StellaPatricia/SPStepperView.git"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "StellaPatricia" => "stella.patricia95@gmail.com" }
  
  spec.ios.deployment_target = '12.0'
  spec.swift_versions = ['5.0'] # Specify your Swift version here
  spec.source       = { :git => "https://github.com/StellaPatricia/SPStepperView.git", :tag => "#{spec.version}" }

  spec.source_files  = "SPStepperView/**/*.{swift}"
  
  # If you have resources like images, add them here
  # spec.resources = "SPStepperView/Resources/*.png"
  
  # If your library requires ARC, add this line
  # spec.requires_arc = true

  # If you have dependencies, list them here
  # spec.dependency "SomeOtherPod", "~> 1.0"
end
