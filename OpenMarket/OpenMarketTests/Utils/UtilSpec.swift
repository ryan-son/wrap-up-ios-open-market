//
//  UtilTests.swift
//  OpenMarketTests
//
//  Created by Ryan-Son on 2021/09/03.
//

import Nimble
import Quick
@testable import OpenMarket

final class UtilSpec: QuickSpec {

    override func spec() {
        describe("Data extension append(_:)") {
            var data = Data()
            
            context("데이터 타입 인스턴스에 문자열을 append하면") {
                let expected: String = "String -> Data"
                data.append(expected)

                it("Data 형태로 인코딩되어 append된다.") {
                    expect(data).to(equal(expected.data(using: .utf8)))
                }
            }
        }

        describe("Int extension priceFormatted()") {
            let largeInteger: Int = 10000000000000
            
            context("priceFormatted()를 사용하면") {
                let formattedNumber: String = largeInteger.priceFormatted()
                let expected: String = "10,000,000,000,000"

                it("구분 표시가 포함된 문자열 형태의 수를 얻을 수 있다") {
                    expect(formattedNumber).to(beAKindOf(String.self))
                    expect(formattedNumber).to(equal(expected))
                }
            }

        }

        describe("String extension strikeThrough()") {
            let someStringToBeStruckThrough = "취소선이 그어질 문자열"

            context("strikeThourgh()를 사용하면") {
                let struckThrough: NSAttributedString = someStringToBeStruckThrough.strikeThrough()
                let attributes = struckThrough.attributes(at: .zero, effectiveRange: nil)
                let expectedAttribute = attributes[.strikethroughStyle] as? Int

                it("취소선이 포함된 NSAttributedString을 얻을 수 있다.") {
                    expect(struckThrough).to(beAKindOf(NSAttributedString.self))
                    expect(struckThrough.string).to(equal(someStringToBeStruckThrough))
                    expect(expectedAttribute).to(equal(NSUnderlineStyle.single.rawValue))
                }
            }
        }
    }
}
