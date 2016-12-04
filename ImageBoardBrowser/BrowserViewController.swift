//
//  BrowserViewController.swift
//  ImageBoardBrowser
//
//  Created by Paul Zhang on 4/12/2016.
//  Copyright © 2016 Paul Zhang. All rights reserved.
//

import UIKit

class BrowserViewController: UIViewController {
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    var imageInfoList: [ImageInfo] = []
    
    let spacing = 10
    let itemsPerRow = 2
    
    var pagesLoaded = 1

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        loadMoreData()
    }
    
    func loadMoreData() {
        ImageDownloader.downloadImages(withPage: pagesLoaded, completionHandler: {(imageInfoList) -> Void in
            self.imageInfoList += imageInfoList
            self.pagesLoaded = self.pagesLoaded + 1
            self.imageCollectionView.reloadData()
        })
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
    
}
