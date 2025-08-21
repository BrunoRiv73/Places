//
//  ViewModel.swift
//  Places
//
//  Created by Elvia Rosas on 18/08/25.
//

import Foundation

@Observable
@MainActor
class PlaceViewModel {
    
    var arrPlaces = [Place]()
    
    init() {
        
        Task {
            try await loadAPI()
        }

    }

    func load<T: Decodable>(_ filename: String) -> T {
        let data: Data

        guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
            else {
                fatalError("Couldn't find \(filename) in main bundle.")
        }

        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        }

        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
        }
    }
    
    func loadAPI() async throws {
        //1. URL
        guard let url = URL(string: "https://tec-actions-test-production.up.railway.app/places") else {
            print("Invalid URL")
            return
        }
        
        //2.URLRequest
        let urlRequest = URLRequest(url: url)
        
        //3. URL Call
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else{
            print("error")
            return
        }
        
        //4. Decode
        let results = try JSONDecoder().decode([Place].self, from: data)

        //5. Update Place Array
        self.arrPlaces = results
        
    }
    
}
