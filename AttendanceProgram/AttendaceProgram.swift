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
                updateAttendance()
            case 4:
                deleteAttendance()
            case 5:
                exitProgram()
            default:
                wrongInput()
            }
        }
    }

    private func receiveInput() -> String? {
        print(TextLiteral.inputMark, terminator: " ")
        return readLine()?.precomposedStringWithCompatibilityMapping
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
            inquireAttendanceMenu()
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

    private func inquireAttendanceMenu() {
        print("# 조회할 등수를 입력해주세요.")
        inquireAttendance(id: Int(receiveInput()!)!)
    }

    private func inquireAttendance(id: Int) {
        networkManager.requestData(id) { data in
            let attendance = data as! Attendance
            print("현재 \(attendance.id)등은 \(attendance.name)입니다!\n")
        }
    }

    private func updateAttendance() {
        print("# 수정할 사람의 등수를 입력해주세요.")

        let id = Int(receiveInput()!)
        networkManager.requestData(id) { data in
            let attendance = data as! Attendance
            print("\(attendance.id)등의 현재 이름은 \(attendance.name)입니다. 변경할 이름을 입력해주세요.")
        }

        let newName = receiveInput()
        networkManager.requestData(id, httpMethod: .put, parameter: ["name": newName!]) { data in
            let attendance = data as! Attendance
            print("\(attendance.id)등의 이름이 \(attendance.oldName!)에서 \(attendance.name)으로 변경되었습니다!\n")
        }
    }

    private func deleteAttendance() {
        print("# 삭제할 사람의 등수를 입력해주세요.")
        let id = Int(receiveInput()!)!
        networkManager.requestData(id, httpMethod: .delete) { data in
            let attendance = data as! Attendance
            print("출석에서 \(attendance.id)등 \(attendance.name)가 삭제되었습니다!\n")
        }
    }

    private func exitProgram() {
        print("출석 프로그램을 종료합니다!")
        exit(0)
    }

    private func wrongInput() {
        print("잘못된 입력입니다.\n")
    }
}
