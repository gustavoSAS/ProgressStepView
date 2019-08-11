Pod::Spec.new do |spec|

  spec.name          = "ProgressStepView"
  spec.version       = "1.0.0"
  spec.summary       = "A library for progress view with steps, labels and animations."
  spec.homepage      = "https://github.com/gustavoSAS/ProgressStepView"
  spec.license       = "MIT"
  spec.author        = { "Gustavo Storck" => "gustavo.storck1@gmail.com" }
  spec.platform      = :ios, "10.0"
  spec.source        = { :git => "https://github.com/gustavoSAS/ProgressStepView.git", :tag => "#{spec.version}" }
  spec.source_files  = "ProgressStepView"
  spec.swift_versions = ["4.2","5"]
end
