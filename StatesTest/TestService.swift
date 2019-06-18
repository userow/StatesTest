//
//  TestService.swift
//  StatesTest
//
//  Created by Paul Vasilenko on 6/18/19.
//  Copyright © 2019 Paul Vasilenko. All rights reserved.
//

import Foundation

protocol TestServiceProtocol {
    func dataReceived()
    func errorOccured(error: Error?)
}

class TestService {
    
    var statesDictionary: [String : String]!
    var statesDictionaryKeys: [String]!
    
    var delegate: TestServiceProtocol?
    
    func getStates() {
//        let headers = [
//            "User-Agent": "PostmanRuntime/7.15.0",
//            "Accept": "*/*",
//            "Cache-Control": "no-cache",
//            "Postman-Token": "19942d75-c7ab-4c74-93c5-1885fc50358a,af7a6377-6fd4-4075-91ee-4f0187fcadb4",
//            "Host": "gist.githubusercontent.com",
//            "accept-encoding": "gzip, deflate",
//            "Connection": "keep-alive",
//            "cache-control": "no-cache"
//        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://gist.githubusercontent.com/SpookyDT/d7c7029db3a1681272fffe70565cf0c5/raw/22ecca639a2e791bd8c5517a2a19bbb51114c993/states_hash.json")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
//        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { [unowned self] (data, response, error) -> Void in
            if (error != nil) {
                print(error as Any)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse as Any)
                print(data as Any)
                
                self.parseStates(data: data)
            }
        })

        dataTask.resume()
    }
    
    func parseStates(data: Data?) {
        let decoder = JSONDecoder()

        guard let data = data, let statesDictionary: [String : String] = try? decoder.decode([String : String].self, from: data) else {
            return
        }
        
        print(statesDictionary)
        
        self.statesDictionary = statesDictionary
        self.statesDictionaryKeys = Array(statesDictionary.keys.sorted())
        
        self.delegate?.dataReceived()
    }
}
