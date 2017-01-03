//
//  SingleImageViewController.swift
//  ImageBoardBrowser
//
//  Created by Paul Zhang on 4/12/2016.
//  Copyright © 2016 Paul Zhang. All rights reserved.
//

import UIKit
import SDWebImage
import AFNetworking

enum TypeOfImagePresented {
    case sample
    case jpeg
}

class SingleImageViewController: UIViewController {
    
    var imageInfo: ImageInfo!
    
    var alertController: UIAlertController?
    
    var typeOfImagePresented: TypeOfImagePresented = .sample
    
    var isShowingUI: Bool = true {
        willSet {
            if newValue {
                self.navigationController?.navigationBar.isHidden = false
                self.tabBarController?.tabBar.isHidden = false
                view.bringSubview(toFront: tagsLabelVisualEffectView)
                view.bringSubview(toFront: tagsLabel)
                UIView.animate(withDuration: 0.5, animations: {
                    self.navigationController?.navigationBar.alpha = 1
                    self.tabBarController?.tabBar.alpha = 1
                    self.tagsLabel.alpha = 1
                    
                    self.tagsLabelVisualEffectView.alpha = 1
                })
            } else {
                UIView.animate(withDuration: 0.5, animations: {
                    self.navigationController?.navigationBar.alpha = 0
                    self.tabBarController?.tabBar.alpha = 0
                    self.tagsLabel.alpha = 0
                    
                    self.tagsLabelVisualEffectView.alpha = 0
                    
                }) { (finished) in
                    self.navigationController?.navigationBar.isHidden = true
                    self.tabBarController?.tabBar.isHidden = true
                    self.view.bringSubview(toFront: self.scrollView)
                }
            }
        }
    }
    
    var isZoomedMax: Bool {
        return scrollView.zoomScale == scrollView.maximumZoomScale
    }
    
    var imageView = UIImageView()
    
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loadingProgressView: UIProgressView!
    @IBOutlet weak var imageLoadingIndicator: UIActivityIndicatorView!    
    
    @IBOutlet weak var tagsLabelVisualEffectView: UIVisualEffectView!
    
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
        coordinator.animate(alongsideTransition: nil) { (context) in
            UIView.animate(withDuration: 0.3) {
                self.setMinZoomScale()
                self.setImageViewCenterToScrollView()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 1.5
        imageView.contentMode = .scaleAspectFit
        scrollView.addSubview(imageView)
        
        setupGestureRecognizers()
        
        imageLoadingIndicator.isHidden = false
        imageLoadingIndicator.hidesWhenStopped = true
    }
    
    func setupGestureRecognizers() {
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(sender:)))
        self.scrollView.addGestureRecognizer(longPressGestureRecognizer)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureTriggered(sender:)))
        self.scrollView.addGestureRecognizer(tapGestureRecognizer)
        
        let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(doubleTapGestureTriggered(sender:)))
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        self.scrollView.addGestureRecognizer(doubleTapGestureRecognizer)
        
//        Double tap gesture will not trigger single tap
        tapGestureRecognizer.require(toFail: doubleTapGestureRecognizer)
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
    
    func tapGestureTriggered(sender: UITapGestureRecognizer) {
        isShowingUI = !isShowingUI
    }
    
    func doubleTapGestureTriggered(sender: UITapGestureRecognizer) {
        scrollView.setZoomScale(isZoomedMax ? scrollView.minimumZoomScale : scrollView.maximumZoomScale, animated: true)
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
                self.cancelLoadImage()
                self.loadImage(withURL: self.imageInfo.getJpegURL())
            })
        case .jpeg:
            requestImageAction = UIAlertAction(title: "Request Sample Image", style: UIAlertActionStyle.default, handler: { (action) in
                self.typeOfImagePresented = .sample
                self.cancelLoadImage()
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
        if AFNetworkReachabilityManager.shared().isReachable {
            loadImage(withURL: imageInfo.getSampleURL())
        } else {
            showNetworkErrorAlertController()
        }
        isShowingUI = true
    }
    
    private func showNetworkErrorAlertController() {
        let alertController = UIAlertController(title: "No Network", message: "Please connect your device to network", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cancelLoadImage()
        isShowingUI = true
    }
    
    private func setImageViewSize() {
        switch typeOfImagePresented {
        case .sample:
            imageView.bounds.size = CGSize(width: imageInfo.sampleWidth, height: imageInfo.sampleHeight)
        case .jpeg:
            imageView.bounds.size = CGSize(width: imageInfo.jpegWidth, height: imageInfo.jpegHeight)
        }
        imageView.frame.origin = CGPoint.zero
        scrollView.contentSize = imageView.bounds.size
        view.layoutIfNeeded()
    }
    
    private func setMinZoomScale() {
        let widthScale = scrollView.bounds.width / imageView.bounds.width
        let heightScale = scrollView.bounds.height / imageView.bounds.height
        let minScale = min(widthScale, heightScale)
        
        scrollView.minimumZoomScale = minScale
        scrollView.setZoomScale(minScale, animated: false)
    }
 
    fileprivate func setImageViewCenterToScrollView() {
        let x = max(0, (scrollView.bounds.width - imageView.frame.width) / 2)
        let y = max(0, (scrollView.bounds.height - imageView.frame.height) / 2)
        
        scrollView.contentInset = UIEdgeInsets(top: y, left: x, bottom: y, right: x)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setImageViewCenterToScrollView()
    }
    
    func loadImage(withURL url: URL) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        imageLoadingIndicator.startAnimating()
        loadingProgressView.isHidden = false
        loadingProgressView.setProgress(0, animated: false)
        alertController = createAlertController()
        
        setImageViewSize()
        setMinZoomScale()
        
        self.imageView.sd_setImage(
            with: url,
            placeholderImage: UIImage(named: "placeholder")!,
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
        loadingProgressView.setProgress(0.0, animated: false)
        loadingProgressView.isHidden = true
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
