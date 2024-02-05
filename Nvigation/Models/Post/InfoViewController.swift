//
//  InfoViewController.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 02.10.2023.
//

import UIKit
import StorageService

class InfoViewController: UIViewController {
    
    private let lock = NSLock()
    private var residents: [Resident] = []
    private let networkClient: INetworkClient = NetworkClient()
    
    // MARK: - UI Elements
    
    private lazy var showAlertButton: CustomButton = {
        let button = CustomButton(title: "Show Alert", titleColor: .white) { [weak self] in
            self?.showInfoAlert()
        }
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()
        label.textAlignment = .center
        return label
    }()
    
    private lazy var planetLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()
        label.textAlignment = .center
        return label
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(
            frame: .zero,
            style: .grouped
        )
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "residentCell")
        return tableView
    }()
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        view.addSubview(showAlertButton)
        view.addSubview(titleLabel)
        view.addSubview(planetLabel)
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setupConstraints()
        fetchAndDisplayTitle()
        fetchPlanetData()
    }
    
    // MARK: - Private
    
    private func setupConstraints() {
        showAlertButton.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        planetLabel.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            showAlertButton.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            showAlertButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            showAlertButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            showAlertButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: showAlertButton.bottomAnchor, constant: 20),
            titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            
            planetLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            planetLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            planetLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            planetLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: planetLabel.bottomAnchor, constant: 20),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
        ])
    }
    
    private func createTableViewHeader() -> UIView {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.systemBlue

        let headerLabel = UILabel()
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.font = UIFont.boldSystemFont(ofSize: 16)
        headerLabel.textColor = UIColor.white
        headerLabel.text = "Tatooine residents names"

        headerView.addSubview(headerLabel)

        // Constraints
        NSLayoutConstraint.activate([
            headerLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 15),
            headerLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -15)
        ])

        return headerView
    }

    
    // MARK: - Parsing
    
    private func fetchAndDisplayTitle() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos/36") else { return }
        let urlRequest = URLRequest(url: url)
        
        networkClient.request(with: urlRequest) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                do {
                    if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        if let title = jsonObject["title"] as? String {
                            DispatchQueue.main.async {
                                self.titleLabel.text = title
                            }
                        }
                    }
                } catch {
                    print("Error parsing JSON: \(error)")
                }
            case .failure(let error):
                print("Error fetching data: \(error)")
            }
        }
    }
    
    private func fetchPlanetData() {
        guard let url = URL(string: "https://swapi.dev/api/planets/1") else { return }
        
        let urlRequest = URLRequest(url: url)
        
        networkClient.request(with: urlRequest) { [weak self] result in
            switch result {
            case .success(let data):
                DataMapper.map(Planet.self, from: data) { (result: Result<Planet, NetworkError>) in
                    switch result {
                    case .success(let planet):
                        self?.planetLabel.text = "Orbital Period: \(planet.orbitalPeriod)"
                        self?.fetchResidents(for: planet)
                    case .failure(let error):
                        print("Error decoding JSON: \(error)")
                    }
                }
            case .failure(let error):
                print("Error fetching data: \(error)")
            }
        }
    }

    
    private func fetchResidents(for planet: Planet) {
        let group = DispatchGroup()

        for url in planet.residents {
            guard let residentUrl = URL(string: url) else { continue }
            let urlRequest = URLRequest(url: residentUrl)

            group.enter()
            networkClient.request(with: urlRequest) { [weak self] result in
                switch result {
                case .success(let data):
                    DataMapper.map(Resident.self, from: data) { result in
                        defer { group.leave() }
                        switch result {
                        case .success(let resident):
                            print("Fetching resident data from URL: \(residentUrl)")
                            self?.appendResident(resident)
                        case .failure(let error):
                            print("Error mapping data: \(error)")
                        }
                    }
                case .failure(let error):
                    print("Error fetching data: \(error)")
                    group.leave()
                }
            }
        }
        group.notify(queue: .main) {
            self.tableView.reloadData()
        }
    }

    
    private func appendResident(_ resident: Resident) {
        lock.lock()
        self.residents.append(resident)
        lock.unlock()
    }

    
    // MARK: - Actions
    
    @objc func showInfoAlert() {
        let alertController = UIAlertController(
            title: "Alert Window",
            message: "Alert Message",
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            print("OK button tapped")
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Cancel button tapped")
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - InfoViewController Extensions

extension InfoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        createTableViewHeader()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return residents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "residentCell", for: indexPath)
        cell.textLabel?.text = residents[indexPath.row].name
        return cell
    }
}
