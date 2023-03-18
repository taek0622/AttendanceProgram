//
//  AttendaceProgram.swift
//  AttendanceProgram
//
//  Created by 김민택 on 2023/03/16.
//

import Foundation

class AttendanceProgram {

    let networkManager = NetworkManager.shared

    init() {
        run()
    }

    private func run() {
        while true {
            print(TextLiteral.programTitle)
            print("# 원하는 메뉴의 번호를 입력해주세요.")
            print("1. 출석하기   2. 출석현황 조회   3. 이름 수정   4. 출석 삭제   5. 종료")
            let input = receiveInput()

            if Int(input!) == nil {
                wrongInput()
                continue
            }

            switch Int(input!)! {
            case 1:
            case 2:
            case 3:
            case 4:
            case 5:
            default:
            }
        }
    }
    private func wrongInput() {
        print("잘못된 입력입니다.\n")
    }
}
