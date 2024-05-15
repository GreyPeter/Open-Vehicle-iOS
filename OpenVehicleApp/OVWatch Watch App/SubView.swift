//
//  SubView.swift
//  OVWatch Watch App
//
//  Created by Peter Harry on 20/2/2024.
//  Copyright © 2024 Open Vehicle Systems. All rights reserved.
//

import SwiftUI

struct SubView: View {
    var Text1: String
    var Data1: String
    var Text2: String
    var Data2: String
    var Text3: String
    var Data3: String
    var Text4: String
    var Data4: String
    var Text5: String
    var Data5: String
    var Text6: String
    var Data6: String
    var body: some View {
        let rows: [GridItem] = Array(repeating: .init(.fixed(15)), count: 2)
        let stackHeight: CGFloat = 35
        let cellSize = 0.35
        GeometryReader { watchGeo in
            VStack {
                LazyHGrid(rows: rows) {
                    Text(Text1)
                        .font(.footnote)
                        .frame(width: watchGeo.size.width * cellSize)
                    Text(Data1)
                        //.fontWeight(.bold)
                        .foregroundColor(Color.red)
                        .frame(width: watchGeo.size.width * cellSize)
                    
                    Text(Text2)
                        .font(.footnote)
                        .frame(width: watchGeo.size.width * cellSize)
                    Text(Data2)
                        //.fontWeight(.bold)
                        .foregroundColor(Color.orange)
                        .frame(width: watchGeo.size.width * cellSize)
                    
                    Text(Text3)
                        .font(.footnote)
                        .frame(width: watchGeo.size.width * cellSize)
                    Text(Data3)
                        //.fontWeight(.bold)
                        .foregroundColor(Color.yellow)
                        .frame(width: watchGeo.size.width * cellSize)
                }
                .frame(width: watchGeo.size.width, height: stackHeight, alignment: .top)
                
                LazyHGrid(rows: rows) {
                    Text(Text4)
                        .font(.footnote)
                        .frame(width: watchGeo.size.width * cellSize)
                    Text(Data4)
                        //.fontWeight(.bold)
                        .foregroundColor(Color.red)
                        .frame(width: watchGeo.size.width * cellSize)
                    
                    Text(Text5)
                        .font(.footnote)
                        .frame(width: watchGeo.size.width * cellSize)
                    Text(Data5)
                        //.fontWeight(.bold)
                        .foregroundColor(Color.orange)
                        .frame(width: watchGeo.size.width * cellSize)
                    
                    Text(Text6)
                        .font(.footnote)
                        .frame(width: watchGeo.size.width * cellSize)
                    Text(Data6)
                        //.fontWeight(.bold)
                        .foregroundColor(Color.yellow)
                        .frame(width: watchGeo.size.width * cellSize)
                }
                .frame(width: watchGeo.size.width, height: stackHeight, alignment: .top)
            }
            .frame(width: watchGeo.size.width, height: stackHeight * 2.3, alignment: .center)
        }
    }
}

#Preview {
    
    //SubView(Text1: "Full", Data1: "5:25", Text2: "80%", Data2: "1:20", Text3: "175K", Data3: "0:54", Text4: "Dur", Data4: "0:20", Text5: "kWh", Data5: "20", Text6: "@ kW", Data6: "2.4")
    SubView(Text1: "Wh/km", Data1: "165", Text2: "PWR", Data2: "2.2kW", Text3: "ODO", Data3: "12590", Text4: "Current", Data4: "5.9A", Text5: "Voltage", Data5: "382.5V", Text6: "12V", Data6: "12.5V")
}
