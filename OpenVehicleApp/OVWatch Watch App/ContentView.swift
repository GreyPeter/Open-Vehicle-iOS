//
//  ContentView.swift
//  OVWatch Watch App
//
//  Created by Peter Harry on 20/2/2024.
//  Copyright © 2024 Open Vehicle Systems. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var metrics = WatchModel.shared
    var body: some View {
        let metricVal = metrics.metricVal
        let socDouble = Double(metricVal.soc) ?? 0.0
        let charging = metricVal.charging ? "CHARGING":"NOT CHARGING"
        GeometryReader { watchGeo in
            VStack {
                Text(charging)
                    .foregroundColor(.red)
                    .font(.title3)
                Image("battery_000")
                    .resizable()
                    .scaledToFit()
                    .frame(width: watchGeo.size.width * 0.9, height: watchGeo.size.height * 0.3, alignment: .center)
                    .frame(width: watchGeo.size.width, height: watchGeo.size.height * 0.3, alignment: .center)
                    .overlay(ProgressBar(value:
                                            socDouble,
                                         maxValue: 100,
                                         backgroundColor: .clear,
                                         foregroundColor: color(forChargeLevel: socDouble)
                                        )
                        .frame(width: watchGeo.size.width * 0.7, height: watchGeo.size.height * 0.25)
                        .frame(width: watchGeo.size.width, height: watchGeo.size.height * 0.25)
                        .opacity(0.6)
                        .padding(0)
                    )
                    .overlay(
                        VStack {
                            Text("\(String(format:"%0.1f",(Float(metricVal.soc) ?? 0.00)))%")
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                            Text("\(String(format:"%0.1fKm",(Float(metricVal.estimatedrange) ?? 0.00)))")
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                        }
                            .background(Color.clear)
                            .opacity(0.9))
                if metricVal.charging {
                    SubView(Text1: "Full", Data1: timeConvert(time: metricVal.durationfull), Text2: "\(metricVal.limitsoc)%", Data2: timeConvert(time: metricVal.durationsoc), Text3: "\(metricVal.limitrange)", Data3: timeConvert(time: metricVal.durationrange), Text4: "Dur", Data4: timeConvert(time: "\((Int(metricVal.chargeduration) ?? 0)/60)"), Text5: "kWh", Data5: String(format:"%0.1f",(Float(metricVal.chargekwh) ?? 0.0)), Text6: "@ kW", Data6: String(format:"%0.1f",(Float(metricVal.chargepower) ?? 0.0)))
                } else {
                    SubView(Text1: "Speed", Data1: String(format:"%0.0f",(Float(metricVal.gpsspeed) ?? 0.0) * 10.0), Text2: "PWR", Data2: String(format:"%0.1fW",(Float(metricVal.power) ?? 0.0)), Text3: "ODO", Data3: String(format:"%d",(Int(metricVal.odometer) ?? 0)/10), Text4: "Current", Data4: String(format:"%0.1fA",(Float(metricVal.current) ?? 0.0)), Text5: "Voltage", Data5: String(format:"%0.1fV",(Float(metricVal.voltage) ?? 0.0)), Text6: "12V", Data6: String(format:"%0.1fV",(Float(metricVal.lowvoltage) ?? 0.0)))
                }
            }
        }
    }
}

func timeConvert(time: String) -> String {
    guard let intTime = Int(time) else { return "--:--" }
    if intTime <= 0 {
        return "--:--"
    }
    return String(format: "%d:%02d",(Int(time) ?? 0)/60,(Int(time) ?? 0)%60)
}

func timeConvertHours(time: String) -> String {
    guard let intTime = Int(time) else { return "--:--:--" }
    if intTime <= 0 {
        return "--:--:--"
    }
    return String(format: "%d:%02d:%02d",intTime/3600,(intTime % 3600) / 60,(intTime % 3600) % 60)
}

#Preview {
    ContentView()
}
