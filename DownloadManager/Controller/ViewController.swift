//
//  ViewController.swift
//  DownloadManager
//
//  Created by Marcelo Sampaio on 09/05/19.
//  Copyright © 2019 Marcelo Sampaio. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Properties
    private var downloadManager = DownloadManager()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    
    // MARK: - UI Actions
    @IBAction func downloadFile(_ sender: Any) {
        self.view.showActivityLoading()
        
        self.downloadManager.downloadFile(id: "jpeg") { (success, message) in
            if success {
                // download OK
                print("OK")
                self.view.hideActivityLoading()
                self.view.alert(msg: "Download OK 👍", sender: self)
            }else{
                // failure
                print("❌ download error with message: \(message)")
                self.view.hideActivityLoading()
                self.view.alert(msg: "❌ Download error with message: \(message)", sender: self)
            }
            
        }
        
        
    }
    

}

