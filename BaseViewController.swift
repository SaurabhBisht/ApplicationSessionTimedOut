//MIT License
//
//Copyright (c) 2022 Saurabh Bisht
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all
//copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//SOFTWARE.

import UIKit


class BaseViewController: UIViewController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        appsessionObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ApplicationSession.sharedInstance.start()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        ApplicationSession.sharedInstance.start()
    }
    
    func showAlert(title: String, message: String, controller:UIViewController) {
        let alert = UIAlertController(title: title , message: message , preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        controller.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func appsessionObserver() {
        ApplicationSession.sharedInstance.sessionListener.bind(listener: { [weak self] val in
            if val ?? false{
                DispatchQueue.main.async {
                    self?.showAlert(title: "Session", message: "DeActive Now", controller: self ?? BaseViewController())
                    self?.logout(completionHandler: { () in
                            ApplicationSession.sharedInstance.sessionListener.value = false
                            ApplicationSession.sharedInstance.stop()
                        })
                    
                    self?.view.layoutIfNeeded()
                }
            }
        })
    }
    
    func logout(completionHandler: @escaping ()->Void){
      //  KeychainResource.remove(key: "INACTIVITY_TIMEOUT_MINS")
        completionHandler()
    }
    
}
