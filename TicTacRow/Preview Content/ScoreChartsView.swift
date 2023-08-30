//
//  ScoreChartsView.swift
//  TicTacRow
//
//  Created by Maks Winters on 09.08.2023.
//

import SwiftUI
import Charts

// Structure for Chart/Form data
struct ChartData: Identifiable, Hashable{
    var type: String
    var count: Int
    var id: String {return type}
}

struct ScoreChartsView: View {
    
    @State public var showSheet: Bool = false // BottomSheet is showing variable
    let testvar = ContentView() // Importing variables from ContentView()
    var columncolor: Color = .green

// Difference between yesterday's score trend and today's one
    func trendsDifference() -> Int{
        if testvar.yesterdaysTrend < 0{
            return testvar.todaysTrend + testvar.yesterdaysTrend
        }else {
            return testvar.todaysTrend - testvar.yesterdaysTrend
        }
    }
    
    var body: some View {
        
// Data from variables for Charts and Forms
        let data = [ChartData(type: "Current Score", count: testvar.score),
                    ChartData(type: "Today's Trend", count: testvar.todaysTrend),
                    ChartData(type: "Yesterday's Trend", count: testvar.yesterdaysTrend)]
        
        VStack{
            HStack{
                Text("Chart View") // Page title
                    .frame(width: 200, height: 60)
                    .fontWeight(.bold)
                    .font(.system(size:(30)))
                Spacer()
            }
// Charts
            Chart{
                ForEach(data){ dataPoint in
                    BarMark(x: .value("Type", dataPoint.type), y: .value("Score", dataPoint.count))
                        .foregroundStyle(dataPoint.count < 0 ? .red : .green)
                }
                ForEach(data){ dataPoint in
                    BarMark(x: .value("Type", dataPoint.type), y: .value("Score", 100))
                        .opacity(0)
                }
            }
            .aspectRatio(1, contentMode: .fit)
                         
            Spacer()
//Forms
            Form{
                ForEach(data) { dataPoint in
                    HStack{
                        Text("\(dataPoint.type): \(dataPoint.count)")
                        Image(systemName: dataPoint.count <= 0 ? "chart.line.downtrend.xyaxis" : "chart.line.uptrend.xyaxis")
                            .foregroundStyle(dataPoint.count <= 0 ? .red : .green)
                        Spacer()
                        Image(systemName: "info.circle")
                            .foregroundColor(.blue)
                    }
                    .onTapGesture {
                        showSheet.toggle() // Showing BottomSheet
                    }
                    .sheet(isPresented: $showSheet) {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(.gray)
                            .frame(width: 60, height: 5)
                            .padding()
                        Spacer()
                            VStack{
                                Spacer()
// Determination of what image to show on the sheet
                                if trendsDifference() > 0{
                                    Image(systemName: "chart.line.uptrend.xyaxis")
                                        .resizable()
                                        .frame(width: 100, height: 100)
                                        .aspectRatio(contentMode: .fit)
                                    .foregroundColor(.green)
                                } else{
                                    Image(systemName: "chart.line.downtrend.xyaxis")
                                        .resizable()
                                        .frame(width: 100, height: 100)
                                        .aspectRatio(contentMode: .fit)
                                    .foregroundColor(.red)
                                }
// Determination of what text to show based on the progress of a player
                                if testvar.todaysTrend > testvar.yesterdaysTrend{
                                    Text("You got it! Today's trend has gone up by \(trendsDifference()) since yesterday!")
                                        .padding()
                                } else{
                                    Text("Oh no! Your trend went down by \(trendsDifference()) compared to yesterday.")
                                        .padding()
                                }
                                Spacer()
// Dismiss button on the sheet
                                Button{
                                    showSheet = false
                                } label: {
                                    Text("Dismiss")
                            }
                                .buttonStyle(BorderedButtonStyle())
                                .cornerRadius(15)
                        }
                            .presentationDetents([.medium])
                            .presentationBackground(.ultraThinMaterial)
                            .presentationCornerRadius(45)
                    }
                }
            }
        }
    }
    
    struct ScoreChartsView_Previews: PreviewProvider {
        static var previews: some View {
            ScoreChartsView()
        }
    }
}
