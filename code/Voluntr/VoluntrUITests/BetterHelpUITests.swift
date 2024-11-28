

import XCTest

final class BetterHelpUITests: XCTestCase {

//    override func setUpWithError() throws {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//
//        // In UI tests it is usually best to stop immediately when a failure occurs.
//        continueAfterFailure = false
//
//        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
//    }
//
//    override func tearDownWithError() throws {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }

    func testJoinEvent() throws {
        let app = XCUIApplication()
        app.launch()
      
        let emailTextField = app.textFields["Email"]
        XCTAssertTrue(emailTextField.exists)
        emailTextField.tap()
        emailTextField.typeText("test@gmail.com")

        let passwordTextField = app.secureTextFields["Password"]
        XCTAssertTrue(passwordTextField.exists)
        passwordTextField.tap()
        passwordTextField.typeText("123123")

        app.buttons["Sign In"].tap()

        let tabBar = app.tabBars["Tab Bar"]
        let searchButton = tabBar.buttons["Search"]
        let profileButton = tabBar.buttons["Profile"]
        
        searchButton.tap()
        app.collectionViews.buttons["Beach Cleanup"].tap()
//         app.buttons["Join"].tap()


        tabBar.buttons["Profile"].tap()
        app.buttons["Log out"].tap()  
    }

//    func testLaunchPerformance() throws {
//        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
//            // This measures how long it takes to launch your application.
//            measure(metrics: [XCTApplicationLaunchMetric()]) {
//                XCUIApplication().launch()
//            }
//        }
//    }
}
