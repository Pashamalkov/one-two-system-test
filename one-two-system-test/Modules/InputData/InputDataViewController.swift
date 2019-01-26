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
    
    private let okContentView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 48 + 16 * 2))
        view.backgroundColor = .clear
        view.autoresizingMask = .flexibleHeight
        return view
    }()
    
    override var inputAccessoryView: UIView? {
        return okContentView
    }
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let cell = tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as? InfoFieldTableViewCell {
            cell.makeFirstResponder()
        }
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        updateData()
//    }
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
        okContentView.addSubview(appointButton)
        view.updateConstraintsIfNeeded()
    }
    
    private func updateData() {
        title = viewModel.getTitle()
        tableView.reloadData()
    }
    
    private func resignFIrstResponder() {
        
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
            make.bottom.equalToSuperview().inset(16)
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
        view.endEditing(true)
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        
        viewModel.uploadData(completion: { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: false, completion: nil)
        })
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
            if indexPath.row == 0 {
                cell.makeFirstResponder()
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
