//
//  StatisticsView.swift
//  Capstone_2
//
//  Created by Nicode . on 12/3/23.
//

import SwiftUI
import Charts

struct ChartItem: Identifiable{
    let id = UUID()
    let name: String
    let count : Int
    let date:String?
}

var chartItemList = [ChartItem(name:"plastic", count:30, date: nil),
                     ChartItem(name:"cardboard", count:60, date: nil),
                     ChartItem(name:"glass", count:90, date: nil),
                     ChartItem(name:"battery", count:50, date: nil),
                     ChartItem(name:"metal", count:70, date: nil)]


struct SalesSummary: Identifiable{
    let weekend:DateComponents
    let sales:Int
    
    var id: DateComponents{ weekend }
}

struct Series: Identifiable{
    let city:String
    let sales:[SalesSummary]
    
    var id: String { city }
}

let cupertinoData:[SalesSummary] = [
    .init(weekend: DateComponents(year:2022, month:5, day:2), sales: 54),
    .init(weekend: DateComponents(year:2022, month:5, day:3), sales: 42),
    .init(weekend: DateComponents(year:2022, month:5, day:4), sales: 88),
    .init(weekend: DateComponents(year:2022, month:5, day:5), sales: 49),
    .init(weekend: DateComponents(year:2022, month:5, day:6), sales: 42),
    .init(weekend: DateComponents(year:2022, month:5, day:7), sales: 125),
    .init(weekend: DateComponents(year:2022, month:5, day:8), sales: 67),
]

let sfData:[SalesSummary] = [
    .init(weekend: DateComponents(year:2022, month:5, day:2), sales: 81),
    .init(weekend: DateComponents(year:2022, month:5, day:3), sales: 90),
    .init(weekend: DateComponents(year:2022, month:5, day:4), sales: 52),
    .init(weekend: DateComponents(year:2022, month:5, day:5), sales: 72),
    .init(weekend: DateComponents(year:2022, month:5, day:6), sales: 84),
    .init(weekend: DateComponents(year:2022, month:5, day:7), sales: 84),
    .init(weekend: DateComponents(year:2022, month:5, day:8), sales: 137),
]

let seriseData:[Series] = [
    .init(city: "Cupertino", sales: cupertinoData),
    .init(city: "San Francisco", sales: sfData)
]

struct StatisticsView: View {
    @State private var kindOfChart = "donut"
    private var chartsList = ["donut", "delta"]
    var body: some View {
        Text("Statistics")
            .font(.system(size:45))
            .frame(width:UIScreen.main.bounds.width, alignment:.leading)
            .offset(x:UIScreen.main.bounds.width * 0.2 / 2)
            .padding(.top, 10)
        Picker("choose you want chart", selection: $kindOfChart){
            ForEach(chartsList, id: \.self) {
                Text($0)
            }
        }
        .pickerStyle(.segmented)
        .cornerRadius(10)
        .frame(width:UIScreen.main.bounds.width * 0.8)
        .padding(.bottom, 20)
        
        switch kindOfChart {
        case "donut":
            GeometryReader{ geo in
                Chart(chartItemList, id:\.id){ elem in
                    SectorMark(
                        angle : .value("count", elem.count),
                        innerRadius: .ratio(0.618),
                        angularInset: 1.5
                    )
                    .cornerRadius(5)
                    .foregroundStyle(by: .value("Name", elem.name))
                }
                .frame(width: geo.size.width * 0.8, height: geo.size.height * 0.6)
                .offset(x:geo.size.width * 0.2 / 2)
                .chartBackground(){ chartProxy in
                    GeometryReader{ geometryProxy in
                        let frame = geometryProxy[chartProxy.plotAreaFrame]
                        VStack{
                            Text("Most Sold Style")
                                .font(.callout)
                                .foregroundStyle(.secondary)
                            Text("CardBoard")
                                .font(.title2.bold())
                                .foregroundStyle(.primary)
                        }.position(x:frame.midX, y:frame.midY)
                    }
                }
            }
        case "delta":
            GeometryReader{ geo in
                Chart(seriseData) { serise in
                    ForEach(serise.sales){ element in
                        let myDateComponents = element.weekend
                        let calendar = Calendar.current
                        let myDate = calendar.date(from: myDateComponents)
                        LineMark(
                            x:.value("Day", myDate ?? Date()),
                            y:.value("Sales", element.sales)
                        )
                        .foregroundStyle(by:.value("City", serise.city))
                        .symbol(by:.value("City", serise.city))
                    }
                }
                .frame(width: geo.size.width * 0.8, height: geo.size.height * 0.6)
                .offset(x:geo.size.width * 0.2 / 2)
            }
        default:
            Text("hello swift!")
        }
    }
}

#Preview {
    StatisticsView()
}
