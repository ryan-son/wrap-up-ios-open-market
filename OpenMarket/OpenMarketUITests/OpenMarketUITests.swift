//
//  OpenMarketUITests.swift
//  OpenMarketUITests
//
//  Created by Ryan-Son on 2021/08/28.
//

import XCTest

final class OpenMarketUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        
        let app = XCUIApplication()
        app.navigationBars["Item Registration"].buttons["Ryan Market"].tap()
        app.collectionViews["marketItemList"]/*@START_MENU_TOKEN@*/.buttons["addNewPost"]/*[[".buttons[\"plus.circle\"]",".buttons[\"addNewPost\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.collectionViews/*[[".scrollViews.collectionViews",".collectionViews"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.cells.children(matching: .other).element.children(matching: .other).element.tap()
        app.sheets["사진을 어디서 가져올까요?"].scrollViews.otherElements.buttons["사진첩"].tap()
        app.scrollViews.children(matching: .other).element.children(matching: .other).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .image).matching(identifier: "Photo, September 06, 9:34 PM").element(boundBy: 0).tap()

        
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
