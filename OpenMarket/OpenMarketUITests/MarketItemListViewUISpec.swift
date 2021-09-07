//
//  MarketItemListViewUISpec.swift
//  OpenMarketUITests
//
//  Created by Ryan-Son on 2021/09/07.
//

import Nimble
import Quick

final class MarketItemListViewUISpec: QuickSpec {

    override func spec() {
        describe("MarketItemListUI") {
            var app: XCUIApplication!

            beforeEach {
                self.continueAfterFailure = false

                app = XCUIApplication()
                app.launch()
            }
            afterEach {
                XCUIDevice.shared.orientation = .portrait
                app = nil
            }

            describe("List View") {
                context("디바이스가 Portrait 방향일 때") {
                    it("로드 시 화면 UI 요소는 내비게이션 바 제목, 셀 스타일 선택, 리프레시 버튼, 상품 셀, 상품 이미지, 셀 제목, 재고, 가격이 있다") {
                        let ryanMarketNavigationBar = app.navigationBars["Ryan Market"]
                        expect(ryanMarketNavigationBar.exists).to(beTrue())
                        
                        expect(ryanMarketNavigationBar.buttons["changeCellStyle"].exists).to(beTrue())
                        expect(ryanMarketNavigationBar.buttons["refreshMarketItems"].exists).to(beTrue())
                        
                        let marketItemListCollectionView = app.collectionViews["marketItemList"]
                        expect(marketItemListCollectionView.exists).to(beTrue())
                        expect(marketItemListCollectionView.buttons["addNewPost"].exists).to(beTrue())

                        let cell = marketItemListCollectionView
                            .children(matching: .cell)
                            .matching(identifier: "listMarketItem")
                            .element(boundBy: .zero)
                        guard cell.waitForExistence(timeout: 3) else {
                            throw XCTSkip("등록된 상품이 없습니다")
                        }

                        expect(cell.exists).to(beTrue())
                        expect(cell.images["thumbnail"].exists).to(beTrue())
                        expect(cell.staticTexts["marketItemTitle"].exists).to(beTrue())
                        expect(cell.staticTexts["price"].exists).to(beTrue())
                        expect(cell.staticTexts["stock"].exists).to(beTrue())
                        
                        let discountedPriceLabel = marketItemListCollectionView.staticTexts["discountedPrice"]
                        try XCTSkipUnless(discountedPriceLabel.exists, "할인가를 가진 Cell이 화면 내에 없습니다")
                        expect(discountedPriceLabel.exists).to(beTrue())
                    }
                }

                context("디바이스가 Landscape 방향일 때") {
                    it("로드 시 화면 UI 요소는 내비게이션 바 제목, 셀 스타일 선택, 리프레시 버튼, 상품 셀, 상품 이미지, 셀 제목, 재고, 가격이 있다") {
                        XCUIDevice.shared.orientation = .landscapeLeft

                        let ryanMarketNavigationBar = app.navigationBars["Ryan Market"]
                        expect(ryanMarketNavigationBar.exists).to(beTrue())
                        
                        expect(ryanMarketNavigationBar.buttons["changeCellStyle"].exists).to(beTrue())
                        expect(ryanMarketNavigationBar.buttons["refreshMarketItems"].exists).to(beTrue())
                        
                        let marketItemListCollectionView = app.collectionViews["marketItemList"]
                        expect(marketItemListCollectionView.exists).to(beTrue())
                        expect(marketItemListCollectionView.buttons["addNewPost"].exists).to(beTrue())

                        let cell = marketItemListCollectionView
                            .children(matching: .cell)
                            .matching(identifier: "listMarketItem")
                            .element(boundBy: .zero)
                        guard cell.waitForExistence(timeout: 3) else {
                            throw XCTSkip("등록된 상품이 없습니다")
                        }

                        expect(cell.exists).to(beTrue())
                        expect(cell.images["thumbnail"].exists).to(beTrue())
                        expect(cell.staticTexts["marketItemTitle"].exists).to(beTrue())
                        expect(cell.staticTexts["price"].exists).to(beTrue())
                        expect(cell.staticTexts["stock"].exists).to(beTrue())
                        
                        let discountedPriceLabel = marketItemListCollectionView.staticTexts["discountedPrice"]
                        try XCTSkipUnless(discountedPriceLabel.exists, "할인가를 가진 Cell이 화면 내에 없습니다")
                        expect(discountedPriceLabel.exists).to(beTrue())
                    }
                }
                
            }

            describe("Grid View") {
                context("디바이스가 Portrait 방향일 때") {
                    it("로드 시 화면 UI 요소는 내비게이션 바 제목, 셀 스타일 선택, 리프레시 버튼, 상품 셀, 상품 이미지, 셀 제목, 재고, 가격이 있다") {
                        let ryanMarketNavigationBar = app.navigationBars["Ryan Market"]
                        let marketItemListCollectionView = app.collectionViews["marketItemList"]
                        let listCell = marketItemListCollectionView
                            .children(matching: .cell)
                            .matching(identifier: "listMarketItem")
                            .element(boundBy: .zero)

                        guard listCell.waitForExistence(timeout: 3) else {
                            throw XCTSkip("등록된 상품이 없습니다")
                        }

                        let changeCellStyleButton = ryanMarketNavigationBar.buttons["changeCellStyle"]
                        expect(changeCellStyleButton.exists).to(beTrue())
                        expect(changeCellStyleButton.isEnabled).to(beTrue())
                        
                        changeCellStyleButton.tap()

                        expect(ryanMarketNavigationBar.exists).to(beTrue())
                        expect(changeCellStyleButton.exists).to(beTrue())
                        expect(ryanMarketNavigationBar.buttons["refreshMarketItems"].exists).to(beTrue())

                        expect(marketItemListCollectionView.exists).to(beTrue())
                        expect(marketItemListCollectionView.buttons["addNewPost"].exists).to(beTrue())

                        let gridCell = marketItemListCollectionView
                            .children(matching: .cell)
                            .matching(identifier: "gridMarketItem")
                            .element(boundBy: .zero)

                        expect(gridCell.exists).to(beTrue())
                        expect(gridCell.images["thumbnail"].exists).to(beTrue())
                        expect(gridCell.staticTexts["marketItemTitle"].exists).to(beTrue())
                        expect(gridCell.staticTexts["price"].exists).to(beTrue())
                        expect(gridCell.staticTexts["stock"].exists).to(beTrue())
                        
                        let discountedPriceLabel = marketItemListCollectionView/*@START_MENU_TOKEN@*/.staticTexts["discountedPrice"]/*[[".cells",".staticTexts[\"USD 165\"]",".staticTexts[\"discountedPrice\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
                        try XCTSkipUnless(discountedPriceLabel.exists, "할인가를 가진 Cell이 화면 내에 없습니다")
                        expect(discountedPriceLabel.exists).to(beTrue())
                    }
                }

                context("디바이스가 Landscape 방향일 때") {
                    it("로드 시 화면 UI 요소는 내비게이션 바 제목, 셀 스타일 선택, 리프레시 버튼, 상품 셀, 상품 이미지, 셀 제목, 재고, 가격이 있다") {
                        XCUIDevice.shared.orientation = .landscapeLeft

                        let ryanMarketNavigationBar = app.navigationBars["Ryan Market"]
                        let marketItemListCollectionView = app.collectionViews["marketItemList"]
                        let listCell = marketItemListCollectionView
                            .children(matching: .cell)
                            .matching(identifier: "listMarketItem")
                            .element(boundBy: .zero)

                        guard listCell.waitForExistence(timeout: 3) else {
                            throw XCTSkip("등록된 상품이 없습니다")
                        }

                        let changeCellStyleButton = ryanMarketNavigationBar.buttons["changeCellStyle"]
                        expect(changeCellStyleButton.exists).to(beTrue())
                        expect(changeCellStyleButton.isEnabled).to(beTrue())
                        
                        changeCellStyleButton.tap()

                        expect(ryanMarketNavigationBar.exists).to(beTrue())
                        expect(changeCellStyleButton.exists).to(beTrue())
                        expect(ryanMarketNavigationBar.buttons["refreshMarketItems"].exists).to(beTrue())

                        expect(marketItemListCollectionView.exists).to(beTrue())
                        expect(marketItemListCollectionView.buttons["addNewPost"].exists).to(beTrue())

                        let gridCell = marketItemListCollectionView
                            .children(matching: .cell)
                            .matching(identifier: "gridMarketItem")
                            .element(boundBy: .zero)

                        expect(gridCell.exists).to(beTrue())
                        expect(gridCell.images["thumbnail"].exists).to(beTrue())
                        expect(gridCell.staticTexts["marketItemTitle"].exists).to(beTrue())
                        expect(gridCell.staticTexts["price"].exists).to(beTrue())
                        expect(gridCell.staticTexts["stock"].exists).to(beTrue())
                        
                        let discountedPriceLabel = marketItemListCollectionView.staticTexts["discountedPrice"]
                        try XCTSkipUnless(discountedPriceLabel.exists, "할인가를 가진 Cell이 화면 내에 없습니다")
                        expect(discountedPriceLabel.exists).to(beTrue())
                    }
                }
            }

            describe("Change cell style button") {
                context("한 번 탭하면") {
                    it("셀 스타일을 grid로 변경할 수 있다") {
                        let ryanMarketNavigationBar = app.navigationBars["Ryan Market"]
                        let marketItemListCollectionView = app.collectionViews["marketItemList"]

                        let listCell = marketItemListCollectionView
                            .children(matching: .cell)
                            .matching(identifier: "listMarketItem")
                            .element(boundBy: .zero)
                        guard listCell.waitForExistence(timeout: 3) else {
                            throw XCTSkip("등록된 상품이 없습니다")
                        }
                        expect(listCell.exists).to(beTrue())
                        expect(listCell.isEnabled).to(beTrue())
                        
                        let changeCellStyleButton = ryanMarketNavigationBar.buttons["changeCellStyle"]
                        expect(changeCellStyleButton.exists).to(beTrue())
                        expect(changeCellStyleButton.isEnabled).to(beTrue())
                        
                        changeCellStyleButton.tap()

                        let gridCell = marketItemListCollectionView
                            .children(matching: .cell)
                            .matching(identifier: "gridMarketItem")
                            .element(boundBy: .zero)
                        expect(gridCell.exists).to(beTrue())
                        expect(gridCell.isEnabled).to(beTrue())
                    }
                }
                
                context("두 번 탭하면") {
                    it("셀 스타일을 다시 list로 변경할 수 있다") {
                        let ryanMarketNavigationBar = app.navigationBars["Ryan Market"]
                        let marketItemListCollectionView = app.collectionViews["marketItemList"]

                        let listCell = marketItemListCollectionView
                            .children(matching: .cell)
                            .matching(identifier: "listMarketItem")
                            .element(boundBy: .zero)
                        guard listCell.waitForExistence(timeout: 3) else {
                            throw XCTSkip("등록된 상품이 없습니다")
                        }
                        expect(listCell.exists).to(beTrue())
                        expect(listCell.isEnabled).to(beTrue())
                        
                        let changeCellStyleButton = ryanMarketNavigationBar.buttons["changeCellStyle"]
                        expect(changeCellStyleButton.exists).to(beTrue())
                        expect(changeCellStyleButton.isEnabled).to(beTrue())
                        
                        changeCellStyleButton.tap()

                        let gridCell = marketItemListCollectionView
                            .children(matching: .cell)
                            .matching(identifier: "gridMarketItem")
                            .element(boundBy: .zero)
                        expect(gridCell.exists).to(beTrue())
                        expect(gridCell.isEnabled).to(beTrue())

                        changeCellStyleButton.tap()
                        expect(listCell.exists).to(beTrue())
                        expect(listCell.isEnabled).to(beTrue())
                    }
                }
                
            }

            describe("Refresh market items button") {
                it("버튼을 탭하여 서버로부터 상품들을 다시 불러올 수 있다") {
                    let ryanMarketNavigationBar = app.navigationBars["Ryan Market"]
                    let marketItemListCollectionView = app.collectionViews["marketItemList"]

                    let listCell = marketItemListCollectionView
                        .children(matching: .cell)
                        .matching(identifier: "listMarketItem")
                        .element(boundBy: .zero)
                    guard listCell.waitForExistence(timeout: 3) else {
                        throw XCTSkip("등록된 상품이 없습니다")
                    }
                    try XCTSkipUnless(listCell.exists, "등록된 상품이 없습니다")
                    expect(listCell.exists).to(beTrue())
                    expect(listCell.isEnabled).to(beTrue())

                    let refreshButton = ryanMarketNavigationBar.buttons["refreshMarketItems"]
                    refreshButton.tap()

                    expect(listCell.exists).to(beTrue())
                    expect(listCell.isEnabled).to(beTrue())
                }
            }

            describe("Pull to refresh") {
                it("collection View의 최상단을 swipe하여 서버로부터 상품들을 다시 불러올 수 있다") {
                    let marketItemListCollectionView = app.collectionViews["marketItemList"]

                    let listCell = marketItemListCollectionView
                        .children(matching: .cell)
                        .matching(identifier: "listMarketItem")
                        .element(boundBy: .zero)
                    guard listCell.waitForExistence(timeout: 3) else {
                        throw XCTSkip("등록된 상품이 없습니다")
                    }
                    expect(listCell.exists).to(beTrue())
                    expect(listCell.isEnabled).to(beTrue())

                    marketItemListCollectionView.swipeDown()

                    expect(listCell.exists).to(beTrue())
                    expect(listCell.isEnabled).to(beTrue())
                }
            }

            describe("상품 셀") {
                context("list cell tap") {
                    it("상품 상세 페이지로 이동한다") {
                        let marketItemListCollectionView = app.collectionViews["marketItemList"]
                        let cell = marketItemListCollectionView
                            .children(matching: .cell)
                            .matching(identifier: "listMarketItem")
                            .element(boundBy: .zero)
                        guard cell.waitForExistence(timeout: 3) else {
                            throw XCTSkip("등록된 상품이 없습니다")
                        }

                        cell.tap()

                        let itemDetailNavigationBar = app.navigationBars["Item Detail"]
                        expect(itemDetailNavigationBar.exists).to(beTrue())
                    }
                }

                context("grid cell tap") {
                    it("상품 상세 페이지로 이동한다") {
                        let marketItemListCollectionView = app.collectionViews["marketItemList"]
                        let cell = marketItemListCollectionView
                            .children(matching: .cell)
                            .matching(identifier: "listMarketItem")
                            .element(boundBy: .zero)
                        guard cell.waitForExistence(timeout: 3) else {
                            throw XCTSkip("등록된 상품이 없습니다")
                        }

                        let ryanMarketNavigationBar = app.navigationBars["Ryan Market"]
                        let changeCellStyleButton = ryanMarketNavigationBar.buttons["changeCellStyle"]
                        changeCellStyleButton.tap()

                        let gridCell = marketItemListCollectionView
                            .children(matching: .cell)
                            .matching(identifier: "gridMarketItem")
                            .element(boundBy: .zero)
                        gridCell.tap()

                        let itemDetailNavigationBar = app.navigationBars["Item Detail"]
                        expect(itemDetailNavigationBar.exists).to(beTrue())
                    }
                }
            }

            describe("새 상품 등록 버튼") {
                context("탭하면") {
                    it("새 상품 등록 화면으로 이동한다") {
                        let marketItemListCollectionView = app.collectionViews["marketItemList"]
                        let addNewPostButton = marketItemListCollectionView.buttons["addNewPost"]
                        addNewPostButton.tap()

                        let itemRegistrationNavigationBar = app.navigationBars["Item Registration"]
                        expect(itemRegistrationNavigationBar.exists).to(beTrue())
                    }
                }
            }
        }
    }
}
