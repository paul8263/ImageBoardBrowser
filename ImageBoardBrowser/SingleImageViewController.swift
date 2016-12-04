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
    
    @IBOutlet weak var imageLoadingIndicator: UIActivityIndicatorView!
    @IBAction func rightBarButtonItemTouched(_ sender: UIBarButtonItem) {
        UIImageWriteToSavedPhotosAlbum(self.imageView.image!, nil, nil, nil)
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
        print(FavourateStorageHelper.isExisting(imageInfo: imageInfo))
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let favourateAction: UIAlertAction!
        if FavourateStorageHelper.isExisting(imageInfo: imageInfo) {
            favourateAction = UIAlertAction(title: "Remove from Favourate", style: UIAlertActionStyle.default, handler: { (action) in
                FavourateStorageHelper.removeOneFromFavourateList(imageInfo: self.imageInfo)
            })
        } else {
            favourateAction = UIAlertAction(title: "Add to Favourate", style: UIAlertActionStyle.default, handler: { (action) in
                FavourateStorageHelper.addToFavourateList(imageInfo: self.imageInfo)
            })
        }
        
        let saveToAlbumAction = UIAlertAction(title: "Save to Album", style: UIAlertActionStyle.default, handler: { (action) in
            UIImageWriteToSavedPhotosAlbum(self.imageView.image!, nil, nil, nil)
        })
        let requestLargerImageAction = UIAlertAction(title: "Request Larger Image", style: UIAlertActionStyle.default, handler: { (action) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            self.imageLoadingIndicator.startAnimating()
            self.imageView.sd_setImage(with: URL(string: self.imageInfo.jpegUrl)!, completed: { void in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.imageLoadingIndicator.stopAnimating()
            })
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        alertController.addAction(favourateAction)
        alertController.addAction(saveToAlbumAction)
        alertController.addAction(requestLargerImageAction)
        alertController.addAction(cancelAction)
        return alertController
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tagsLabel.text = imageInfo.tags
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        imageLoadingIndicator.startAnimating()
        self.imageView.sd_setImage(with: URL(string: imageInfo.sampleUrl)!, completed: { void in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.imageLoadingIndicator.stopAnimating()
        })
        self.alertController = createAlertController()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}
