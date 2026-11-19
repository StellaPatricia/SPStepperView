Pod::Spec.new do |spec|
  spec.name         = "SPStepperView"
  spec.version      = "1.2.0"
  spec.summary      = "A customizable step indicator with a progress bar for iOS."

  spec.description  = <<-DESC
                   SPStepperView is a UIView subclass that shows a row of titled steps on top of a progress bar.
                   Move to a step by index or by percentage, use your own images for completed and incomplete
                   steps, and customize fonts, colors and sizes. Steps are accessible to VoiceOver.
                DESC

  spec.homepage     = "https://github.com/StellaPatricia/SPStepperView"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "StellaPatricia" => "stella.patricia95@gmail.com" }

  spec.ios.deployment_target = "12.0"
  spec.swift_versions = ["5.5"]
  spec.source       = { :git => "https://github.com/StellaPatricia/SPStepperView.git", :tag => "#{spec.version}" }

  spec.source_files = "SPStepperView/**/*.swift"
  spec.frameworks   = "UIKit"
end
