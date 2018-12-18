//
//  ViewController.swift
//  PromiseKitExamples
//
//  Created by Jonathan Oh on 12/18/18.
//  Copyright © 2018 Jonathan Oh. All rights reserved.
//

import UIKit
import PromiseKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let async = AsyncFunctions()
        
        // Chaining async functions are all nested
//        async.asyncFunctionTwoSeconds {
//            print("completed two seconds")
//            async.asyncFunctionEightSeconds {
//                print("8 seconds")
//            }
//        }
        
        // Chaining async functions promise kit way
        async.promiseTwoSeconds().then { _ -> Promise<Void> in
            print("completed two seconds")
            return async.promiseFiveSeconds()
        }.then { _ -> Promise<Void> in
            print("five seconds")
            return async.promiseEightSeconds()
        }.done {
            print("eight seconds")
        }.cauterize()
        
        // Wait until both async functions are done
        when(fulfilled: [async.promiseTwoSeconds(), async.promiseFiveSeconds()]).done {
            print("should only take 5 seconds")
        }.cauterize()
        
        async.promiseStringInt().done { word in
            print("do i have a word?")
        }.catch { error in
            print("error handling here!")
        }
        
    }
}


class AsyncFunctions {
    
    func asyncFunctionTwoSeconds(completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            print("two seconds!")
            completion()
        }
    }
    // PROMISE VERSION EXPANDED
    func promiseTwoSeconds() -> Promise<Void> {
        return Promise { seal in
            return asyncFunctionTwoSeconds {
                seal.fulfill()
            }
        }
    }
    
    func asyncFunctionFiveSeconds(_ completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            print("five seconds!")
            completion()
        }
    }
    // PROMISE VERSION EXPANDED
    func promiseFiveSeconds() -> Promise<Void> {
        return Promise { seal in
            return asyncFunctionFiveSeconds {
                seal.fulfill()
            }
        }
    }
    
    func asyncFunctionEightSeconds(_ completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
            print("eight seconds!")
            completion()
        }
    }
    // PROMISE VERSION EXPANDED
    func promiseEightSeconds() -> Promise<Void> {
        return Promise { seal in
            return asyncFunctionEightSeconds {
                seal.fulfill()
            }
        }
    }
    
    func asyncFunctionStringInt(_ completion: @escaping (String?) -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            // if stringNil { completion(nil); return }
            completion("This New String")
        }
    }
    // Promise Version Expanded
    func promiseStringInt() -> Promise<String> {
        return Promise { seal in
            return asyncFunctionStringInt({ word in
                if let word = word {
                    seal.fulfill(word)
                } else {
                    //seal.reject(<#T##error: Error##Error#>) STRING IS NIL ERROR
                }
            })
        }
    }
    
}
