//
//  GetPlanetDetailsService.swift
//  JPMC Test
//
//  Created by Sudhir Kumar on 08/01/19.
//  Copyright © 2019 Sudhir Kumar. All rights reserved.
//

import UIKit


struct PlanetDetails : Codable {
  var results :[Result]
}
struct Result : Codable {
   var name : String
}


class GetPlanetDetailsService: GetBaseService<GetRequestDTO<EmptyQueryParameter>,PlanetDetails> {

}
