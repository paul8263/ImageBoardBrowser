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
    
    
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBAction func rightBarButtonItemTouched(_ sender: UIBarButtonItem) {
        UIImageWriteToSavedPhotosAlbum(self.imageView.image!, nil, nil, nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 5.0
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tagsLabel.text = imageInfo.tags
        self.imageView.sd_setImage(with: URL(string: imageInfo.sampleUrl)!)
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
