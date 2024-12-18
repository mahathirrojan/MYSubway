//
//  TrainLinesView.swift
//  MYSubway
//
//  Created by Mahathir Rojan on 11/10/24.
//

// TrainLinesView.swift

import SwiftUI

struct TrainLinesView: View {
    // Grouped train lines by color
    let trainLinesByColor = [
        "Blue Line": [("A", "Uptown & Queens"), ("C", "Uptown & Brooklyn"), ("E", "Downtown & Queens")],
        "Orange Line": [("B", "Bronx & Brooklyn"), ("D", "Bronx & Brooklyn"), ("F", "Queens & Brooklyn"), ("M", "Queens & Queens")],
        "Red Line": [("1", "Bronx & Downtown"), ("2", "Bronx & Brooklyn"), ("3", "Uptown & Brooklyn")],
        "Green Line": [("4", "Bronx & Brooklyn"), ("5", "Bronx & Brooklyn"), ("6", "Bronx & Downtown"), ("6D", "Bronx & Downtown")],
        "Purple Line": [("7", "Manhattan & Downtown"), ("7D", "Manhattan & Queens")],
        "Yellow Line": [("N", "Queens & Brooklyn"), ("Q", "Manhattan & Brooklyn"), ("R", "Queens & Brooklyn"), ("W", "Queens & Downtown")],
        "Gray Line": [("L", "Manhattan & Brooklyn")],
        "Lime Line": [("G", "Queens & Brooklyn")],
        "Brown Line": [("J", "Manhattan & Brooklyn"), ("Z", "Manhattan & Brooklyn")],
        "Shuttle": [("S", "Manhattan"), ("SF", "Brooklyn"), ("SR", "Rockaway Beach")]
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(trainLinesByColor.keys.sorted(), id: \.self) { color in
                        if let lines = trainLinesByColor[color] {
                            TrainLineColorCard(color: color, lines: lines)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Train Lines")
        }
    }
}


struct TrainLineColorCard: View {
    var color: String
    var lines: [(String, String)] // Array of train line and direction

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(color)
                .font(.title2)
                .fontWeight(.bold)
                .padding(.bottom, 5)

            // List-like view of clickable icons
            VStack(spacing: 0) {
                ForEach(lines, id: \.0) { line, direction in
                    NavigationLink(destination: TrainLineDetailView(line: line)) {
                        HStack {
                            Image(line) // Train line icon
                                .resizable()
                                .frame(width: 30, height: 30)
                                .padding(.trailing, 10)

                            VStack(alignment: .leading) {
                                Text(line)
                                    .font(.headline)
                                Text(direction)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }

                            Spacer()
                        }
                        .padding()
                        .background(Color(.systemGray6))
                    }
                    .buttonStyle(PlainButtonStyle()) // Removes NavigationLink styling
                    .cornerRadius(8)
                    .padding(.vertical, 2) // Padding between items
                }
            }
        }
        .padding()
        .background(Color(.systemGray5))
        .cornerRadius(12)
        .shadow(radius: 4)
    }
}
#Preview {
    TrainLinesView()
}
