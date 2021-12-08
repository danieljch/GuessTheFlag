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
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var answerFlag = 0
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 400)
                .ignoresSafeArea()
            VStack {
                Spacer()
                Text("Guess the Flag")
                        .font(.largeTitle.weight(.bold))
                        .foregroundColor(.white)
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
                        } label: {
                            Image(countries[number])
                                .renderingMode(.original)
                                .clipShape(Capsule())
                                .shadow(radius: 5)
                        }
                        
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
    }
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
