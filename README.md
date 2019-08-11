# ProgressStepView
A library for creating progress with steps.

<p align="center" >
<img src="https://github.com/gustavoSAS/ProgressStepView/blob/master/Screenshots/increasing.gif" width="50%" height="50%" />
</p>

<p align="center" >
<img src="https://github.com/gustavoSAS/ProgressStepView/blob/master/Screenshots/decreasing.gif" width="50%" height="50%" />
</p>


## Installation

### CocoaPods

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate ProgressStepView into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'ProgressStepView', '~> 1.0.0'
```


## Requirements

- iOS 10.0 or later
- Xcode 10.0 or later


## How To Use

* Swift

```swift
import ProgressStepView

private lazy var progress: ProgressStepView = {
    let progress = ProgressStepView(frame: viewTeste.bounds)
    progress.numberOfPoints = 4
    progress.spacing = 5.0
    progress.progressLineHeight = 8
    progress.circleRadius = 20
    progress.circleStrokeWidth = 2.5
    progress.translatesAutoresizingMaskIntoConstraints = false

    return progress
}()

view.addSubview(progress)

NSLayoutConstraint.activate([
    progress.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
    progress.leadingAnchor.constraint(equalTo: view.leadingAnchor),
    progress.trailingAnchor.constraint(equalTo: view.trailingAnchor)
])

progress.progress = 0.5
```

### Customization
Values of following properties have been set as defaults already. Change them if they are not suitable for you.

```swift
progress.numberOfPoints = 4
progress.spacing = 5.0
progress.progressLineHeight = 8
progress.progressCornerRadius = 4
progress.circleRadius = 20
progress.circleStrokeWidth = 2.5
progress.circleTintColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
progress.circleColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
progress.descriptionSpacing = 10.0
progress.descriptionColor = .black
progress.descriptionFont = UIFont.systemFont(ofSize: 15, weight: .bold)
progress.position = .top
```

### Add Description
Implement delegate, choose position

```swift
progress.position = .bottom
```
<p align="center" >
<img src="https://github.com/gustavoSAS/ProgressStepView/blob/master/Screenshots/description_below.png" width="50%" height="50%" />
</p>

```swift
progress.position = .top
```

<p align="center" >
<img src="https://github.com/gustavoSAS/ProgressStepView/blob/master/Screenshots/description above.png" width="50%" height="50%" />
</p>

```swift
progress.delegate = self
progress.position = .bottom

...

extension ViewController: ProgressStepViewDelegate {
    func progressStepView(descriptionForRow row: Int) -> String? {
        return "Number \(row)"
    }
}
```
## License

ProgressStepView is released under the MIT license. [See LICENSE](https://github.com/gustavoSAS/ProgressStepView/blob/master/LICENSE) for details.
