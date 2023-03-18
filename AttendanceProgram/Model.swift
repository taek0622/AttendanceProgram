//
//  Model.swift
//  AttendanceProgram
//
//  Created by 김민택 on 2023/03/19.
//

import Foundation

struct Attendance: Codable {
    let id: Int
    let oldName: String?
    let name: String
}

struct ErrorMessage: Codable {
    let message: String
    let errorInfo: String?
}
