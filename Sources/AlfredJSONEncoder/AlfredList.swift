// Created by Ahmet Karalar for  in 2024
// Using Swift 5.0


import Foundation

public struct AlfredList: Equatable, Hashable, Encodable {
    public var items: [AlfredListItem]

    public init(items: [any AlfredListItemConvertible]) {
        self.items = items.map(\.asAlfredListItem)
    }

    public func toJSON() throws -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        if #available(macOS 10.15, *) {
            encoder.outputFormatting.update(with: .withoutEscapingSlashes)
        } else {
            // TODO: Implement for macOS 10.15 and below, change string
            // string.replacingOccurrences(of: "\\/", with: "/")
        }
        let data = try encoder.encode(self)
        let string = String(data: data, encoding: .utf8)!
        return string
    }

    public static func errorJSON(with text: String) throws -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        if #available(macOS 10.15, *) {
            encoder.outputFormatting.update(with: .withoutEscapingSlashes)
        } else {
            // TODO: Implement for macOS 10.15 and below, change string
            // string.replacingOccurrences(of: "\\/", with: "/")
        }
        let data = try encoder.encode(text)
        let string = String(data: data, encoding: .utf8)!
        return string

    }
}
