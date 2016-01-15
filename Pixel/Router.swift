//
//  Router.swift
//  Pixel
//
//  Created by SongFei on 15/12/4.
//  Copyright © 2015年 SongFei. All rights reserved.
//

import UIKit
import Alamofire

enum Router: URLRequestConvertible {
    
    static let baseURLString = "https://api.500px.com/v1"
    static let consumerKey = "7AqOElDfu35aVav8bgztEdMWLVojPEFZoAp66JJw"
    
    case PopularPhotos(Int)
    case HighestPhotos(Int)
    case UpcomingPhotos(Int)
    case EditorsPhotos(Int)
    case PhotoInfo(Int, ImageSize)
    case Comments(Int, Int)
    case CommentPhoto(Int, String)
    case Users()
    case UsersShow(Int)
    case UserPhotos(Int, Int)
    case SearchUsers(String, Int)
    case SearchPhotos(String, Int)
    case VotePhoto(Int, Int)
    case UserFriends(Int, Int)
    case UserFollowers(Int, Int)
    case FollowUser(Int)
    case UnFollowUser(Int)
    case Report(Int, Int, String)
    
    private var method: Alamofire.Method {
        switch self {
        case .CommentPhoto(_, _):
            return .POST
        case .VotePhoto(_, _):
            return .POST
        case .FollowUser(_):
            return .POST
        case .UnFollowUser(_):
            return .DELETE
        case .Report(_, _, _):
            return .POST
        default:
            return .GET
        }
    }
    
    var URLRequest: NSMutableURLRequest {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        var oauthToken: String = ""
        if let accessToken = userDefaults.valueForKey("accessToken") {
            oauthToken = accessToken as! String
//            print("oauthToken: \(oauthToken)")
        }
        
        let result: (path: String, parameters: [String: AnyObject]) = {
            switch self {
            case .PopularPhotos(let page):
                let params = [
                    "consumer_key": Router.consumerKey,
                    "oauth_token": oauthToken,
                    "page": "\(page)",
                    "feature": "popular",
                    "rpp": "50",
                    "image_size": "6,20",
                    //"include_store":
                    //"store_download",
                    "include_states": "votes"
                ]
                return ("/photos", params)
            case .HighestPhotos(let page):
                let params = [
                    "consumer_key": Router.consumerKey,
                    "oauth_token": oauthToken,
                    "page": "\(page)",
                    "image_size": "6,20",
                    "feature": "highest_rated",
                    "rpp": "50",
                    //"include_store":
                    //"store_download",
                    "include_states": "votes"
                ]
                return ("/photos", params)
            case .UpcomingPhotos(let page):
                let params = [
                    "consumer_key": Router.consumerKey,
                    "oauth_token": oauthToken,
                    "page": "\(page)",
                    "image_size": "6,20",
                    "feature": "upcoming",
                    "rpp": "50",
                    //"include_store":
                    //"store_download",
                    "include_states": "votes"
                ]
                return ("/photos", params)
            case .EditorsPhotos(let page):
                let params = [
                    "consumer_key": Router.consumerKey,
                    "oauth_token": oauthToken,
                    "page": "\(page)",
                    "image_size": "6,20",
                    "feature": "editors",
                    "rpp": "50",
                    //"include_store":
                    //"store_download",
                    "include_states": "votes"
                ]
                return ("/photos", params)
            case .PhotoInfo(let photoID, let imageSize):
                let params = [
                    "consumer_key": Router.consumerKey,
                    "image_size": "\(imageSize.rawValue)",
                    "oauth_token": oauthToken
                ]
                return ("/photos/\(photoID)", params)
            case .Comments(let photoID, let commentsPage):
                let params = [
                    "consumer_key": Router.consumerKey,
                    "comments": "1",
                    "oauth_token": oauthToken,
                    "page": "\(commentsPage)"
                ]
                return ("/photos/\(photoID)/comments", params)
            case .Users():
                let paramas = [
                    "oauth_token": oauthToken
                ]
                return ("/users", paramas)
            case .UsersShow(let userId):
                let params = [
                    "consumer_key": Router.consumerKey,
                    "oauth_token": oauthToken,
                    "id": "\(userId)"
                ]
                return ("/users/show", params)
            case .UserPhotos(let userId, let page):
                let params = [
                    "consumer_key": Router.consumerKey,
                    "oauth_token": oauthToken,
                    "page": "\(page)",
                    "feature": "user",
                    "rpp": "50",
                    "image_size": "6,20",
                    "user_id": "\(userId)",
                    "include_states": "votes"
                ]
                return ("/photos", params)
            case .UserFriends(let userId, let page):
                let params = [
                    "consumer_key": Router.consumerKey,
                    "oauth_token": oauthToken,
                    "page": "\(page)",
                    "rpp": "50"
                ]
                return ("/users/\(userId)/friends", params)
            case .UserFollowers(let userId, let page):
                let params = [
                    "consumer_key": Router.consumerKey,
                    "oauth_token": oauthToken,
                    "page": "\(page)",
                    "rpp": "50"
                ]
                return ("/users/\(userId)/followers", params)
            case .FollowUser(let userId):
                let params = [
                    "consumer_key": Router.consumerKey,
                    "oauth_token": oauthToken
                ]
                return ("/users/\(userId)/friends", params)
            case .UnFollowUser(let userId):
                let params = [
                    "consumer_key": Router.consumerKey,
                    "oauth_token": oauthToken
                ]
                return ("/users/\(userId)/friends", params)
            case .CommentPhoto(let photoId, let commentBody):
                let params = [
                    "consumer_key": Router.consumerKey,
                    "oauth_token": oauthToken,
                    "body": commentBody
                ]
                return ("/photos/\(photoId)/comments", params)
            case .SearchUsers(let keyword, let page):
                let params = [
                    "consumer_key": Router.consumerKey,
                    "oauth_token": oauthToken,
                    "page": "\(page)",
                    "term": keyword
                ]
                return ("/users/search", params)
            case .SearchPhotos(let keyword, let page):
                let params = [
                    "consumer_key": Router.consumerKey,
                    "oauth_token": oauthToken,
                    "page": "\(page)",
                    "term": keyword,
                    "rpp": "50",
                    "image_size": "6,20",
                    "include_states": "1",
                    "sort": "highest_rating"
                ]
                return ("photos/search", params)
            case .VotePhoto(let id, let vote):
                let params = [
                    "consumer_key": Router.consumerKey,
                    "oauth_token": oauthToken,
                    "vote": "\(vote)"
                ]
                return ("photos/\(id)/vote", params)
            case .Report(let photoId, let reason, let reasonBody):
                let params = [
                    "consumer_key": Router.consumerKey,
                    "reason": "\(reason)",
                    "reason_details": reasonBody
                ]
                return ("photos/\(photoId)/report", params)
            }
        }()
        
        let URL = NSURL(string: Router.baseURLString)!
        let URLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(result.path))
        URLRequest.HTTPMethod = method.rawValue
        let encoding = Alamofire.ParameterEncoding.URL
        
        
        return encoding.encode(URLRequest, parameters: result.parameters).0
    }
}