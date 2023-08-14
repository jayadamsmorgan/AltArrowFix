//
//  SourceEditorCommand.swift
//  AltArrowExtension
//
//  Created by user on 8/13/23.
//

import Foundation
import XcodeKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    
    private let specialCharacters = "`~!@#$%^&*()_+{}[]:;\"'<>?,./'|\\-= \n"
    
    private static var previousTextRangeValue = XCSourceTextRange()
    
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
                while position.column + caret != 0 {
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
    
    func moveCursorOneWordLeft(invocation: XCSourceEditorCommandInvocation) {
        
        let textRange = invocation.buffer.selections.firstObject as! XCSourceTextRange
        
        let caret = caretLeft(textRange: textRange, lines: invocation.buffer.lines)
        
        invocation.buffer.selections.removeAllObjects()
        textRange.start.column = textRange.start.column + caret
        textRange.end.column = textRange.start.column
        invocation.buffer.selections.add(textRange)
    }
    
    func moveCursorOneWordRight(invocation: XCSourceEditorCommandInvocation) {
        let textRange = invocation.buffer.selections.firstObject as! XCSourceTextRange
        
        let caret = caretRight(textRange: textRange, lines: invocation.buffer.lines)
        
        invocation.buffer.selections.removeAllObjects()
        textRange.start.column = textRange.start.column + caret
        textRange.end.column = textRange.start.column
        invocation.buffer.selections.add(textRange)
    }
    
    func moveSelectionOneWordLeft(invocation: XCSourceEditorCommandInvocation) {
        
        let textRange = invocation.buffer.selections.firstObject as! XCSourceTextRange
        
        if (textRange.start.column == SourceEditorCommand.previousTextRangeValue.end.column &&
            textRange.end.column == SourceEditorCommand.previousTextRangeValue.start.column) {
            textRange.end.column = textRange.start.column
            textRange.start.column = SourceEditorCommand.previousTextRangeValue.start.column
        }
        
        let caret = caretLeft(textRange: textRange, lines: invocation.buffer.lines)
        
        invocation.buffer.selections.removeAllObjects()
        textRange.end.column = textRange.end.column + caret
        invocation.buffer.selections.add(textRange)
        
        SourceEditorCommand.previousTextRangeValue = textRange
        
    }
    
    func moveSelectionOneWordRight(invocation: XCSourceEditorCommandInvocation) {
        
        let textRange = invocation.buffer.selections.firstObject as! XCSourceTextRange
        
        if (textRange.start.column == SourceEditorCommand.previousTextRangeValue.end.column &&
            textRange.end.column == SourceEditorCommand.previousTextRangeValue.start.column) {
            textRange.end.column = textRange.start.column
            textRange.start.column = SourceEditorCommand.previousTextRangeValue.start.column
        }
        
        let caret = caretRight(textRange: textRange, lines: invocation.buffer.lines)
        
        invocation.buffer.selections.removeAllObjects()
        textRange.end.column = textRange.end.column + caret
        invocation.buffer.selections.add(textRange)
        
        SourceEditorCommand.previousTextRangeValue = textRange
        
    }
    
}
