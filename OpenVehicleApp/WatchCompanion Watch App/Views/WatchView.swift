//
//  ContentView.swift
//  WatchCompanion Watch App
//
//  Created by Peter Harry on 24/9/2024.
//  Copyright © 2024 Open Vehicle Systems. All rights reserved.
//

import SwiftUI

enum CarMode {
  static let identifierKey = "identifier"
  case driving
  case charging
  case idle
  var identifier: String {
    switch self {
    case .driving:
      return "Driving"
    case .charging:
      return "Charging"
    case .idle:
      return "Parked"
    }
  }
  var color: Color {
    switch self {
    case .driving:
      return .blue
    case .charging:
      return .red
    case .idle:
      return .green
    }
  }
}

struct WatchView: View {
  @ObservedObject var metrics = WatchModel.shared
  let timer = Timer.publish(every: 30, on: .main, in: .common).autoconnect()

  var body: some View {
    let metricVal = metrics.metricVal
    let socDouble = Double(metricVal.soc) ?? 0.0
    let carMode = metrics.carMode
    let phoneImage = metrics.sessionAvailable ? "iphone.gen3.circle" : "iphone.gen3.slash.circle"
    GeometryReader { watchGeo in
      VStack {
        Button(action: {
          metrics.getChargeData()
        }) {
          Label(carMode.identifier, systemImage: phoneImage)
        }
        .controlSize(.mini)
        .foregroundStyle(carMode.color)
        //              HStack {
        //                Text(carMode.identifier)
        //                  .foregroundStyle(carMode.color)
        //                  .font(.caption)
        //                Image(systemName: "phone")
        //              }
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
              Text("\(metricVal.soc)%")//"\(String(format:"%0.1f",(Float(metricVal.soc) ?? 0.00)))%")
                .fontWeight(.bold)
                .foregroundColor(Color.white)
              Text("\(metricVal.estimatedrange)Km")//"\(String(format:"%0.1fKm",(Float(metricVal.estimatedrange) ?? 0.00)))")
                .fontWeight(.bold)
                .foregroundColor(Color.white)
            }
              .background(Color.clear)
              .opacity(0.9))
        if metricVal.charging {
          SubView(Text1: "Full", Data1: timeConvert(time: metricVal.durationfull), Text2: "\(metricVal.limitsoc)%", Data2: timeConvert(time: metricVal.durationsoc), Text3: "\(metricVal.limitrange)K", Data3: timeConvert(time: metricVal.durationrange), Text4: "Dur", Data4: timeConvert(time: "\((Int(metricVal.chargeduration) ?? 0)/60)"), Text5: "kWh", Data5: String(format:"%0.1f",(Float(metricVal.chargekwh) ?? 0.00)), Text6: "@ kW", Data6: String(format:"%0.1f",(Float(metricVal.power) ?? 0.00)))
        } else {
          
          SubView(Text1: "Speed", Data1: String(format:"%0.1f",(Float(metricVal.gpsspeed) ?? 0.00)), Text2: "ODO", Data2: String(format:"%0.0f",(Float(metricVal.odometer) ?? 0.0)/*/10*/),Text3: "PWR", Data3: String(format:"%0.1fW",(Float(metricVal.power) ?? 0.00)), Text4: "Current", Data4: String(format:"%0.1fA",(Float(metricVal.current) ?? 0.00)), Text5: "Voltage", Data5: String(format:"%0.1f",(Float(metricVal.voltage) ?? 0.00)), Text6: "12V", Data6: String(format:"%0.1fV",(Float(metricVal.lowvoltage) ?? 0.0)))
        }
      }
    }
    .onReceive(timer) { count in
      metrics.getChargeData()
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
  WatchView()
}
