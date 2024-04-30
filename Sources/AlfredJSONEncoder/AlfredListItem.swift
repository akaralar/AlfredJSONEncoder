// Created by Ahmet Karalar for  in 2024
// Using Swift 5.0


import Foundation

public struct AlfredList: Equatable, Hashable, Encodable {
    public var items: [AlfredListItem]

    public init(items: [AlfredListItem]) {
        self.items = items
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
}

public struct AlfredListItem: Equatable, Hashable, Encodable {
    public var uid: String?
    public var title: String
    public var subtitle: String?
    public var arguments: OutputArguments
    public var icon: Icon?
    public var isValid: Bool?
    public var match: String?
    public var autocomplete: String?
    public var type: ItemType?
    public var modifierActions: [HeldModifiers: ModifierAction]?
    public var action: Action?
    public var text: Text?
    public var quicklookURL: URL?
    public var skipKnowledge: Bool?

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
        case skipKnowledge = "skipknowledge"
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.uid, forKey: .uid)
        try container.encode(self.title, forKey: .title)
        try container.encodeIfPresent(self.subtitle, forKey: .subtitle)
        try container.encode(self.arguments, forKey: .arguments)
        try container.encodeIfPresent(self.icon, forKey: .icon)
        try container.encodeIfPresent(self.isValid, forKey: .isValid)
        try container.encodeIfPresent(self.match, forKey: .match)
        try container.encodeIfPresent(self.autocomplete, forKey: .autocomplete)
        try container.encodeIfPresent(self.type, forKey: .type)
        try container.encodeIfPresent(self.modifierActions, forKey: .modifierActions)
        try container.encodeIfPresent(self.action, forKey: .action)
        try container.encodeIfPresent(self.text, forKey: .text)
        try container.encodeIfPresent(self.quicklookURL, forKey: .quicklookURL)
        try container.encodeIfPresent(self.skipKnowledge, forKey: .skipKnowledge)
    }

    public init(
        uid: String? = nil,
        title: String,
        subtitle: String? = nil,
        arguments: OutputArguments,
        icon: Icon? = nil,
        isValid: Bool? = nil,
        match: String? = nil,
        autocomplete: String? = nil,
        type: ItemType? = nil,
        modifierActions: [HeldModifiers : ModifierAction]? = nil,
        action: Action? = nil,
        text: Text? = nil,
        quicklookURL: URL? = nil,
        skipKnowledge: Bool? = nil
    ) {
        self.uid = uid
        self.title = title
        self.subtitle = subtitle
        self.arguments = arguments
        self.icon = icon
        self.isValid = isValid
        self.match = match
        self.autocomplete = autocomplete
        self.type = type
        self.modifierActions = modifierActions
        self.action = action
        self.text = text
        self.quicklookURL = quicklookURL
        self.skipKnowledge = skipKnowledge
    }

    public static let dummy = AlfredListItem(
        uid: "some uid",
        title: "Some title",
        subtitle: "Some subtitle",
        arguments: .single("One Argument"),
        icon: Icon(path: "com.akaralar.somefileuti", type: .fileType),
        isValid: true,
        match: "some match",
        autocomplete: "some autocomplete strng",
        type: .skipCheck,
        modifierActions: [:],
        action: .single("some action"),
        text: Text(copy: "some copy", largeType: "some largetype"),
        quicklookURL: nil,
        skipKnowledge: true
    )
}

public enum OutputArguments: Equatable, Hashable, Encodable {
    case single(String)
    case multiple([String])

    public func encode(to encoder: any Encoder) throws {
        switch self {
        case .single(let argument):
            var container = encoder.singleValueContainer()
            try container.encode(argument)
        case .multiple(let arguments):
            var container = encoder.unkeyedContainer()
            try container.encode(arguments)
        }
    }
}

public struct Icon: Equatable, Hashable, Encodable {
    public var path: String
    public var type: IconType?

    public init(path: String, type: IconType? = nil) {
        self.path = path
        self.type = type
    }
}

public enum IconType: String, Equatable, Hashable, Encodable {
    case fileIcon = "fileicon"
    case fileType = "filetype"
}

public enum ItemType: String, Equatable, Hashable, Encodable {
    case `default` = "default"
    case file
    case skipCheck = "file:skipcheck"
}

public enum Modifier: String, Equatable, Hashable, Encodable {
    case command = "cmd"
    case shift
    case option = "alt"
    case control = "ctrl"
    case function = "fn"
}

public struct HeldModifiers: Equatable, Hashable, Encodable {
    var mods: Set<Modifier>

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(Array(mods).map(\.rawValue).joined(separator: "+"))
    }
}

public struct ModifierAction: Equatable, Hashable, Encodable {
    var isValid: Bool
    var outputArgument: OutputArguments
    var subtitle: String

    enum CodingKeys: String, CodingKey {
        case isValid = "valid"
        case outputArgument = "arg"
        case subtitle
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.isValid, forKey: .isValid)
        try container.encode(self.outputArgument, forKey: .outputArgument)
        try container.encode(self.subtitle, forKey: .subtitle)
    }
}

public enum UniversalAction: Equatable, Hashable, Encodable {
    case singleText(String)
    case multipleText([String])
    case url(URL)
    case file(URL)
    case auto(String)

    enum CodingKeys: String, CodingKey {
        case text
        case url
        case file
        case auto
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .singleText(let string):
            try container.encode(string, forKey: .text)
        case .multipleText(let array):
            try container.encode(array, forKey: .text)
        case .url(let url):
            try container.encode(url, forKey: .url)
        case .file(let file):
            try container.encode(file, forKey: .file)
        case .auto(let string):
            try container.encode(string, forKey: .auto)
        }
    }
}

public enum Action: Equatable, Hashable, Encodable {
    case single(String)
    case multiple([String])
    case universalAction(UniversalAction)

    public func encode(to encoder: any Encoder) throws {
        switch self {
        case .single(let string):
            var container = encoder.singleValueContainer()
            try container.encode(string)
        case .multiple(let strings):
            var container = encoder.unkeyedContainer()
            try container.encode(strings)
        case .universalAction(let action):
            try action.encode(to: encoder)
        }
    }
}

public struct Text: Equatable, Hashable, Encodable {
    public var copy: String
    public var largeType: String

    enum CodingKeys: String, CodingKey {
        case copy
        case largeType = "largetype"
    }

    public init(copy: String, largeType: String) {
        self.copy = copy
        self.largeType = largeType
    }
}
