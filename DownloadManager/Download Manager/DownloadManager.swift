//
//  DownloadManager.swift
//  DownloadManager
//
//  Created by Marcelo Sampaio on 09/05/19.
//  Copyright © 2019 Marcelo Sampaio. All rights reserved.
//

import Foundation

class DownloadManager {
    
    func downloadFile(id: String, completion: @escaping (Bool , String) -> ()) {

        // ----------------------
        // Create destination URL
        // ----------------------
        let documentsUrl : URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileName = "\(id).file"
        let destinationFileUrl = documentsUrl.appendingPathComponent(fileName)
        
        // download Url
        let server = WebService.getEndpoint("server")
        
        let urlString = server
        let url = URL(string: urlString)

        //Create URL to the source file you want to download
        let fileURL = url
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        
        let request = URLRequest(url:fileURL!)
        print("***** WILL DOWNLOAD FILE 👉 URL: \(fileURL!)")
        
        
        
        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                // Success
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    print("🌎 ***** Successfully downloaded. Status code: \(statusCode)")
                    print("🌎 ***** Successfully downloaded 👉 URL: \(fileURL!)")
                    
                    // response header fields
                    if let httpResponse = response as? HTTPURLResponse {
                        if let contentType = httpResponse.allHeaderFields["Content-Type"] as? String {
                            print("🌎 ***** Response header 👉 Content-Type: \(contentType)")
                        }
                        if let contentDisposition = httpResponse.allHeaderFields["Content-Disposition"] as? String {
                            print("🌎 ***** Response header 👉 Content-Disposition: \(contentDisposition)")
                        }
                    }
                    
                    do {
                        
                        let files = PersistenceManager.standard.getFilesNames()
                        for file in files {
                            if file == fileName {
                                // remove existing file before copying a new one
                                try! FileManager.default.removeItem(at: documentsUrl.appendingPathComponent(file))
                                print("👉 delete file: \(file)")
                            }
                        }
                        
                        // save file on disk
                        try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl)
                        print("👍 ***** File manager copied item OK to \(destinationFileUrl)")
                        
                        completion(true, destinationFileUrl.absoluteString)
                    } catch (let writeError) {
                        print("❌ Error creating a file \(destinationFileUrl) : \(writeError)")
                        completion(true, "Error creating a file \(destinationFileUrl) : \(writeError)")
                    }
                }
            } else {
                print("Download error description: %@", error!.localizedDescription);
                completion(false, "Download error file")
            }
            
        }
        task.resume()
    }
}
