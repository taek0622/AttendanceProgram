//
//  NetworkManager.swift
//  AttendanceProgram
//
//  Created by 김민택 on 2023/03/17.
//

import Foundation

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

class NetworkManager {

    static let shared = NetworkManager()

    private init() {}

    func requestData(_ id: Int? = nil,
                     httpMethod: HttpMethod = .get,
                     parameter: [String: String]? = nil,
                     completion: @escaping (Any) -> Void) {

        let semaphore = DispatchSemaphore(value: 0)
        let url = URL(string: id == nil ? APIEnvironment.baseURL : APIEnvironment.baseURL + "/\(id!)")!

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.rawValue
        urlRequest.addValue(APIEnvironment.apiKey, forHTTPHeaderField: APIEnvironment.apiKeyHeaderField)
        if httpMethod == .post || httpMethod == .put {
            let jsonData = try! JSONEncoder().encode(parameter)
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = jsonData
        }

        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error {
                print(error)
                return
            }

            guard let data = data else { return }

            switch ((response) as? HTTPURLResponse)?.statusCode {
            case 200:
                if id == nil && httpMethod == .get {
                    let responseData = try! JSONDecoder().decode([Attendance].self, from: data)
                    completion(responseData)
                } else {
                    let responseData = try! JSONDecoder().decode(Attendance.self, from: data)
                    completion(responseData)
                }
            case 400:
                print("400 \(data)")
            case 403:
                print("403 \(data)")
            case 404:
                print("404 \(data)")
            case 500:
                print("500 \(data)")
            default:
                completion(String(decoding: data, as: UTF8.self))
            }
            semaphore.signal()
        }.resume()

        semaphore.wait()
    }
}
