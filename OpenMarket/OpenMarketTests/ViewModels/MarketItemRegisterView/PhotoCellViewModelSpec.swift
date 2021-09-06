//
//  PhotoCellViewModelSpec.swift
//  OpenMarketTests
//
//  Created by Ryan-Son on 2021/09/06.
//

import Nimble
import Quick
@testable import OpenMarket

final class PhotoCellViewModelSpec: QuickSpec {

    override func spec() {
        describe("PhotoCellViewModel") {

            describe("bind - setImage") {
                it("setImage를 실행하면 바인딩 상태를 통해 전달했던 이미지를 받을 수 있다") {
                    let sut = PhotoCellViewModel()
                    let expected = TestAssets.Expected.image
                    sut.bind { image in
                        expect(image).to(equal(sut.photoImage))
                    }
                    sut.setImage(expected)
                }
            }
        }
    }
}
