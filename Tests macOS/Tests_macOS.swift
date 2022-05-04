//
//  Tests_macOS.swift
//  Tests macOS
//
//  Created by Shayarneel Kundu on 4/29/22.
//

import XCTest
import ManhattanProjectReed

class Tests_macOS: XCTestCase {

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
        app.launch()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    

    
//    func testf()  throws {
//        let twoSphereFission = TwoSphereFission()
//        var f = twoSphereFission.massRatio(m1: 141, m2: 92)
//        var answer = 1.53
//            XCTAssertEqual(f, answer, accuracy: 1.0E-2, "Was not equal to this resolution.")
//
//        f = twoSphereFission.massRatio(m1: 92, m2: 141)
//        answer = 1.53
//        XCTAssertEqual(f, answer, accuracy: 1.0E-2, "Was not equal to this resolution.")
//
//        f = twoSphereFission.massRatio(m1: 141, m2: 141)
//        answer = 1.00
//        XCTAssertEqual(f, answer, accuracy: 1.0E-2, "Was not equal to this resolution.")
//
//        }
//
    func testd()  throws {
        let untamped = Untamped()
        var d = untamped.d(lfisscore: 16.89, ltranscore: 3.596, nu: 2.637)
        var danswer = 3.517
        XCTAssertEqual(d, danswer, accuracy: 1.0E-3, "Was not equal to this resolution.")
        
        d = untamped.d(lfisscore: 14.14, ltranscore: 4.108, nu: 3.172)
        danswer = 2.985
        XCTAssertEqual(d, danswer, accuracy: 1.0E-3, "Was not equal to this resolution.")
        }
    
    func testEta()  throws {
        let untamped = Untamped()
        var eta = untamped.eta(lfisscore: 16.89, ltranscore: 3.596, nu: 2.637)
        var etaanswer = 0.6817
        XCTAssertEqual(eta, etaanswer, accuracy: 1.0E-3, "Was not equal to this resolution.")
        eta = untamped.eta(lfisscore: 14.14, ltranscore: 4.108, nu: 3.172)
        etaanswer = 0.9174
        XCTAssertEqual(eta, etaanswer, accuracy: 1.0E-3, "Was not equal to this resolution.")
        }
    
    
    func testURC()  throws {
        let untamped = Untamped()
        var urc = untamped.untampedRCritical(untampedRC: 8.366, lfisscore: 16.89, ltranscore: 3.596, nu: 2.637)
        var urcanswer = 0.0
        XCTAssertEqual(urc, urcanswer, accuracy: 1.0E-3, "Was not equal to this resolution.")
    
        urc = untamped.untampedRCritical(untampedRC: 6.345, lfisscore: 14.14, ltranscore: 4.108, nu: 3.172)
        urcanswer = 0.0
        XCTAssertEqual(urc, urcanswer, accuracy: 1.0E-2, "Was not equal to this resolution.")
        }
    
    func testBisection()  throws {
        let zeroFinder = FindingZero()
        var zero = zeroFinder.bisection(lb: -1.0, ub: 1.3)
        var ans = 0.0
        XCTAssertEqual(zero, ans, accuracy: 1.0E-12, "Was not equal to this resolution.")
        }
    
    func testTRC()  throws {
        let tamped = Tamped()
        var trc = tamped.tampedRCritical(rCore: 3.517, rTamp: 10.551, ltranstamp: 0.878, ltranscore: 3.596, lfisscore: 16.89, sfisscore: 1.235, stranscore: (1.235+4.566), nu: 2.637)
        var trcanswer = 0.0
        XCTAssertEqual(trc, trcanswer, accuracy: 1.0E-2, "Was not equal to this resolution.")
        }
    
    func testZeroURC()  throws {
        let untamped = Untamped()
        var urcZero = untamped.urcFinder(lfisscore: 14.14, ltranscore: 4.108, nu: 3.172)
        var urcZeroAns = 0.000
        XCTAssertEqual(urcZero, urcZeroAns, accuracy: 1.0E-2, "Was not equal to this resolution.")
        }
    
    
    func testv()  throws {
        let efficiency = Efficiency()
        var v = efficiency.avgV()
        var vans = 3635408.36439
        XCTAssertEqual(v,vans, accuracy: 1.0E-2, "Was not equal to this resolution.")
        }
    
//    func testAl()  throws {
//        let efficiency = Efficiency()
//        var al = efficiency.alpha(rCritical: 8.366, rCore: 120.0, dCore: 19.1, nu: 2.637)/2.0
//        var alans = 0.246
//        XCTAssertEqual(al,alans, accuracy: 1.0E-2, "Was not equal to this resolution.")
//        }
    
    
    
    func testEff()  throws {
        let efficiency = Efficiency()
        var eff = efficiency.eff(atomicMass: 238.02891, lfisscore: 16.89, rCritical: 8.366, rCore: 8.366, dCore: 18.71, nu: 2.637)
        var effans = 0.0
        XCTAssertEqual(eff,effans, accuracy: 1.0E-2, "Was not equal to this resolution.")
            }
    
    func testmaxdr()  throws {
        let efficiency = Efficiency()
        var maxdr = efficiency.maxrCoreFinder(atomicMass: 238.02891, lfisscore: 16.89, ltranscore: <#T##Double#>, rCore: <#T##Double#>, dCore: <#T##Double#>, nu: <#T##Double#>)
        eff(atomicMass: , lfisscore: , rCritical: 8.366, rCore: 8.366, dCore: 18.71, nu: 2.637)
        var maxdrans = 20.0
        XCTAssertEqual(maxdr,maxdrans, accuracy: 1.0E-2, "Was not equal to this resolution.")
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
