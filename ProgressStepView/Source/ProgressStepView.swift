//
//  ProgressStepView.swift
//  ProgressStep
//
//  Created by Gustavo Storck on 03/06/19.
//  Copyright © 2019 Gustavo Storck. All rights reserved.
//

import UIKit
// MARK: Delegate

public protocol ProgressStepViewDelegate: class {
    /// Waits for the description text of the current step
    ///
    /// - Parameter row: Represents the current step view position
    /// - Returns: Description text that will be assigned to step view
    func progressStepView(descriptionForRow row: Int) -> String?
}

public class ProgressStepView: UIView {
    // MARK: Private attributes
    private var progressViewArray: [UIProgressView] = []
    private var stepViewArray: [StepView] = []
    private var descriptionLabelArray: [(UILabel, Int)] = []
    private var currentProgress: Float = 0
    private var animateFinish: Bool = true
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.spacing = spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private var progressView: UIProgressView {
        let progressView = UIProgressView()
        progressView.trackTintColor = circleColor
        progressView.progressTintColor = circleTintColor
        progressView.progress = 0.0
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        return progressView
    }
    
    private var stepView: StepView {
        let stepView = StepView()
        stepView.circleRadius = circleRadius
        stepView.circleStrokeWidth = circleStrokeWidth
        stepView.circleColor = circleColor
        stepView.circleTintColor = circleTintColor
        stepView.translatesAutoresizingMaskIntoConstraints = false
        
        return stepView
    }
    
