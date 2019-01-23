//
//  NewsListViewController.swift
//  

import Foundation
import UIKit

class TemplateViewController: UIViewController, TemplateViewProtocol, NavigationItemConfigurationProtocol {
  var presenter: TemplatePresenterProtocol! = nil
  
  var tableView: UITableView = UITableView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    createUI()
    self.tableView.delegate = self
    self.tableView.dataSource = self
  }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: - UI
    
    private func createUI () {
        setupNavigationBar()
        view.addSubview(tableView)
        tableView.backgroundColor = .white
        setupConstrains()
    }
    
    func setupConstrains() {
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalTo(view.safeArea.bottom)
        }
    }
    
    func setupNavigationBar() {
        configureTitle("Template", onNavigationItem: navigationItem, attributes: [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16),  NSAttributedStringKey.kern : 5.0])

        navigationController?.navigationBar.barTintColor = UIColor.white
    }
}


extension TemplateViewController: UITableViewDelegate, UITableViewDataSource {
    func updateData() {
      self.tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return UITableViewAutomaticDimension
    }
}

