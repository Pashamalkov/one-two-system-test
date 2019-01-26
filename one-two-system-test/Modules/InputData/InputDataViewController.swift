//
//  InputDataViewController.swift
//
//  Created by Павел on 23/01/2019.
//  Copyright © 2019 Павел. All rights reserved.
//

import UIKit

final class InputDataViewController: UIViewController, NavigationItemConfigurationProtocol {
    private var viewModel: InputDataViewModelProtocol
    private let tableView = UITableView()
    private let appointButton = AppointButton()
    
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
        tableView.tableFooterView = UIView()
        tableView.register(InfoFieldTableViewCell.self, forCellReuseIdentifier: "InfoFieldTableViewCell")
        appointButton.title = "Отправить"
        appointButton.isEnabled = false
        appointButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        view.addSubview(tableView)
        view.addSubview(appointButton)
        view.updateConstraintsIfNeeded()
    }
    
    private func updateData() {
        title = viewModel.getTitle()
        tableView.reloadData()
    }
}

// MARK: - Layout
extension InputDataViewController {
    override func updateViewConstraints() {
        // Update constraints before `super` call (using SnapKit: *.snp.remakeConstraints)
        tableView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        appointButton.snp.remakeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(48)
            make.bottom.equalToSuperview().inset(32)
        }
        super.updateViewConstraints()
    }
}

// MARK: - Bindings
extension InputDataViewController {
    private func setupBindings() {
        // Setup any bindings, e.g. with viewModel
        viewModel.dataUpdateCallback = { [weak self] in
            guard let self = self else { return }
            self.appointButton.isEnabled = true
            self.updateData()
        }
    }
    
    private func checkButton() {
        var isAvailable = true
        for data in viewModel.newData {
            if let value = data.data, value.value.isEmpty {
                isAvailable = false
            }
        }
        appointButton.isEnabled = isAvailable
    }
}

// MARK: - Actions
extension InputDataViewController {
    // Add any actions here, e.g. button selectors
    
    @objc private func didTapButton() {
        viewModel.uploadData()
    }
}

// MARK: - UITableViewDelegate
extension InputDataViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "InfoFieldTableViewCell", for: indexPath) as? InfoFieldTableViewCell {
            let row = viewModel.rows[indexPath.row]
            cell.fieldId = row.id
            cell.cellName = row.directory.name
            if let newValue = viewModel.newData.first(where: {$0.inputId == "\(row.id)"}), let data = newValue.data {
                cell.title = data.value
            } else {
                cell.title = row.value
            }
        
            cell.textFieldDidChangeCallback = { [weak self] (id,text) in
                guard let self = self else { return }
                self.viewModel.setData(id: id, text: text)
                self.checkButton()
            }
            return cell
        }
        return UITableViewCell()
    }
}

// MARK: - UITableViewDelegate
extension InputDataViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
