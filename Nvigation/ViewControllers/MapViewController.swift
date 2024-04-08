//
//  MapViewController.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 18.03.2024.
//

import UIKit
import MapKit
import CoreLocation

final class MapViewController: UIViewController {
    
    var locationService = LocationService()
    var destinationCoordinate: CLLocationCoordinate2D?
    
    //MARK: - UI
    
    private let mapView: MKMapView = {
        let map = MKMapView()
        map.showsUserLocation = true
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    private let clearButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("Clear", comment: "Очистить"), for: .normal)
        button.backgroundColor = .black
        button.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        button.layer.cornerRadius = 4
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        
        return button
    }()
    
    private let buildRouteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("Route", comment: "Маршрут"), for: .normal)
        button.backgroundColor = .black
        button.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        button.layer.cornerRadius = 4
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        
        return button
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    
    private let locationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "location.fill"), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let segmentedControl: UISegmentedControl = {
        let items = [NSLocalizedString("Standart", comment: "Обычный"), NSLocalizedString("Satellite", comment: "Спутник"), NSLocalizedString("Hybrid", comment: "Гибрид")]
        let segmentedControl = UISegmentedControl(items: items)
        
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        return segmentedControl
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(mapView)
        view.addSubview(clearButton)
        view.addSubview(buildRouteButton)
        view.addSubview(segmentedControl)
        view.addSubview(locationButton)
        view.addSubview(searchButton)
        
        setupConstraints()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationService.requestAuthorization()
        locationService.startUpdatingLocation()
    }
    
    //MARK: - Methods
    
    private func setupUI() {
        mapView.delegate = self
        
        //Actions
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        mapView.addGestureRecognizer(longPressGesture)
        
        clearButton.addTarget(self, action: #selector(clearPins), for: .touchUpInside)
        buildRouteButton.addTarget(self, action: #selector(buildRoute), for: .touchUpInside)
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        locationButton.addTarget(self, action: #selector(centerMapOnUser), for: .touchUpInside)
        searchButton.addTarget(self, action: #selector(searchLocation), for: .touchUpInside)
        
        // Location service delegate
        locationService.delegate = self
    }
    
    private func setupConstraints() {
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        clearButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-20)
        }
        buildRouteButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
        }
        segmentedControl.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(80)
            make.right.equalToSuperview().offset(-10)
            make.left.equalToSuperview().offset(10)
            make.height.equalTo(40)
        }
        locationButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(45)
            make.centerX.equalTo(buildRouteButton.snp.trailing).offset(20)
        }
        searchButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(45)
            make.centerX.equalTo(clearButton.snp.leading).offset(-20)
        }
    }
    
    private func showLocation(_ coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(annotation)
        
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
    }
    
    @objc private func searchLocation() {
        let alertController = UIAlertController(title: NSLocalizedString("Input coordinates", comment: "Введите координаты"), message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = NSLocalizedString("Latitude", comment: "Широта")
            textField.keyboardType = .decimalPad
        }
        alertController.addTextField { textField in
            textField.placeholder = NSLocalizedString("Longitude", comment: "Долгота")
            textField.keyboardType = .decimalPad
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Отмена"), style: .cancel)
        let okAction = UIAlertAction(title: "ОК", style: .default) { [weak self] _ in
            guard let latitudeText = alertController.textFields?.first?.text,
                  let longitudeText = alertController.textFields?.last?.text,
                  let latitude = Double(latitudeText),
                  let longitude = Double(longitudeText) else { return }
            
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            self?.showLocation(coordinate)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        present(alertController, animated: true)
    }
    
    private func showLocationAccessDeniedAlert() {
        let alertController = UIAlertController(title: NSLocalizedString("Location Access Denied", comment: "Доступ к геолокации запрещен"),
                                                message: NSLocalizedString("Please allow access to your location in Settings to use this feature.", comment: "Дайте разрешение на использование локации, чтобы использовать карту"),
                                                preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: NSLocalizedString("Settings", comment: "Настройки"), style: .default) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Отмена"), style: .cancel)
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .satellite
        case 2:
            mapView.mapType = .hybrid
        default:
            break
        }
    }
    
    @objc private func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let touchPoint = gestureRecognizer.location(in: mapView)
            let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)

            mapView.removeAnnotations(mapView.annotations)
       
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            
            mapView.addAnnotation(annotation)
            
            destinationCoordinate = coordinate
            
            buildRouteButton.isEnabled = true
        }
    }

    
    @objc private func clearPins() {
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)

        buildRouteButton.isEnabled = false
    }
    
    @objc private func buildRoute() {
        guard let destinationCoordinate = destinationCoordinate else { return }
    
        let request = MKDirections.Request()
        request.source = MKMapItem.forCurrentLocation()
    
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate)
        request.destination = MKMapItem(placemark: destinationPlacemark)
    
        request.transportType = .automobile

        let directions = MKDirections(request: request)

        directions.calculate { [weak self] (response, error) in
            guard let self = self else { return }
            if let error = error {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: NSLocalizedString("Error", comment: "Ошибка"), message: NSLocalizedString("Can't find the way: ", comment: "Не могу построить маршрут: ") + "\(error.localizedDescription)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "ОК", style: .default))
                    self.present(alert, animated: true)
                }
            } else if let response = response {
                DispatchQueue.main.async {
                    self.mapView.removeOverlays(self.mapView.overlays)
                    
                    for route in response.routes {
                        self.mapView.addOverlay(route.polyline)
                        self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                    }
                }
            }
        }
    }
    
    @objc private func centerMapOnUser() {
        if let userLocation = mapView.userLocation.location?.coordinate {
            let region = MKCoordinateRegion(center: userLocation, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true)
        }
    }
}

//MARK: - Extensions

extension MapViewController: LocationServiceDelegate {
    func locationService(_ service: LocationService, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
    }

    func locationService(_ service: LocationService, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationService.startUpdatingLocation()
        } else {
            showLocationAccessDeniedAlert()
        }
    }
}



extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .systemRed
        renderer.lineWidth = 4.0
        return renderer
    }
}
