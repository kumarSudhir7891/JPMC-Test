//
//  ViewControllerViewModel.swift
//  JPMC Test
//
//  Created by Sudhir Kumar on 07/01/19.
//  Copyright © 2019 Sudhir Kumar. All rights reserved.
//

import UIKit

class ViewControllerViewModel:ClassName {
    var fetchData : ((DataSourceStandard<BaseConfiguratorSection>) -> Void)!
    var dataSource : DataSourceStandard<BaseConfiguratorSection> = DataSourceStandard<BaseConfiguratorSection>() {
        didSet {
            if let fetchData = fetchData {
                DispatchQueue.main.async {
                    fetchData(self.dataSource)
                }
            }
        }
    }
    
    func resetDataSource()  {
        self.dataSource = DataSourceStandard<BaseConfiguratorSection>()
    }
    func getPlanetDetails(completion:@escaping(ServiceError?)->Void){
        
        let service = GetPlanetDetailsService(callerName: self)
        let requestDto = GetRequestDTO<EmptyQueryParameter>(url: "https://swapi.co/api/planets/", queryParameter: nil)
        service.getRequest(requestDto: requestDto, responseDto: PlanetDetails.self) {[weak self] (result) in
            if let self  = self {
                var errorResult : ServiceError?
                switch result {
                case .Success(let response):
                    self.setPlanetToLocalStorage(planet: response)
                    self.dataSource = self.prepareDataSource(planets: response.results)
                case .Failure(let error):
                    errorResult = error
                    if let details =  self.getPlanetfromLocalStorage() {
                        self.dataSource = self.prepareDataSource(planets: details.results)
                    }
                }
                DispatchQueue.main.async {
                    completion(errorResult)
                }
            }
            
        }
    }
    
    let planetFileName = "Planet"
    
    
    private func setPlanetToLocalStorage(planet : PlanetDetails){
    _ = FolderName.PlanetPath.createFolder(directory: .documentDirectory)
     let path = FolderName.PlanetPath.getFilePath(fileName: planetFileName, directory: .documentDirectory)
     FileManager.save(data: planet, filePath: path)
    }
    
    
   private func getPlanetfromLocalStorage() -> PlanetDetails? {
      let path = FolderName.PlanetPath.getFilePath(fileName: planetFileName, directory: .documentDirectory)
      return FileManager.retrieve(forFilePath: path)
    }
    
    
    private func prepareDataSource(planets : [Result]) -> DataSourceStandard<BaseConfiguratorSection> {
        let dataSource = DataSourceStandard<BaseConfiguratorSection>()
        let section = BaseConfiguratorSection()
        
        for planet in planets {
            let configurator = TableItemConfigurator<PlanetNameTableViewCell, PlanetModelProtocol>(modelData: PlanetModel(name : planet.name))
            section.items.append(configurator)
        }
        if section.items.count != 0 {
            dataSource.sections.append(section)
        }
        return dataSource
    }
   
}
