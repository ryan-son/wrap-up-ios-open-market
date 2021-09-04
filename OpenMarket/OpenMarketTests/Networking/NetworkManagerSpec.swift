//
//  NetworkManagerSpec.swift
//  OpenMarketTests
//
//  Created by Ryan-Son on 2021/09/04.
//

import Nimble
import Quick
@testable import OpenMarket

final class NetworkManagerSpec: QuickSpec {

    override func spec() {
        describe("NetworkManager") {
            var session: URLSession!
            var dummyMultipartFormData: DummyMultipartFormData!
            var sut: NetworkManageable!

            beforeEach {
                let configuration: URLSessionConfiguration = .ephemeral
                configuration.protocolClasses = [MockURLProtocol.self]
                session = URLSession(configuration: configuration)
                dummyMultipartFormData = DummyMultipartFormData()
                sut = NetworkManager(session: session, multipartFormData: dummyMultipartFormData)
            }
            afterEach {
                sut = nil
                dummyMultipartFormData = nil
                session = nil
            }

            describe("fetch MarketItemList data") {
                context("정해진 path에 pageNumber를 path parameter로 전달하면") {
                    let path = EndPoint.items(page: TestAssets.Expected.FetchList.pageNumber).path

                    it("지정된 pageNumber의 MarketItem들이 MarketItemList json 형태로 반환된다") {
                        let expectedFetchedMarketItemListJSON: Data = TestAssets.Expected.fetchMarketItemListData
                        self.setLoadingHandler(shouldSuccessNetwork: true, expectedFetchedMarketItemListJSON)
                        sut.fetch(from: path) { result in
                            switch result {
                            case .success(let data):
                                expect(data).to(equal(expectedFetchedMarketItemListJSON))
                            case .failure(let error):
                                XCTFail("응답이 예상과 다릅니다. Error: \(error)")
                            }
                        }
                    }

                    it("통신에 실패하면 Result 타입으로 래핑된 NetworkManagerError를 반환한다") {
                        let failedInput: Data = TestAssets.Expected.fetchMarketItemListData
                        let expected: NetworkManagerError = TestAssets.Expected.FetchList.error
                        self.setLoadingHandler(shouldSuccessNetwork: false, failedInput)
                        sut.fetch(from: path) { result in
                            switch result {
                            case .success:
                                XCTFail("응답이 예상과 다릅니다.")
                            case .failure(let error):
                                expect(error).to(equal(expected))
                            }
                        }
                    }
                }
            }

            describe("fetch MarketItem detail data") {
                context("정해진 path에 itemID를 path parameter로 전달하면") {
                    let path = EndPoint.item(id: TestAssets.Expected.Post.id).path

                    it("지정된 id를 가진 MarketItem이 json 형태로 반환된다") {
                        let expectedFetchedMarketItemDetail: Data = TestAssets.Expected.fetchMarketItemDetailData
                        self.setLoadingHandler(shouldSuccessNetwork: true, expectedFetchedMarketItemDetail)
                        sut.fetch(from: path) { result in
                            switch result {
                            case .success(let data):
                                expect(data).to(equal(expectedFetchedMarketItemDetail))
                            case .failure(let error):
                                XCTFail("응답이 예상과 다릅니다. Error: \(error)")
                            }
                        }
                    }

                    it("통신에 실패하면 Result 타입으로 래핑된 NetworkManagerError를 반환한다") {
                        let failedInput: Data = TestAssets.Expected.fetchMarketItemDetailData
                        let expected: NetworkManagerError = TestAssets.Expected.FetchDetail.error
                        self.setLoadingHandler(shouldSuccessNetwork: false, failedInput)
                        sut.fetch(from: path) { result in
                            switch result {
                            case .success:
                                XCTFail("응답이 예상과 다릅니다.")
                            case .failure(let error):
                                expect(error).to(equal(expected))
                            }
                        }
                    }
                }
            }

            describe("multipartUpload post") {
                let postMarketItem: PostMarketItem = TestAssets.Dummies.postMarketItem
                
                context("지정된 path에 PostMarketItem 인스턴스를 전달하면") {
                    let path = EndPoint.uploadItem.path

                    it("등록된 상품이 MarketItem json 형태로 반환된다") {
                        let expected: Data = TestAssets.Expected.postMarketItemData
                        self.setLoadingHandler(shouldSuccessNetwork: true, expected)

                        sut.multipartUpload(postMarketItem, to: path, method: .post) { result in
                            switch result {
                            case .success(let data):
                                expect(data).to(equal(expected))
                            case .failure(let error):
                                XCTFail("응답이 예상과 다릅니다. Error: \(error)")
                            }
                        }
                    }

                    it("통신에 실패하면 Result 타입으로 래핑된 NetworkManagerError를 반환한다") {
                        let failedInput = TestAssets.Expected.postMarketItemData
                        self.setLoadingHandler(shouldSuccessNetwork: false, failedInput)
                        let expected: NetworkManagerError = TestAssets.Expected.Post.error

                        sut.multipartUpload(postMarketItem, to: path, method: .post) { result in
                            switch result {
                            case .success:
                                XCTFail("응답이 예상과 다릅니다.")
                            case .failure(let error):
                                expect(error).to(equal(expected))
                            }
                        }
                    }
                }
            }

            describe("multipartUpload patch") {
                let patchMarketItem: PatchMarketItem = TestAssets.Dummies.patchMarketItem
                
                context("지정된 path에 itemID를 PatchMarketItem 인스턴스를 전달하면") {
                    let path = EndPoint.item(id: TestAssets.Expected.Patch.id).path

                    it("수정된 상품이 MarketItem json 형태로 반환된다") {
                        let expected: Data = TestAssets.Expected.patchMarketItemData
                        self.setLoadingHandler(shouldSuccessNetwork: true, expected)

                        sut.multipartUpload(patchMarketItem, to: path, method: .patch) { result in
                            switch result {
                            case .success(let data):
                                expect(data).to(equal(expected))
                            case .failure(let error):
                                XCTFail("응답이 예상과 다릅니다. Error: \(error)")
                            }
                        }
                    }
                }
            }

            describe("delete") {
                let deleteMarketItem: DeleteMarketItem = TestAssets.Dummies.deleteMarketItem
                let encoder = JSONEncoder()
                encoder.keyEncodingStrategy = .convertToSnakeCase

                context("지정된 path에 itemID를 DeleteMarketItem 인스턴스를 JSON 형태로 인코딩하여 전달하면") {
                    let path = EndPoint.item(id: .zero).path

                    it("성공 시 Result 타입으로 래핑된 HTTP Status Code 200을 반환한다") {
                        let encoded = try! encoder.encode(deleteMarketItem)
                        self.setLoadingHandler(shouldSuccessNetwork: true, encoded)
                        let expected: Int = TestAssets.Expected.Delete.successStatusCode

                        sut.delete(encoded, at: path) { result in
                            switch result {
                            case .success(let statusCode):
                                expect(statusCode).to(equal(expected))
                            case .failure(let error):
                                XCTFail("응답이 예상과 다릅니다. Error: \(error)")
                            }
                        }
                    }

                    it("통신에 실패하면 Result 타입으로 래핑된 NetworkManagerError를 반환한다") {
                        let failedInput = try! encoder.encode(deleteMarketItem)
                        self.setLoadingHandler(shouldSuccessNetwork: false, failedInput)
                        let expected: NetworkManagerError = TestAssets.Expected.Delete.error

                        sut.delete(failedInput, at: path) { result in
                            switch result {
                            case .success:
                                XCTFail("응답이 예상과 다릅니다.")
                            case .failure(let error):
                                expect(error).to(equal(expected))
                            }
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Private methods for testing

extension NetworkManagerSpec {

    private func setLoadingHandler(shouldSuccessNetwork: Bool, _ data: Data) {
        MockURLProtocol.loadingHandler = { request in
            let response: HTTPURLResponse

            if shouldSuccessNetwork {
                response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
                return (response, data)
            } else {
                response = HTTPURLResponse(url: request.url!, statusCode: 400, httpVersion: nil, headerFields: nil)!
                return (response, nil)
            }
        }
    }
}

extension NetworkManagerError: Equatable {

    public static func == (lhs: NetworkManagerError, rhs: NetworkManagerError) -> Bool {
        return lhs.localizedDescription == rhs.localizedDescription
    }
}
