//
//  ThumbnailUseCaseSpec.swift
//  OpenMarketTests
//
//  Created by Ryan-Son on 2021/09/05.
//

import Nimble
import Quick
@testable import OpenMarket

final class ThumbnailUseCaseSpec: QuickSpec {

    override func spec() {
        describe("ThumbnailUseCase") {
            var stubNetworkManager: StubNetworkManager!
            var sut: ThumbnailUseCaseProtocol!
            
            beforeEach {
                stubNetworkManager = StubNetworkManager()
                sut = ThumbnailUseCase(networkManager: stubNetworkManager)
            }
            afterEach {
                sut = nil
                stubNetworkManager = nil
            }

            describe("fetchThumbnail") {
                context("thumbnail이 있는 인터넷 url path를 문자열 형태로 전달하면") {
                    let path: String = TestAssets.Expected.thumbnailURLString

                    it("UIImage 형태로 반환하고 fetch한 thumbnail은 sharedCache 타입 프로퍼티에 NSURL 타입의 키값을 가지고 저장된다") {
                        let expected: Data = TestAssets.Expected.image.pngData()!
                        let _ = sut.fetchThumbnail(from: path) { result in
                            switch result {
                            case .success(let thumbnail):
                                let thumbnailData: Data = thumbnail!.pngData()!
                                expect(thumbnailData).to(equal(expected))
                            case .failure(let error):
                                XCTFail("동작이 예상과 다릅니다. Error: \(error)")
                            }
                        }
                        
                        let url = NSURL(string: path)!
                        let cached: Data = ThumbnailUseCase.sharedCache.object(forKey: url)!.pngData()!
                        expect(cached).to(equal(expected))
                    }
                }

                context("기존 네트워크 요청 결과에 따라 cache된 thumbnail이 있으면") {
                    let path: String = TestAssets.Expected.thumbnailURLString

                    it("네트워크 요청을 하지 않고 sharedCache에 저장된 thumbnail을 반환한다") {
                        let _ = sut.fetchThumbnail(from: path) { _ in }
                        let thumbnailTask = sut.fetchThumbnail(from: path) { result in
                            switch result {
                            case .success(let thumbnail):
                                let url = NSURL(string: path)!
                                let expected: Data = ThumbnailUseCase.sharedCache.object(forKey: url)!.pngData()!
                                let thumbnailData: Data = thumbnail!.pngData()!
                                expect(thumbnailData).to(equal(expected))
                            case .failure(let error):
                                XCTFail("동작이 예상과 다릅니다. Error: \(error)")
                            }
                        }

                        expect(thumbnailTask).to(beNil())
                    }
                }
            }
        }
    }
}
