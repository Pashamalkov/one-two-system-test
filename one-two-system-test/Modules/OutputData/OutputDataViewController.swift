//
//  OutputDataViewController.swift
//
//  Created by Павел on 26/01/2019.
//  Copyright © 2019 Павел. All rights reserved.
//

import UIKit

final class OutputDataViewController: UIViewController, NavigationItemConfigurationProtocol {
    private var viewModel: OutputDataViewModelProtocol
    private let tableView = UITableView()
    
    init(viewModel: OutputDataViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
}

// MARK: - UI
extension OutputDataViewController {
    private func setupUI() {
        title = viewModel.getTitle()
        view.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
        tableView.register(InfoFieldTableViewCell.self, forCellReuseIdentifier: "InfoFieldTableViewCell")
        view.addSubview(tableView)
        view.updateConstraintsIfNeeded()
    }
    
    private func updateData() {
        title = viewModel.getTitle()
        tableView.reloadData()
    }
}

// MARK: - Layout
extension OutputDataViewController {
    override func updateViewConstraints() {
        // Update constraints before `super` call (using SnapKit: *.snp.remakeConstraints)
        tableView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        super.updateViewConstraints()
    }
}

// MARK: - Bindings
extension OutputDataViewController {
    private func setupBindings() {
        // Setup any bindings, e.g. with viewModel
        viewModel.dataUpdateCallback = { [weak self] in
            guard let self = self else { return }
            self.updateData()
        }
    }
}

// MARK: - Actions
extension OutputDataViewController {
    // Add any actions here, e.g. button selectors
}

// MARK: - UITableViewDelegate
extension OutputDataViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "InfoFieldTableViewCell", for: indexPath) as? InfoFieldTableViewCell {
            let row = viewModel.rows[indexPath.row]
            cell.cellName = row.0.directory.name
            cell.title = row.1
            cell.isEditable = false
            return cell
        }
        return UITableViewCell()
    }
}

// MARK: - UITableViewDelegate
extension OutputDataViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
