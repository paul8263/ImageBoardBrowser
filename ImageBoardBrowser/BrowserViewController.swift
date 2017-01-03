//
//  BrowserViewController.swift
//  ImageBoardBrowser
//
//  Created by Paul Zhang on 4/12/2016.
//  Copyright © 2016 Paul Zhang. All rights reserved.
//

import UIKit
import AFNetworking
import SDWebImage

private let reusableIdentifier = "imageCollectionViewCell"

class BrowserViewController: UIViewController {
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    let reachabilityManager = AFNetworkReachabilityManager.shared()
    let activityIndicatorManager = AFNetworkActivityIndicatorManager.shared()
    
    var imageInfoList: [ImageInfo] = []
    
    var numberOfColumns: Int {
        set {
            (imageCollectionView.collectionViewLayout as! PZImageBoardCollectionViewLayout).numberOfColumn = newValue
        }
        get {
            return (imageCollectionView.collectionViewLayout as! PZImageBoardCollectionViewLayout).numberOfColumn
        }
    }
    
    var pagesLoaded = 1
    
    private func loadData(withOtherOperation otherOperation: (() -> Void)?) {
        self.showLoadingIndicatorView()
        ImageDownloader.downloadImages(withPage: pagesLoaded, completionHandler: {(downloadedImageInfoList) -> Void in
            self.imageInfoList += downloadedImageInfoList
            self.pagesLoaded += 1
            self.imageCollectionView.reloadData()
            self.navigationController?.hidesBarsOnSwipe = true
            self.hideLoadingIndicatorView()
            otherOperation?()
        }, failureHandler: {(error) in            
            self.hideLoadingIndicatorView()
            if !self.reachabilityManager.isReachable {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.showNetworkErrorAlertController()
            }
        })
    }
    
    @IBAction func rightBarButtonItemTouched(_ sender: UIBarButtonItem) {
        prepareForRefresh()
        loadData(withOtherOperation: nil)
    }
    
    private func prepareForRefresh() {
        pagesLoaded = 1
        imageInfoList = []
        imageCollectionView.reloadData()
        
        for cell in imageCollectionView.visibleCells {
            if let cell = cell as? ImageCollectionViewCell {
                cell.forceStopDownloading()
            }
        }
    }
    
    fileprivate func showNetworkErrorAlertController() {
        let alertController = UIAlertController(title: "No Network", message: "Please connect your device to network", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imageCollectionView.register(UINib(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reusableIdentifier)
     
        setupCollectionViewLayout()
    }
    
    private func setupCollectionViewLayout() {
        let layout = PZImageBoardCollectionViewLayout()
        layout.cellMargin = 10
        layout.contentWidth = view.frame.width
        imageCollectionView.collectionViewLayout = layout
    }
    
    private func setNumberOfColumnsAfterScreenRotation() {
        if let layout = imageCollectionView?.collectionViewLayout as? PZImageBoardCollectionViewLayout {
            let isIpad = UIDevice.current.userInterfaceIdiom == .pad
            layout.contentWidth = UIScreen.main.bounds.width
            let orientation = UIApplication.shared.statusBarOrientation
            switch orientation {
            case .portrait:
                numberOfColumns = isIpad ? 3 : 2
            case .landscapeLeft, .landscapeRight:
                numberOfColumns = 3
            default:
                numberOfColumns = isIpad ? 3 : 2
            }
            imageCollectionView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.imageInfoList.count != 0 {
            self.navigationController?.hidesBarsOnSwipe = true
        }
        setNumberOfColumnsAfterScreenRotation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if self.imageInfoList.count == 0 {
            loadMoreData()
        }        
    }
    
    fileprivate func loadMoreData() {
        loadData(withOtherOperation: nil)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showImage" {
            let singleImageViewController = segue.destination as! SingleImageViewController
            singleImageViewController.imageInfo = sender as! ImageInfo
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { (context) in
            self.setNumberOfColumnsAfterScreenRotation()
            self.centerLoadingIndicatorView()
        }
    }
}

extension BrowserViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageInfoList.count;
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusableIdentifier, for: indexPath) as! ImageCollectionViewCell
        cell.delegate = self
        cell.loadImage(url: self.imageInfoList[indexPath.row].getPreviewURL())
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == imageInfoList.count - 1 {
            if reachabilityManager.isReachable {
                loadMoreData()
            } else {
                showNetworkErrorAlertController()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showImage", sender: imageInfoList[indexPath.row])
    }
}

extension BrowserViewController: PZImageBoardCollectionViewLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, heightForCellAtIndexPath indexPath: IndexPath) -> CGFloat {
        let imageInfo = imageInfoList[indexPath.row]
        let ratio: CGFloat = CGFloat(imageInfo.actualPreviewHeight) / CGFloat(imageInfo.actualPreviewWidth)
        let columnWidth = (layout as! PZImageBoardCollectionViewLayout).columnWidth
        return columnWidth * ratio
    }
}

extension BrowserViewController: ImageCollectionViewCellDelegate {
    func imageLoadingWillStart() {
        activityIndicatorManager.incrementActivityCount()
    }
    
    func imageLoadingDidStop() {
        activityIndicatorManager.decrementActivityCount()
    }
}

