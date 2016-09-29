//
//  SACCoreTests.swift
//  SACCoreTests
//
//  Created by Emiaostein on 28/09/2016.
//  Copyright © 2016 botai. All rights reserved.
//

import XCTest
@testable import SACCore

class SACCoreTests: XCTestCase {
    
    var parser: XMLParser!
    var e: XCTestExpectation!
    var node: Node!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        e = expectation(description: "pareser")
        
        
        
        let path = Bundle(for: type(of: self)).path(forResource: "demo", ofType: "xml")!
        let url = URL(fileURLWithPath: path)
        parser = XMLParser(contentsOf: url)
        parser.delegate = self
        parser.parse()
        
        waitForExpectations(timeout: 100) { (error) in
        }
        
        
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

extension SACCoreTests: XMLParserDelegate {
    
    func parserDidStartDocument(_ parser: XMLParser) {
        print("Start!")
        
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        print(node.dic())
        e.fulfill()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        let typevalue = attributeDict["type"]
        let type: ParsingType? = typevalue != nil ? ParsingType(rawValue: typevalue!) : .dictionary
        node = Node(key: elementName, type: type != nil ? type! : .dictionary)
        node.parent = self
        parser.delegate = node
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        node.value = string
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        parser.delegate = self
    }
}
