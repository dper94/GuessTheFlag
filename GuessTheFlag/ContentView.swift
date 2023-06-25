//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Diego Perdomo on 21/6/23.
//

import SwiftUI

struct FlagImage: View {
    var countries: [String]
    var number: Int
    
    var body: some View {
        Image(countries[number])
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 5)
    }
}

struct ContentView: View {
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var numberOfQuestions = 0
    @State private var isGameFinish = false

    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()

    @State private var correctAnswer = Int.random(in: 0 ... 2)

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            VStack {
                Spacer()
                Text("Guess the flag")
                    .foregroundColor(.white)
                    .font(.largeTitle.bold())
                    .padding()
                VStack(spacing: 30) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundColor(.white)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .foregroundColor(.white)
                            .font(.largeTitle.weight(.semibold))
                    }
                    ForEach(0 ..< 3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                           FlagImage(countries: countries, number: number)
                        }
                    }
                }
                Spacer()
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                    .padding()
                Spacer()
            }
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue") {
                if numberOfQuestions < 8 {
                    askQuestion()
                }
            }
        } message: {
            Text("Your score is \(score)")
        }
        .alert("Your final score is \(score)", isPresented: $isGameFinish) {
            Button("Start Again", action: resetGame)
        }
    }

    func flagTapped(_ number: Int) {
        numberOfQuestions += 1
        if numberOfQuestions == 8 {
            isGameFinish = true
        }
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
        } else {
            scoreTitle = "Wrong. That's the flag of \(countries[number])"
        }
        showingScore = true
    }

    func resetGame() {
        askQuestion()
        score = 0
        numberOfQuestions = 0
        showingScore = false
    }

    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0 ... 2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
