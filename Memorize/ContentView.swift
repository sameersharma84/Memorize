//  ContentView.swift
//  Memorize
//  Created by Sameer Sharma on 2023-11-01.

/*
 The actual sequence of events when running the app would be:

 ContentView is instantiated and its body computed.
 SwiftUI evaluates the body property of ContentView.
 SwiftUI then creates the HStack and evaluates the bodies of each CardView.
 Each CardView sets up its UI according to the isFaceUp state.
 The user sees the initial UI state on the screen.
 When the user taps a card, the onTapGesture closure toggles isFaceUp, and this change causes SwiftUI to recompute the body of the CardView that was tapped, thus updating the UI to reflect the card's new face-up or face-down state.
 */
import SwiftUI

struct ContentView: View {
    @State var cardCount: Int = 3
    var body: some View {
        VStack {
            HStack {
                let emojis: [String] = ["🐝", " 🦆", "🐼", "⚽️", "🪐", "🍗"]
                ForEach(0..<cardCount, id: \.self) { index in
                    CardView(content: emojis[index])
                }
            }.foregroundColor(.orange)
                
            HStack {
                Button(action: {
                    cardCount += 1
                }, label: {
                    Image(systemName: "plus.circle")
                })
                .imageScale(.large)
                Spacer()
                Button(action: {
                    cardCount -= 1
                }, label: {
                    Image(systemName: "minus.circle")
                })
                .imageScale(.large)
            }
        }.padding()
            
    }
}

struct CardView: View {
    @State var isFaceUp: Bool = false
    var content: String
    var body: some View {
        /*
         Overlaying Views: In the CardView, the use of ZStack is to overlay the RoundedRectangle and the Text view (which shows the basketball emoji) when the card is face up. Without ZStack, these views would not be overlaid but would be laid out according to the default container behavior (which is not what you want for a card representation).
         Conditional Content: The ZStack allows for conditional content to be shown easily. Depending on the isFaceUp boolean, either the card face (with the emoji and border) or the card back (just the filled rectangle) is shown.
         */
        ZStack {
            let base: RoundedRectangle = RoundedRectangle(cornerRadius: 15)
            if isFaceUp {
                base.foregroundColor(.white)
                base.stroke(style: StrokeStyle(lineWidth: 5))
                Text(content).font(.largeTitle)
            } else {
                base.fill().foregroundColor(.orange)
            }
        }.onTapGesture {
            isFaceUp.toggle()
        }
    }
}

#Preview {
    ContentView()
}
