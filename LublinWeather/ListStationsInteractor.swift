//
//  ListStationsInteractor.swift
//  LublinWeather
//
//  Created by Damian Rzeszot on 15/09/16.
//  Copyright © 2016 Piotr Woloszkiewicz. All rights reserved.
//



protocol ListStationsProvider {
    func getStations() -> [WeatherStation]
}



private let mainURL = "http://212.182.4.252/"

private func mainURLWithStationParam(stationParam: String) -> String {
    return mainURL + stationParam
}



class ListStationsInteractor: ListStationsProvider {


    func getStations() -> [WeatherStation] {
        return weatherStationList
    }

    private let weatherStationList = [
        WeatherStation(name: "Lublin - Plac Litewski", ip: mainURLWithStationParam("data.php?s=16")),
        WeatherStation(name: "Lublin - Ogród Botaniczny", ip: mainURLWithStationParam("data.php?s=10")),
        WeatherStation(name: "Lublin - MPWiK Zemborzycka", ip: mainURLWithStationParam("data.php?s=17")),
        WeatherStation(name: "Lublin - MPWiK Hajdów", ip: mainURLWithStationParam("data2.php?s=18")),
        WeatherStation(name: "Lubartów", ip: mainURLWithStationParam("data.php?s=19")),
        WeatherStation(name: "Guciów", ip: mainURLWithStationParam("data.php?s=11")),
        WeatherStation(name: "Florianka", ip: mainURLWithStationParam("data2.php?s=12")),
        WeatherStation(name: "Łuków", ip: mainURLWithStationParam("data2.php?s=13"))
    ]

}
