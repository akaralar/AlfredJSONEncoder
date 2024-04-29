// Created by Ahmet Karalar for  in 2024
// Using Swift 5.0


import Foundation

public struct AlfredListItem: Encodable {
    var uid: String?
    var title: String
    var subtitle: String?
    var arguments: Arguments
    var icon: Icon?
    var isValid: Bool
    var match: String?
    var autocomplete: String?
    var type: ItemType?
    var modifierActions: CustomModifierActions?
    var action: Action?
    var text: Text?
    var quicklookURL: String?

    enum CodingKeys: String, CodingKey {
        case uid
        case title
        case subtitle
        case arguments = "arg"
        case icon
        case isValid = "valid"
        case match
        case autocomplete
        case type
        case modifierActions = "mods"
        case action
        case text
        case quicklookURL = "quicklookurl"
    }
}

public enum Arguments: Encodable {
    case single(String)
    case multiple([String])
}

public enum IconType: Encodable {
    case fileIcon
    case fileType
}

public struct Icon: Encodable {
    var path: String
    var type: IconType
}

public enum ItemType: Encodable {
    case `default`
    case file
    case skipCheck
}

public struct Modifiers: OptionSet, Equatable, Hashable, Encodable {
    public let rawValue: Int

    static let command = Modifiers(rawValue: 1 << 0)
    static let shift = Modifiers(rawValue: 1 << 1)
    static let option = Modifiers(rawValue: 1 << 2)
    static let control = Modifiers(rawValue: 1 << 3)
    static let function = Modifiers(rawValue: 1 << 4)

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct ModifierAction: Encodable {
    var isValid: Bool
    var arg: String
    var subtitle: String
}

public struct CustomModifierActions: Encodable {
    var mods: [Modifiers: ModifierAction]
}

public enum UniversalAction: Encodable {
    case text([String])
    case url(URL)
    case file(URL)
    case auto(String)
}

public enum Action: Encodable {
    case single(String)
    case multiple([String])
    case universal(UniversalAction)
}

public struct Text: Encodable {
    var copy: String
    var largeType: String

    enum CodingKeys: String, CodingKey {
        case copy
        case largeType = "largetype"
    }
}
