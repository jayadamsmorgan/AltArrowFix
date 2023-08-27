//
//  SourceEditorExtension.swift
//  AltArrowExtension
//
//  Created by user on 8/13/23.
//

import Foundation
import XcodeKit

enum CommandIdentifier: String {
    
    case moveCursorWR = "moveCursorWR"
    case moveCursorWL = "moveCursorWL"
    case moveSelectionWR = "moveSelectionWR"
    case moveSelectionWL = "moveSelectionWL"
    case moveSelectionWU = "moveSelectionWU"
    case moveSelectionWU2 = "moveSelectionWU2"
    case moveSelectionWD = "moveSelectionWD"
    case moveSelectionWD2 = "moveSelectionWD2"
    case moveSelectionWEnd = "moveSelectionWEnd"
    case moveSelectionWStart = "moveSelectionWDStart"
    case moveSelectionL = "moveSelectionL"
    case moveSelectionR = "moveSelectionR"
    
}

enum CommandName: String {
    
    case moveCursorWR = "Move Cursor One Word Right"
    case moveCursorWL = "Move Cursor One Word Left"
    case moveSelectionWR = "Move Selection One Word Right"
    case moveSelectionWL = "Move Selection One Word Left"
    case moveSelectionWU = "Move Selection One Word Up"
    case moveSelectionWU2 = "Move Selection One Word Up 2"
    case moveSelectionWD = "Move Selection One Word Down"
    case moveSelectionWD2 = "Move Selection One Word Down 2"
    case moveSelectionWEnd = "Move Selection To The End of Line"
    case moveSelectionWStart = "Move Selection To The Start of Line"
    case moveSelectionL = "Move Selection One Character Left"
    case moveSelectionR = "Move Selection One Character Right"
    
}

struct Command {
    
    static let moduleName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? ""
    
    //File Name
    static let className =  moduleName + ".SourceEditorCommand"
    
    //Command Name and identifier
    static let moveCursorWL = (CommandName.moveCursorWL, CommandIdentifier.moveCursorWL)
    static let moveCursorWR = (CommandName.moveCursorWR, CommandIdentifier.moveCursorWR)
    static let moveSelectionWR = (CommandName.moveSelectionWR, CommandIdentifier.moveSelectionWR)
    static let moveSelectionWL = (CommandName.moveSelectionWL, CommandIdentifier.moveSelectionWL)
    static let moveSelectionWU = (CommandName.moveSelectionWU, CommandIdentifier.moveSelectionWU)
    static let moveSelectionWU2 = (CommandName.moveSelectionWU2, CommandIdentifier.moveSelectionWU2)
    static let moveSelectionWD = (CommandName.moveSelectionWD, CommandIdentifier.moveSelectionWD)
    static let moveSelectionWD2 = (CommandName.moveSelectionWD2, CommandIdentifier.moveSelectionWD2)
    static let moveSelectionWEnd = (CommandName.moveSelectionWEnd, CommandIdentifier.moveSelectionWEnd)
    static let moveSelectionWStart = (CommandName.moveSelectionWStart, CommandIdentifier.moveSelectionWStart)
    static let moveSelectionL = (CommandName.moveSelectionL, CommandIdentifier.moveSelectionL)
    static let moveSelectionR = (CommandName.moveSelectionR, CommandIdentifier.moveSelectionR)
    
    private static func all() -> [(CommandName, CommandIdentifier)] {
        return [
            moveCursorWL,
            moveCursorWR,
            moveSelectionWR,
            moveSelectionWL,
            moveSelectionWU,
            moveSelectionWU2,
            moveSelectionWD,
            moveSelectionWD2,
            moveSelectionWEnd,
            moveSelectionWStart,
            moveSelectionL,
            moveSelectionR
        ]
    }
    
    static func allCommands() -> [[XCSourceEditorCommandDefinitionKey: Any]] {
        return all().map {
            
            [XCSourceEditorCommandDefinitionKey.classNameKey: className,
             XCSourceEditorCommandDefinitionKey.identifierKey: $0.1.rawValue,
             XCSourceEditorCommandDefinitionKey.nameKey: $0.0.rawValue
            ]
        }
    }
    
}

class SourceEditorExtension: NSObject, XCSourceEditorExtension {
    
    /*
    func extensionDidFinishLaunching() {
        // If your extension needs to do any work at launch, implement this optional method.
    }
    */
    
    
    var commandDefinitions: [[XCSourceEditorCommandDefinitionKey: Any]] {
        // If your extension needs to return a collection of command definitions that differs from those in its Info.plist, implement this optional property getter.
        return Command.allCommands()
    }
    
    
}
