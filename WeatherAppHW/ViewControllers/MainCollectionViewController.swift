//
//  MainCollectionViewController.swift
//  WeatherAppHW
//
//  Created by mac on 19.06.2023.
//

import UIKit

//private let reuseIdentifier = "userAction"

class MainCollectionViewController: UICollectionViewController {
    private let userActions = UserAction.allCases
    
     // MARK: - Navigation
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        userActions.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userAction", for: indexPath) as? UserActionCell else { return UICollectionViewCell() }
        
        cell.userActionLabel.text = userActions[indexPath.item].title
        
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let userAction = userActions[indexPath.item]
        switch userAction {
        case .fetchCurrentWeather: fetchCurrentWeather()
        case .fetchLastTenDaysWeather:
            fetchCurrentWeather()
        }
    }
    
    
    // MARK: - Private Methods
    private func showAlert(withStatus status: Alert) {
        let alert = UIAlertController(title: status.title, message: status.message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        DispatchQueue.main.async { [unowned self] in
            present(alert, animated: true)
        }
    }
}
    // MARK: - Enums
    // создаем возможные названия кнопок
    enum Link {
        case currentWeatherURL
        case lastTenDaysWeaterURL
        
        var url: URL {
            switch self {
            case .currentWeatherURL:
                return URL(string: "https://api.open-meteo.com/v1/forecast?latitude=52.52&longitude=13.41&current_weather=true&hourly=temperature_2m,relativehumidity_2m,windspeed_10m")!
            case .lastTenDaysWeaterURL:
                return URL(string: "https://api.open-meteo.com/v1/forecast?latitude=52.52&longitude=13.41&past_days=10&hourly=temperature_2m,relativehumidity_2m,windspeed_10m")!
                
            }
        }
    }
    enum UserAction: CaseIterable {
        case fetchCurrentWeather
        case fetchLastTenDaysWeather
        
        var title: String {
            switch self {
            case .fetchCurrentWeather:
                return "Show info about current weather."
            case .fetchLastTenDaysWeather:
                return "Info about last 10 days weather."
            }
        }
    }

enum Alert {
    case success
    case failed
    
    var title: String {
        switch self {
        case .success:
            return "Success"
        case .failed:
            return "Failed"
        }
    }
    
    var message: String {
        switch self {
        case .success:
            return "You can see the results in the Debug area"
        case .failed:
            return "You can see error in the Debug area"
        }
    }
}


    // MARK: UICollectionViewDelegate

    // MARK: - Networking
    extension MainCollectionViewController {
        private func fetchCurrentWeather() {
            URLSession.shared.dataTask(with: Link.currentWeatherURL.url) { [weak self] data, _, error in
                guard let data else {
                    print(error?.localizedDescription ?? "No error description")
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let weatherCurrent = try decoder.decode(Weather.self, from: data)
                    print(weatherCurrent)
                    self?.showAlert(withStatus: .success)
                } catch {
                    print(error.localizedDescription)
                    self?.showAlert(withStatus: .failed)
                }
                
            }.resume()
        }

        private func fetchTenDaysWeather() {
            URLSession.shared.dataTask(with: Link.lastTenDaysWeaterURL.url) { [weak self] data, _, error in
                guard let data else {
                    print(error?.localizedDescription ?? "No error description")
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let weatherTenDays = try decoder.decode(WeatherTenDays.self, from: data)
                    print(weatherTenDays.hourly.relativehumidity2M)
                    self?.showAlert(withStatus: .success)
                } catch {
                    print(error.localizedDescription)
                    self?.showAlert(withStatus: .failed)
                }
                
            }.resume()
        }
        
}
