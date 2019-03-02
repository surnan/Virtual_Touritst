//
//  flickr.photos.getSizes.swift
//  Virtual_Tourist
//
//  Created by admin on 3/2/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

//struct PhotosGetSizes: Codable {
//
//    var sizes: SizesStruct
//    var stat: String
//
//    struct  SizesStruct: Codable {
//        var canblog: Int
//        var canprint: Int
//        var candownload: Int
//        var size: [SizeStruct]
//    }
//
//    struct SizeStruct: Codable {
//        var source: String
//        var url: String
//        var media: String
//        var label: String
//        var height: String
//        var width: String
//    }
//}

struct Root: Codable {
    let sizes: Sizes
    let stat: String
}

struct Sizes: Codable {
    let canblog, canprint, candownload: Int
    let size: [Size]
}

struct Size: Codable {
    let label,media,source: String
    let width, height: Height
    let url:URL
}

enum Height: Codable {
    case integer(Int)
    case string(String)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(Height.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Height"))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}

