//
//  SearchVC.swift
//  SampleFlicker-MVVm
//
//  Created by Babak Afsheh on 12/18/20.
//

import UIKit
import CoreLocation

class SearchVC:UIViewController {
    @IBOutlet var collectionView: UICollectionView?
    @IBOutlet weak var searchBar: UISearchBar?
    fileprivate let sectionInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
    fileprivate let itemsPerRow: CGFloat = 3
    var activityIndicator: ActivityIndicator? = ActivityIndicator()
    var searchActive: Bool = false
    let dataSource = SearchViewDataSource()
    private var isWaiting = false
    private var isLastPage = false
   
    lazy var viewModel: SearchViewModel = {
        let viewModel = SearchViewModel(dataSource: dataSource)
        return viewModel
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupViewModel()
        self.setupLocationService()
    }

    func setupUI() {
        self.title = "Flickr Search"
        self.view.backgroundColor = .white
    }

    func setupViewModel() {
        self.collectionView?.dataSource = self.dataSource
        self.dataSource.data.addAndNotify(observer: self) { [weak self] _ in
            self?.collectionView?.reloadData()
        }
        if let _ = LocationService.sharedInstance.lastLocation {
            self.methodViewModelService()
        }
        self.viewModel.onErrorHandling = { [weak self] error in
            self?.showAlert(title: "An error occured", message: "Oops, something went wrong!")
        }
    }

    func methodViewModelService(_ searchText: String? = "") {
        guard let strText = searchText else {return}
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.activityIndicator?.start()
        self.viewModel.fetchServiceCall(strText) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.activityIndicator?.stop()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.searchActive = false
                    self.collectionView?.reloadData()
                    self.isWaiting = false
                    self.isLastPage = false
                    break
                case .failure(let error) :
                    self.showAlert(title: "Netwrok Error", message: error.localizedDescription)
                }
            }
        }
    }
    private func loadMoreData() {
        self.activityIndicator?.start()
        self.viewModel.fetchNextPage() { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let isLastPage):
                    self.activityIndicator?.stop()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.searchActive = false
                    self.collectionView?.reloadData()
                    self.isWaiting = false
                    self.isLastPage = isLastPage
                    break
                    
                case .failure(let error) :
                    self.showAlert(title: "Netwrok Error", message: error.localizedDescription)
                    
                }
            }
        }
    }
}
// MARK: UICollectionViewDelegateFlowLayout
extension SearchVC: UICollectionViewDelegateFlowLayout {
    func setupCollectionView() {
        guard let layout = self.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        self.collectionView?.collectionViewLayout = layout
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        self.collectionView?.backgroundColor = .white
        self.collectionView?.showsHorizontalScrollIndicator = false
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewModel.presentProfile(indexPath) { (_) in
            
            if let storyBoard = self.storyboard
               ,let vc:DetailsVC = storyBoard.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsVC {
                vc.selectedData = self.viewModel.selectedData
                vc.hidesBottomBarWhenPushed = true
                if let view = self.navigationController?.view {
                    UIView.transition(
                        with: view,
                        duration: 0.75,
                        options: .transitionFlipFromRight,
                        animations: { [self] in
                            self.navigationController?.pushViewController(vc, animated: false)
                        })
                }
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        let heightPerItem = widthPerItem + 21
        return CGSize(width: widthPerItem, height: heightPerItem)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == dataSource.data.value.count-1 && !self.isWaiting && !self.isLastPage  {
            isWaiting = true;
            self.loadMoreData()
        }
    }
}

// MARK: LocationServiceDelegate
extension SearchVC: LocationServiceDelegate {
    func setupLocationService() {
        LocationService.sharedInstance.delegate = self
        LocationService.sharedInstance.startUpdatingLocation()
    }

    func locationDidUpdate(_ currentLocation: CLLocation) {
        self.methodViewModelService()
    }

    func locationDidFail(_ error: Error) {
        print("tracing Location Error : \(error)")
    }
}



// MARK: - UISearchBarDelegate Setup
extension SearchVC: UISearchBarDelegate {

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.methodFlickerSearch(searchBar.text)
        view.endEditing(true)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchActive = true
    }

    func methodFlickerSearch(_ searchText: String?) {
        guard let strText = searchText else {return}
        if !strText.isEmpty {
            let searchText: String =  searchText!.replacingOccurrences(of: " ", with: "")
            self.methodViewModelService(searchText)
        } else {
            searchActive = false
        }
    }
}
