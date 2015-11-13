//
//  ViewController.swift
//  PrecallTestT1701
//
//  Created by Ankur Oberoi on 11/12/15.
//  Copyright © 2015 Ankur Oberoi. All rights reserved.
//

import UIKit

class NetworkTestViewController: UIViewController, OTNetworkTestDelegate {
    
    let networkTester = OTNetworkTest()
    
    var isTesting: Bool = false {
        didSet {
            if isTesting {
                networkTestButton.enabled = false
            } else {
                networkTestButton.enabled = true
            }
        }
    }
    
    var testResult: OTNetworkTestResult? {
        didSet {
            switch testResult {
            case .Some(OTNetworkTestResultVoiceOnly):
                startChatButton.enabled = true
                startChatButton.setTitle("Start Chat (Voice-Only)", forState: .Normal)
            case .Some(OTNetworkTestResultVideoAndVoice):
                startChatButton.enabled = true
                startChatButton.setTitle("Start Chat (Voice & Video)", forState: .Normal)
            case .Some(OTNetworkTestResultNotGood):
                startChatButton.enabled = false
                startChatButton.setTitle("Cannot Start Chat", forState: .Disabled)
            default:
                startChatButton.enabled = false
            }
        }
    }
    
    @IBOutlet weak var networkTestButton: UIButton!
    @IBOutlet weak var startChatButton: UIButton!
    
    // MARK: Config
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    lazy var testCredentials: OpenTokCredentials = {
      return OpenTokCredentials.init(fromDictionary: self.networkTestConfig)
    }()
    
    lazy var networkTestConfig: [String:String] = {
        return self.appDelegate.config["NetworkTest"] as! [String:String]
    }()
    
    // MARK: View Controller

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func beginNetworkTest(sender: UIButton) {
        guard !isTesting else {
            return
        }
        
        networkTester.runConnectivityTestWithApiKey(testCredentials.apiKey, sessionId: testCredentials.sessionId, token: testCredentials.token, executeQualityTest: true, qualityTestDuration: 10, delegate: self)
        
        isTesting = true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let chatViewController = segue.destinationViewController as? ChatViewController {
            switch testResult {
            case .Some(OTNetworkTestResultVoiceOnly):
                chatViewController.publishVideo = false
                chatViewController.publishAudio = true
            case .Some(OTNetworkTestResultVideoAndVoice):
                chatViewController.publishVideo = true
                chatViewController.publishAudio = false
            default:
                break
            }
        }
    }
    
    // MARK: Network Test Delegate
    
    func networkTestDidCompleteWithResult(result: OTNetworkTestResult, error: OTError!) {
        isTesting = false
        testResult = result
    }
    
}

