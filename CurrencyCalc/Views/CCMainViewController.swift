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
    typealias CVCell = CCMainCollectionViewCell
    typealias Constants = CConstants.MainVC

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
    private var dateLabel: UILabel!
    private var collectionView: UICollectionView!

    private let currencyArr = Observable.just(CConstants.API.currencyArr)
    private var currencyData: [String]?
    private let cellID = String(describing: CVCell.self)

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
        title = Constants.title
        view.backgroundColor = .white

        setupEvents()
        setupViews()

        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.addTarget(self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGestureRecognizer)

//        viewModel.viewModelEvents.onNext(.getCurrenciesData(.live))
        viewModel.viewModelEvents.onNext(.getCurrenciesData(.historical))
    }
}

// MARK: - Setup
extension CCMainViewController {
    private func setupEvents() {
        viewModel.uiEvents.subscribe(onNext: { [weak self] event in
            guard let `self` = self else { return }
            switch event {
            case .requestDataSuccess:
                guard let response = self.viewModel.currencyLayerResponse else { return }
                self.currencyData = response.getQuoteArr().compactMap({$0})
                self.collectionView.reloadData()
                CCGlobalTimer.shared.startTimer()
                if let strDate = response.date {
                    self.dateLabel.text = String(format: Constants.dateLabel, arguments: [strDate])
                }
            case .requestDataFailure(let error):
                var alertModel = UIAlertModel(style: .alert)
                if let error = error {
                    alertModel.message = error.responseString ?? String()
                } else {
                    guard let response = self.viewModel.currencyLayerResponse,
                        let error = response.error else { return }
                    alertModel.message = error.info ?? String() + "(code: \(error.code ?? 0))"
                }

                alertModel.title = "Request Data Failure"
                alertModel.actions = [UIAlertActionModel(title: "OK", style: .cancel)]
                self.showAlert(with: alertModel)
                .asObservable()
                .subscribe(onNext: { selectedActionIdx in
                //handle the action here
                    print("alert action index = \(selectedActionIdx)")
                }).disposed(by: self.disposeBag)
            case .resultCalculation(let result):
                DispatchQueue.main.async {
                    self.convertedAmountLabel.text  = String(format: "%.2f", result)
                }
            default: break
            }
        }).disposed(by: disposeBag)
    }

    private func setupViews() {
        setupSourceField()
        setupConvertedField()
        setupCalculateButton()
        setupExchangeDataField()
        setupActions()
    }

    private func setupSourceField() {
        upperStackView = UIStackView(frame: .zero)
        upperStackView.distribution = .fill

        var customData = UISetupModel()
        var chp = ContentHuggingPrio(prio: .defaultHigh, axis: .horizontal)

        currencySourceLabel = UILabel(frame: .zero)
        customData.text = "USD"
        customData.textAlignment = .left
        customData.textColor = .black
        customData.contentHuggingPrio = chp
        currencySourceLabel.setup(with: customData)
        upperStackView.addArrangedSubview(currencySourceLabel)

        amountTextField = UITextField(frame: .zero)
        customData.placeholderText = "Type number here"
        customData.keyboardType = .numberPad
        customData.textAlignment = .right
        chp = ContentHuggingPrio(prio: .defaultLow, axis: .horizontal)
        customData.contentHuggingPrio = chp
        amountTextField.setup(with: customData)
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

        var customData = UISetupModel()
        var chp = ContentHuggingPrio(prio: .defaultHigh, axis: .horizontal)

        currencyListTextField = UITextField(frame: .zero)
        customData.placeholderText = "--Choose--"
        customData.textAlignment = .center
        customData.contentHuggingPrio = chp
        currencyListTextField.setup(with: customData)
        currencyListTextField.inputView = currencyPicker
        lowerStackView.addArrangedSubview(currencyListTextField)

        convertedAmountLabel = UILabel(frame: .zero)
        customData.text = String(format: "%.2f", arguments: [0])
        customData.textAlignment = .right
        customData.textColor = .black
        chp = ContentHuggingPrio(prio: .defaultLow, axis: .horizontal)
        customData.contentHuggingPrio = chp
        convertedAmountLabel.setup(with: customData)
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

    private func setupExchangeDataField() {
        dateLabel = UILabel(frame: .zero)
        var customData = UISetupModel()
        customData.text = String(format: Constants.dateLabel, arguments: ["-"])
        customData.textAlignment = .left
        customData.textColor = .black
        customData.font = .systemFont(ofSize: 15)
        customData.numberOfLines = 0
        dateLabel.setup(with: customData)
        view.addSubview(dateLabel)

        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.minimumLineSpacing = 10
        collectionViewLayout.minimumInteritemSpacing = 10
        collectionViewLayout.itemSize = CGSize(width: 150, height: 150)
        collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: collectionViewLayout)
        collectionView.register(CVCell.self,
                                forCellWithReuseIdentifier: cellID)
        collectionView.allowsSelection = false
        collectionView.allowsMultipleSelection = false
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)

        dateLabel.snp.makeConstraints({ make in
            make.leading.equalTo(calculateButton.snp.leading)
            make.trailing.equalTo(calculateButton.snp.trailing)
            make.top.equalTo(calculateButton.snp.bottom).offset(15)
//            make.height.equalTo(25)
        })

        collectionView.snp.makeConstraints({ make in
            make.leading.equalTo(dateLabel.snp.leading)
            make.trailing.equalTo(dateLabel.snp.trailing)
            make.bottom.equalTo(view.snp.bottomMargin).offset(25)
            make.top.equalTo(dateLabel.snp.bottom).offset(15)
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
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                guard let `self` = self else { return }
                var amount: Float = 0
                var exchange = String()
                if let amountTxt = self.amountTextField.text,
                    let xchgTxt =  self.currencyListTextField.text,
                    let amountFloat = Float(amountTxt) {
                    amount = amountFloat
                    exchange = xchgTxt
                }
                self.viewModel
                    .viewModelEvents
                    .onNext(.calculateExchangeCurrency(amount, exchange))
        }).disposed(by: disposeBag)
    }
}

extension CCMainViewController: UICollectionViewDelegateFlowLayout,
UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currencyData?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: cellID,
                                 for: indexPath) as? CVCell else { return UICollectionViewCell()}
        return cell
    }
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        guard let cell = cell as? CVCell, let data = currencyData else { return }
        var text = String()
        currencyArr
            .enumerated()
            .subscribe(onNext: { value in
                text = value.element[indexPath.item] + ":\n" + data[indexPath.item]
                cell.setupData(with: text)
            }).disposed(by: disposeBag)
    }
}
