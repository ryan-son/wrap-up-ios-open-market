//
//  MarketItemDetailViewUISpec.swift
//  OpenMarketUITests
//
//  Created by Ryan-Son on 2021/09/08.
//

import Nimble
import Quick

final class MarketItemDetailViewUISpec: QuickSpec {

    override func spec() {
        describe("MarketItemDetailViewUI") {
            var app: XCUIApplication!
            beforeSuite {
                app = XCUIApplication()
                app.launch()

                let marketItemListCollectionView = app.collectionViews["marketItemList"]
                let cell = marketItemListCollectionView
                    .children(matching: .cell)
                    .matching(identifier: "listMarketItem")
                    .element(boundBy: .zero)

                guard cell.waitForExistence(timeout: 5) else {
                    return XCTFail("등록된 상품이 없습니다")
                }

                cell.tap()
            }
            afterSuite {
                app = nil
            }

            describe("상품 상세 화면 UI") {
                it("back, more 버튼, 상품 제목, 가격, 재고와 본문이 있다") {
                    let itemDetailNavigationBar = app.navigationBars["Item Detail"]
                    let backButton = itemDetailNavigationBar.buttons["< Back"]
                    let moreActionsButton = itemDetailNavigationBar.buttons["moreActions"]
                    expect(itemDetailNavigationBar.exists).to(beTrue())
                    expect(backButton.exists).to(beTrue())
                    expect(moreActionsButton.exists).to(beTrue())
                    
                    let imageScrollView = app.scrollViews["imageScroll"]
                    let imageView = imageScrollView.children(matching: .image).firstMatch

                    guard imageView.waitForExistence(timeout: 3) else {
                        return XCTFail("상품 정보가 로드 되지 않습니다.")
                    }

                    expect(imageScrollView.exists).to(beTrue())
                    expect(imageView.exists).to(beTrue())

                    let contentScrollView = app.scrollViews["content"]
                    let titleLabel = contentScrollView.staticTexts["title"]
                    let priceLabel = contentScrollView.staticTexts["price"]
                    let bodyLabel = contentScrollView.staticTexts["body"]
                    let stockLabel = contentScrollView.staticTexts["stock"]
                    expect(titleLabel.exists).to(beTrue())
                    expect(priceLabel.exists).to(beTrue())
                    expect(bodyLabel.exists).to(beTrue())
                    expect(stockLabel.exists).to(beTrue())
                }
            }

            describe("이미지 전환") {
                it("swipe를 통해 다음 이미지를 볼 수 있다") {
                    let imageScrollView = app.scrollViews["imageScroll"]
                    let firstImageView = imageScrollView.images["itemDetail0"]

                    guard firstImageView.waitForExistence(timeout: 3) else {
                        return XCTFail("상품 정보가 로드 되지 않습니다.")
                    }

                    expect(firstImageView.exists).to(beTrue())
                    imageScrollView.swipeLeft()
                    imageScrollView.tap()

                    let secondImageView = imageScrollView.images["itemDetail1"]
                    expect(secondImageView.exists).to(beTrue())
                }
            }

            describe("moreActions") {
                it("상품 수정 및 상품 삭제 액션을 가지고 있다") {
                    let itemDetailNavigationBar = app.navigationBars["Item Detail"]
                    let moreActionsButton = itemDetailNavigationBar.buttons["moreActions"]
                    moreActionsButton.tap()
                    
                    let moreActionSheet = app.sheets["무엇을 해볼까요?"]
                    let editItemButton = moreActionSheet.buttons["상품 수정"]
                    let deleteItemButton = moreActionSheet.buttons["상품 삭제"]
                    let cancelButton = moreActionSheet.buttons["취소"]
                    expect(moreActionSheet.exists).to(beTrue())
                    expect(editItemButton.exists).to(beTrue())
                    expect(deleteItemButton.exists).to(beTrue())
                    expect(cancelButton.exists).to(beTrue())

                    cancelButton.tap()
                }

                context("상품 수정 버튼을 탭하면") {
                    it("비밀번호 입력창이 나타난다") {
                        let itemDetailNavigationBar = app.navigationBars["Item Detail"]
                        let moreActionsButton = itemDetailNavigationBar.buttons["moreActions"]
                        moreActionsButton.tap()
                        
                        let moreActionSheet = app.sheets["무엇을 해볼까요?"]
                        let editItemButton = moreActionSheet.buttons["상품 수정"]
                        editItemButton.tap()

                        let passwordInputAlert = app.alerts["비밀번호를 입력해주세요."]

                        guard passwordInputAlert.waitForExistence(timeout: 2) else {
                            return XCTFail("비밀번호 입력창이 로드되지 않았습니다")
                        }

                        let passwordInputTextField = passwordInputAlert.textFields["비밀번호"]
                        let cancelButton = passwordInputAlert.buttons["취소"]
                        let okButton = passwordInputAlert.buttons["확인"]
                        expect(passwordInputAlert.exists).to(beTrue())
                        expect(passwordInputTextField.exists).to(beTrue())
                        expect(cancelButton.exists).to(beTrue())
                        expect(okButton.exists).to(beTrue())
                        cancelButton.tap()
                    }
                }

                context("상품 수정 시 잘못된 비밀번호를 입력하면") {
                    it("잘못 입력했다는 alert을 보여준다") {
                        let itemDetailNavigationBar = app.navigationBars["Item Detail"]
                        let moreActionsButton = itemDetailNavigationBar.buttons["moreActions"]
                        moreActionsButton.tap()
                        
                        let moreActionSheet = app.sheets["무엇을 해볼까요?"]
                        let editItemButton = moreActionSheet.buttons["상품 수정"]
                        editItemButton.tap()

                        let passwordInputAlert = app.alerts["비밀번호를 입력해주세요."]

                        guard passwordInputAlert.waitForExistence(timeout: 2) else {
                            return XCTFail("비밀번호 입력창이 로드되지 않았습니다")
                        }

                        let okButton = passwordInputAlert.buttons["확인"]
                        okButton.tap()

                        let wrongPasswordAlert = app.alerts["비밀번호가 다릅니다."]

                        guard wrongPasswordAlert.waitForExistence(timeout: 2) else {
                            return XCTFail("재시도 창이 로드되지 않았습니다.")
                        }

                        let cancelButton = wrongPasswordAlert.buttons["취소"]
                        let retryButton = wrongPasswordAlert.buttons["재시도"]
                        expect(wrongPasswordAlert.exists).to(beTrue())
                        expect(cancelButton.exists).to(beTrue())
                        expect(retryButton.exists).to(beTrue())
                        cancelButton.tap()
                    }
                }

                context("상품 수정 시 잘못된 비밀번호를 입력 후 재시도 버튼을 탭하면") {
                    it("비밀번호 입력창이 다시 나타난다") {
                        let itemDetailNavigationBar = app.navigationBars["Item Detail"]
                        let moreActionsButton = itemDetailNavigationBar.buttons["moreActions"]
                        moreActionsButton.tap()
                        
                        let moreActionSheet = app.sheets["무엇을 해볼까요?"]
                        let editItemButton = moreActionSheet.buttons["상품 수정"]
                        editItemButton.tap()

                        let passwordInputAlert = app.alerts["비밀번호를 입력해주세요."]

                        guard passwordInputAlert.waitForExistence(timeout: 2) else {
                            return XCTFail("비밀번호 입력창이 로드되지 않았습니다")
                        }

                        let okButton = passwordInputAlert.buttons["확인"]
                        okButton.tap()

                        let wrongPasswordAlert = app.alerts["비밀번호가 다릅니다."]

                        guard wrongPasswordAlert.waitForExistence(timeout: 2) else {
                            return XCTFail("재시도 창이 로드되지 않았습니다.")
                        }

                        let retryButton = wrongPasswordAlert.buttons["재시도"]
                        retryButton.tap()

                        guard passwordInputAlert.waitForExistence(timeout: 2) else {
                            return XCTFail("비밀번호 입력창이 로드되지 않았습니다")
                        }

                        expect(passwordInputAlert.exists).to(beTrue())
                        passwordInputAlert.buttons["취소"].tap()
                    }
                }

                context("상품 삭제 버튼을 탭하면") {
                    it("비밀번호 입력창이 나타난다") {
                        let itemDetailNavigationBar = app.navigationBars["Item Detail"]
                        let moreActionsButton = itemDetailNavigationBar.buttons["moreActions"]
                        moreActionsButton.tap()
                        
                        let moreActionSheet = app.sheets["무엇을 해볼까요?"]
                        let editItemButton = moreActionSheet.buttons["상품 삭제"]
                        editItemButton.tap()

                        let passwordInputAlert = app.alerts["비밀번호를 입력해주세요."]

                        guard passwordInputAlert.waitForExistence(timeout: 2) else {
                            return XCTFail("비밀번호 입력창이 로드되지 않았습니다")
                        }

                        let passwordInputTextField = passwordInputAlert.textFields["비밀번호"]
                        let cancelButton = passwordInputAlert.buttons["취소"]
                        let okButton = passwordInputAlert.buttons["확인"]
                        expect(passwordInputAlert.exists).to(beTrue())
                        expect(passwordInputTextField.exists).to(beTrue())
                        expect(cancelButton.exists).to(beTrue())
                        expect(okButton.exists).to(beTrue())
                        cancelButton.tap()
                    }
                }

                context("상품 삭제 시 잘못된 비밀번호를 입력하면") {
                    it("잘못 입력했다는 alert을 보여준다") {
                        let itemDetailNavigationBar = app.navigationBars["Item Detail"]
                        let moreActionsButton = itemDetailNavigationBar.buttons["moreActions"]
                        moreActionsButton.tap()
                        
                        let moreActionSheet = app.sheets["무엇을 해볼까요?"]
                        let editItemButton = moreActionSheet.buttons["상품 삭제"]
                        editItemButton.tap()

                        let passwordInputAlert = app.alerts["비밀번호를 입력해주세요."]

                        guard passwordInputAlert.waitForExistence(timeout: 2) else {
                            return XCTFail("비밀번호 입력창이 로드되지 않았습니다")
                        }

                        let okButton = passwordInputAlert.buttons["확인"]
                        okButton.tap()

                        let wrongPasswordAlert = app.alerts["비밀번호가 다릅니다."]

                        guard wrongPasswordAlert.waitForExistence(timeout: 2) else {
                            return XCTFail("재시도 창이 로드되지 않았습니다.")
                        }

                        let cancelButton = wrongPasswordAlert.buttons["취소"]
                        let retryButton = wrongPasswordAlert.buttons["재시도"]
                        expect(wrongPasswordAlert.exists).to(beTrue())
                        expect(cancelButton.exists).to(beTrue())
                        expect(retryButton.exists).to(beTrue())
                        cancelButton.tap()
                    }
                }

                context("상품 삭제 시 잘못된 비밀번호를 입력 후 재시도 버튼을 탭하면") {
                    it("비밀번호 입력창이 다시 나타난다") {
                        let itemDetailNavigationBar = app.navigationBars["Item Detail"]
                        let moreActionsButton = itemDetailNavigationBar.buttons["moreActions"]
                        moreActionsButton.tap()
                        
                        let moreActionSheet = app.sheets["무엇을 해볼까요?"]
                        let editItemButton = moreActionSheet.buttons["상품 삭제"]
                        editItemButton.tap()

                        let passwordInputAlert = app.alerts["비밀번호를 입력해주세요."]

                        guard passwordInputAlert.waitForExistence(timeout: 2) else {
                            return XCTFail("비밀번호 입력창이 로드되지 않았습니다")
                        }

                        let okButton = passwordInputAlert.buttons["확인"]
                        okButton.tap()

                        let wrongPasswordAlert = app.alerts["비밀번호가 다릅니다."]

                        guard wrongPasswordAlert.waitForExistence(timeout: 2) else {
                            return XCTFail("재시도 창이 로드되지 않았습니다.")
                        }

                        let retryButton = wrongPasswordAlert.buttons["재시도"]
                        retryButton.tap()

                        guard passwordInputAlert.waitForExistence(timeout: 2) else {
                            return XCTFail("비밀번호 입력창이 로드되지 않았습니다")
                        }

                        expect(passwordInputAlert.exists).to(beTrue())
                        passwordInputAlert.buttons["취소"].tap()
                    }
                }
            }
        }
    }
}
