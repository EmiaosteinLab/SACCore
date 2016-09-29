//
//  Parsing.swift
//  SACCore
//
//  Created by Emiaostein on 28/09/2016.
//  Copyright © 2016 botai. All rights reserved.
//

import Foundation

public enum ParsingType: String {
    case array, dictionary
}

protocol Parsing: NSObjectProtocol {

}
protocol XMLParsing: Parsing, XMLParserDelegate {
    var key: String {get}
    var value: String {get set}
    var type: ParsingType {get}
    var children: [XMLParsing] {get}
    var parent: XMLParserDelegate? {get}
    
    init(key: String, type: ParsingType)
    func addParsing(withKey key: String, attributes: [String: String], parser: XMLParser)
    func dic() -> [String: AnyObject]
}

extension XMLParsing {

    
    func dic() -> [String: AnyObject] {
        
        switch type {
        case .array:
            var d = [AnyObject]()
            for c in children {
                let a = c.dic()
                d.append(a as AnyObject)
            }
            return [key: d as AnyObject]
            
        default:
            if children.count > 0 {
            var d = [String: AnyObject]()
            for c in children {
                let a = c.dic()
                for (k, v) in a {
                    d[k] = v
                }
            }
            return [key: d as AnyObject]
            } else {
                return [key: value as AnyObject]
            }
        }
    }
}

class Node:NSObject, XMLParsing {
    let key: String
    let type: ParsingType
    var value: String = ""
    var children = [XMLParsing]()
    weak var parent: XMLParserDelegate?
    
    required init(key: String, type: ParsingType = .dictionary) {
        self.key = key
        self.type = type
    }
    
    func addParsing(withKey key: String, attributes: [String: String] = [:], parser: XMLParser) {
        let typevalue = attributes["type"]
        let type: ParsingType? = typevalue != nil ? ParsingType(rawValue: typevalue!) : .dictionary
        let node = Node(key: key, type: type != nil ? type! : .dictionary)
        node.parent = self
        children.append(node)
        parser.delegate = node
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        print("* \(elementName)")
        addParsing(withKey: elementName, attributes: attributeDict, parser: parser)
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        print("- \(string)")
        value = string
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        parser.delegate = parent
    }
}
