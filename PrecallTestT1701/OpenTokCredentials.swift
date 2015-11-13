//
//  OpenTokCredentials.swift
//  PrecallTestT1701
//
//  Created by Ankur Oberoi on 11/12/15.
//  Copyright © 2015 Ankur Oberoi. All rights reserved.
//

struct OpenTokCredentials {
    let apiKey: String
    let sessionId: String
    let token: String
    
    init(fromDictionary dict: Dictionary<String, String>) {
        apiKey = dict["apiKey"]!
        sessionId = dict["sessionId"]!
        token = dict["token"]!
    }
}