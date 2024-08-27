import XCTest

@testable import CallSMSBlock

final class PhoneNumberViewModeTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSaveBlockNumber() throws {
        let viewModel = PhoneNumberViewModel(appCoordinator: AppCoordinator())
    
        viewModel.save(name: "Teste single",
                       ddi: "55",
                       fromNumber: "16991426807",
                       toNumber: nil)
        XCTAssertNil(viewModel.messageError)
    }

    func testSaveRangeBlockNumber() throws {
        let viewModel = PhoneNumberViewModel(appCoordinator: AppCoordinator())

        viewModel.save(name: "Teste 2",
                       ddi: "55",
                       fromNumber: "1150364900",
                       toNumber: "1150364999")
        XCTAssertNil(viewModel.messageError)
    }
}
