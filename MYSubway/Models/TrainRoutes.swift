//
//  TrainRoutes.swift
//  MYSubway
//
//  Created by Mahathir Rojan on 11/15/24.
//
import Foundation

class TrainRoutes {
    static let shared = TrainRoutes()

    private var routesByStation: [String: [String]] = [:]
    private init (){
        loadRoutes()
    }
    func loadRoutes() {
        routesByStation = [
            // 1 Train (Broadway–7th Avenue Local)
            "1": [
                "Van Cortlandt Park–242nd Street", "238th Street", "231st Street", "Marble Hill–225th Street",
                "215th Street", "207th Street", "Dyckman Street", "191st Street", "181st Street",
                "168th Street", "157th Street", "145th Street", "137th Street–City College",
                "125th Street", "116th Street–Columbia University", "Cathedral Parkway–110th Street",
                "103rd Street", "96th Street", "86th Street", "79th Street", "72nd Street",
                "66th Street–Lincoln Center", "59th Street–Columbus Circle", "50th Street",
                "Times Square–42nd Street", "34th Street–Penn Station", "28th Street", "23rd Street",
                "18th Street", "14th Street", "Christopher Street–Sheridan Square", "Houston Street",
                "Canal Street", "Franklin Street", "Chambers Street", "Rector Street", "South Ferry"
            ],
            // 2 Train (7th Avenue Express)
            "2": [
                "Wakefield–241st Street", "Nereid Avenue", "233rd Street", "225th Street",
                "219th Street", "Gun Hill Road", "Burke Avenue", "Allerton Avenue",
                "Pelham Parkway", "Bronx Park East", "East 180th Street",
                "West Farms Square–East Tremont Avenue", "174th Street", "Freeman Street",
                "Simpson Street", "Intervale Avenue", "Prospect Avenue", "Jackson Avenue",
                "3rd Avenue–149th Street", "149th Street–Grand Concourse", "135th Street",
                "125th Street", "116th Street", "Central Park North–110th Street", "96th Street",
                "72nd Street", "Times Square–42nd Street", "34th Street–Penn Station",
                "14th Street", "Chambers Street", "Park Place", "Fulton Street", "Wall Street",
                "Clark Street", "Borough Hall", "Hoyt Street", "Nevins Street",
                "Atlantic Avenue–Barclays Center", "Bergen Street", "Grand Army Plaza",
                "Eastern Parkway–Brooklyn Museum", "Franklin Avenue–Medgar Evers College",
                "President Street–Medgar Evers College", "Sterling Street", "Winthrop Street",
                "Church Avenue", "Beverly Road", "Newkirk Avenue–Little Haiti",
                "Flatbush Avenue–Brooklyn College"
            ],
            // 3 Train (7th Avenue Express)
            "3": [
                "New Lots Avenue", "Livonia Avenue", "Sutter Avenue–Rutland Road",
                "Saratoga Avenue", "Rockaway Avenue", "Junius Street", "Pennsylvania Avenue",
                "Van Siclen Avenue", "135th Street", "125th Street", "116th Street",
                "Central Park North–110th Street", "96th Street", "72nd Street",
                "Times Square–42nd Street", "34th Street–Penn Station", "14th Street",
                "Chambers Street", "Park Place", "Fulton Street", "Wall Street"
            ],
            // 4 Train (Lexington Avenue Express)
            "4": [
                "Woodlawn", "Mosholu Parkway", "Bedford Park Boulevard–Lehman College",
                "Kingsbridge Road", "Fordham Road", "183rd Street", "Burnside Avenue",
                "176th Street", "Mt. Eden Avenue", "170th Street", "167th Street",
                "161st Street–Yankee Stadium", "149th Street–Grand Concourse", "125th Street",
                "86th Street", "59th Street", "Grand Central–42nd Street",
                "14th Street–Union Square", "Brooklyn Bridge–City Hall", "Borough Hall",
                "Nevins Street", "Atlantic Avenue–Barclays Center",
                "Franklin Avenue–Medgar Evers College", "Utica Avenue", "New Lots Avenue"
            ],
            // 5 Train (Lexington Avenue Express)
            "5": [
                "Eastchester–Dyre Avenue", "Baychester Avenue", "Gun Hill Road", "Pelham Parkway",
                "Morris Park", "East 180th Street", "West Farms Square–East Tremont Avenue",
                "174th Street", "Freeman Street", "Simpson Street", "Intervale Avenue",
                "Prospect Avenue", "Jackson Avenue", "3rd Avenue–149th Street",
                "149th Street–Grand Concourse", "125th Street", "86th Street",
                "59th Street", "Grand Central–42nd Street", "14th Street–Union Square",
                "Brooklyn Bridge–City Hall", "Borough Hall", "Nevins Street",
                "Atlantic Avenue–Barclays Center", "Franklin Avenue–Medgar Evers College",
                "Utica Avenue", "New Lots Avenue"
            ],
            // 6 Train (Lexington Avenue Local/Pelham Express)
            "6": [
                "Pelham Bay Park", "Buhre Avenue", "Middletown Road", "Westchester Square–East Tremont Avenue",
                "Zerega Avenue", "Castle Hill Avenue", "Parkchester", "St. Lawrence Avenue",
                "Morrison Avenue–Soundview", "Elder Avenue", "Whitlock Avenue", "Hunts Point Avenue",
                "Longwood Avenue", "East 149th Street", "East 143rd Street–St. Mary’s Street",
                "Cypress Avenue", "Brook Avenue", "3rd Avenue–138th Street", "125th Street",
                "116th Street", "110th Street", "103rd Street", "96th Street", "86th Street",
                "77th Street", "68th Street–Hunter College", "59th Street", "51st Street",
                "Grand Central–42nd Street", "33rd Street", "28th Street", "23rd Street",
                "14th Street–Union Square", "Astor Place", "Bleecker Street", "Spring Street",
                "Canal Street", "Brooklyn Bridge–City Hall"
            ],
            // 7 Train (Flushing Local and Express)
            "7": [
                "Flushing–Main Street", "Mets–Willets Point", "111th Street", "103rd Street–Corona Plaza",
                "Junction Boulevard", "90th Street–Elmhurst Avenue", "82nd Street–Jackson Heights",
                "74th Street–Broadway", "69th Street", "61st Street–Woodside", "52nd Street",
                "46th Street–Bliss Street", "40th Street–Lowery Street", "33rd Street–Rawson Street",
                "Queensboro Plaza", "Hunters Point Avenue", "Vernon Boulevard–Jackson Avenue",
                "Grand Central–42nd Street", "5th Avenue", "Times Square–42nd Street",
                "34th Street–Hudson Yards"
            ],
            // A Train (8th Avenue Express)
            "A": [
                "Inwood–207th Street", "Dyckman Street", "190th Street", "181st Street", "175th Street",
                "168th Street", "145th Street", "125th Street", "59th Street–Columbus Circle",
                "42nd Street–Port Authority Bus Terminal", "34th Street–Penn Station",
                "23rd Street", "14th Street", "West 4th Street–Washington Square", "Canal Street",
                "Chambers Street", "Fulton Street", "High Street", "Jay Street–MetroTech",
                "Hoyt–Schermerhorn Streets", "Lafayette Avenue", "Clinton–Washington Avenues",
                "Franklin Avenue", "Nostrand Avenue", "Kingston–Throop Avenues", "Utica Avenue",
                "Ralph Avenue", "Rockaway Avenue", "Broadway Junction", "Liberty Avenue",
                "Van Siclen Avenue", "Shepherd Avenue", "Euclid Avenue", "Grant Avenue",
                "Aqueduct Racetrack", "Howard Beach–JFK Airport", "Broad Channel",
                "Beach 67th Street", "Beach 60th Street", "Beach 44th Street", "Beach 36th Street",
                "Beach 25th Street", "Far Rockaway–Mott Avenue"
            ],
            // B Train (6th Avenue Express)
            "B": [
                "Bedford Park Boulevard", "Kingsbridge Road", "Fordham Road", "182nd–183rd Streets",
                "Tremont Avenue", "174th–175th Streets", "170th Street", "167th Street",
                "161st Street–Yankee Stadium", "155th Street", "145th Street", "135th Street",
                "125th Street", "116th Street", "110th Street", "103rd Street", "96th Street",
                "86th Street", "72nd Street", "59th Street–Columbus Circle",
                "47th–50th Streets–Rockefeller Center", "42nd Street–Bryant Park",
                "34th Street–Herald Square", "23rd Street", "14th Street", "West 4th Street–Washington Square",
                "Jay Street–MetroTech", "DeKalb Avenue", "Atlantic Avenue–Barclays Center",
                "7th Avenue", "Prospect Park", "Church Avenue", "Newkirk Plaza",
                "Kings Highway", "Sheepshead Bay", "Brighton Beach"
            ],
            // C Train (8th Avenue Local)
            "C": [
                "168th Street", "163rd Street–Amsterdam Avenue", "155th Street", "145th Street",
                "135th Street", "125th Street", "116th Street", "110th Street", "Cathedral Parkway–110th Street",
                "103rd Street", "96th Street", "86th Street", "81st Street–Museum of Natural History",
                "72nd Street", "59th Street–Columbus Circle", "50th Street",
                "42nd Street–Port Authority Bus Terminal", "34th Street–Penn Station",
                "23rd Street", "14th Street", "West 4th Street–Washington Square", "Spring Street",
                "Canal Street", "Chambers Street", "Fulton Street", "High Street",
                "Jay Street–MetroTech", "Hoyt–Schermerhorn Streets", "Lafayette Avenue",
                "Clinton–Washington Avenues", "Franklin Avenue", "Nostrand Avenue",
                "Kingston–Throop Avenues", "Utica Avenue", "Ralph Avenue", "Rockaway Avenue",
                "Broadway Junction", "Liberty Avenue", "Van Siclen Avenue", "Shepherd Avenue",
                "Euclid Avenue"
            ],
            // D Train (6th Avenue Express)
            "D": [
                "Norwood–205th Street", "Bedford Park Boulevard", "Kingsbridge Road", "Fordham Road",
                "182nd–183rd Streets", "Tremont Avenue", "174th–175th Streets", "170th Street",
                "167th Street", "161st Street–Yankee Stadium", "155th Street", "145th Street",
                "135th Street", "125th Street", "116th Street", "110th Street",
                "Cathedral Parkway–110th Street", "103rd Street", "96th Street", "86th Street",
                "81st Street–Museum of Natural History", "72nd Street", "59th Street–Columbus Circle",
                "47th–50th Streets–Rockefeller Center", "42nd Street–Bryant Park",
                "34th Street–Herald Square", "23rd Street", "14th Street",
                "West 4th Street–Washington Square", "Jay Street–MetroTech", "DeKalb Avenue",
                "Atlantic Avenue–Barclays Center", "Pacific Street", "36th Street", "9th Avenue",
                "Fort Hamilton Parkway", "62nd Street", "New Utrecht Avenue", "Bay Parkway",
                "20th Avenue", "18th Avenue", "79th Street", "86th Street", "Coney Island–Stillwell Avenue"
            ],
            // E Train (8th Avenue Local)
            "E": [
                "Jamaica Center–Parsons/Archer", "Sutphin Boulevard–Archer Avenue–JFK Airport",
                "Briarwood", "Kew Gardens–Union Turnpike", "Forest Hills–71st Avenue",
                "Jackson Heights–Roosevelt Avenue", "74th Street–Broadway", "65th Street",
                "Northern Boulevard", "46th Street", "Steinway Street", "Queens Plaza",
                "Lexington Avenue–53rd Street", "5th Avenue–53rd Street", "7th Avenue",
                "42nd Street–Port Authority Bus Terminal", "34th Street–Penn Station",
                "23rd Street", "14th Street", "West 4th Street–Washington Square",
                "Spring Street", "Canal Street", "Chambers Street", "Fulton Street",
                "World Trade Center"
            ],
            // F Train (6th Avenue Local / Queens Boulevard Express)
            "F": [
                "Jamaica–179th Street", "169th Street", "Parsons Boulevard", "Sutphin Boulevard",
                "Briarwood", "Kew Gardens–Union Turnpike", "Forest Hills–71st Avenue",
                "75th Avenue", "67th Avenue", "63rd Drive–Rego Park", "Woodhaven Boulevard",
                "Grand Avenue–Newtown", "Elmhurst Avenue", "Jackson Heights–Roosevelt Avenue",
                "21st Street–Queensbridge", "Lexington Avenue–63rd Street", "57th Street",
                "47th–50th Streets–Rockefeller Center", "42nd Street–Bryant Park",
                "34th Street–Herald Square", "23rd Street", "14th Street",
                "West 4th Street–Washington Square", "Broadway–Lafayette Street", "2nd Avenue",
                "Delancey Street–Essex Street", "York Street", "Jay Street–MetroTech",
                "Bergen Street", "Carroll Street", "Smith–9th Streets", "4th Avenue–9th Street",
                "7th Avenue", "15th Street–Prospect Park", "Fort Hamilton Parkway",
                "Church Avenue", "Ditmas Avenue", "18th Avenue", "Avenue I", "Bay Parkway",
                "Avenue N", "Avenue P", "Kings Highway", "Avenue U", "Avenue X",
                "Neptune Avenue", "Coney Island–Stillwell Avenue"
            ],
            // G Train (Brooklyn-Queens Crosstown Local)
            "G": [
                "Court Square", "21st Street", "Greenpoint Avenue", "Nassau Avenue",
                "Metropolitan Avenue", "Broadway", "Flushing Avenue", "Myrtle–Willoughby Avenues",
                "Bedford–Nostrand Avenues", "Classon Avenue", "Clinton–Washington Avenues",
                "Fulton Street", "Hoyt–Schermerhorn Streets", "Bergen Street", "Carroll Street",
                "Smith–9th Streets", "4th Avenue–9th Street", "7th Avenue",
                "15th Street–Prospect Park", "Fort Hamilton Parkway", "Church Avenue"
            ],
            // J Train (Nassau Street Express)
            "J": [
                "Jamaica Center–Parsons/Archer", "Sutphin Boulevard–Archer Avenue–JFK Airport",
                "121st Street", "111th Street", "104th Street", "Woodhaven Boulevard",
                "85th Street–Forest Parkway", "75th Street–Elderts Lane", "Cypress Hills",
                "Crescent Street", "Norwood Avenue", "Cleveland Street", "Van Siclen Avenue",
                "Alabama Avenue", "Broadway Junction", "Chauncey Street", "Halsey Street",
                "Gates Avenue", "Kosciuszko Street", "Myrtle Avenue", "Flushing Avenue",
                "Lorimer Street", "Hewes Street", "Marcy Avenue", "Essex Street",
                "Bowery", "Canal Street", "Chambers Street", "Fulton Street", "Broad Street"
            ],
            // L Train (14th Street–Canarsie Local)
            "L": [
                "8th Avenue", "6th Avenue", "Union Square–14th Street", "3rd Avenue",
                "1st Avenue", "Bedford Avenue", "Lorimer Street", "Graham Avenue", "Grand Street",
                "Montrose Avenue", "Morgan Avenue", "Jefferson Street", "DeKalb Avenue",
                "Myrtle–Wyckoff Avenues", "Halsey Street", "Wilson Avenue",
                "Bushwick Avenue–Aberdeen Street", "Broadway Junction", "Atlantic Avenue",
                "Sutter Avenue", "Livonia Avenue", "New Lots Avenue", "East 105th Street",
                "Canarsie–Rockaway Parkway"
            ],
            // N Train (Broadway Express)
            "N": [
                "Astoria–Ditmars Boulevard", "Astoria Boulevard", "30th Avenue", "Broadway",
                "36th Avenue", "39th Avenue–Dutch Kills", "Queensboro Plaza",
                "Lexington Avenue–59th Street", "5th Avenue–59th Street",
                "57th Street–7th Avenue", "Times Square–42nd Street",
                "34th Street–Herald Square", "28th Street", "23rd Street",
                "14th Street–Union Square", "8th Street–NYU", "Canal Street",
                "City Hall", "Cortlandt Street", "Rector Street",
                "Whitehall Street–South Ferry", "Atlantic Avenue–Barclays Center",
                "Union Street", "4th Avenue–9th Street", "Prospect Avenue",
                "25th Street", "36th Street", "45th Street", "53rd Street",
                "59th Street", "8th Avenue", "Fort Hamilton Parkway",
                "New Utrecht Avenue", "18th Avenue", "20th Avenue", "Bay Parkway",
                "Kings Highway", "Avenue U", "86th Street", "Coney Island–Stillwell Avenue"
            ],
            // Q Train (Second Avenue/Brighton Express)
            "Q": [
                "96th Street", "86th Street", "72nd Street", "Lexington Avenue–63rd Street",
                "57th Street–7th Avenue", "Times Square–42nd Street",
                "34th Street–Herald Square", "14th Street–Union Square", "Canal Street",
                "DeKalb Avenue", "Atlantic Avenue–Barclays Center", "7th Avenue",
                "Prospect Park", "Church Avenue", "Beverly Road", "Newkirk Plaza",
                "Kings Highway", "Avenue U", "Neck Road", "Sheepshead Bay",
                "Brighton Beach", "Ocean Parkway", "Coney Island–Stillwell Avenue"
            ],
            // R Train (Broadway Local)
            "R": [
                "Forest Hills–71st Avenue", "67th Avenue", "63rd Drive–Rego Park",
                "Woodhaven Boulevard", "Grand Avenue–Newtown", "Elmhurst Avenue",
                "Jackson Heights–Roosevelt Avenue", "Queens Plaza",
                "Lexington Avenue–59th Street", "5th Avenue–59th Street",
                "57th Street–7th Avenue", "Times Square–42nd Street",
                "34th Street–Herald Square", "28th Street", "23rd Street",
                "14th Street–Union Square", "8th Street–NYU", "Prince Street",
                "Canal Street", "City Hall", "Cortlandt Street", "Rector Street",
                "Whitehall Street–South Ferry", "Court Street", "Jay Street–MetroTech",
                "DeKalb Avenue", "Atlantic Avenue–Barclays Center", "Union Street",
                "4th Avenue–9th Street", "Prospect Avenue", "25th Street",
                "36th Street", "45th Street", "53rd Street", "59th Street",
                "Bay Ridge Avenue", "77th Street", "86th Street", "Bay Ridge–95th Street"
            ],
            // W Train (Broadway Local)
            "W": [
                "Astoria–Ditmars Boulevard", "Astoria Boulevard", "30th Avenue", "Broadway",
                "36th Avenue", "39th Avenue–Dutch Kills", "Queensboro Plaza",
                "Lexington Avenue–59th Street", "5th Avenue–59th Street",
                "57th Street–7th Avenue", "Times Square–42nd Street",
                "34th Street–Herald Square", "28th Street", "23rd Street",
                "14th Street–Union Square", "8th Street–NYU", "Canal Street",
                "City Hall", "Cortlandt Street", "Rector Street", "Whitehall Street–South Ferry"
            ],
            // S Train (Shuttle Services)
            // S Train (42nd Street Shuttle)
            "S": [
                "Times Square–42nd Street", "Grand Central–42nd Street"
            ],
            // SF Train (Franklin Avenue Shuttle)
            "SF": [
                "Franklin Avenue–Medgar Evers College", "Park Place", "Botanic Garden", "Prospect Park"
            ],
            // SR Train (Rockaway Park Shuttle)
            "SR": [
                "Broad Channel", "Beach 90th Street", "Beach 98th Street",
                "Beach 105th Street", "Rockaway Park–Beach 116th Street"
            ],
            // Z Train (Nassau Street Express – Limited Service)
            "Z": [
                "Jamaica Center–Parsons/Archer", "Sutphin Boulevard–Archer Avenue–JFK Airport",
                "121st Street", "111th Street", "104th Street", "Woodhaven Boulevard",
                "85th Street–Forest Parkway", "75th Street–Elderts Lane", "Cypress Hills",
                "Crescent Street", "Norwood Avenue", "Cleveland Street", "Van Siclen Avenue",
                "Alabama Avenue", "Broadway Junction", "Chauncey Street", "Halsey Street",
                "Gates Avenue", "Kosciuszko Street", "Myrtle Avenue", "Flushing Avenue",
                "Lorimer Street", "Hewes Street", "Marcy Avenue", "Essex Street",
                "Bowery", "Canal Street", "Chambers Street", "Fulton Street", "Broad Street"
            ]
        ]
    }

    func routes(for stationName: String) -> [String] {
        var matchingRoutes: [String] = []

        for (train, stations) in routesByStation {
            if stations.contains(stationName) {
                matchingRoutes.append(train)
            }
        }

        return matchingRoutes
    }

    func allStations() -> [String] {
        var stationSet: Set<String> = []
        for stations in routesByStation.values {
            stationSet.formUnion(stations)
        }
        return Array(stationSet).sorted()
    }
}
