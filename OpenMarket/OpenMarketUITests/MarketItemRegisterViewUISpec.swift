//
//  MarketItemRegisterViewUISpec.swift
//  OpenMarketUITests
//
//  Created by Ryan-Son on 2021/09/08.
//

import Nimble
import Quick

final class MarketItemRegisterViewUISpec: QuickSpec {

    override func spec() {
        describe("MarketItemRegisterViewUI") {
            var app: XCUIApplication!

            beforeEach {
                app = XCUIApplication()
                app.launch()
            }
            afterEach {
                app = nil
            }

            describe("상품 등록 - 수정 - 삭제 시나리오") {
                it("프로세스 검증") {
                    let addNewPostButton = app.collectionViews["marketItemList"]/*@START_MENU_TOKEN@*/.buttons["addNewPost"]/*[[".buttons[\"plus.circle\"]",".buttons[\"addNewPost\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
                    addNewPostButton.tap()

                    let titleTextView = app/*@START_MENU_TOKEN@*/.textViews["title"]/*[[".scrollViews[\"content\"].textViews[\"title\"]",".textViews[\"title\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
                    titleTextView.tap()
                    titleTextView.typeText("UI Test로 업로드하는 글")

                    let currencyTextField = app/*@START_MENU_TOKEN@*/.textFields["currency"]/*[[".scrollViews[\"content\"]",".textFields[\"화폐\"]",".textFields[\"currency\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
                    currencyTextField.tap()
                    app.pickerWheels["KRW"].swipeUp()
                    app.toolbars["Toolbar"].buttons["Done"].tap()

                    let priceTextView = app.textViews["price"]
                    priceTextView.tap()
                    priceTextView.typeText("399")

                    let discountedPriceTextView = app/*@START_MENU_TOKEN@*/.textViews["discountedPrice"]/*[[".scrollViews[\"content\"].textViews[\"discountedPrice\"]",".textViews[\"discountedPrice\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
                    discountedPriceTextView.tap()
                    discountedPriceTextView.typeText("299")

                    let stockTextView = app/*@START_MENU_TOKEN@*/.textViews["stock"]/*[[".scrollViews[\"content\"].textViews[\"stock\"]",".textViews[\"stock\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
                    stockTextView.tap()
                    stockTextView.typeText("10")

                    let passwordTextView = app/*@START_MENU_TOKEN@*/.textViews["password"]/*[[".scrollViews[\"content\"].textViews[\"password\"]",".textViews[\"password\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
                    passwordTextView.tap()
                    passwordTextView.typeText("Ryan")

                    let descriptionsTextView = app/*@START_MENU_TOKEN@*/.textViews["descriptions"]/*[[".scrollViews[\"content\"].textViews[\"descriptions\"]",".textViews[\"descriptions\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
                    descriptionsTextView.tap()
                    descriptionsTextView.typeText("UI Test")

                    let addPhotoCell = app/*@START_MENU_TOKEN@*/.collectionViews["photo"]/*[[".scrollViews[\"content\"].collectionViews[\"photo\"]",".collectionViews[\"photo\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.cells["addPhoto"]
                    addPhotoCell.tap()
                    addPhotoCell.tap()

                    let selectPhotoSourceSheet = app.sheets["사진을 어디서 가져올까요?"]
                    guard selectPhotoSourceSheet.waitForExistence(timeout: 10) else {
                        return XCTFail("사진 선택 액션시트가 나타나지 않았습니다")
                    }

                    let photoAlbumButton = selectPhotoSourceSheet.buttons["사진첩"]
                    photoAlbumButton.tap()

                    let photo = app.scrollViews.images["Photo, March 31, 2018, 4:14 AM"]
                    guard photo.waitForExistence(timeout: 10) else {
                        return XCTFail("사진첩이 나타나지 않았습니다")
                    }

                    photo.tap()

                    let itemRegistrationNavigationBar = app.navigationBars["Item Registration"]
                    let doneButton = itemRegistrationNavigationBar.buttons["Done"]
                        
                    guard doneButton.waitForExistence(timeout: 5) else {
                        return XCTFail("완료 버튼이 나타나지 않았습니다")
                    }
                    doneButton.tap()

                    let itemDetailNavigationBar = app.navigationBars["Item Detail"]
                    let moreActionsButton = itemDetailNavigationBar.buttons["moreActions"]
                    
                    guard moreActionsButton.waitForExistence(timeout: 10) else {
                        return XCTFail("더보기 액션 버튼이 나타나지 않았습니다")
                    }
                    
                    moreActionsButton.tap()
                    
                    let moreActionSheet = app.sheets["무엇을 해볼까요?"]
                    let editItemButton = moreActionSheet.buttons["상품 수정"]
                    editItemButton.tap()

                    let passwordInputAlert = app.alerts["비밀번호를 입력해주세요."]

                    guard passwordInputAlert.waitForExistence(timeout: 2) else {
                        return XCTFail("비밀번호 입력창이 로드되지 않았습니다")
                    }

                    let okButton = passwordInputAlert.buttons["확인"]
                    let passwordInputTextField = passwordInputAlert.textFields["비밀번호"]
                    passwordInputTextField.tap()
                    passwordInputTextField.typeText("Ryan")
                    okButton.tap()

                    titleTextView.tap()
                    titleTextView.typeText("Updated: ")
                    app.navigationBars["Edit"].buttons["Done"].tap()

                    moreActionsButton.tap()

                    let deleteItemButton = moreActionSheet.buttons["상품 삭제"]
                    deleteItemButton.tap()

                    let deletePasswordInputAlert = app.alerts["삭제를 위해 비밀번호를 입력해주세요."]
                    guard deletePasswordInputAlert.waitForExistence(timeout: 2) else {
                        return XCTFail("비밀번호 입력창이 로드되지 않았습니다")
                    }

                    let deletePasswordInputTextField = deletePasswordInputAlert.textFields["비밀번호"]
                    deletePasswordInputTextField.tap()
                    deletePasswordInputTextField.typeText("Ryan")

                    let deleteOKButton = deletePasswordInputAlert.buttons["삭제"]
                    deleteOKButton.tap()

                    let didDeleteAlert = app.alerts["삭제되었습니다."]
                    let confirmButton = didDeleteAlert.buttons["확인"]
                    confirmButton.tap()
                }
            }
        }
    }
}
