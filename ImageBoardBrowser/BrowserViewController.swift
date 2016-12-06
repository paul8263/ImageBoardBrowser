//
//  BrowserViewController.swift
//  ImageBoardBrowser
//
//  Created by Paul Zhang on 4/12/2016.
//  Copyright © 2016 Paul Zhang. All rights reserved.
//

import UIKit
import AFNetworking

class BrowserViewController: UIViewController {
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    var imageInfoList: [ImageInfo] = []
    
    let spacing = 10
    var itemsPerRow = 2
    
    var pagesLoaded = 1
    
    @IBAction func rightBarButtonItemTouched(_ sender: UIBarButtonItem) {
        pagesLoaded = 1
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        ImageDownloader.downloadImages(withPage: pagesLoaded, completionHandler: {(imageInfoList) -> Void in
            self.imageInfoList = imageInfoList
            self.pagesLoaded = self.pagesLoaded + 1
            self.imageCollectionView.reloadData()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if self.imageInfoList.count != 0 {
                self.imageCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: UICollectionViewScrollPosition.top, animated: true)
            }
        }, failureHandler: {(error) in
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.showNetworkErrorAlertController()
            }
        })

    }
    
    func showNetworkErrorAlertController() {
        let alertController = UIAlertController(title: "No Network", message: "Please connect your device to network", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if self.imageInfoList.count == 0 {
            loadMoreData()
        }        
    }
    
    func loadMoreData() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        ImageDownloader.downloadImages(withPage: pagesLoaded, completionHandler: {(imageInfoList) -> Void in
            self.imageInfoList += imageInfoList
            self.pagesLoaded = self.pagesLoaded + 1
            self.imageCollectionView.reloadData()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.navigationController?.hidesBarsOnSwipe = true
        }, failureHandler: {(error) in
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.showNetworkErrorAlertController()
            }            
        })
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
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        let rect = UIScreen.main.bounds
        if rect.height > rect.width {
            self.itemsPerRow = 3
        } else {
            self.itemsPerRow = 2
        }
        if let collectionView = self.imageCollectionView {
            collectionView.reloadData()
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        cell.loadImage(urlString: self.imageInfoList[indexPath.row].previewUrl)
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
