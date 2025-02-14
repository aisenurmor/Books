//
//  ApiRequestBuilder.swift
//
//
//  Created by Aise Nur Mor on 14.02.2025.
//

public final class ApiRequestBuilder {

    var httpMethod: HTTPMethod
    var endpoint: Endpoint
    var urlParams: [String: String]?
    var headers: [String: String]?
    var payload: [String: Any]?

    public init(endpoint: Endpoint, httpMethod: HTTPMethod) {
        self.endpoint = endpoint
        self.httpMethod = httpMethod
    }

    func urlParams(urlParams: [String: String]?) -> ApiRequestBuilder {
        self.urlParams = urlParams
        return self
    }

    func headers(headers: [String: String]) -> ApiRequestBuilder {
        self.headers = headers
        return self
    }

    func payload(payload: [String: Any]) -> ApiRequestBuilder {
        self.payload = payload
        return self
    }
}

