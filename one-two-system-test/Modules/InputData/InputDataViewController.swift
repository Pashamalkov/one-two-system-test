//
//  InputDataViewController.swift
//
//  Created by Павел on 23/01/2019.
//  Copyright © 2019 Павел. All rights reserved.
//

import UIKit

final class InputDataViewController: UIViewController, NavigationItemConfigurationProtocol {
    private let viewModel: InputDataViewModelProtocol
    private let tableView = UITableView()
    
    init(viewModel: InputDataViewModelProtocol) {
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
extension InputDataViewController {
    private func setupUI() {
        title = viewModel.getTitle()
        view.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        view.addSubview(tableView)
        view.updateConstraintsIfNeeded()
    }
}

// MARK: - Layout
extension InputDataViewController {
    override func updateViewConstraints() {
        // Update constraints before `super` call (using SnapKit: *.snp.remakeConstraints)
        tableView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        super.updateViewConstraints()
    }
}

// MARK: - Bindings
extension InputDataViewController {
    private func setupBindings() {
        // Setup any bindings, e.g. with viewModel
        viewModel.dataUpdateCallback?()
    }
}

// MARK: - Actions
extension InputDataViewController {
    // Add any actions here, e.g. button selectors
}

// MARK: - UITableViewDelegate
extension InputDataViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5//viewModel.rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

// MARK: - UITableViewDelegate
extension InputDataViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
