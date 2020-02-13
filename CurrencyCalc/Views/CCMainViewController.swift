//
//  CCMainViewController.swift
//  CurrencyCalc
//
//  Created by Luthfi Fathur Rahman on 13/02/20.
//  Copyright © 2020 StandAlone. All rights reserved.
//

import UIKit
import RxSwift
import RxOptional
import SnapKit

class CCMainViewController: UIViewController {
    private var viewModel: CCMainViewModel!

    private let disposeBag = DisposeBag()
    
    private var textField: UITextField!
    private var currencyMenu: UIPickerView!

    // MARK: - Initialization
    convenience init() {
        self.init(viewModel: nil)
    }

    init(viewModel: CCMainViewModel?) {
        super.init(nibName: nil, bundle: nil)

        self.viewModel = viewModel
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupEvents()
        setupViews()

        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.addTarget(self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
}

extension CCMainViewController {
    private func setupEvents() {
        viewModel.uiEvents.subscribe(onNext: { event in
            switch event {
            default: break
            }
        }).disposed(by: disposeBag)
    }

    private func setupViews() {
        textField = UITextField(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100))
        textField.backgroundColor = .white
        textField.keyboardType = .numberPad
        view.addSubview(textField)

        textField.snp.makeConstraints({ make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(50)
        })
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
