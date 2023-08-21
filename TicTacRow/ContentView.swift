//
//  ContentView.swift
//  TicTacRow
//
//  Created by Maks Winters on 05.08.2023.
//

import SwiftUI


struct ContentView: View {

// Check if the game is played at a new day
    func isNewDay() -> Bool {
        let defaults = UserDefaults.standard
        let now = Date()
        if let savedDate = defaults.object(forKey: "currentDate") as? Date,
           Calendar.current.compare(savedDate, to: now, toGranularity: .day) == .orderedSame {
            print("Same day")
                   return false
               }
               defaults.set(now, forKey: "currentDate")
            print("New day")
               return true
           }
// Scores:
        @AppStorage("SCORE_KEY") var score: Int = 100
        @AppStorage("TREND_KEY") var todaysTrend = 0
        @AppStorage("YTREND_KEY") var yesterdaysTrend = 0
// Playing field shapes
        @State var tile: String = "o.circle"
        @State var tile1: String = "o.circle"
        @State var tile2: String = "o.circle"
// Randomizer variables
        @State var random: Int = 0
        @State var random1: Int = 0
        @State var random2: Int = 0
// "You won!!!" text opacity variable
        @State var opacity: Double = 0
// Disabling button after press variable
        @State var buttonisDisabled = false
// ChartsButton default state
        @State var chartsButton = "chart.line.flattrend.xyaxis.circle.fill"
        @State var chartsButtonColor: Color = .blue
    

// Play action after pressing "Play!"
    func playAction(){
//Disabling "Play!" button
        buttonisDisabled = true
//Randomizing
        random = Int.random(in: 0...1)
        random1 = Int.random(in: 0...1)
        random2 = Int.random(in: 0...1)
        
        switch random{
        case 0:
            tile = "o.circle"
        case 1:
            tile = "x.circle"
        default:
            tile = "o.circle"
        }
        switch random1{
        case 0:
            tile1 = "o.circle"
        case 1:
            tile1 = "x.circle"
        default:
            tile1 = "o.circle"
        }
        switch random2{
        case 0:
            tile2 = "o.circle"
        case 1:
            tile2 = "x.circle"
        default:
            tile2 = "o.circle"
        }

// Win/lose state determination
        if random + random1 + random2 == 3{
            opacity = 100
            self.score += 100
            self.todaysTrend += 100
        } else if random + random1 + random2 == 0{
            opacity = 100
            self.score += 100
            self.todaysTrend += 100
        } else{
            opacity = 0
            self.score -= 25
            self.todaysTrend -= 25
        }
        if isNewDay() == true{
            yesterdaysTrend = todaysTrend
            todaysTrend = 0
        }
        
        if yesterdaysTrend > todaysTrend{
            chartsButton = "chart.line.downtrend.xyaxis.circle.fill"
            chartsButtonColor = .red
        } else{
            chartsButton = "chart.line.uptrend.xyaxis.circle.fill"
            chartsButtonColor = .green
        }
        print(random, random1, random2)

//  Enabling "Play!" button after 1 second
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
            buttonisDisabled = false
        }
    }
    
    var body: some View {
        NavigationView(){
            VStack{
                ZStack{
                    HStack{
                        
                        Text("Score: \(score)")
                            .frame(width: 100, height: 20)
                        
                        Button{
                            score = 100
                            todaysTrend = 0
                            buttonisDisabled = false
                        } label: {
                            Image(systemName: "arrow.counterclockwise.circle.fill")
                        } .frame(width: 1)
                        
                        Spacer()
                    }
                    HStack{
                        
                        Text("TicTacRow")
                            .font(.system(size: 20))
                            .frame(width: 175)
                        
                    }
                    HStack{
                        Spacer()
                        NavigationLink{
                            ScoreChartsView()
                        } label: {
                            Image(systemName: chartsButton)
                        } .frame(width: 1)
                            .foregroundStyle(chartsButtonColor)

                            Text("Trend: \(todaysTrend)")
                                .frame(width: 100, height: 20)
                    }
                } .padding(10)
              
                Text("Yesterday: \(yesterdaysTrend)")
           
                Spacer()
                HStack{
                    
                    Image(systemName: tile)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: tile1)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: tile2)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                }
                
                Spacer()
                ZStack{
                    Text("You won!!!")
                        .opacity(opacity)
                        .font(.system(size: 40))
                }
                Button{
                    if score <= 0{
                        print("Game over!")
                        buttonisDisabled = true
                    } else{
                        playAction()
                        
                    }
                } label: {
                    Text("Play!")
                        .padding(.horizontal, 100)
                        .padding(.vertical, 7)
                        .font(.system(size: 30))
                }       .buttonStyle(.borderedProminent)
                    .cornerRadius(30)
                    .disabled(buttonisDisabled)

            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

