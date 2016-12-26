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
    
    let spacing = 10
    
    var itemsPerRow = 2 {
        didSet {
            imageCollectionView?.collectionViewLayout.invalidateLayout()
        }
    }
    
    var pagesLoaded = 1
    
    private func loadData(withOtherOperation otherOperation: (() -> Void)?) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.showLoadingIndicatorView()
        ImageDownloader.downloadImages(withPage: pagesLoaded, completionHandler: {(downloadedImageInfoList) -> Void in
            self.imageInfoList += downloadedImageInfoList
            self.pagesLoaded += 1
            self.imageCollectionView.reloadData()
            self.navigationController?.hidesBarsOnSwipe = true
            self.hideLoadingIndicatorView()
            otherOperation?()
        }, failureHandler: {(error) in
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.hideLoadingIndicatorView()
                self.showNetworkErrorAlertController()
            }
        })
    }
    
    @IBAction func rightBarButtonItemTouched(_ sender: UIBarButtonItem) {
        
        pagesLoaded = 1
        self.imageInfoList = []
        loadData { 
            if self.imageInfoList.count != 0 {
                self.imageCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: UICollectionViewScrollPosition.top, animated: true)
            }
        }
    }
    
    private func showNetworkErrorAlertController() {
        let alertController = UIAlertController(title: "No Network", message: "Please connect your device to network", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imageCollectionView.register(UINib(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reusableIdentifier)
        let rect = UIScreen.main.bounds
        if rect.height < rect.width {
            self.itemsPerRow = 3
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
        let rect = UIScreen.main.bounds
        if rect.height > rect.width {
            self.itemsPerRow = 3
        } else {
            self.itemsPerRow = 2
        }
    }
}

extension BrowserViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
        performSegue(withIdentifier: "showImage", sender: imageInfoList[indexPath.row])
    }
}

extension BrowserViewController: ImageCollectionViewCellDelegate {
    func imageLoadingWillStart() {
        currentImageLoadingTaskCount += 1
    }
    
    func imageLoadingDidStop() {
        if currentImageLoadingTaskCount > 0 {
            currentImageLoadingTaskCount -= 1
        }
    }
}
