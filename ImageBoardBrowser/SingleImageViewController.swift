//
//  SingleImageViewController.swift
//  ImageBoardBrowser
//
//  Created by Paul Zhang on 4/12/2016.
//  Copyright © 2016 Paul Zhang. All rights reserved.
//

import UIKit
import SDWebImage

enum TypeOfImagePresented {
    case sample
    case jpeg
}

class SingleImageViewController: UIViewController {
    
    
    var imageInfo: ImageInfo!
    
    var alertController: UIAlertController?
    
    var typeOfImagePresented: TypeOfImagePresented = .sample
    
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loadingProgressView: UIProgressView!
    
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var imageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var imageLoadingIndicator: UIActivityIndicatorView!
    @IBAction func rightBarButtonItemTouched(_ sender: UIBarButtonItem) {

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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        perform(#selector(setMinScaleAndCenterImageAfterRotation), with: nil, afterDelay: 0.4)
    }
    
    func setMinScaleAndCenterImageAfterRotation() {
        UIView.animate(withDuration: 0.3) { 
            self.setMinZoomScale()
            self.setImageViewCenterToScrollView()
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
                if UIDevice.current.userInterfaceIdiom == .pad {
                    if let popoverController = alertController.popoverPresentationController {
                        popoverController.sourceView = imageView
                        let point = sender.location(in: imageView)
                        popoverController.sourceRect = CGRect(origin: point, size: CGSize.zero)
                    }
                }
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
        let requestImageAction: UIAlertAction!
        switch typeOfImagePresented {
        case .sample:
            requestImageAction = UIAlertAction(title: "Request Larger Image", style: UIAlertActionStyle.default, handler: { (action) in
                self.typeOfImagePresented = .jpeg
                self.loadImage(withURL: self.imageInfo.getJpegURL())
            })
        case .jpeg:
            requestImageAction = UIAlertAction(title: "Request Sample Image", style: UIAlertActionStyle.default, handler: { (action) in
                self.typeOfImagePresented = .sample
                self.loadImage(withURL: self.imageInfo.getSampleURL())
            })
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        alertController.addAction(favouriteAction)
        alertController.addAction(saveToAlbumAction)
        alertController.addAction(requestImageAction)
        alertController.addAction(cancelAction)
        
        return alertController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.hidesBarsOnSwipe = false
        self.tagsLabel.text = imageInfo.tags
        
        loadImage(withURL: imageInfo.getSampleURL())
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setImageViewSizeConstraint()
        setMinZoomScale()
        setImageViewCenterToScrollView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cancelLoadImage()
    }
    
    private func setImageViewSizeConstraint() {
        switch typeOfImagePresented {
        case .sample:
            imageViewHeightConstraint.constant = CGFloat(imageInfo.sampleHeight)
            imageViewWidthConstraint.constant = CGFloat(imageInfo.sampleWidth)
        case .jpeg:
            imageViewHeightConstraint.constant = CGFloat(imageInfo.jpegHeight)
            imageViewWidthConstraint.constant = CGFloat(imageInfo.jpegWidth)
        }
        view.layoutIfNeeded()
    }
    
    private func setMinZoomScale() {
        let widthScale = scrollView.bounds.width / imageViewWidthConstraint.constant
        let heightScale = scrollView.bounds.height / imageViewHeightConstraint.constant
        let minScale = min(widthScale, heightScale)
        scrollView.minimumZoomScale = minScale
        scrollView.zoomScale = minScale
    }
 
    fileprivate func setImageViewCenterToScrollView() {
        
        let x = max(0, (scrollView.bounds.width - imageView.frame.width) / 2)
        imageViewTrailingConstraint.constant = x
        imageViewLeadingConstraint.constant = x
        let y = max(0, (scrollView.bounds.height - imageView.frame.height) / 2)
        imageViewTopConstraint.constant = y
        imageViewBottomConstraint.constant = y
        view.layoutIfNeeded()        
    }
    
    func loadImage(withURL url: URL) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        imageLoadingIndicator.startAnimating()
        loadingProgressView.isHidden = false
        loadingProgressView.setProgress(0, animated: false)
        alertController = createAlertController()
        
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
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.loadingProgressView.isHidden = true
                    self.imageLoadingIndicator.stopAnimating()
                }
        })
    }
    
    func cancelLoadImage() {
        self.imageView.sd_cancelCurrentImageLoad()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        imageLoadingIndicator.stopAnimating()
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
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        setImageViewCenterToScrollView()
    }
}
