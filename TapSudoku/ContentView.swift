//
//  ContentView.swift
//  TapSudoku
//
//  Created by Gökhan Bozkurt on 12.04.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var board = Board(difficulty: .easy)
    
    @State private var selectedRow = -1
    @State private var selectedCol = -1
    @State private var selectedNum = 0
    
    @State private var solved = false
    @State private var showingNewGame = false
    
    @State private var counts = [Int: Int]()
    
    let spacing = 1.0
    
    var body: some View {
        NavigationStack {
            VStack {
                Grid(horizontalSpacing: 1, verticalSpacing: 1) {
                    ForEach(0..<9) { row in
                    GridRow {
                            ForEach(0..<9) { col in
                                CellView(
                                    number: board.playerBoard[row][col],
                                    selectedNumber: selectedNum,
                                    highlightState: highlightState(for: row, col: col),
                                    isCorrect: board.playerBoard[row][col] == board.fullBoard[row][col]) {
                                        selectedRow = row
                                        selectedCol = col
                                        selectedNum = board.playerBoard[row][col]
                                    }
                                
                                if col == 2 || col == 5 {
                                    Spacer()
                                        .frame(width: spacing, height: 1)
                                }
                            }
                        }
                        .padding(.bottom, row == 2 || row == 5 ? spacing: 0)
                    }
                }
                HStack {
                    ForEach(1..<10) { i in
                        Button(String(i)) {
                            enter(i)
                        }
                        .frame(maxWidth: .infinity)
                        .font(.largeTitle)
                        .opacity(counts[i, default: 0] == 9 ? 0 : 1)

                    }
                }
                .padding()
                .disabled(disableEnterNumber())
                
            }
            .toolbar {
                Button {
                    showingNewGame = true
                } label: {
                    Label("Start a New Game", systemImage: "plus")
                }

            }
            .navigationTitle("Tap Sudoku")
            .alert("Start New Game", isPresented: $showingNewGame) {
                ForEach(Board.Difficulty.allCases, id: \.self) {  difficulty in
                    Button(String(describing: difficulty).capitalized) {
                        newGame(difficulty: difficulty)
                    }
                }
                Button("Cancel",role: .cancel ) { }
            } message: {
                if solved {
                    Text("You solved the board correctly - good job!")
                    
                }
            }
        }
        .preferredColorScheme(.dark)
        .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
        .onAppear {
            updateCounts()
        }
        .onChange(of: board) { _ in
            updateCounts()
        }
    }
    
    func highlightState(for row: Int, col: Int) -> CellView.HighlightState {
        if row == selectedRow {
            if col == selectedCol {
                return .selected
            } else {
                return .highlighted
            }
        } else if col == selectedCol  {
            return .highlighted
        } else {
            return .standart
        }
    }
    func newGame(difficulty: Board.Difficulty) {
        board = Board(difficulty: difficulty)
         var selectedRow = -1
         var selectedCol = -1
         var selectedNum = 0
    }
    func enter(_ number: Int) {
        if board.playerBoard[selectedRow][selectedCol] == number {
            board.playerBoard[selectedRow][selectedCol] = 0
            selectedNum = 0
        } else {
            board.playerBoard[selectedRow][selectedCol] = number
            selectedNum = number
        }
    }
    func disableEnterNumber() -> Bool {
        if selectedRow == -1 {
            return true
        }
        if selectedCol == -1 {
            return true
        }
        return false
    }
    func updateCounts() {
        solved = false
        var newCounts = [Int: Int]()
        var correctCount = 0
        
        for row in 0..<board.size {
            for col in 0..<board.size {
                let value = board.playerBoard[row][col]
                
                if value == board.fullBoard[row][col] {
                    newCounts[value, default: 0] += 1
                    correctCount += 1
                }
            }
        }
        counts = newCounts
        
        if correctCount ==  board.size * board.size {
            Task {
                try await Task.sleep(for: .seconds(0.5))
                showingNewGame = true
                solved = true
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
