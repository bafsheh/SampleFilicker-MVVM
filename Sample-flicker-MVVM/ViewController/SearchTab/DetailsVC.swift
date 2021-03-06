//
//  DetailsViewController.swift
//  Sample-flicker-MVVM
//
//  Created by Babak Afsheh on 12/20/20.
//

import UIKit

class DetailsVC: UIViewController {
    @IBOutlet weak var tableView: UITableView?
    var activityIndicator: ActivityIndicator? = ActivityIndicator()
    var selectedData: PhotosModel?
    let dataSource = DetailsViewDataSource()
    lazy var viewModel: DetailsViewModel = {
        let viewModel = DetailsViewModel(dataSource: dataSource)
        return viewModel
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupViewModel()
        self.setupTableView()
    }
    

    func setupUI() {
        self.navigationItem.title = "Details"
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "<--Search", style: .plain, target: self, action: #selector(back(sender:)))
                self.navigationItem.leftBarButtonItem = newBackButton
    }
    @objc func back(sender: UIBarButtonItem) {
        if let view = self.navigationController?.view {
            UIView.transition(
                with: view,
                duration: 0.75,
                options: .transitionFlipFromRight,
                animations: { [self] in
                    self.navigationController?.popViewController(animated: true)
                })
        }
    }

    func setupTableView() {
        self.tableView?.tableFooterView = UIView(frame: CGRect.zero)
    }

    func setupViewModel() {
        self.tableView?.dataSource = self.dataSource
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.activityIndicator?.start()
        self.viewModel.fetchDataSource(photoData: self.selectedData) { _ in
            DispatchQueue.main.async {
                self.activityIndicator?.stop()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.tableView?.reloadData()
            }
        }
        self.dataSource.data.addAndNotify(observer: self) { [weak self] _ in
            self?.tableView?.reloadData()
        }
    }
}

// MARK: - TableViewDelegate Setup
extension DetailsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return UITableView.automaticDimension
        default:
            return 60
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return UITableView.automaticDimension
        default:
            return 60
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tapped")
    }
}

