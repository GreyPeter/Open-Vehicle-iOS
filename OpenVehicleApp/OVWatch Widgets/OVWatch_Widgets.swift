//
//  OVWatch_Widgets.swift
//  OVWatch Widgets
//
//  Created by Peter Harry on 15/5/2024.
//  Copyright © 2024 Open Vehicle Systems. All rights reserved.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    @ObservedObject var metrics = WatchModel.shared
    
    func placeholder(in context: Context) -> OVwidgetEntry {
        
        return OVwidgetEntry(date: Date(), soc: 50.0, range: 131.5)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (OVwidgetEntry) -> ()) {
        
        let entry = OVwidgetEntry(date: Date(), soc: 40.0, range: 100.0)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {

        //let socVal = Double(metrics.metricVal.soc) ?? 0.0
        let range = Double(metrics.metricVal.idealrange) ?? 0.0
        let charging = Bool(metrics.metricVal.charging)
        
        var entries: [OVwidgetEntry] = []
        var percentPerMinute = 0.0
        var currentDate = Date()
        let endDate = currentDate + 20 * 60
        
        //var percent = 0.0
        var percentToFull = 0.0
        var maxRange:Double = 0.0
        var soc:Double = 0.0
        //var range:Double = 0.0
                
        /*Charge.loadChargeData(username: user, password: password, vehicle: vehicleID) { (currentCharge, error) in
            guard let charge = currentCharge else {
                //logger.error("Charge Data not loaded")
                return
            }
            
            if let socVal = Double(metrics.metricVal.soc) {
                soc = socVal
                //percent = soc / 100
                percentToFull = 100 - soc
            }
            if let health = Double(metrics.metricVal.soh) {
                if let max = Double(metrics.metricVal.idealrange_max) {
                    let max_range = max * health / 100.0
                    maxRange = max_range
                    //maxRange = max * health / 100.0
                    range = max_range * soc / 100
                }
            }*/
            
            if charging {
                
                if let timeToFull = Double(metrics.metricVal.durationfull) {
                    if timeToFull > 0 {
                        percentPerMinute = percentToFull / timeToFull
                        //logger.debug("Percent per Minute = \(percentPerMinute)")
                    }
                }
                
                while currentDate < endDate {
                    //range = maxRange * soc / 100
                    print("SOC: \(String(format:"%0.1f",soc)) Range: \(String(format:"%0.2f",range)) @ \(currentDate.formatted(date: .omitted , time: .shortened))")
                    let entry = OVwidgetEntry(date: currentDate, soc: soc, range: range)
                    soc += percentPerMinute
                    soc = soc > 100 ? 100.0 : soc
                    currentDate += 60
                    entries.append(entry)
                }
            } else if metrics.metricVal.on != "0" {
                /*Location.loadLocationData(username: user, password: password, vehicle: vehicleID) { (currentLoc, error) in
                    guard let location = currentLoc else {
                        //logger.error("Location Data not loaded")
                        return
                    }*/
                    while currentDate < endDate {
                        var distance = 0.0
                        let interval = currentDate.timeIntervalSince(Date()) / 60
                        //if let kmPerHr = Double(location.speed) {
                        if let kmPerHr = Double(metrics.metricVal.gpsspeed) {
                            let kmPerMinute = kmPerHr / 60
                            distance = kmPerMinute * interval
                        }
                        if let estimatedrange = Double(metrics.metricVal.estimatedrange) {
                            let range = estimatedrange - distance
                            let soc = range / maxRange * 100
                            print("SOC: \(String(format:"%0.1f",soc)) Range: \(String(format:"%0.2f",range)) @ \(currentDate.formatted(date: .omitted , time: .shortened))")
                            let entry = OVwidgetEntry(date: currentDate, soc: soc, range: range)
                            entries.append(entry)
                            currentDate += 60
                        }
                    }
                //}
            } else {
                while currentDate < endDate {
                    let entry = OVwidgetEntry(date: currentDate, soc: soc, range: range)
                    entries.append(entry)
                    currentDate += 60
                }
            }
            //logger.debug("Entries = \(entries.count) Estimated Range = \(String(format:"%0.2f",range)) Charge = \(String(format:"%0.1f",soc))")
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }
//}

struct OVwidgetEntry: TimelineEntry {
    let date: Date
    let soc: Double
    let range: Double
}

struct OV_Watch_WidgetsEntryView : View {
    
    @Environment(\.widgetFamily) var family
    
    var entry: Provider.Entry
    
    var body: some View {
        switch family {
        case .accessoryCircular:
            ZStack {
                Gauge(value: min(entry.soc, 100.0), in: 0.0...100.0 ) {
                    Text("\(Int(entry.soc))%")
                }
            currentValueLabel: { Text(String(format: "%.0f", entry.range)) }
                    .gaugeStyle(CircularGaugeStyle(tint: Gradient(colors: [.red, .orange, .yellow, .green])))
            }
            .containerBackground(for: .widget) {
                Color.clear
            }
            
        case .accessoryRectangular:
            HStack(alignment: .center, spacing: 0) {
                VStack {
                    Gauge(value: min(entry.soc, 100.0), in: 0.0...100.0 ) {
                    }
                    .gaugeStyle(LinearGaugeStyle(tint: Gradient(colors: [.red, .orange, .yellow, .green])))
                    Text("Range: \(String(format: "%.1f", entry.range))Km")
                    Text("Charge: \(String(format: "%.1f%%", entry.soc))")
                }
            }
            .containerBackground(for: .widget) {
                Color.clear
            }

            
        case .accessoryInline:
            ViewThatFits {
                Text("Charge:\(String(format: "%.0f%%", entry.soc)) - Range:\(String(format: "%.0f", entry.range))K")
            }
            
        default:
            HStack(alignment: .center, spacing: 0) {
                Text("\(String(format: "%.1f%%", entry.soc))")
            }
        }
    }
}

@main

struct OV_Watch_Widgets: Widget {
    let kind: String = "OV_Watch_Widgets"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            OV_Watch_WidgetsEntryView(entry: entry)
        }
        .configurationDisplayName("OV-Watch Widget")
        .description("Charge and Range Display.")
    }
}

struct OV_Watch_Widgets_Previews: PreviewProvider {
    static var previews: some View {
        let soc = 50.0
        let range = 132.5
        Group {
            OV_Watch_WidgetsEntryView(entry: OVwidgetEntry(date: Date(), soc: soc, range: range))
                .previewContext(WidgetPreviewContext(family: .accessoryCircular))
                .previewDisplayName("Circular")
                .previewDisplayName("Series 6 40mm")
            OV_Watch_WidgetsEntryView(entry: OVwidgetEntry(date: Date(), soc: soc, range: range))
                .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
                .previewDisplayName("Rectangular")
                .previewDisplayName("Series 7 41mm")
            OV_Watch_WidgetsEntryView(entry: OVwidgetEntry(date: Date(), soc: soc, range: range))
                .previewContext(WidgetPreviewContext(family: .accessoryInline))
                .previewDisplayName("Inline")
                .previewDisplayName("Series 8 45mm")
        }
    }
}
