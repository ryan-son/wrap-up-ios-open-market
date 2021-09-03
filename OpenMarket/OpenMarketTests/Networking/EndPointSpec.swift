//
//  EndPointSpec.swift
//  OpenMarketTests
//
//  Created by Ryan-Son on 2021/09/03.
//

import Nimble
import Quick
@testable import OpenMarket

final class EndPointSpec: QuickSpec {

    override func spec() {
        describe("EndPoint 타입: 적절한 인터넷 URL을 문자열로 반환") {
            context("items 케이스에 페이지 번호를 입력하면") {
                let pathForItemsPageOne = EndPoint.items(page: 1).path
                let expected = "https://camp-open-market-2.herokuapp.com/items/1"

                it("문자열 형태로 인터넷 URL을 얻을 수 있다") {
                    expect(pathForItemsPageOne).to(equal(expected))
                }
            }

            context("item 케이스에 id를 입력하면") {
                let pathForItemWithIDNumberOne = EndPoint.item(id: 1).path
                let expected = "https://camp-open-market-2.herokuapp.com/item/1"

                it("문자열 형태로 인터넷 URL을 얻을 수 있다") {
                    expect(pathForItemWithIDNumberOne).to(equal(expected))
                }
            }

            context("uploadItem 케이스를 통해") {
                let pathForUploadItem = EndPoint.uploadItem.path
                let expected = "https://camp-open-market-2.herokuapp.com/item/"
                
                it("문자열 형태로 인터넷 URL을 얻을 수 있다") {
                    expect(pathForUploadItem).to(equal(expected))
                }
            }
        }
    }
}
