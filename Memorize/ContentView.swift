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
    @State var cardCount: Int = 6
    @State var emojis: [String] = ["🐝", " 🦆", "🐼", "⚽️", "🐼", "⚽️"]
    //Initialize emojis for different themes
    let cars_theme: [String] = ["🚒", "🏎️", "🚑", "🚓", "🚜", "🚒", "🏎️", "🚑", "🚓",]
    let space_theme: [String] = ["🌎", "🌞", "🌙", "🪐", "☄️", "🌞", "🌙", "🪐", "☄️"]
    let shapes_theme: [String] = ["🛑", "🔱", "🌀", "♣️", "♖", "🔱", "🌀", "♣️", "♖"]
    let random_theme: [String] = ["🐝", " 🦆", "🐼", "⚽️", "🍗", "🏹", "🍩", "🦷", " 🦆", "🐼", "⚽️", "🍗"]
    
    @State var deviceOrientation: UIDeviceOrientation = .portrait
    
    var body: some View {
        NavigationView {
            VStack {
                cards
                Spacer(minLength: 20)
                themeButtons
                cardCountAdjusters
            }.padding().font(.largeTitle)
                .navigationTitle("Memorize !")
                .navigationBarTitleDisplayMode(.large)
                .onAppear {self.deviceOrientation = UIDevice.current.orientation}
                .onChange(of: UIDevice.current.orientation) {
                    newOrientation in self.deviceOrientation = newOrientation
                }
        }
    }
    
    var cardCountAdjusters: some View {
        HStack {
            cardAdder
            Spacer()
            cardRemover
        }
    }
    
    var cards: some View {
        //Creating buttons for the theme selection
        ScrollView {
            
            let columns = [GridItem(.adaptive(minimum: deviceOrientation.isLandscape ? 150:115))]
            
            LazyVGrid(columns: columns, spacing: deviceOrientation.isLandscape ? 20:10) {
                
                ForEach(0..<cardCount, id: \.self) { index in
                    CardView(content: emojis[index]).aspectRatio(2/3, contentMode: .fit).padding()
                }
            }
            
        }.foregroundColor(.orange)
    }

    // Theme Buttons as a separate computed property
        var themeButtons: some View {
            HStack {
                themeButton(action: { emojis = cars_theme.shuffled() }, systemIcon: "car.circle.fill")
                themeButton(action: { emojis = shapes_theme.shuffled() }, systemIcon: "square.on.square.squareshape.controlhandles")
                themeButton(action: { emojis = space_theme.shuffled() }, systemIcon: "globe.americas.fill")
                themeButton(action: { emojis = random_theme.shuffled() }, systemIcon: "lightspectrum.horizontal")
            }
        }
        
        // Helper method to create theme button
        func themeButton(action: @escaping () -> Void, systemIcon: String) -> some View {
            Button(action: action) {
                Image(systemName: systemIcon)
            }
        }
    
    func cardCountAdjuster(by offset: Int, symbol: String) -> some View {
        Button(action: {
            cardCount += offset
            }, label: {
            Image(systemName: symbol)
            }).disabled(cardCount + offset < 1 || cardCount + offset > emojis.count)
        .imageScale(.large)
    }
    
    var cardAdder: some View {
        cardCountAdjuster(by: 1, symbol: "plus.circle")
    }
    var cardRemover: some View {
        cardCountAdjuster(by: -1, symbol: "minus.circle")
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
                base.fill().foregroundColor(.orange).opacity(isFaceUp ? 0 : 1)
            }
        }.onTapGesture {
            isFaceUp.toggle()
        }
    }
}

#Preview {
    ContentView()
}
