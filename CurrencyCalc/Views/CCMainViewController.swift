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

    private var currencySourceLabel: UILabel!
    private var amountTextField: UITextField!
    private var upperStackView: UIStackView!
    private var currencyPicker: UIPickerView!
    private var currencyListTextField: UITextField!
    private var convertedAmountLabel: UILabel!
    private var lowerStackView: UIStackView!
    private var calculateButton: UIButton!

    //dummy
    private let currencyArr = Observable.just(["AUD", "CNY", "JPY", "SGD"])

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
        title = "Currency Exchange"
        view.backgroundColor = .white

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
        setupSourceField()
        setupConvertedField()
        setupCalculateButton()
        setupActions()
    }

    private func setupSourceField() {
        upperStackView = UIStackView(frame: .zero)
        upperStackView.distribution = .fill

        currencySourceLabel = UILabel(frame: .zero)
        currencySourceLabel.text = "USD"
        currencySourceLabel.font = UIFont.systemFont(ofSize: 32)
        currencySourceLabel.textAlignment = .left
        currencySourceLabel.textColor = .black
        currencySourceLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        upperStackView.addArrangedSubview(currencySourceLabel)

        amountTextField = UITextField(frame: .zero)
        amountTextField.backgroundColor = .lightGray
        amountTextField.keyboardType = .numberPad
        amountTextField.borderStyle = .bezel
        amountTextField.textAlignment = .right
        amountTextField.placeholder = "Type number here"
        amountTextField.clearsOnBeginEditing = false
        amountTextField.font = .systemFont(ofSize: 32)
        amountTextField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        upperStackView.addArrangedSubview(amountTextField)

        view.addSubview(upperStackView)

        upperStackView.snp.makeConstraints({ make in
            make.leading.equalTo(view.snp.leadingMargin)
            make.trailing.equalTo(view.snp.trailingMargin)
            make.top.equalTo(view.snp.topMargin).offset(25)
        })
    }

    private func setupConvertedField() {
        lowerStackView = UIStackView(frame: .zero)
        lowerStackView.distribution = .fill

        currencyPicker = UIPickerView()

        currencyListTextField = UITextField(frame: .zero)
        currencyListTextField.backgroundColor = .lightGray
        currencyListTextField.borderStyle = .bezel
        currencyListTextField.textAlignment = .left
        currencyListTextField.placeholder = "--Choose--"
        currencyListTextField.font = .systemFont(ofSize: 32)
        currencyListTextField.inputView = currencyPicker
        currencyListTextField.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        lowerStackView.addArrangedSubview(currencyListTextField)

        convertedAmountLabel = UILabel(frame: .zero)
        convertedAmountLabel.text = "0"
        convertedAmountLabel.font = UIFont.systemFont(ofSize: 32)
        convertedAmountLabel.textAlignment = .right
        convertedAmountLabel.textColor = .black
        convertedAmountLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        lowerStackView.addArrangedSubview(convertedAmountLabel)

        view.addSubview(lowerStackView)

        lowerStackView.snp.makeConstraints({ make in
            make.leading.equalTo(currencySourceLabel.snp.leading)
            make.trailing.equalTo(amountTextField.snp.trailing)
            make.top.equalTo(amountTextField.snp.bottom).offset(25)
        })
    }

    private func setupCalculateButton() {
        calculateButton = UIButton(type: .custom)
        calculateButton.setTitle("Calculate", for: .normal)
        calculateButton.setTitleColor(.white, for: .normal)
        calculateButton.backgroundColor = .blue
        calculateButton.layer.cornerRadius = 5
        calculateButton.layer.masksToBounds = true
        view.addSubview(calculateButton)

        calculateButton.snp.makeConstraints({ make in
            make.leading.equalTo(lowerStackView.snp.leading)
            make.trailing.equalTo(lowerStackView.snp.trailing)
            make.top.equalTo(lowerStackView.snp.bottom).offset(25)
            make.height.equalTo(50)
        })
    }

    private func setupActions() {
        preparePickerViewAction()
        prepareCalculateButtonAction()
    }
}

// MARK: - Actions
extension CCMainViewController {
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    private func preparePickerViewAction() {
        currencyArr.bind(to: currencyPicker.rx.itemTitles) { _, element in
            return element
        }.disposed(by: disposeBag)

        currencyPicker.rx
            .itemSelected
            .subscribe(onNext: { [weak self] row, value in
            guard let `self` = self else { return }
            self.currencyArr
                .elementAt(value)
                .subscribe(onNext: { elementValue in
                self.currencyListTextField.text = elementValue[row]
            }).disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
    }

    private func prepareCalculateButtonAction() {
        calculateButton.rx
            .tap
            .asObservable().subscribe(onNext: { _ in
            print()
        }).disposed(by: disposeBag)
    }
}
