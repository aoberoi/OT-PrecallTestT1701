//
//  ChatViewController.swift
//  PrecallTestT1701
//
//  Created by Ankur Oberoi on 11/12/15.
//  Copyright © 2015 Ankur Oberoi. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, OTSessionDelegate, OTPublisherDelegate {
    
    var publishVideo = true {
        didSet {
            publisher.publishVideo = publishVideo
        }
    }
    var publishAudio = true {
        didSet {
            publisher.publishAudio = publishAudio
        }
    }
    lazy var session: OTSession = {
        return OTSession(apiKey: self.chatCredentials.apiKey, sessionId: self.chatCredentials.sessionId, delegate: self)
    }()
    lazy var publisher: OTPublisher = {
        return OTPublisher(delegate: self)
    }()
    
    @IBOutlet weak var publisherViewContainer: UIView!
    
    // MARK: Config
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    lazy var chatCredentials: OpenTokCredentials = {
        return OpenTokCredentials.init(fromDictionary: self.chatConfig)
    }()
    
    lazy var chatConfig: [String:String] = {
        return self.appDelegate.config["Chat"] as! [String:String]
    }()
    
    // MARK: View Controller

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("View did load")
        
        var connectError: OTError?
        session.connectWithToken(chatCredentials.token, error: &connectError)
        
        guard (connectError == nil) else {
            print("Connect Error: \(connectError!.description)")
            return
        }
        
        publisherViewContainer.addSubview(publisher.view)
    }
    
    override func viewDidLayoutSubviews() {
        publisher.view.frame = publisherViewContainer.bounds
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Session Delegate

    func sessionDidConnect(session: OTSession!) {
        print("Session connected")
        
        var publishError: OTError?
        session.publish(publisher, error: &publishError)
        
        guard (publishError == nil) else {
            print("Publish Error: \(publishError!.description)")
            return
        }
    }
    
    func sessionDidDisconnect(session: OTSession!) {
        print("Session disconnected")
    }
    
    func session(session: OTSession!, didFailWithError error: OTError!) {
        print("Session failed with error: \(error.description)")
    }
    
    func session(session: OTSession!, streamCreated stream: OTStream!) {
        print("Stream created")
    }
    
    func session(session: OTSession!, streamDestroyed stream: OTStream!) {
        print("Stream destroyed")
    }
    
    // MARK: Publisher Delegate

    func publisher(publisher: OTPublisherKit!, didFailWithError error: OTError!) {
        print("Publisher did fail with error: \(error.description)")
    }
    
    func publisher(publisher: OTPublisherKit!, streamCreated stream: OTStream!) {
        print("Publisher stream created")
    }
    
    func publisher(publisher: OTPublisherKit!, streamDestroyed stream: OTStream!) {
        print("Publisher stream destroyed")
    }
}
