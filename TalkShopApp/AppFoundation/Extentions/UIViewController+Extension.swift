//
//  UIViewController+Extension.swift
//  TalkShopApp
//
//  Created by Nirman Kalia on 21/04/24.
//

import UIKit

extension UIViewController {
    static var identifier: String {
        String(describing: Self.self)
    }
    
    func showAlert(title: String, msg: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
            alert.addAction(.init(title: "Okay", style: .default))
            self.present(alert, animated: true)
        }
    }
    
    func shareText(text: String) {
        
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        self.present(activityViewController, animated: true, completion: nil)
        
    }
}
