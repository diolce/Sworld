//
//  Datas.swift
//  SWorld
//
//  Created by Diego Olmo Cejudo on 12/11/21.
//

import Foundation

class DatasResponse: Codable {
    let page: Int?
    let results: [Movie]?
    let total_pages: Int?
    let total_results: Int?
    let success: Bool?
    let status_code: Int?
    let status_message: String?
    let errors: [String]?
}
