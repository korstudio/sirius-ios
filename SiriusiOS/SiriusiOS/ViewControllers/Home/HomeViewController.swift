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

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(CityNameCell.self, forCellReuseIdentifier: CityNameCell.id)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init()
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
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func setupObservers() {
        viewModel.observeFilter { [weak self] cities in
            self?.tableView.reloadData()
        }
    }
}

extension HomeViewController: HomeDelegate {
    func displayData() {
        tableView.reloadData()
    }
}

extension HomeViewController: UITableViewDataSource & UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numOfCities
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        .init()
    }
}
