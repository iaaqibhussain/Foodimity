//
//  Request.swift
//  Foodimity
//
//  Created by Syed Muhammad Aaqib Hussain on 19.03.23.
//


import Foundation

enum RequestType: String {
  case GET
  case POST
}

protocol Request {
    var baseURL: String { get }
    var path: String { get }
    var version: String { get }
    var queryParams: [String : String] { get }
    var requestType: RequestType { get }
    var params: [String : Any] { get }
    var readFromLocal: Bool { get }
}

extension Request {
    var baseURL: String {
        ""
    }

    var version: String {
        ""
    }

    var params: [String : Any] {
        [:]
    }
    
    var requestType: RequestType {
        .GET
    }
    
    func createRequest() throws -> URLRequest {
        var components = URLComponents()
        components.scheme = "https"
        components.host = baseURL
        components.path = path
        
        if !queryParams.isEmpty {
            components.queryItems = queryParams.map { URLQueryItem(name: $0, value: $1) }
        }
        
        guard let url = components.url else { throw  NetworkError.invalidURL }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = requestType.rawValue

        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if !params.isEmpty {
          urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params)
        }

        return urlRequest
    }
}