    private var descriptionLabel: UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.font = descriptionFont
        label.textColor = descriptionColor
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }
    
    // MARK: Public attributes
    
    /// Number of progress steps
    public var numberOfPoints: Int = 2 {
        didSet {
            numberOfPoints = numberOfPoints < 2 ? 2 : numberOfPoints
        }
    }
    
    /// Represents the height of the progreeView
    public var progressLineHeight: CGFloat = 5
    
    /// The radius to use when drawing rounded corners ProgressLine
    public var progressCornerRadius: CGFloat = 0
    
    /// The size of the space between a step and a progress view
    public var spacing: CGFloat = 5.0
    
    /// The size of circle
    public var circleRadius: CGFloat = 20
    
    /// The width of the circle border
    public var circleStrokeWidth: CGFloat = 2.5
    
    /// The color shown for the portion of the circle that is not filled.
    public var circleColor: UIColor = .gray
    
    /// The color shown for the portion of the circle that is filled.
    public var circleTintColor: UIColor = .blue
    
    /// Description text position.
    ///
    /// - top: Text over the step
    /// - bottom: Text below step
    public var position: Position = .top
    
    /// The font used to display the text.
    public var descriptionFont: UIFont = UIFont.systemFont(ofSize: 14, weight: .regular)
    
    /// The color of the text.
    public var descriptionColor: UIColor = .black
    
    /// Space between description text and stepView.
    public var descriptionSpacing: CGFloat = 10.0
    
    /// The current progress shown by the receiver.
    ///
    /// The current progress is represented by a floating-point value
    /// between 0.0 and 1.0, inclusive, where 1.0 indicates the completion
    /// of the task. The default value is 0.0. Values less than 0.0 and greater than 1.0
    /// are pinned to those limits.
    public var progress: Float = 0.0 {
        didSet {
            progress = progress > 1 ? 1 : progress
            progress = progress < 0 ? 0 : progress
            
            updateProgress(to: progress)
        }
    }
    
    public weak var delegate: ProgressStepViewDelegate?
    
    // MARK: Life cycle
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        addComponents()
        addDescription()
        layoutComponents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private functions
    
    private func addComponents() {
        for _ in 0..<(numberOfPoints - 1) {
            let step = stepView
            let progress = progressView
            
            stackView.addArrangedSubview(step)
            stackView.addArrangedSubview(progress)
            
            stepViewArray.append(step)
            progressViewArray.append(progress)
        }
        
        let step = stepView
        stepViewArray.append(step)
        stackView.addArrangedSubview(step)
        addSubview(stackView)
    }
    
    private func addDescription() {
        for index in 0..<stepViewArray.count {
            guard let text = delegate?.progressStepView(descriptionForRow: index) else { continue }
            let stepView = stepViewArray[index]
            let label = descriptionLabel
            
            label.text = text
            addSubview(label)
            layoutDescription(label, stepView: stepView)
            descriptionLabelArray.append((label, index))
        }
    }
    
    private func layoutDescription(_ label: UILabel, stepView: StepView) {
        let constraintLabel = constraint(label: label, stepView: stepView)
        let width = valueWidthDescription()
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: stepView.centerXAnchor),
            constraintLabel,
            label.widthAnchor.constraint(lessThanOrEqualToConstant: width)
        ])
    }
    
    private func constraint(label: UILabel, stepView: StepView) -> NSLayoutConstraint {
        switch position {
        case .top:
            return label.bottomAnchor.constraint(equalTo: stepView.topAnchor, constant: -descriptionSpacing)
        case .bottom:
            return label.topAnchor.constraint(equalTo: stepView.bottomAnchor, constant: descriptionSpacing)
        }
    }
    
    private func layoutComponents() {
        switch position {
        case .bottom:
            layoutComponentsBottom()
        case .top:
            layoutComponentsTop()
        }
        
        if let label = startLabel(), label.intrinsicContentSize.width >= circleRadius {
            label.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        } else {
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        }
        
        if let label = endLabel(), label.intrinsicContentSize.width >= circleRadius {
            label.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        } else {
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        }
        
        for progress in progressViewArray {
            configureProgressView(progressView: progress)
        }
    }
    
    private func configureProgressView(progressView: UIProgressView) {
        NSLayoutConstraint.activate([
            progressView.widthAnchor.constraint(equalTo: progressViewArray[0].widthAnchor),
            progressView.heightAnchor.constraint(equalToConstant: progressLineHeight)
        ])
        
        progressView.clipsToBounds = true
        progressView.layer.cornerRadius = progressCornerRadius
    }
    
    private func layoutComponentsTop() {
        if let label = maxHeightLabel() {
            label.topAnchor.constraint(equalTo: topAnchor).isActive = true
        } else {
            stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        }
        
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    private func layoutComponentsBottom() {
        if let label = maxHeightLabel() {
            label.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        } else {
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        }
        
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    }
    
    // MARK: Calculate functions
    
    private func valueWidthProgress() -> CGFloat {
        let numberSpacing = 2 * (CGFloat(numberOfPoints) - 1) * spacing
        let width = (frame.width - (circleRadius * CGFloat(numberOfPoints) + numberSpacing)) / CGFloat(numberOfPoints - 1)
        
        return width
    }
    
    private func valueWidthDescription() -> CGFloat {
        let widthProgress = 0.6 * valueWidthProgress()
        let spacingWidth = 2 * spacing
        let stepWidth = circleRadius
        
        return (widthProgress + spacingWidth + stepWidth)
    }
    
    private func startLabel() -> UILabel? {
        var startLabel: UILabel?
        for (label, index) in descriptionLabelArray {
            if index == 0 { startLabel = label }
        }
        return startLabel
    }
    
    private func endLabel() -> UILabel? {
        var endLabel: UILabel?
        for (label, index) in descriptionLabelArray {
            if index == (numberOfPoints - 1) { endLabel = label }
        }
        return endLabel
    }
    
    private func maxHeightLabel() -> UILabel? {
        var maxLabel: UILabel?
        for (label, _) in descriptionLabelArray {
            if label.intrinsicContentSize.width >= (maxLabel?.intrinsicContentSize.width ?? 0) {
                maxLabel = label
            }
        }
        
        return maxLabel
    }
    
    // MARK: Animate functions
    
    private func updateProgress(to progress: Float) {
        guard animateFinish else { return }
        let numStep = Float(numberOfPoints - 1)
        let value = progress * numStep
        
        animateFinish = false
        if value < currentProgress {
            animateDown(index: progressViewArray.endIndex - 1, value: numStep - value)
        } else {
            animateUp(index: 0, value: value)
        }
        
        currentProgress = value
    }
    
    private func animateDown(index: Int, value: Float) {
        let x = value - 1 < 0 ? -(value - 1) : 0
        
        if index == (progressViewArray.startIndex - 1) || x >= 1 {
            if x == 1 {
                stepViewArray[index + 1].animateTo(.wait)
            }
            animateFinish = true
            return
        }
        
        let progressView = progressViewArray[index]
        
        if x < 1 {
            stepViewArray[index + 1].animateTo(.pending)
        } else if x == 1 {
            stepViewArray[index + 1].animateTo(.wait)
        }
        
        let time: Float = progressView.progress - x
        progressView.setProgress(x, animated: false)
        UIView.animate(withDuration: (TimeInterval(time * 0.8)), animations: {
            progressView.layoutIfNeeded()
        }, completion: { [weak self] _ in
            self?.animateDown(index: index - 1, value: value - 1)
        })
    }
    
    private func animateUp(index: Int, value: Float) {
        let x = value - 1 < 0 ? value : 1
        if index == progressViewArray.endIndex || x < 0 {
            if x == 0 {
                stepViewArray[index].animateTo(.complete)
            }
            animateFinish = true
            return
        }
        
        let progressView = progressViewArray[index]
        
        if x > 0 {
            stepViewArray[index].animateTo(.complete)
        } else if x == 0 {
            stepViewArray[index].animateTo(.wait)
        }
        
        let time: Float = x - progressView.progress
        progressView.setProgress(x, animated: false)
        UIView.animate(withDuration: TimeInterval(time * 0.8), animations: {
            progressView.layoutIfNeeded()
        }, completion: { [weak self] _ in
            self?.animateUp(index: index + 1, value: value - 1)
        })
    }
}

// MARK: Extensions

extension ProgressStepView {
    /// Represents the position of the text in relation to the view.
    ///
    /// - top: Text over the step
    /// - bottom: Text below step
    public enum Position {
        case top
        case bottom
    }
}
