//
//  PixelOAuthClient.swift
//  Pixel
//
//  Created by SongFei on 15/12/6.
//  Copyright © 2015年 SongFei. All rights reserved.
//

import UIKit
import Alamofire

class PixelOAuthClient {
    
    typealias SuccessHandler = (accessToken: OAuthAccessToken?) -> Void
    typealias FailureHandler = (error: NSError) -> Void

    
    struct OAuth {
        static let version = "1.0"
        static let signatureMethod = "HMAC-SHA1"
    }
    
    struct SwifterError {
        static let domain = "SwifterErrorDomain"
        static let appOnlyAuthenticationErrorCode = 1
    }
    
    struct OAuthAccessToken {
        var key: String
        var secret: String
        var verifier: String?
        
        init(key: String, secret: String) {
            self.key = key
            self.secret = secret
        }
        
        init(queryString: String) {
            var attributes = queryString.paramtersFromQueryString()
            
            self.key = attributes["oauth_token"]!
            self.secret = attributes["oauth_token_secret"]!
        }
    }


    var consumerKey: String
    var consumerSecret: String
    
    var oauthToken: OAuthAccessToken
    var apiURL :NSURL
    
    var dataEncoding: NSStringEncoding
    
    init(consumerKey: String, consumerSecret: String) {
        self.consumerKey = consumerKey
        self.consumerSecret = consumerSecret
        self.dataEncoding = NSUTF8StringEncoding
        self.oauthToken = OAuthAccessToken(key: "", secret: "")
        self.apiURL = NSURL(string: "https://api.500px.com/v1")!
    }
    
    init(consumerKey: String, consumerSecret: String, accessToken: String, accessTokenSecret: String) {
        self.consumerKey = consumerKey
        self.consumerSecret = consumerSecret
        
        self.oauthToken = OAuthAccessToken(key: accessToken, secret: accessTokenSecret)
        self.apiURL = NSURL(string: "https://api.500px.com/v1")!
        
        self.dataEncoding = NSUTF8StringEncoding
    }
    
    
    func postOAuthRequestTokenWithCallbackURL(callbackURL: NSURL, success: SuccessHandler, failure: FailureHandler?) {
        let path = "/oauth/request_token"
        
        var parameters =  Dictionary<String, String>()
        
        parameters["oauth_callback"] = callbackURL.absoluteString
        
        let url = NSURL(string: "\(self.apiURL)\(path)")!
        
        self.post(url, parameters: parameters) { response in
            let responseString = String(response)
            self.oauthToken = OAuthAccessToken(queryString: responseString)
//            print("\(responseString) and and \(self.oauthToken)")
            success(accessToken: self.oauthToken)
        }
        
    }
    
    func postOAuthAccessTokenWithRequestToken(callbackURL: NSURL, success: SuccessHandler, failure: FailureHandler?) {
        if let verifier = self.oauthToken.verifier {
            let path =  "/oauth/access_token"
            
            var parameters = Dictionary<String, String>()
            parameters["oauth_token"] = self.oauthToken.key
            parameters["oauth_verifier"] = verifier
            parameters["oauth_callback"] = callbackURL.absoluteString
            
            let url = NSURL(string: "\(self.apiURL)\(path)")!
            
            self.post(url, parameters: parameters) {
                responseString in
                let responseString = String(responseString)
                self.oauthToken = OAuthAccessToken(queryString: responseString)
                success(accessToken: self.oauthToken)
                
            }
            
        }
        else {
            let userInfo = [NSLocalizedFailureReasonErrorKey: "Bad OAuth response received from server"]
            let error = NSError(domain: SwifterError.domain, code: NSURLErrorBadServerResponse, userInfo: userInfo)
            failure?(error: error)
        }
    }

    
    func post(url: NSURL, parameters: Dictionary<String, String>, completion: (response: String) -> ()) {
        
        let headers = ["Authorization": self.authorizationHeaderForMethod("POST", url: url, parameters: parameters)]
        Alamofire.request(.POST, url, parameters: nil, encoding: .URLEncodedInURL, headers: headers)
            .responseString { response in
                if response.result.error != nil { return }
                let responseResult = response.result.value! as String
                completion(response: responseResult as String)
        }
    }
    
    func authorizationHeaderForMethod(method: String, url: NSURL, parameters: Dictionary<String, String>) -> String {
        var authorizationParameters = Dictionary<String, String>()
        authorizationParameters["oauth_version"] = OAuth.version
        authorizationParameters["oauth_signature_method"] = OAuth.signatureMethod
        authorizationParameters["oauth_consumer_key"] = self.consumerKey
        authorizationParameters["oauth_timestamp"] = String(Int(NSDate().timeIntervalSince1970))
        authorizationParameters["oauth_nonce"] = NSUUID().UUIDString
        
        if !self.oauthToken.key.isEmpty {
            authorizationParameters["oauth_token"] = self.oauthToken.key
        }
        
        
        for (key, value): (String, String) in parameters {
            if key.hasPrefix("oauth_") {
                authorizationParameters.updateValue(value, forKey: key)
            }
        }
        
        let finalParameters = authorizationParameters +| parameters
        
        authorizationParameters["oauth_signature"] = self.oauthSignatureForMethod(method, url: url, parameters: finalParameters, accessToken: self.oauthToken)
      
    
        var authorizationParameterComponents = authorizationParameters.urlEncodedQueryStringWithEncoding(self.dataEncoding).componentsSeparatedByString("&") as [String]
        authorizationParameterComponents.sortInPlace { $0 < $1 }
        
        var headerComponents = [String]()
        for component in authorizationParameterComponents {
            let subcomponent = component.componentsSeparatedByString("=") as [String]
            if subcomponent.count == 2 {
                headerComponents.append("\(subcomponent[0])=\"\(subcomponent[1])\"")
            }
        }
//        print("OAuth " + headerComponents.joinWithSeparator(", "))
        return "OAuth " + headerComponents.joinWithSeparator(",")
    }
    
    func oauthSignatureForMethod(method: String, url: NSURL, parameters: Dictionary<String, String>, accessToken token: OAuthAccessToken?) -> String {
        var tokenSecret: NSString = ""
        if token != nil {
            tokenSecret = token!.secret.urlEncodedStringWithEncoding(self.dataEncoding)
        }
        
        let encodedConsumerSecret = self.consumerSecret.urlEncodedStringWithEncoding(self.dataEncoding)
        
        let signingKey = "\(encodedConsumerSecret)&\(tokenSecret)"
        
        var parameterComponents = parameters.urlEncodedQueryStringWithEncoding(self.dataEncoding).componentsSeparatedByString("&") as [String]
        parameterComponents.sortInPlace { $0 < $1 }
        
        let parameterString = parameterComponents.joinWithSeparator("&")
        let encodedParameterString = parameterString.urlEncodedStringWithEncoding(self.dataEncoding)
        
        let encodedURL = url.absoluteString.urlEncodedStringWithEncoding(self.dataEncoding)
        
        let signatureBaseString = "\(method)&\(encodedURL)&\(encodedParameterString)"
        
        // let signature = signatureBaseString.SHA1DigestWithKey(signingKey)
        
        return signatureBaseString.SHA1DigestWithKey(signingKey).base64EncodedStringWithOptions([])
    }

}
