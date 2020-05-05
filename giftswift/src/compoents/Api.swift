//
//  Api.swift
//  giftswift
//
//  Created by kevin on 2020/5/2.
//  Copyright © 2020 kevin. All rights reserved.
//

import UIKit

struct KVError: Error {
    let msg:String?
    let code: Int?
}

let app_domain = ""
let app_version = "1.0"

//public struct Api {
//    static func loadData<ResT: Codable>(_ url: String, method: HTTPMethod = .get, params paramsDict : [String : Any]? = nil, insertToken: Bool = false) -> Promise<ResT> {
//        
//        // 插入token
//        var params: [String : Any] = paramsDict ?? [:]
//        if insertToken == true, let token = UserInfoManager.sharedInstance.data?.accessToken {
//            params["access_token"] = token
//        }
//        
//        return Promise<ResT> { filfull, reject in
//            AF.request(url, method: method, parameters: params).response { (res) in
//                
//                // 请求出错
//                guard res.error == nil, let data = res.data else {
//                    let error = KVError(msg: "网络连接错误", code: 0, description: "")
//                    log(url: url, params: params, error: error, data: nil)
//                    reject(error)
//                    return
//                }
//
//                // 解析
//                guard let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers),
//                    let dict = json as? [String: Any] else {
//                    let error = KVError(msg: "解析数据出错", code: 0, description: "")
//                    log(url: url, params: params, error: error, data: nil)
//                    reject(error)
//                    return
//                }
//                
//                // 请求成功并打印
//                log(url: url, params: params, error: nil, data: data)
//                
//                // 业务报错
//                let msg = dict["msg"] as? String ?? "服务器返回错误"
//                let code = dict["code"] as? Int ?? -1
//                if code != 0 {
//                    if code == 401 {
//                        relogin(msg)
//                    }
//                    reject(KVError(msg: msg, code: code, description: ""))
//                    return
//                }
//
//                // json to model
//                let jsonDecoder = JSONDecoder()
//                if let model: ResT = try? jsonDecoder.decode(ResT.self, from: data) {
//                    filfull(model)
//                } else {
//                    reject(KVError(msg: "数据转换失败", code: 0, description: ""))
//                }
//            }
//        }
//        
//    }
//    
//    static func log(url: String, params: [String : Any]? = nil, error: KVError? = nil, data: Data? = nil) {
//        #if DEBUG
//        
//        KLog("--- api res log ---")
//        KLog("url: \(url)")
//        if let paramsData = try? JSONSerialization.data(withJSONObject: params ?? [:], options: []) {
//            if let log = String(data: paramsData, encoding: .utf8) {
//                KLog("params: \n \(log)")
//            }
//        }
//        
//        if error != nil {
//            KLog("\(error?.msg ?? "错误")\n")
//        } else {
//            KLog("请求成功\n")
//            if let data = data {
//                if let log = String(data: data, encoding: .utf8) {
//                    KLog("res data: \n \(log)")
//                }
//            }
//        }
// 
//        KLog("--- api res log ---")
//        
//        #endif
//    }
//    
//    static func relogin(_ resoan: String) {
//        UserInfoManager.sharedInstance.relogin(reason: resoan)
//    }
//}



