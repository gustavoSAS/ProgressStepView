//
//  StepView.swift
//  ProgressStep
//
//  Created by Gustavo Storck on 03/06/19.
//  Copyright © 2019 Gustavo Storck. All rights reserved.
//

import UIKit

class StepView: UIView {
    // MARK: Private attributes
    private lazy var checkImage: UIImageView = {
        let bundle = Bundle(for: StepView.self)
        guard let url = bundle.url(forResource: "ProgressStepView", withExtension: "bundle") else { return UIImageView() }
        
        let image = UIImage(named: "ic_check", in: Bundle(url: url), compatibleWith: nil)
        let imageView = UIImageView(image: image)
        imageView.alpha = 0.0
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var stepView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = circleRadius / 2
        view.layer.borderWidth = circleStrokeWidth
        view.backgroundColor = .clear
        view.layer.borderColor = circleColor.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var descStepView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = descCircleRadius / 2
        view.backgroundColor = circleTintColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        
        return view
    }()
    
    private var descCircleRadius: CGFloat {
        return circleRadius / 2
    }
    
    // MARK: Public attributes
    
    /// The size of circle
    var circleRadius: CGFloat = 20
    
    /// The width of the circle border
    var circleStrokeWidth: CGFloat = 2.5
    
    /// The color shown for the portion of the circle that is not filled.
    var circleColor: UIColor = .gray
    
    /// The color shown for the portion of the circle that is filled.
    var circleTintColor: UIColor = .blue
    
    /// The animation time, between the state transitions.
    var animationTime: TimeInterval = 0.3
    
    // MARK: Life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        addComponents()
        layoutComponents()
    }
    
    // MARK: Private functions
    
    private func addComponents() {
        addSubview(stepView)
        addSubview(descStepView)
        addSubview(checkImage)
    }
    
    private func layoutComponents() {
        NSLayoutConstraint.activate([
            stepView.topAnchor.constraint(equalTo: topAnchor),
            stepView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stepView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stepView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stepView.widthAnchor.constraint(equalToConstant: circleRadius),
            stepView.heightAnchor.constraint(equalToConstant: circleRadius)
        ])
        
        NSLayoutConstraint.activate([
            descStepView.centerXAnchor.constraint(equalTo: stepView.centerXAnchor),
            descStepView.centerYAnchor.constraint(equalTo: stepView.centerYAnchor),
            descStepView.widthAnchor.constraint(equalToConstant: descCircleRadius),
            descStepView.heightAnchor.constraint(equalToConstant: descCircleRadius)
        ])
        
        NSLayoutConstraint.activate([
            checkImage.topAnchor.constraint(equalTo: topAnchor),
            checkImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            checkImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            checkImage.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func animatePending() {
        UIView.animate(withDuration: animationTime, delay: 0.0, options: [.curveEaseOut], animations: { [weak self] in
            self?.descStepView.alpha = 0.0
            self?.checkImage.alpha = 0.0
            self?.stepView.backgroundColor = .clear
            self?.stepView.layer.borderWidth = self?.circleStrokeWidth ?? 0.0
            self?.stepView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }, completion: { [weak self] _ in
            self?.descStepView.isHidden = true
        })
    }
    
    private func animateWait() {
        descStepView.alpha = 0.0
        descStepView.isHidden = false
        UIView.animate(withDuration: animationTime, delay: 0, options: [.curveEaseOut], animations: { [weak self] in
            self?.descStepView.alpha = 1.0
            self?.checkImage.alpha = 0.0
            self?.stepView.backgroundColor = .clear
            self?.stepView.layer.borderWidth = self?.circleStrokeWidth ?? 0.0
            self?.stepView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
    private func animateComplete() {
        UIView.animate(withDuration: animationTime, delay: 0.0, options: [.curveEaseOut], animations: { [weak self] in
            self?.checkImage.alpha = 1.0
            self?.stepView.backgroundColor = self?.circleTintColor
            self?.stepView.layer.borderWidth = 0.0
            self?.stepView.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        }, completion: { [weak self] _ in
            self?.descStepView.isHidden = false
            self?.descStepView.alpha = 1.0
        })
    }
    
    // MARK: Public functions
    
    /// Performs a state transition animation
    ///
    /// - Parameter status: Indicates the next StepView status
    func animateTo(_ status: Status) {
        switch status {
        case .pending:
            animatePending()
        case .wait:
            animateWait()
        case .complete:
            animateComplete()
        }
    }
}

// MARK: Extensions

extension StepView {
    /// Status that StepView can take
    ///
    /// - pending: It does not show any marking
    /// - wait: Displays the current status mark
    /// - complete: Displays full status marking
    enum Status {
        case pending
        case wait
        case complete
    }
}
