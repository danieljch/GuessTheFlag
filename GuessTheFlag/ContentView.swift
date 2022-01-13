//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Daniel Jesus Callisaya Hidalgo on 8/12/21.
//

import SwiftUI

struct ContentView: View {
    @State private var score = 0
    @State private var showingScore = false
    @State private var showingEndGame = false
    @State private var scoreTitle = ""
    @State private var rounds = 0
    @State private var angle = 0.0 //Challenge 1 Animation
    @State private var animation = false
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var answerFlag = 3
    @State private var isCorrect = false
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.41, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.16), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 400)
                .ignoresSafeArea()
            VStack {
                Spacer()
                // ViewAndModifier use custom largeTittle modifier
                Text("Guess the Flag")
                    .largeTitle()
                VStack(spacing: 15) {
                        Text("Tap the flag of")
                        .font(.subheadline.weight(.heavy))
                        .foregroundStyle(.secondary)
                        Text(countries[correctAnswer])
                        .font(.largeTitle.weight(.semibold))
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                            answerFlag = number
                            //Challenge 1 Animation
                            if isCorrect {
                            withAnimation {angle += 360}
                            }
                        } label: {
                           FlagImage(text: countries[number])
                        }//Challenge 1 Animation
                        .rotation3DEffect( isCorrect && correctAnswer == number ? Angle(degrees: angle) : Angle(degrees: 0.0), axis: (x:0,y:1,z:0))
                        .opacity(answerFlag != number && animation  ? 0.25 : 1 )
                        .scaleEffect( !isCorrect && answerFlag == number ? 0.5 : 1)
                        .animation(.default, value: answerFlag)
                    }
                }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                Spacer()
                Spacer()
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                Spacer()
            }
            .padding()
            
            
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text((scoreTitle == "Correct") ? "Your score is \(score)" : "That’s the flag of \(countries[answerFlag])")
        }
        .alert("End of Game", isPresented: $showingEndGame) {
            Button("Continue", action: resetGame)
        } message: {
            Text(scoreMesagge(score))
        }
    }
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            isCorrect = true
            scoreTitle = "Correct"
            score += 1
        } else {
            scoreTitle = "Wrong"
        }
        rounds += 1
        if rounds < 8 {
        showingScore = true
        } else {
            showingEndGame = true
        }
        withAnimation { animation = true}
    }
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        isCorrect = false
        answerFlag = 3
        withAnimation {animation = false}
    }
    func resetGame(){
        score = 0
        rounds = 0
    }
    func scoreMesagge(_ score: Int)-> String{
        let scoreValue = [0:"terribly poor", 1: "poor", 2: "you should improve", 3:"regular", 4:"it is going well", 5 : "good", 6 : "very good", 7 : "Awesome", 8: "perfect!"]
        return scoreValue[score] ?? "unknow"
    }
}
// ViewAndModifiers 2nd Challenge, struct implementation
struct FlagImage: View {
    var text : String
    var body: some View {
        Image(text)
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 5)
    }
}

// ViewAndModifiers Third Challenge,  implementation
struct LargeTitle: ViewModifier{
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.blue)
            .shadow(color: .white, radius: 3, x: -2, y: 0)
    }
}

extension View{
    func largeTitle() -> some View {
        modifier(LargeTitle())
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
