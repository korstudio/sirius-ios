//
//  HomeViewController.swift
//  SiriusiOS
//
//  Created by Methas Tariya on 31/5/23.
//

import UIKit
import SnapKit

protocol HomeDelegate: AnyObject {
    func displayData()
}

class HomeViewController: UIViewController {
    private let viewModel: HomeViewModel
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()

    private lazy var filterTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.leftView = .init(frame: .init(x: 0, y: 0, width: 12, height: 70))
        textField.leftViewMode = .always
        textField.clearButtonMode = .always
        textField.placeholder = "Search"
        textField.backgroundColor = .init(white: 0.95, alpha: 1)
        textField.textColor = .black
        return textField
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(CityNameCell.self, forCellReuseIdentifier: CityNameCell.id)
        tableView.keyboardDismissMode = .onDrag
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.didLoad()
        setupViews()
        setupObservers()
    }
}

private extension HomeViewController {
    func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(filterTextField)
        filterTextField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(70)
        }

        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(filterTextField.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        activityIndicator.startAnimating()
    }
    
    func setupObservers() {
        viewModel.observeFilter { [weak self] cities in
            self?.tableView.reloadData()
        }
    }
}

extension HomeViewController: HomeDelegate {
    func displayData() {
        activityIndicator.stopAnimating()
        tableView.reloadData()
    }
}

extension HomeViewController: UITableViewDataSource & UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numOfCities
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CityNameCell.id, for: indexPath)
        let key = viewModel.getKey(at: indexPath.row)
        
        if let cityCell = cell as? CityNameCell,
           let city = viewModel.getCity(with: key) {
            cityCell.set(name: city.title)
        }
        
        return cell
    }
}
