//
//  Info.swift
//  LublinWeather
//
//  Created by Damian Rzeszot on 03/10/2019.
//  Copyright © 2019 Piotr Woloszkiewicz. All rights reserved.
//

import SwiftUI

struct Info: View {

    var body: some View {
        VStack {
            Text("Dane pogodowe są własnością Zakładu Meteorologii i Klimatologii Uniwersytetu Marii Curie-Skłodowskiej w Lublinie, aplikacja powstała jedynie, aby ułatwić szybki dostęp do ogólnodostępnych danych - nie odpowiadam za ich poprawność, brak oraz ewentualną niedostępność. Jest to aplikacjanon-profit, nie czerpię z niej żadnych korzyści finansowych.")

            more
                .padding(.vertical, 20)

            Text("Prezentowane dane są danymi pochodzącymi z mierników automatycznych i nie są weryfikowane przez człowieka. Dane te nie mogą być wykorzystywane jako materiał dowodowy w sprawach roszczeniowych.")

            Spacer()
        }
        .padding(20)
        .navigationBarTitle("Informacje")
    }

    // MARK: -

    private var more: some View {
        Button(action: open, label: {
            Text("Więcej")
        })
    }

    private func open() {
        UIApplication.shared.open(URL(string: "https://www.umcs.pl/pl/pogoda-w-regionie,2812.htm")!, options: [:]) { success in
            if !success {
                // TODO: report failure
            }
        }
    }

}
