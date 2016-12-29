//
//  SearchViewController.swift
//  ImageBoardBrowser
//
//  Created by Paul Zhang on 4/12/2016.
//  Copyright © 2016 Paul Zhang. All rights reserved.
//

import UIKit

private let reusableIdentifier = "ImageCollectionViewCell"

class SearchViewController: UIViewController {
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    var imageInfoList: [ImageInfo] = []
    
    var currentImageLoadingTaskCount = 0 {
        didSet {
            if currentImageLoadingTaskCount == 0 {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            } else {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }
        }
    }
    
    var pagesLoaded = 1
    
    var searchedTags = ""
    
    let spacing = 10
    var itemsPerRow = 2 {
        didSet {
            imageCollectionView?.collectionViewLayout.invalidateLayout()
        }
    }
    
    var searchBar: UISearchBar = UISearchBar()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpSearchBar()
        imageCollectionView.register(UINib(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reusableIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.imageInfoList.count != 0 {
            self.navigationController?.hidesBarsOnSwipe = true
        }
        reorderCollectionViewOnRotation()
    }
    
    private func reorderCollectionViewOnRotation() {
        let rect = UIScreen.main.bounds
        if rect.height > rect.width {
            self.itemsPerRow = 2
        } else {
            self.itemsPerRow = 3
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpSearchBar() {
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Enter your tags"
        searchBar.delegate = self
        
        self.navigationItem.titleView = searchBar
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showImageFromSearch" {
            let singleImageViewController = segue.destination as! SingleImageViewController
            singleImageViewController.imageInfo = sender as! ImageInfo
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBar.resignFirstResponder()
    }
    
    private func showNetworkErrorAlertController() {
        let alertController = UIAlertController(title: "No Network", message: "Please connect your device to network", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func loadData(withOtherOperation otherOperation: (() -> Void)?) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        showLoadingIndicatorView()
        ImageDownloader.downloadImages(withTags: self.searchedTags, withPage: pagesLoaded, completionHandler: {(imageInfoList) -> Void in
            self.imageInfoList += imageInfoList
            self.pagesLoaded = self.pagesLoaded + 1
            self.imageCollectionView.reloadData()
            self.hideLoadingIndicatorView()
            otherOperation?()
        }, failureHandler: {(error) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.hideLoadingIndicatorView()
            self.showNetworkErrorAlertController()
        })
    }
    
    func performSearch() {
        prepareForRefresh()
        
        loadData {
            if self.imageInfoList.count != 0 {
                self.imageCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: UICollectionViewScrollPosition.top, animated: true)
                self.navigationController?.hidesBarsOnSwipe = true
            } else {
                self.navigationController?.hidesBarsOnSwipe = false
            }
        }
    }
    
    private func prepareForRefresh() {
        pagesLoaded = 1
        imageInfoList = []
        currentImageLoadingTaskCount = 0
        imageCollectionView?.reloadData()
        
        if imageCollectionView != nil {
            for cell in imageCollectionView.visibleCells {
                if let cell = cell as? ImageCollectionViewCell {
                    cell.forceStopDownloading()
                }
            }
        }
        
    }
    
    fileprivate func loadMoreData() {
        loadData(withOtherOperation: nil)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let rect = UIScreen.main.bounds
        if rect.height > rect.width {
            self.itemsPerRow = 3
        } else {
            self.itemsPerRow = 2
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let tags = searchBar.text {
            self.searchedTags = tags
            searchBar.resignFirstResponder()
            performSearch()
        }
    }
}

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusableIdentifier, for: indexPath) as! ImageCollectionViewCell
        cell.delegate = self
        cell.loadImage(url: imageInfoList[indexPath.row].getPreviewURL())
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageInfoList.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - CGFloat(spacing * (itemsPerRow + 1))) / CGFloat(itemsPerRow)
        return CGSize(width: width, height: width / 1.6)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: CGFloat(spacing), left: CGFloat(spacing), bottom: CGFloat(spacing), right: CGFloat(spacing))
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == imageInfoList.count - 1 {
            loadMoreData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showImageFromSearch", sender: imageInfoList[indexPath.row])
    }
}

extension SearchViewController: ImageCollectionViewCellDelegate {
    func imageLoadingWillStart() {
        currentImageLoadingTaskCount += 1
    }
    
    func imageLoadingDidStop() {
        if currentImageLoadingTaskCount > 0 {
            currentImageLoadingTaskCount -= 1
        }
    }
}
