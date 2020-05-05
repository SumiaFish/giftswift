//
//  GiftData.swift
//  giftswift
//
//  Created by kevin on 2020/5/2.
//  Copyright © 2020 kevin. All rights reserved.
//

import UIKit

struct GiftData {
    
    static func loadData() -> Promise<GiftDataResponse> {
        return Promise<GiftDataResponse> { (filfull, reject) in
            DispatchQueue.global().async {
                Thread.sleep(forTimeInterval: 1)
                if let path = Bundle.main.path(forResource: "data.json", ofType: nil),
                    let data = try? UIKit.Data(contentsOf: URL(fileURLWithPath: path)) {
                    
                    do {
                        let res = try JSONDecoder().decode(GiftDataResponse.self, from: data)
                        filfull(res)
                    } catch {
                        reject(KVError(msg: "解析失败", code: -1))
                        KLog("err: \(error)")
                    }
                    
                } else {
                    reject(KVError(msg: "请求失败", code: -1))
                }
            }
        }
    }
}

struct GiftDataResponse : Codable {

    let amount : Int?
    let data : [Gift]?
    let error : Int?
    let scoreE1 : String?
    let scoreX1 : String?


}

struct Gift : Codable {

    let cat : String?
    let costType : String?
    let createdTime : String?
    let deleted : String?
    let expire : String?
    let extra : String?
    let giftOrder : String?
    let icon : String?
    let iconGif : String?
    let id : String?
    let influence : String?
    let name : String?
    let type : String?
    let updatedTime : String?
    let username : String?
    let value : Int?
    
    /// --- client begin ---
    /// 是否选中
    var isSelected: Bool = false
    /// --- client end ---
    
    enum CodingKeys: String, CodingKey {
        case cat = "cat"
        case costType = "cost_type"
        case createdTime = "createdTime"
        case deleted = "deleted"
        case expire = "expire"
        case extra = "extra"
        case giftOrder = "giftOrder"
        case icon = "icon"
        case iconGif = "icon_gif"
        case id = "id"
        case influence = "influence"
        case name = "name"
        case type = "type"
        case updatedTime = "updatedTime"
        case username = "username"
        case value = "value"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        cat = try values.decodeIfPresent(String.self, forKey: .cat)
        costType = try values.decodeIfPresent(String.self, forKey: .costType)
        createdTime = try values.decodeIfPresent(String.self, forKey: .createdTime)
        deleted = try values.decodeIfPresent(String.self, forKey: .deleted)
        expire = try values.decodeIfPresent(String.self, forKey: .expire)
        extra = try values.decodeIfPresent(String.self, forKey: .extra)
        giftOrder = try values.decodeIfPresent(String.self, forKey: .giftOrder)
        icon = try values.decodeIfPresent(String.self, forKey: .icon)
        iconGif = try values.decodeIfPresent(String.self, forKey: .iconGif)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        influence = try values.decodeIfPresent(String.self, forKey: .influence)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        updatedTime = try values.decodeIfPresent(String.self, forKey: .updatedTime)
        username = try values.decodeIfPresent(String.self, forKey: .username)
        if let ret = try? values.decodeIfPresent(String.self, forKey: .value) {
            value = Int(ret)
        } else {
            value = try values.decodeIfPresent(Int.self, forKey: .value)
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try values.encode(cat, forKey: .cat)
        try values.encode(costType, forKey: .costType)
        try values.encode(createdTime, forKey: .createdTime)
        try values.encode(deleted, forKey: .deleted)
        try values.encode(expire, forKey: .expire)
        try values.encode(extra, forKey: .extra)
        try values.encode(giftOrder, forKey: .giftOrder)
        try values.encode(icon, forKey: .icon)
        try values.encode(iconGif, forKey: .iconGif)
        try values.encode(id, forKey: .id)
        try values.encode(influence, forKey: .influence)
        try values.encode(name, forKey: .name)
        try values.encode(type, forKey: .type)
        try values.encode(updatedTime, forKey: .updatedTime)
        try values.encode(username, forKey: .username)
        if let _ = try? values.encode(value, forKey: .value) {

        } else {
            try values.encode(value, forKey: .value)
        }
        
    }
}

enum StringOrInt: Codable {
    case int(Int)
    case string(String)
    case bool(Bool)

    var intValue: Int? {
        switch self {
        case .int(let int):
            return int
        case .string( _):
            break
        case .bool( _):
            break
        }
        return nil
    }
    
    var stringValue: String? {
        switch self {
        case .int( _):
            break
        case .string(let string):
            return string
        case .bool( _):
            break
        }
        return nil
    }
    
    var boolValue: Bool? {
        switch self {
        case .int(_):
            break
        case .string(_):
            break
        case .bool(let bool):
            return bool
        }
        return nil
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            self = try .int(container.decode(Int.self))
        } catch DecodingError.typeMismatch {
            do {
                self = try .bool(container.decode(Bool.self))
            } catch DecodingError.typeMismatch {
                do {
                    self = try .string(container.decode(String.self))
                } catch DecodingError.typeMismatch {
                    throw DecodingError.typeMismatch(StringOrInt.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Encoded payload not of an expected type"))
                }
            }
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .int(let int):
            try container.encode(int)
        case .string(let string):
            try container.encode(string)
        case .bool(let bool):
            try container.encode(bool)
        }
    }
    
}
