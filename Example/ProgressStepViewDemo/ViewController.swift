//
//  ViewController.swift
//  ProgressStepViewDemo
//
//  Created by Gustavo Storck on 09/08/19.
//  Copyright © 2019 Gustavo Storck. All rights reserved.
//

import UIKit
import ProgressStepView

class ViewController: UIViewController {
    @IBOutlet weak var slider: UISlider!
    
    private lazy var progress: ProgressStepView = {
        let progress = ProgressStepView(frame: view.bounds)
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
        progress.position = .bottom

        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.delegate = self

        return progress
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(progress)

        NSLayoutConstraint.activate([
            progress.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            progress.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            progress.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        progress.progress = 0.5
    }

    @IBAction func didTapButton(_ sender: Any) {
        progress.progress = slider.value
    }
}

extension ViewController: ProgressStepViewDelegate {
    func progressStepView(descriptionForRow row: Int) -> String? {
        return "Number \(row)"
    }
}
