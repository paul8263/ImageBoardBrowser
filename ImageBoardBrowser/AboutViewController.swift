//
//  AboutViewController.swift
//  ImageBoardBrowser
//
//  Created by Paul Zhang on 6/12/2016.
//  Copyright © 2016 Paul Zhang. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    @IBOutlet weak var aboutImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.aboutImageView.clipsToBounds = true
        self.aboutImageView.layer.cornerRadius = 3
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true, completion: nil)
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
