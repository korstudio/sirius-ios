//
//  HomeViewModel.swift
//  SiriusiOS
//
//  Created by Methas Tariya on 31/5/23.
//

import Foundation
import RxCocoa
import RxSwift

enum HomeError: Error {
    case dataError
}

final class HomeViewModel: BaseViewModel {
    // filtering state enum
    enum FilterState {
        case none
        case filtered
    }
    // TODO: consider removing this (or not)
    weak var delegate: HomeDelegate?

    // store all data in a dictionary
    private var cities: [String: City] = [:]
    
    // store keys (ie. "City, CO") as filtering keys
    // `citiesSet` stores all keys
    private var citiesSet: Set<String> = []
    private var filteredCities: Set<String> = []

    // filtering state
    private var filterState: FilterState = .none
    
    // keyword as a publish subject, indefinitely broadcast value
    private var keyword: PublishSubject<String> = .init()
    private let disposeBag: DisposeBag = .init()

    var numOfCities: Int {
        if filterState == .filtered {
            return filteredCities.count
        }

        return cities.count
    }

    func didLoad() {
        loadData()
            .subscribe(on: MainScheduler.asyncInstance)
            .subscribe { [weak self] _ in
                self?.delegate?.displayData()
            }
            .disposed(by: disposeBag)
    }

    func observeFilter(next: @escaping (Set<String>) -> ()) {
        // after receiving new keyword, do filtering
        // receiving next(:) from view as a callback
        // so view won't have to do a subscription
        keyword
            .subscribe(on: MainScheduler.asyncInstance)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] keyword in
                self?.doFilter(keyword)
                if self?.filterState == .filtered,
                   let set = self?.filteredCities {
                    next(set)
                } else if let all = self?.citiesSet {
                    next(all)
                }
            }
            .disposed(by: disposeBag)
    }

    func filter(with keyword: String = "") {
        self.keyword.onNext(keyword)
    }

    func getCity(with key: String) -> City? {
        cities[key]
    }
}

private extension HomeViewModel {
    func loadData() -> Single<Void> {
       Single<Void>.create { [weak self] single in
            let decoder = JSONDecoder()
            guard let url = Bundle.main.url(forResource: "cities", withExtension: "json"),
                  let data = try? Data(contentsOf: url),
                  let fileContent: [City] = try? decoder.decode([City].self, from: data)
            else {
                return Disposables.create()
            }

           self?.cities = [:]
           self?.citiesSet = []
           self?.filteredCities = []

            fileContent.forEach { city in
                let key = "\(city.name), \(city.country.uppercased())"
                self?.cities[key] = city
                self?.citiesSet.insert(key)
            }

           single(.success(()))
           return Disposables.create()
        }
    }
    
    func doFilter(_ keyword: String) {
        if keyword.isEmpty {
            filterState = .none
            filteredCities = []
            return
        }
        
        let subject: Set<String>
        if filterState == .filtered {
            subject = filteredCities
        } else {
            subject = citiesSet
        }
        
        filteredCities = subject.filter { s in
            s.lowercased().contains(keyword.lowercased())
        }
        
        filterState = .filtered
    }
}
