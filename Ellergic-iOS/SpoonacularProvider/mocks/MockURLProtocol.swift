//
//  MockURLProtocol.swift
//  Ellergic-iOS

import Foundation

class MockURLProtocol: URLProtocol {

    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}
