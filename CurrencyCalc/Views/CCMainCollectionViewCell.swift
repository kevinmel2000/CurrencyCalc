//
//  CCMainCollectionViewCell.swift
//  CurrencyCalc
//
//  Created by Luthfi Fathur Rahman on 15/02/20.
//  Copyright © 2020 StandAlone. All rights reserved.
//

import UIKit
import SnapKit

class CCMainCollectionViewCell: UICollectionViewCell {
    private var label: UILabel!

    func setupData(with text: String) {
        backgroundColor = .orange
        if label == nil {
            label = UILabel(frame: .zero)
            var customData = UISetupModel()
            customData.text = text
            customData.textAlignment = .center
            customData.textColor = .white
            customData.font = .systemFont(ofSize: 15)
            customData.numberOfLines = 0
            label.setup(with: customData)

            contentView.addSubview(label)

            label.snp.makeConstraints({ make in
                make.edges.equalToSuperview()
            })
        }
    }
}
