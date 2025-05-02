//
//  MockURLProtocol.swift
//  Ellergic-iOS


import Foundation

class MockURLProtocol: URLProtocol {
    static var errorToThrow: Error?

    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        if let error = MockURLProtocol.errorToThrow {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {}
}
