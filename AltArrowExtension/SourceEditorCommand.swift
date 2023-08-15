//
//  SourceEditorCommand.swift
//  AltArrowExtension
//
//  Created by user on 8/13/23.
//

import Foundation
import XcodeKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    
    fileprivate let specialCharacters = "`~!@#$%^&*()_+{}[]:;\"'<>?,./'|\\-= \n"
    
    fileprivate static var previousTextRangeValue = XCSourceTextRange()
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        
        switch invocation.commandIdentifier {
            
        case CommandIdentifier.moveCursorWL.rawValue:
            moveCursorOneWordLeft(invocation: invocation)
            
        case CommandIdentifier.moveCursorWR.rawValue:
            moveCursorOneWordRight(invocation: invocation)
            
        case CommandIdentifier.moveSelectionWL.rawValue:
            moveSelectionOneWordLeft(invocation: invocation)
            
        case CommandIdentifier.moveSelectionWR.rawValue:
            moveSelectionOneWordRight(invocation: invocation)
            
        case CommandIdentifier.moveSelectionWD.rawValue:
            moveSelectionOneLineDown(invocation: invocation)
            
        case CommandIdentifier.moveSelectionWD2.rawValue:
            moveSelectionOneLineDown(invocation: invocation)
            
        case CommandIdentifier.moveSelectionWU.rawValue:
            moveSelectionOneLineUp(invocation: invocation)
            
        case CommandIdentifier.moveSelectionWU2.rawValue:
            moveSelectionOneLineUp(invocation: invocation)
            
        case CommandIdentifier.moveSelectionWEnd.rawValue:
            moveSelectionToTheEnd(invocation: invocation)
            
        case CommandIdentifier.moveSelectionWStart.rawValue:
            moveSelectionToTheStart(invocation: invocation)
            
        case CommandIdentifier.moveSelectionL.rawValue:
            moveSelectionOneCharLeft(invocation: invocation)
            
        case CommandIdentifier.moveSelectionR.rawValue:
            moveSelectionOneCharRight(invocation: invocation)
            
        default:
            print("Unavailable command")
            
        }
        
        completionHandler(nil)
    }
    
    fileprivate func caretLeft(textRange: XCSourceTextRange, lines: NSMutableArray) -> Int {
        
        let position = textRange.end
        
        let currentLine = lines.object(at: position.line) as! String
        let currentLineCharacters = currentLine.split(separator: "")
        
        var caret = 0
        while true {
            if position.column + caret <= 0 {
                break
            }
            let leftCharactersToTheLeft = currentLineCharacters[0..<(position.column + caret + 1)]
            if leftCharactersToTheLeft.dropFirst().allSatisfy({ $0 == " " }) && caret >= -1 {
                while position.column + caret != -1 {
                    caret -= 1
                }
                break
            }
            if specialCharacters.contains(currentLineCharacters[position.column + caret]) && caret != 0 {
                break
            }
            caret -= 1
        }
        
        if caret == 0 {
            return 0
        }
        
        if caret < -1 {
            caret += 1
        }
        
        return caret
    }
    
    fileprivate func caretRight(textRange: XCSourceTextRange, lines: NSMutableArray) -> Int {
        
        let position = textRange.end
        
        let currentLine = lines.object(at: position.line) as! String
        let currentLineCharacters = currentLine.split(separator: "")
        
        if currentLineCharacters.count == position.column + 1 {
            return 0
        }
        
        var caret = 0
        
        while true {
            if specialCharacters.contains(currentLineCharacters[position.column + caret]) {
                if (caret == 0) {
                    while currentLineCharacters[position.column + caret] == " " {
                        caret += 1
                    }
                }
                break
            }
            caret += 1
        }
        
        if caret == 0 {
            caret = 1
        }
        
        return caret
    }
    
    fileprivate func moveCursorOneWordLeft(invocation: XCSourceEditorCommandInvocation) {
        
        let textRange = invocation.buffer.selections.firstObject as! XCSourceTextRange
        
        let caret = caretLeft(textRange: textRange, lines: invocation.buffer.lines)
        
        invocation.buffer.selections.removeAllObjects()
        textRange.end.column = textRange.end.column + caret
        textRange.start.column = textRange.end.column
        textRange.start.line = textRange.end.line
        invocation.buffer.selections.add(textRange)
    }
    
    fileprivate func moveCursorOneWordRight(invocation: XCSourceEditorCommandInvocation) {
        let textRange = invocation.buffer.selections.firstObject as! XCSourceTextRange
        
        let caret = caretRight(textRange: textRange, lines: invocation.buffer.lines)
        
        invocation.buffer.selections.removeAllObjects()
        textRange.end.column = textRange.end.column + caret
        textRange.start.column = textRange.end.column
        textRange.start.line = textRange.end.line
        invocation.buffer.selections.add(textRange)
    }
    
    fileprivate func moveSelectionOneLineUp(invocation: XCSourceEditorCommandInvocation) {
        let textRange = invocation.buffer.selections.firstObject as! XCSourceTextRange
        
        if (textRange.start.column == SourceEditorCommand.previousTextRangeValue.end.column &&
            textRange.end.line == SourceEditorCommand.previousTextRangeValue.start.line) {
            
            textRange.end.column = textRange.start.column
            textRange.start.column = SourceEditorCommand.previousTextRangeValue.start.column
            textRange.end.line = textRange.start.line
            textRange.start.line = SourceEditorCommand.previousTextRangeValue.start.line
        }
        
        textRange.end.line -= 1
        
        if textRange.end.line == -1 {
            return
        }
        
        let newLine = invocation.buffer.lines.object(at: textRange.end.line) as! String
        let newLineCharacters = newLine.split(separator: "")
        
        if newLineCharacters.count - 1 < textRange.end.column {
            textRange.end.column = newLineCharacters.count - 1
        }
        
        invocation.buffer.selections.removeAllObjects()
        invocation.buffer.selections.add(textRange)
        
        SourceEditorCommand.previousTextRangeValue = textRange
    }
    
    fileprivate func moveSelectionOneLineDown(invocation: XCSourceEditorCommandInvocation) {
        let textRange = invocation.buffer.selections.firstObject as! XCSourceTextRange
        
        if (textRange.start.column == SourceEditorCommand.previousTextRangeValue.end.column &&
            textRange.end.line == SourceEditorCommand.previousTextRangeValue.start.line) {
            
            textRange.end.column = textRange.start.column
            textRange.start.column = SourceEditorCommand.previousTextRangeValue.start.column
            textRange.end.line = textRange.start.line
            textRange.start.line = SourceEditorCommand.previousTextRangeValue.start.line
            
        }
        
        textRange.end.line += 1
        
        if textRange.end.line > invocation.buffer.lines.count {
            return
        }
        
        let newLine = invocation.buffer.lines.object(at: textRange.end.line) as! String
        let newLineCharacters = newLine.split(separator: "")
        
        if newLineCharacters.count - 1 < textRange.end.column {
            textRange.end.column = newLineCharacters.count - 1
        }
        
        invocation.buffer.selections.removeAllObjects()
        invocation.buffer.selections.add(textRange)
        
        SourceEditorCommand.previousTextRangeValue = textRange
    }
    
    fileprivate func moveSelectionToTheStart(invocation: XCSourceEditorCommandInvocation) {
        let textRange = invocation.buffer.selections.firstObject as! XCSourceTextRange
        
        if (textRange.start.column == SourceEditorCommand.previousTextRangeValue.end.column &&
            textRange.end.column == SourceEditorCommand.previousTextRangeValue.start.column &&
            textRange.start.line == SourceEditorCommand.previousTextRangeValue.end.line &&
            textRange.end.line == SourceEditorCommand.previousTextRangeValue.start.line) {
            textRange.end.column = textRange.start.column
            textRange.start.column = SourceEditorCommand.previousTextRangeValue.start.column
            textRange.end.line = textRange.start.line
            textRange.start.line = SourceEditorCommand.previousTextRangeValue.start.line
        }
        
        var caret = 0
        let currentLine = invocation.buffer.lines.object(at: textRange.end.line) as! String
        let currentLineCharacters = currentLine.split(separator: "")
        
        while true {
            let leftCharactersToTheLeft = currentLineCharacters[0..<(textRange.end.column + caret + 1)]
            if leftCharactersToTheLeft.dropFirst().allSatisfy( { $0 == " " } ) {
                if caret != -1 && caret != 0 {
                    caret += 1
                    break
                }
                textRange.end.column = 0
                invocation.buffer.selections.removeAllObjects()
                invocation.buffer.selections.add(textRange)
                SourceEditorCommand.previousTextRangeValue = textRange
                return
            }
            caret -= 1
        }
        
        textRange.end.column = textRange.end.column + caret
        invocation.buffer.selections.removeAllObjects()
        invocation.buffer.selections.add(textRange)
        SourceEditorCommand.previousTextRangeValue = textRange
    }
    
    fileprivate func moveSelectionToTheEnd(invocation: XCSourceEditorCommandInvocation) {
        let textRange = invocation.buffer.selections.firstObject as! XCSourceTextRange
        
        if (textRange.start.column == SourceEditorCommand.previousTextRangeValue.end.column &&
            textRange.end.column == SourceEditorCommand.previousTextRangeValue.start.column &&
            textRange.start.line == SourceEditorCommand.previousTextRangeValue.end.line &&
            textRange.end.line == SourceEditorCommand.previousTextRangeValue.start.line) {
            textRange.end.column = textRange.start.column
            textRange.start.column = SourceEditorCommand.previousTextRangeValue.start.column
            textRange.end.line = textRange.start.line
            textRange.start.line = SourceEditorCommand.previousTextRangeValue.start.line
        }
        
        let currentLine = invocation.buffer.lines.object(at: textRange.end.line) as! String
        let currentLineCharacters = currentLine.split(separator: "")
        
        textRange.end.column = currentLineCharacters.count - 1
        invocation.buffer.selections.removeAllObjects()
        invocation.buffer.selections.add(textRange)
        SourceEditorCommand.previousTextRangeValue = textRange
    }
    
    fileprivate func moveSelectionOneWordLeft(invocation: XCSourceEditorCommandInvocation) {
        
        let textRange = invocation.buffer.selections.firstObject as! XCSourceTextRange
        
        if (textRange.start.column == SourceEditorCommand.previousTextRangeValue.end.column &&
            textRange.end.column == SourceEditorCommand.previousTextRangeValue.start.column &&
            textRange.start.line == SourceEditorCommand.previousTextRangeValue.end.line &&
            textRange.end.line == SourceEditorCommand.previousTextRangeValue.start.line) {
            textRange.end.column = textRange.start.column
            textRange.start.column = SourceEditorCommand.previousTextRangeValue.start.column
            textRange.end.line = textRange.start.line
            textRange.start.line = SourceEditorCommand.previousTextRangeValue.start.line
        }
        
        let caret = caretLeft(textRange: textRange, lines: invocation.buffer.lines)
        
        invocation.buffer.selections.removeAllObjects()
        textRange.end.column = textRange.end.column + caret
        invocation.buffer.selections.add(textRange)
        
        SourceEditorCommand.previousTextRangeValue = textRange
        
    }
    
    fileprivate func moveSelectionOneWordRight(invocation: XCSourceEditorCommandInvocation) {
        
        let textRange = invocation.buffer.selections.firstObject as! XCSourceTextRange
        
        if (textRange.start.column == SourceEditorCommand.previousTextRangeValue.end.column &&
            textRange.end.column == SourceEditorCommand.previousTextRangeValue.start.column &&
            textRange.start.line == SourceEditorCommand.previousTextRangeValue.end.line &&
            textRange.end.line == SourceEditorCommand.previousTextRangeValue.start.line) {
            textRange.end.column = textRange.start.column
            textRange.start.column = SourceEditorCommand.previousTextRangeValue.start.column
            textRange.end.line = textRange.start.line
            textRange.start.line = SourceEditorCommand.previousTextRangeValue.start.line
        }
        
        let caret = caretRight(textRange: textRange, lines: invocation.buffer.lines)
        
        invocation.buffer.selections.removeAllObjects()
        textRange.end.column = textRange.end.column + caret
        invocation.buffer.selections.add(textRange)
        
        SourceEditorCommand.previousTextRangeValue = textRange
        
    }
    
    fileprivate func moveSelectionOneCharLeft(invocation: XCSourceEditorCommandInvocation) {
        let textRange = invocation.buffer.selections.firstObject as! XCSourceTextRange
        
        if (textRange.start.column == SourceEditorCommand.previousTextRangeValue.end.column &&
            textRange.end.column == SourceEditorCommand.previousTextRangeValue.start.column &&
            textRange.start.line == SourceEditorCommand.previousTextRangeValue.end.line &&
            textRange.end.line == SourceEditorCommand.previousTextRangeValue.start.line) {
            textRange.end.column = textRange.start.column
            textRange.start.column = SourceEditorCommand.previousTextRangeValue.start.column
            textRange.end.line = textRange.start.line
            textRange.start.line = SourceEditorCommand.previousTextRangeValue.start.line
        }
        
        if textRange.end.column != 0 {
            textRange.end.column -= 1
        }
        
        invocation.buffer.selections.removeAllObjects()
        invocation.buffer.selections.add(textRange)
        SourceEditorCommand.previousTextRangeValue = textRange
    }
    
    fileprivate func moveSelectionOneCharRight(invocation: XCSourceEditorCommandInvocation) {
        let textRange = invocation.buffer.selections.firstObject as! XCSourceTextRange
        
        if (textRange.start.column == SourceEditorCommand.previousTextRangeValue.end.column &&
            textRange.end.column == SourceEditorCommand.previousTextRangeValue.start.column &&
            textRange.start.line == SourceEditorCommand.previousTextRangeValue.end.line &&
            textRange.end.line == SourceEditorCommand.previousTextRangeValue.start.line) {
            textRange.end.column = textRange.start.column
            textRange.start.column = SourceEditorCommand.previousTextRangeValue.start.column
            textRange.end.line = textRange.start.line
            textRange.start.line = SourceEditorCommand.previousTextRangeValue.start.line
        }
        
        let line = invocation.buffer.lines.object(at: textRange.end.line) as! String
        let lineCharacters = line.split(separator: "")
        
        if textRange.end.column < lineCharacters.count - 1 {
            textRange.end.column += 1
        }
        
        invocation.buffer.selections.removeAllObjects()
        invocation.buffer.selections.add(textRange)
        SourceEditorCommand.previousTextRangeValue = textRange
    }
    
}
