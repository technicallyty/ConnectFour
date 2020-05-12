//
//  ContentView.swift
//  ConnectFour
//
//  Created by Tyler Goodman on 5/11/20.
//  Copyright © 2020 Tyler Goodman. All rights reserved.
//

import SwiftUI
import Foundation

class Game: ObservableObject {
    @Published var turn = 1
    @Published var previousTurn = 1
    @Published var gameBoard = [["0", "0", "0", "0"], ["0", "0", "0", "0"], ["0", "0", "0", "0"], ["0", "0", "0", "0"]]
    @Published var showingAlert = false
}

struct ContentView: View {
    @EnvironmentObject var game: Game
    var body: some View {
        VStack{
            Text("Player \(self.game.turn) Turn")
            HStack{
                cell(row: 0, col: 0)
                cell(row: 0, col: 1)
                cell(row: 0, col: 2)
                cell(row: 0, col: 3)
            }
            HStack {
                cell(row: 1, col: 0)
                cell(row: 1, col: 1)
                cell(row: 1, col: 2)
                cell(row: 1, col: 3)
            }
            HStack{
                cell(row: 2, col: 0)
                cell(row: 2, col: 1)
                cell(row: 2, col: 2)
                cell(row: 2, col: 3)
            }
            HStack{
                cell(row: 3, col: 0)
                cell(row: 3, col: 1)
                cell(row: 3, col: 2)
                cell(row: 3, col: 3)
            }
        }

    }
}


struct cell: View {
    @EnvironmentObject var game: Game
    
    init(row: Int, col: Int){
        self.row = row
        self.col = col
    }
    
    @State var color = Color.clear
    @State var isTapped = false
    @State private var showingAlert = false
    
    var row : Int
    var col: Int
    
    func checkRows(player: String) -> Bool {
        //check rows
        for (_, rows) in self.game.gameBoard.enumerated(){
            var rowHasWinner = true
            for item in rows {
                if (item != player){
                    rowHasWinner = false
                    break
                }
            }
            if rowHasWinner {
                print("Found a winner.")
                return true
            }
        }
        
        
        
        return false
    }
    
    func checkCols(player: String) -> Bool {
        for x in (0...3){
            var colWinner = true
            for y in(0...3){
                if(self.game.gameBoard[y][x] != player){
                    colWinner = false
                    break
                }
            }
            
            if (colWinner){
                print("COLUMN WIN")
                return true
            }
        }
        
        return false
    }
    
    func checkDiagonal(player: String) -> Bool {
        
        
        
        //check forward
        var hasWinnerForwards = true
        for x in (0...3){
            if(self.game.gameBoard[x][x] != player){
                hasWinnerForwards = false
                break
            }
        }
        
        var hasWinnerBackwards = true
        var y = 3
        for x in (0...3){
            if(self.game.gameBoard[x][y] != player) {
                hasWinnerBackwards = false
                break
            }
            y -= 1
        }
        
        if(hasWinnerForwards || hasWinnerBackwards){
            print("winner diagonal.")
        }
        
        return (hasWinnerBackwards || hasWinnerForwards)
    }
    
    
    var body: some View {
        
        
        
        Button(action: {
            if(!self.isTapped){
                self.game.previousTurn = self.game.turn
                self.isTapped = true
                self.color = self.game.turn == 1 ? Color.red : Color.blue
                let player = self.game.turn == 1 ? "R" : "B"
                self.game.gameBoard[self.row][self.col] = player
                let rowsResult = self.checkRows(player: player)
                let colsResult = self.checkCols(player: player)
                let diagResult = self.checkDiagonal(player: player)
                
                if(rowsResult || colsResult || diagResult){
                    self.showingAlert = true
                }
                
                self.game.turn = self.game.turn == 1 ? 2 : 1
            }
        }) {
            Text("").frame(width: 50, height: 50, alignment: .center)
                    .background(self.color)
                    .cornerRadius(100)
                    .padding()
                    .border(Color.black)
                .alert(isPresented: self.$showingAlert){
                    Alert(title: Text("WINNER"), message: Text("Player \(self.game.previousTurn) has won!"))
            }
        }
    }
}
