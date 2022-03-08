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

final class ApplicationSession: NSObject {
    ///Global Variables
    static private var timer: Timer?
    static var isActive: Bool = false
    var sessionListener: ObserverBox<Bool?> = ObserverBox(nil)
    static let sharedInstance: ApplicationSession = ApplicationSession()

    private override init() { }
    
    /// Starts the timer
    /// Logs out only when sessionn is active
    func start() {
        ApplicationSession.timer?.invalidate()
        ApplicationSession.timer = nil
        
        ApplicationSession.timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(getTimeInterval()), repeats: false) {[weak self] (timer) in
            if  ApplicationSession.timer!.isValid && ApplicationSession.isActive {
                self?.logout()
                ApplicationSession.timer?.invalidate()
            }
        }
    }

    /// Stops the timer
    func stop() {
        ApplicationSession.timer?.invalidate()
    }
    
    /// Resets  the timer
    func reset() {
        start()
    }
    
    /// Initiates to listen the session
    func logout() {
        sessionListener.value = true
    }

    /// Enables the session to eligible to get end
    func activateSession() {
        ApplicationSession.isActive = true
    }
    
    /// Disables the session to eligible to get end
    func deActivateSession() {
        ApplicationSession.isActive = false
    }
    
    /// Sets the time Interval
    /// Fetches from Keychain if exists
    /// Else Default
    fileprivate func getTimeInterval() -> Int {
        if let timeOutSeconds = KeychainResource.load(key: "INACTIVITY_TIMEOUT_MINS") {
            return (Int(String(decoding: timeOutSeconds, as: UTF8.self)) ?? 1) * 10
        }
        else{
          return 10
        }
    }
}

