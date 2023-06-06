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
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()
    
    private lazy var coordsLabel: UILabel = {
        let label = UILabel()
        label.font = .italicSystemFont(ofSize: 12)
        label.textColor = .init(white: 0.75, alpha: 1)
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
            $0.top.left.right.equalToSuperview().inset(10)
        }
        
        addSubview(coordsLabel)
        coordsLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(5)
            $0.left.right.bottom.equalToSuperview().inset(10)
        }
    }
}

extension CityNameCell {
    func set(city: City) {
        nameLabel.text = city.title
        coordsLabel.text = city.coord.text
    }
}
