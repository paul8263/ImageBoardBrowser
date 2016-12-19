//
//  SingleImageViewController.swift
//  ImageBoardBrowser
//
//  Created by Paul Zhang on 4/12/2016.
//  Copyright © 2016 Paul Zhang. All rights reserved.
//

import UIKit
import SDWebImage

class SingleImageViewController: UIViewController {
    
    var imageInfo: ImageInfo!
    
    var alertController: UIAlertController?
    
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loadingProgressView: UIProgressView!
    
    
    @IBOutlet weak var imageLoadingIndicator: UIActivityIndicatorView!
    @IBAction func rightBarButtonItemTouched(_ sender: UIBarButtonItem) {
//        UIImageWriteToSavedPhotosAlbum(self.imageView.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        performSegue(withIdentifier: "showImageInfo", sender: imageInfo)
    }
    
    func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        
        if let _ = error {
            let failureAlertController = UIAlertController(title: nil, message: "Image failed to save", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            failureAlertController.addAction(okAction)
            self.present(failureAlertController, animated: true, completion: nil)
        } else {
            let successAlertController = UIAlertController(title: nil, message: "Image has been saved", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            successAlertController.addAction(okAction)
            self.present(successAlertController, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 5.0
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(sender:)))
        self.scrollView.addGestureRecognizer(longPressGestureRecognizer)
        
        imageLoadingIndicator.isHidden = false
        imageLoadingIndicator.hidesWhenStopped = true
    }
    
    func longPressed(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            if let alertController = self.alertController {
                present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func createAlertController() -> UIAlertController {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let favouriteAction: UIAlertAction!
        if FavouriteStorageHelper.isExisting(imageInfo: imageInfo) {
            favouriteAction = UIAlertAction(title: "Remove from Favourite", style: UIAlertActionStyle.default, handler: { (action) in
                FavouriteStorageHelper.removeOneFromFavouriteList(imageInfo: self.imageInfo)
                self.alertController = self.createAlertController()
            })
        } else {
            favouriteAction = UIAlertAction(title: "Add to Favourite", style: UIAlertActionStyle.default, handler: { (action) in
                FavouriteStorageHelper.addToFavouriteList(imageInfo: self.imageInfo)
                self.alertController = self.createAlertController()
            })
        }
        
        let saveToAlbumAction = UIAlertAction(title: "Save to Album", style: UIAlertActionStyle.default, handler: { (action) in
            UIImageWriteToSavedPhotosAlbum(self.imageView.image!, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
        })
        let requestLargerImageAction = UIAlertAction(title: "Request Larger Image", style: UIAlertActionStyle.default, handler: { (action) in
            self.loadImage(withURL: self.imageInfo.getJpegURL())
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        alertController.addAction(favouriteAction)
        alertController.addAction(saveToAlbumAction)
        alertController.addAction(requestLargerImageAction)
        alertController.addAction(cancelAction)
        return alertController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.hidesBarsOnSwipe = false
        self.tagsLabel.text = imageInfo.tags
        
        loadImage(withURL: imageInfo.getSampleURL())
        
        self.alertController = createAlertController()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cancelLoadImage()
    }
    
    func loadImage(withURL url: URL) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        imageLoadingIndicator.startAnimating()
        loadingProgressView.isHidden = false
        loadingProgressView.setProgress(0, animated: false)
        
        self.imageView.sd_setImage(
            with: url,
            placeholderImage: UIImage(named: "placeholder"),
            options: SDWebImageOptions.allowInvalidSSLCertificates,
            progress: { (finished, expected) in
                DispatchQueue.main.async {
                    let progress = (Float(finished) / Float(expected))
                    self.loadingProgressView.setProgress(progress, animated: true);
                }
        },
            completed: { void in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.loadingProgressView.isHidden = true
                self.imageLoadingIndicator.stopAnimating()
        })
    }
    
    func cancelLoadImage() {
        self.imageView.sd_cancelCurrentImageLoad()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showImageInfo" {
            let imageInfoTableViewController = segue.destination as! ImageInfoTableViewController
            imageInfoTableViewController.imageInfo = sender as! ImageInfo
        }
    }
    

}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}
