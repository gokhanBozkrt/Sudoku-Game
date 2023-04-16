//
//  CellView.swift
//  TapSudoku
//
//  Created by Gökhan Bozkurt on 12.04.2023.
//

import SwiftUI

struct CellView: View {
    enum HighlightState {
        case standart,highlighted,selected
        
        var color: Color {
            switch self {
            case .standart:
                return .squareStandart
            case .highlighted:
                return .squareHighlighted
            case .selected:
                return .squareSelected
            }
        }
    }
    let number: Int
    let selectedNumber: Int
    let highlightState: HighlightState
    let isCorrect: Bool
    var onSelected: () -> Void
    
    var displayNumber: String {
        if number == 0 {
            return ""
        } else {
            return String(number)
        }
    }
    
    var foregroundColor: Color {
        if isCorrect {
            if number == selectedNumber {
                return .squareTextSame
            } else {
                return .squareTextCorrect
            }
        } else {
            return .squareTextWrong
        }
    }
    
    
    var body: some View {
        Button(action: onSelected) {
            Text(displayNumber)
                .font(.title)
                .foregroundColor(foregroundColor)
                .frame(maxWidth: 100, maxHeight: 100)
                .aspectRatio(1, contentMode: .fit)
                .background(highlightState.color)
        }
        .buttonStyle(.plain)
    }
}

struct CellView_Previews: PreviewProvider {
    static var previews: some View {
        CellView(number: 1, selectedNumber: 2, highlightState: .standart, isCorrect: true, onSelected: { } )
    }
}
