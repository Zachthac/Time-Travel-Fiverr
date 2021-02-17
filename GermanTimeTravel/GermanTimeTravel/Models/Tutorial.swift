//
//  Tutorial.swift
//  GermanTimeTravel
//
//  Created by Cora Jacobson on 2/17/21.
//

import UIKit

struct TutorialPage {
    let image: UIImage
    let textEn: String
    let textDe: String
}

let tutorial: [TutorialPage] = [
    TutorialPage(image: UIImage(named: "Icon")!,
                 textEn: "Welcome to TimeTranslator!\nThis app allows you to experience various scenarios in a pace of your choice.",
                 textDe: "Willkommen bei TimeTranslator!\nMit dieser App kannst du verschiedene Szenarien in einer Geschwindigkeit deiner Wahl erleben."),
    TutorialPage(image: UIImage(named: "")!,
                 textEn: "First, you pick a scenario...",
                 textDe: "Wähle zuerst ein Szenario..."),
    TutorialPage(image: UIImage(named: "")!,
                 textEn: "...then, decide how long you want it to run.",
                 textDe: "...und anschließend die Echtzeit, in der du es erleben willst."),
    TutorialPage(image: UIImage(named: "")!,
                 textEn: "While time is passing by, the scenario proceeds and you experience all the scenario’s events.",
                 textDe: "Während die Zeit verstreicht, schreitet das Szenario voran und du erlebst nach und nach die Events, die das Szenario enthält."),
    TutorialPage(image: UIImage(named: "")!,
                 textEn: "If the app is minimized, the scenario continues and TimeTranslator notifies you when something important happens.",
                 textDe: "Wenn du die App minimierst läuft das Szenario weiter und TimeTranslator benachrichtigt dich, sobald etwas Wichtiges passiert."),
    TutorialPage(image: UIImage(named: "Icon")!,
                 textEn: "Just pick a scenario and go! Have a good time exploring!",
                 textDe: "Wähle gleich ein Szenario aus und leg los, viel Spaß beim Entdecken!")
]
