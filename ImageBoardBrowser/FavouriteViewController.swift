//
//  FavouriteViewController.swift
//  ImageBoardBrowser
//
//  Created by Paul Zhang on 4/12/2016.
//  Copyright © 2016 Paul Zhang. All rights reserved.
//

import UIKit

class FavouriteViewController: UIViewController {
    var imageInfoList: [ImageInfo] = []
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    let spacing = 10
    var itemsPerRow = 2 {
        didSet {
            imageCollectionView?.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        reorderCollectionViewOnRotation()
    }
    
    func reorderCollectionViewOnRotation() {
        let rect = UIScreen.main.bounds
        if rect.height > rect.width {
            self.itemsPerRow = 2
        } else {
            self.itemsPerRow = 3
        }
    }
    
    func loadData() {
        self.imageInfoList = FavouriteStorageHelper.loadFavouriteList()
        self.imageCollectionView.reloadData()
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        let rect = UIScreen.main.bounds
        if rect.height > rect.width {
            self.itemsPerRow = 3
        } else {
            self.itemsPerRow = 2
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

extension FavouriteViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageInfoList.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favouriteImageCollectionViewCell", for: indexPath) as! FavouriteImageCollectionViewCell
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showImageFromFavourite", sender: imageInfoList[indexPath.row])
    }
    
}
