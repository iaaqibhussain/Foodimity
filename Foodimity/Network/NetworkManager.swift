//
//  NetworkManager.swift
//  Foodimity
//
//  Created by Syed Muhammad Aaqib Hussain on 19.03.23.
//

import Foundation

protocol NetworkManager {
    func execute<T: Decodable>(
        request: Request,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) throws
}

final class NetworkManagerImpl: NSObject, NetworkManager {
    private let urlSession: URLSession
    private let parser: DataParser

    init(
        urlSession: URLSession = URLSession.shared,
        parser: DataParser = DataParserImpl()
    ) {
        self.urlSession = urlSession
        self.parser = parser
    }

    func execute<T: Decodable>(
        request: Request,
        completion: @escaping (_ response: Result<T, NetworkError>) -> ()
    ) throws {
        
        guard !request.readFromLocal else {
            try loadLocalJSON(filename: request.path, type: T.self, completion: completion)
            return
        }
        
        urlSession.dataTask(with: try request.createRequest()) { (data, response, error) in
            if let data = data {
                do {
                    let model: T = try self.parser.parse(data: data)
                    completion(.success(model))
                } catch {
                    completion(.failure(.error(error)))
                }
            } else if let err = error {
                completion(.failure(.error(err)))
            }
        }.resume()
    }
}

private extension NetworkManagerImpl {
    func loadLocalJSON<T: Decodable>(
        filename: String,
        type: T.Type,
        completion: @escaping (_ response: Result<T, NetworkError>) -> ()
    ) throws {
        if let path = Bundle.main.path(forResource: filename, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let model: T = try self.parser.parse(data: data)
                completion(.success(model))
            } catch {
                completion(.failure(.error(error)))
            }
        } else {
            completion(.failure(.invalidPath))
        }
    }
}
