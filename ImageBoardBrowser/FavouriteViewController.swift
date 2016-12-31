//
//  FavouriteViewController.swift
//  ImageBoardBrowser
//
//  Created by Paul Zhang on 4/12/2016.
//  Copyright © 2016 Paul Zhang. All rights reserved.
//

import UIKit

private let reusableIdentifier = "ImageCollectionViewCell"

class FavouriteViewController: UIViewController {
    var imageInfoList: [ImageInfo] = []
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    var currentImageLoadingTaskCount = 0 {
        didSet {
            if currentImageLoadingTaskCount == 0 {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            } else {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }
        }
    }
    
    var numberOfColumns: Int {
        set {
            (imageCollectionView.collectionViewLayout as! PZImageBoardCollectionViewLayout).numberOfColumn = newValue
        }
        get {
            return (imageCollectionView.collectionViewLayout as! PZImageBoardCollectionViewLayout).numberOfColumn
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imageCollectionView.register(UINib(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reusableIdentifier)
        setupCollectionViewLayout()
        setNumberOfColumnsAfterScreenRotation()
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
            layout.contentWidth = view.frame.width
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
        loadData()
        if self.imageInfoList.count != 0 {
            self.navigationController?.hidesBarsOnSwipe = true
        }
        setNumberOfColumnsAfterScreenRotation()
    }
    
    private func loadData() {
        self.imageInfoList = FavouriteStorageHelper.loadFavouriteList()
        self.imageCollectionView.reloadData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: nil) { (context) in
            self.setNumberOfColumnsAfterScreenRotation()
            self.centerLoadingIndicatorView()
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showImageFromFavourite" {
            let singleImageViewController = segue.destination as! SingleImageViewController
            singleImageViewController.imageInfo = sender as! ImageInfo
        }
    }
}

extension FavouriteViewController: UICollectionViewDataSource, UICollectionViewDelegate {
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showImageFromFavourite", sender: imageInfoList[indexPath.row])
    }
}

extension FavouriteViewController: PZImageBoardCollectionViewLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, heightForCellAtIndexPath indexPath: IndexPath) -> CGFloat {
        let imageInfo = imageInfoList[indexPath.row]
        let ratio: CGFloat = CGFloat(imageInfo.actualPreviewHeight) / CGFloat(imageInfo.actualPreviewWidth)
        let columnWidth = (layout as! PZImageBoardCollectionViewLayout).columnWidth
        return columnWidth * ratio
    }
}

extension FavouriteViewController: ImageCollectionViewCellDelegate {
    func imageLoadingWillStart() {
        currentImageLoadingTaskCount += 1
    }
    
    func imageLoadingDidStop() {
        if currentImageLoadingTaskCount > 0 {
            currentImageLoadingTaskCount -= 1
        }
    }
}
