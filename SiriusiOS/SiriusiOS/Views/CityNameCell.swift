//
// CityNameCell
// SiriusiOS
//
// Created by Methas Tariya on 31/5/23.
//

import UIKit
import SnapKit

class CityNameCell: UITableViewCell {
    static let id: String = "CityNameCell"

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .black
        return label
    }()

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .white
        setupView()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupView() {
        // Name label
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
    }
}

extension CityNameCell {
    func set(name: String) {
        nameLabel.text = name
    }
}
