//
//  MultipartFormDataSpec.swift
//  OpenMarketTests
//
//  Created by Ryan-Son on 2021/09/04.
//

import Nimble
import Quick
@testable import OpenMarket

final class MultipartFormDataSpec: QuickSpec {

    override func spec() {

        describe("MultipartFormData") {
            var sut: MultipartFormDataEncodable!

            beforeEach { sut = MultipartFormData() }
            afterEach { sut = nil }

            context("boundary가 주어졌을 때") {
                it("Content-Type") {
                    let boundary = sut.boundary
                    let expected = "multipart/form-data; boundary=\(boundary)"
                    expect(sut.contentType).to(equal(expected))
                }
            }

            describe("이미지 이외의 파라미터가 하나만 주어졌을 때 인코딩") {
                let patchMarketItem: PatchMarketItem = TestAssets.Dummies.patchMarketItemThatOnlyHasPassword

                context("이미지가 아닌 하나의 키-값 파라미터를 인코딩 했을 때") {
                    it("인코딩된 데이터의 형태는 예상한 데이터의 형태와 같다") {
                        let encoded = sut.encode(parameters: patchMarketItem.asDictionary)

                        var expected = Data()
                        let boundary: String = sut.boundary
                        let initialBoundary: Data = MultipartFormData.BoundaryGenerator.boundaryData(for: .initial, boundary: boundary)
                        let finalBoundary: Data = MultipartFormData.BoundaryGenerator.boundaryData(for: .final, boundary: boundary)
                        let crlf: String = MultipartFormData.EncodingCharacter.crlf

                        expected.append(initialBoundary)
                        expected.append(
                            "Content-Disposition: form-data; name=\"password\"\(crlf)\(crlf)\(TestAssets.sharedPassword)"
                        )
                        expected.append(finalBoundary)
                        expect(encoded).to(equal(expected))
                    }
                }
            }
            
            describe("이미지와 패스워드만 주어졌을 때 인코딩") {
                let patchMarketItem = TestAssets.Dummies.patchMarketItemThatOnlyHasOneImage

                context("이미지가 하나일 때") {
                    it("인코딩된 데이터의 형태는 예상한 데이터의 형태와 같다") {
                        let encoded = sut.encode(parameters: patchMarketItem.asDictionary)

                        var expected = Data()
                        let boundary: String = sut.boundary
                        let initialBoundary: Data = MultipartFormData.BoundaryGenerator.boundaryData(for: .initial, boundary: boundary)
                        let encapsulatingBoundary: Data = MultipartFormData.BoundaryGenerator.boundaryData(for: .encapsulated, boundary: boundary)
                        let finalBoundary: Data = MultipartFormData.BoundaryGenerator.boundaryData(for: .final, boundary: boundary)
                        let crlf: String = MultipartFormData.EncodingCharacter.crlf

                        expected.append(initialBoundary)
                        expected.append(
                            "Content-Disposition: form-data; name=\"images[]\"; filename=\"image0.jpeg\"\(crlf)" +
                                "Content-Type: image/jpeg\(crlf)\(crlf)"
                        )
                        expected.append(TestAssets.Expected.PatchMarketItem.images[.zero])
                        expected.append(encapsulatingBoundary)
                        expected.append(
                            "Content-Disposition: form-data; name=\"password\"\(crlf)\(crlf)\(TestAssets.sharedPassword)"
                        )
                        expected.append(finalBoundary)
                        expect(encoded).to(equal(expected))
                    }
                }
            }

            describe("전체 파라미터 인코딩") {
                let postMarketItem: PostMarketItem = TestAssets.Dummies.postMarketItem

                context("이미지가 두 개일 때") {
                    it("인코딩된 데이터의 형태는 예상한 데이터의 형태와 같다") {
                        let encoded = sut.encode(parameters: postMarketItem.asDictionary)

                        var expected = Data()
                        let boundary: String = sut.boundary
                        let initialBoundary: Data = MultipartFormData.BoundaryGenerator.boundaryData(for: .initial, boundary: boundary)
                        let encapsulatingBoundary: Data = MultipartFormData.BoundaryGenerator.boundaryData(for: .encapsulated, boundary: boundary)
                        let finalBoundary: Data = MultipartFormData.BoundaryGenerator.boundaryData(for: .final, boundary: boundary)
                        let crlf: String = MultipartFormData.EncodingCharacter.crlf

                        expected.append(initialBoundary)
                        expected.append(
                            "Content-Disposition: form-data; name=\"currency\"\(crlf)\(crlf)\(TestAssets.Expected.PostMarketItem.currency)"
                        )
                        expected.append(encapsulatingBoundary)
                        expected.append(
                            "Content-Disposition: form-data; name=\"descriptions\"\(crlf)\(crlf)\(TestAssets.Expected.PostMarketItem.descriptions)"
                        )
                        expected.append(encapsulatingBoundary)
                        expected.append(
                            "Content-Disposition: form-data; name=\"discounted_price\"\(crlf)\(crlf)\(TestAssets.Expected.PostMarketItem.discountedPrice)"
                        )
                        expected.append(encapsulatingBoundary)
                        expected.append(
                            "Content-Disposition: form-data; name=\"images[]\"; filename=\"image0.jpeg\"\(crlf)" +
                                "Content-Type: image/jpeg\(crlf)\(crlf)"
                        )
                        expected.append(TestAssets.Expected.PostMarketItem.images[.zero])
                        expected.append(encapsulatingBoundary)
                        expected.append(
                            "Content-Disposition: form-data; name=\"images[]\"; filename=\"image1.jpeg\"\(crlf)" +
                                "Content-Type: image/jpeg\(crlf)\(crlf)"
                        )
                        expected.append(TestAssets.Expected.PostMarketItem.images[1])
                        expected.append(encapsulatingBoundary)
                        expected.append(
                            "Content-Disposition: form-data; name=\"password\"\(crlf)\(crlf)\(TestAssets.sharedPassword)"
                        )
                        expected.append(encapsulatingBoundary)
                        expected.append(
                            "Content-Disposition: form-data; name=\"price\"\(crlf)\(crlf)\(TestAssets.Expected.PostMarketItem.price)"
                        )
                        expected.append(encapsulatingBoundary)
                        expected.append(
                            "Content-Disposition: form-data; name=\"stock\"\(crlf)\(crlf)\(TestAssets.Expected.PostMarketItem.stock)"
                        )
                        expected.append(encapsulatingBoundary)
                        expected.append(
                            "Content-Disposition: form-data; name=\"title\"\(crlf)\(crlf)\(TestAssets.Expected.PostMarketItem.title)"
                        )
                        expected.append(finalBoundary)

                        expect(encoded).to(equal(expected))
                    }
                }
            }
        }
    }
}
