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
                attend()
            case 2:
                inquireMenu()
            case 3:
            case 4:
            case 5:
            default:
            }
        }
    }

    private func receiveInput() -> String? {
        print(TextLiteral.inputMark, terminator: " ")
        return readLine()
    }

    private func attend() {
        print("# 출석할 사람의 이름을 입력해주세요.")
        let name = receiveInput()
        if name == "" || name == nil {
            wrongInput()
        } else {
            networkManager.requestData(httpMethod: .post, parameter: ["name": name!]) { data in
                let attendance = data as! Attendance
                print("\(attendance.name)님은 \(attendance.id)등입니다!")
            }
        }
    }

    private func inquireMenu() {
        print("# 원하는 조회 메뉴를 선택해주세요.")
        print("1. 전체 조회   2. 특정 등수 조회")

        let selectedMenu = Int(receiveInput()!)!

        switch selectedMenu {
        case 1:
            inquireAllAttendances()
        case 2:
        default:
            wrongInput()
        }
    }

    private func inquireAllAttendances() {
        print("# 출석현황")
        networkManager.requestData { data in
            (data as! [Attendance]).forEach {
                print("\($0.id)등 \($0.name)")
            }
        }
        print()
    }
    private func wrongInput() {
        print("잘못된 입력입니다.\n")
    }
}
