//
//  PasscodeController.swift
//  secret-photo-album
//
//  Created by Zach Romano on 11/6/19.
//  Copyright © 2019 Zach Romano. All rights reserved.
//

import UIKit

class PasscodeController:  UIViewController, PasscodeViewDelegate {

//    @IBOutlet weak var lockImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let frame = CGRect(x: 0, y: view.frame.height/2 + 20, width: view.frame.width, height: 100)
        let passcodeView = PasscodeView(frame: frame)
        passcodeView.delegate = self
        view.addSubview(passcodeView)
        passcodeView.becomeFirstResponder()
    }
    
    func passcodeView(_ passcodeView: PasscodeView, finishedWithPasscode passcode: String) {
        if (passcode == "1234") {
            self.performSegue(withIdentifier: "showAlbumSegue", sender: self)
        } else {
            let title = "Wrong!"
            let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel) { _ in passcodeView.clear() })
            present(alert, animated: true)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
