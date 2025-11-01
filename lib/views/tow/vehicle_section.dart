import 'package:flutter/material.dart';
import '../../models/tow.dart';

class VehicleSection extends StatefulWidget {
  const VehicleSection({
    super.key,
    required this.tow,
  });

  final Tow tow;

  @override
  State<VehicleSection> createState() => _VehicleSectionState();
}

class _VehicleSectionState extends State<VehicleSection> {
  late String? _selectedYear;
  late String? _selectedMake;
  String? _selectedModel;
  String? _selectedState;

  late TextEditingController _licensePlateController;

  // === Make → Models map (provided) ===
  // Keep this near the widget so it can be reused/tested; you can move it to a constants file later.
  final Map<String, List<String>> modelMap = {
    'Acura': ['ADX', 'CL', 'ILX', 'Integra', 'Legend', 'MDX', 'NSX', 'RDX', 'RL', 'RLX', 'RSX', 'SLX', 'TL', 'TLX', 'TSX', 'Vigor', 'ZDX'],
    'Alfa Romeo': ['164', '4C', '8C Competizione', 'Giulia', 'GTV-6', 'Milano', 'Spider', 'Stelvio', 'Tonale'],
    'Aston Martin': ['DB11', 'DB12', 'DB7', 'DB9', 'DBS', 'DBX', 'Lagonda', 'Rapide', 'Rapide S', 'V12 Vantage', 'V8 Vantage', 'Valiant', 'Valour', 'Vanquish', 'Virage'],
    'Audi': ['100', '200', '4000', '5000', '80', '90', 'A3', 'A4', 'A5', 'A6', 'A6 e-tron', 'A7', 'A8', 'allroad', 'Cabriolet', 'Coupe', 'e-tron', 'e-tron GT', 'e-tron S', 'Q3', 'Q4 e-tron', 'Q5', 'Q6 e-tron', 'Q7', 'Q8', 'Q8 e-tron', 'Quattro', 'R8', 'RS 3', 'RS 4', 'RS 5', 'RS 6', 'RS 7', 'RS e-tron GT', 'RS Q8', 'S e-tron GT', 'S3', 'S4', 'S5', 'S6', 'S6 e-tron', 'S7', 'S8', 'SQ5', 'SQ6 e-tron', 'SQ7', 'SQ8', 'SQ8 e-tron', 'TT', 'TT RS', 'TTS', 'V8 Quattro'],
    'Bentley': ['Arnage', 'Azure', 'Bentayga', 'Brooklands', 'Continental', 'Eight', 'Flying Spur', 'Mulsanne', 'Turbo R'],
    'BMW': ['1 Series M', '128i', '135i', '135is', '228 Gran Coupe', '228 xDrive Gran Coupe', '228i', '228i Gran Coupe', '228i xDrive', '228i xDrive Gran Coupe', '230i', '230i xDrive', '318i', '318iS', '318ti', '320i', '320i xDrive', '323ci', '323i', '323is', '325', '325Ci', '325e', '325es', '325i', '325is', '325iX', '325xi', '328Ci', '328d', '328d xDrive', '328i', '328i Gran Turismo xDrive', '328i xDrive', '328iS', '328xi', '330Ci', '330e', '330e xDrive', '330i', '330i Gran Turismo xDrive', '330i xDrive', '330xi', '335d', '335i', '335i Gran Turismo xDrive', '335i xDrive', '335is', '335xi', '340i', '340i Gran Turismo xDrive', '340i xDrive', '428i', '428i Gran Coupe', '428i Gran Coupe xDrive', '428i xDrive', '430i', '430i Gran Coupe', '430i Gran Coupe xDrive', '430i xDrive', '435i', '435i Gran Coupe', '435i Gran Coupe xDrive', '435i xDrive', '440i', '440i Gran Coupe', '440i Gran Coupe xDrive', '440i xDrive', '524td', '525i', '525xi', '528e', '528i', '528i xDrive', '528xi', '530e', '530e xDrive', '530i', '530i xDrive', '530xi', '533i', '535d', '535d xDrive', '535i', '535i Gran Turismo', '535i Gran Turismo xDrive', '535i xDrive', '535xi', '540d xDrive', '540i', '540i xDrive', '545i', '550e xDrive', '550i', '550i Gran Turismo', '550i Gran Turismo xDrive', '550i xDrive', '633CSi', '635CSi', '640i', '640i Gran Coupe', '640i Gran Coupe xDrive', '640i Gran Turismo xDrive', '640i xDrive', '645Ci', '650i', '650i Gran Coupe', '650i Gran Coupe xDrive', '650i xDrive', '733i', '735i', '735iL', '740e xDrive', '740i', '740i xDrive', '740iL', '740Ld xDrive', '740Li', '740Li xDrive', '745e xDrive', '745i', '745Li', '750e xDrive', '750i', '750i xDrive', '750iL', '750Li', '750Li xDrive', '760i', '760i xDrive', '760Li', '840Ci', '840i', '840i Gran Coupe', '840i Gran Coupe xDrive', '840i xDrive', '850Ci', '850CSi', '850i', 'ActiveHybrid 3', 'ActiveHybrid 5', 'ActiveHybrid 7', 'ActiveHybrid X6', 'ALPINA B6 xDrive Gran Coupe', 'ALPINA B7', 'ALPINA B7 xDrive', 'ALPINA B8 xDrive Gran Coupe', 'ALPINA XB7', 'i3', 'i4', 'i5', 'i7', 'i8', 'iX', 'L6', 'L7', 'M Coupe', 'M Roadster', 'M2', 'M235i', 'M235i xDrive', 'M235i xDrive Gran Coupe', 'M240i', 'M240i xDrive', 'M3', 'M3 xDrive', 'M340i', 'M340i xDrive', 'M4', 'M4 xDrive', 'M440i', 'M440i Gran Coupe', 'M440i xDrive', 'M440i xDrive Gran Coupe', 'M5', 'M550i xDrive', 'M6', 'M6 Gran Coupe', 'M760i xDrive', 'M8', 'M8 Gran Coupe xDrive', 'M850i Gran Coupe xDrive', 'M850i xDrive', 'X1', 'X2', 'X3', 'X3 M', 'X4', 'X4 M', 'X5', 'X5 M', 'X6', 'X6 M', 'X7', 'XM', 'Z3', 'Z4', 'Z8'],
    'Bugatti': ['Chiron', 'Veyron', 'Divo'],
    'Buick': ['Cascada', 'Century', 'Electra', 'Enclave', 'Encore', 'Encore GX', 'Envision', 'Envista', 'LaCrosse', 'Le Sabre', 'Lucerne', 'Park Avenue', 'Rainier', 'Reatta', 'Regal', 'Rendezvous', 'Riviera', 'Roadmaster', 'Skyhawk', 'Skylark', 'Somerset', 'Terraza', 'Verano'],
    'Cadillac': ['Fleetwood', 'Lyriq', 'Optiq', 'Seville', 'SRX', 'STS', 'Vistiq', 'XLR', 'XT4', 'XT5', 'XT6', 'XTS'],
    'Chevrolet': ['Astro', 'Avalanche', 'Aveo', 'Aveo5', 'Beretta', 'Blazer', 'Blazer EV', 'Bolt', 'Bolt EUV', 'Brightdrop', 'C/K Truck', 'Camaro', 'Caprice', 'Captiva Sport', 'Cavalier', 'Celebrity', 'Chevette', 'Citation', 'City Express', 'Cobalt', 'Colorado', 'Corsica', 'Corvette', 'Cruze', 'El Camino', 'Equinox', 'Equinox EV', 'Express 1500', 'Express 2500', 'Express 3500', 'Express 4500', 'G10', 'G20', 'G30', 'HHR', 'Impala', 'Kodiak C4500', 'Kodiak C5500', 'Low Cab Forward', 'Lumina', 'Lumina APV', 'LUV', 'Malibu', 'Metro', 'Monte Carlo', 'Nova', 'Prizm', 'S10 Blazer', 'S10 Pickup', 'Silverado 1500', 'Silverado 2500', 'Silverado 3500', 'Silverado EV', 'Sonic', 'Spark', 'Spark EV', 'Spectrum', 'Sprint', 'SS', 'SSR', 'Suburban', 'Tahoe', 'Tracker', 'TrailBlazer', 'TrailBlazer EXT', 'Traverse', 'Trax', 'Uplander', 'Venture', 'Volt'],
    'Chrysler': ['200', '300', '300M', 'Aspen', 'Cirrus', 'Concorde', 'Conquest', 'Cordoba', 'Crossfire', 'E Class', 'Fifth Avenue', 'Grand Voyager', 'Imperial', 'Intrepid', 'Laser', 'LeBaron', 'LeBaron GTS', 'LHS', 'New Yorker', 'Newport', 'Pacifica', 'Prowler', 'PT Cruiser', 'Sebring', 'TC by Maserati', 'Town & Country', 'Voyager'],
    'Dodge': ['400', '600', 'Aries', 'Avenger', 'B150', 'B1500', 'B250', 'B2500', 'B350', 'B3500', 'Caliber', 'Caravan', 'Challenger', 'Charger', 'Colt', 'Conquest', 'D/W Truck', 'Dakota', 'Dart', 'Daytona', 'Diplomat', 'Durango', 'Dynasty', 'Grand Caravan', 'Hornet', 'Intrepid', 'Journey', 'Lancer', 'Magnum', 'Mirada', 'Monaco', 'Neon', 'Nitro', 'Omni', 'Raider', 'Ram 1500 Truck', 'Ram 2500 Truck', 'Ram 3500 Truck', 'Ram 4500 Truck', 'Ram 50 Truck', 'Ram 5500 Truck', 'Ram SRT-10', 'Ramcharger', 'Rampage', 'Shadow', 'Spirit', 'Sprinter', 'SRT-4', 'St. Regis', 'Stealth', 'Stratus', 'Viper'],
    'Ferrari': ['12Cilindri', '296 GTB', '296 GTS', '308', '328', '348', '360', '456 GT', '456M GT', '458 Italia', '458 Speciale', '458 Spider', '488 GTB', '488 Pista', '488 Spider', '512M', '512TR', '550 Maranello', '575M Maranello', '599 GTB Fiorano', '599 GTO', '599 SA Aperta', '612 Scaglietti', '812 Competizione', '812 Competizione A', '812 GTS', '812 Superfast', 'California', 'Daytona SP3', 'Enzo', 'F12 Berlinetta', 'F12tdf', 'F355', 'F40', 'F430', 'F50', 'F8 Spider', 'F8 Tributo', 'FF', 'GTC4Lusso', 'LaFerrari', 'Mondial', 'Portofino', 'Portofino M', 'Purosangue', 'Roma', 'SF90 Spider', 'SF90 Stradale', 'Testarossa'],
    'Fiat': ['124 Spider', '2000 Spider', '500', '500L', '500X', 'Bertone X1/9', 'Brava', 'Pininfarina Spider', 'Strada', 'X1/9'],
    'Ford': ['Aerostar', 'Aspire', 'Bronco', 'Bronco II', 'Bronco Sport', 'C-MAX', 'Contour', 'Courier', 'Crown Victoria', 'E-100', 'E-150 and Econoline 150', 'E-250 and Econoline 250', 'E-350 and Econoline 350', 'E-450 and Econoline 450', 'E-Transit', 'EcoSport', 'Edge', 'Escape', 'Escort', 'Excursion', 'EXP', 'Expedition', 'Expedition EL', 'Expedition Max', 'Explorer', 'Explorer Sport Trac', 'F100', 'F150', 'F150 Lightning', 'F250', 'F350', 'F450', 'F550', 'F600', 'F650', 'F750', 'Fairmont', 'Festiva', 'Fiesta', 'Five Hundred', 'Flex', 'Focus', 'Freestar', 'Freestyle', 'Fusion', 'Granada', 'GT', 'LTD', 'Maverick', 'Mustang', 'Mustang Mach-E', 'Probe', 'Ranger', 'Taurus', 'Taurus X', 'Tempo', 'Thunderbird', 'Transit 150', 'Transit 250', 'Transit 350', 'Transit Connect', 'Windstar', 'ZX2 Escort'],
    'Genesis': ['Electrified G80', 'Electrified GV70', 'G70', 'G80', 'G90', 'GV60', 'GV70', 'GV80'],
    'GMC': ['Acadia', 'Caballero', 'Canyon', 'Envoy', 'Envoy XL', 'Envoy XUV', 'G1500', 'G2500', 'G3500', 'Hummer EV', 'Jimmy', 'S15 Jimmy', 'S15 Pickup', 'Safari', 'Savana 1500', 'Savana 2500', 'Savana 3500', 'Savana 4500', 'Sierra 1500', 'Sierra 2500', 'Sierra 3500', 'Sierra EV', 'Sonoma', 'Suburban', 'Syclone', 'Terrain', 'TopKick C4500', 'TopKick C5500', 'Typhoon', 'Yukon', 'Yukon XL'],
    'Honda': ['Accord', 'Accord Crosstour', 'Civic', 'Clarity', 'CR-V', 'CR-Z', 'Crosstour', 'CRX', 'Del Sol', 'Element', 'Fit', 'HR-V', 'Insight', 'Odyssey', 'Passport', 'Pilot', 'Prelude', 'Prologue', 'Ridgeline', 'S2000'],
    'Hyundai': ['Accent', 'Azera', 'Elantra', 'Elantra Coupe', 'Elantra N', 'Elantra Touring', 'Entourage', 'Equus', 'Excel', 'Genesis', 'Genesis Coupe', 'Ioniq', 'Ioniq 5', 'Ioniq 5 N', 'Ioniq 6', 'Ioniq 9', 'Kona', 'Kona N', 'Nexo', 'Palisade', 'Santa Cruz', 'Santa Fe', 'Scoupe', 'Sonata', 'Tiburon', 'Tucson', 'Veloster', 'Veloster N', 'Venue', 'Veracruz', 'XG300', 'XG350'],
    'Infiniti': ['EX35', 'EX37', 'FX35', 'FX37', 'FX45', 'FX50', 'G20', 'G25', 'G35', 'G37', 'I30', 'I35', 'J30', 'JX35', 'M30', 'M35', 'M35h', 'M37', 'M45', 'M56', 'Q40', 'Q45', 'Q50', 'Q60', 'Q70', 'QX30', 'QX4', 'QX50', 'QX55', 'QX56', 'QX60', 'QX70', 'QX80'],
    'Jaguar': ['E-PACE', 'F-PACE', 'F-TYPE', 'I-PACE', 'S-TYPE', 'X-TYPE', 'XE', 'XF', 'XJ', 'XJ Sport', 'XJ Vanden Plas', 'XJ12', 'XJ6', 'XJ8', 'XJ8 L', 'XJR', 'XJR-S', 'XJS', 'XK', 'XK8', 'XKR'],
    'Jeep': ['Cherokee', 'CJ', 'Comanche', 'Commander', 'Compass', 'Gladiator', 'Grand Cherokee', 'Grand Cherokee L', 'Grand Wagoneer', 'Grand Wagoneer L', 'Liberty', 'Patriot', 'Pickup', 'Renegade', 'Scrambler', 'Wagoneer', 'Wagoneer L', 'Wagoneer S', 'Wrangler'],
    'Kia': ['Amanti', 'Borrego', 'Cadenza', 'Carnival', 'EV6', 'EV9', 'Forte', 'Forte Koup', 'K4', 'K5', 'K900', 'Niro', 'Optima', 'Rio', 'Rio5', 'Rondo', 'Sedona', 'Seltos', 'Sephia', 'Sorento', 'Soul', 'Spectra', 'Spectra5', 'Sportage', 'Stinger', 'Telluride'],
    'Lamborghini': ['Aventador', 'Centenario', 'Countach', 'Diablo', 'Gallardo', 'Huracan', 'Jalpa', 'LM002', 'Murcielago', 'Revuelto', 'Sian', 'Urus'],
    'Land Rover': ['Defender', 'Discovery', 'Discovery Sport', 'Freelander', 'LR2', 'LR3', 'LR4', 'Range Rover', 'Range Rover Evoque', 'Range Rover Sport', 'Range Rover Velar'],
    'Lexus': ['CT 200h', 'ES 250', 'ES 300', 'ES 300h', 'ES 330', 'ES 350', 'GS 200t', 'GS 300', 'GS 350', 'GS 400', 'GS 430', 'GS 450h', 'GS 460', 'GS F', 'GX 460', 'GX 470', 'GX 550', 'HS 250h', 'IS 200t', 'IS 250', 'IS 250C', 'IS 300', 'IS 350', 'IS 350C', 'IS 500', 'IS F', 'LC 500', 'LC 500h', 'LFA', 'LS 400', 'LS 430', 'LS 460', 'LS 500', 'LS 500h', 'LS 600h', 'LX 450', 'LX 470', 'LX 570', 'LX 600', 'LX 700h', 'NX 200t', 'NX 250', 'NX 300', 'NX 300h', 'NX 350', 'NX 350h', 'NX 450h+', 'RC 200t', 'RC 300', 'RC 350', 'RC F', 'RX 300', 'RX 330', 'RX 350', 'RX 350h', 'RX 350L', 'RX 400h', 'RX 450h', 'RX 450hL', 'RX 500h', 'RZ 300e', 'RZ 450e', 'SC 300', 'SC 400', 'SC 430', 'TX 350', 'TX 500h', 'TX 550h', 'UX 200', 'UX 250h', 'UX 300h'],
    'Lincoln': ['Aviator', 'Blackwood', 'Continental', 'Corsair', 'LS', 'Mark LT', 'Mark VI', 'Mark VII', 'Mark VIII', 'MKC', 'MKS', 'MKT', 'MKX', 'MKZ', 'Nautilus', 'Navigator', 'Navigator L', 'Town Car', 'Zephyr'],
    'Lotus': ['Elan', 'Eletre', 'Elise', 'Emira', 'Esprit', 'Evora', 'Exige'],
    'Lucid': ['Air', 'Gravity'],
    'Maserati': ['430', 'Biturbo', 'Coupe', 'Ghibli', 'GranCabrio', 'GranSport', 'GranTurismo', 'Grecale', 'Levante', 'MC20', 'Quattroporte', 'Spyder'],
    'Mazda': ['323', '626', '929', 'B-Series Pickup', 'CX-3', 'CX-30', 'CX-5', 'CX-50', 'CX-7', 'CX-70', 'CX-9', 'CX-90', 'GLC', 'MAZDA2', 'MAZDA3', 'MAZDA5', 'MAZDA6', 'MAZDASPEED3', 'MAZDASPEED6', 'Millenia', 'MPV', 'MX-30', 'MX-5 Miata', 'MX-5 Miata RF', 'MX3', 'MX6', 'Navajo', 'Protege', 'Protege5', 'RX-7', 'RX-8', 'Tribute'],
    'McLaren': ['570GT', '570S', '600LT', '620R', '650S', '675LT', '720S', '750S', '765LT', 'Artura', 'Elva', 'GT', 'GTS', 'MP4-12C', 'P1', 'Sabre', 'Senna', 'Speedtail'],
    'Mercedes-Benz': ['190 D', '190 E', '240 D', '260 E', '280 CE', '280 E', '300 CD', '300 CE', '300 D', '300 E', '300 SD', '300 SDL', '300 SE', '300 SEL', '300 SL', '300 TD', '300 TE', '350 SD', '350 SDL', '380 SE', '380 SEC', '380 SEL', '380 SL', '380 SLC', '400 E', '400 SE', '400 SEL', '420 SEL', '430', '500 E', '500 SEC', '500 SEL', '500 SL', '560 SEC', '560 SEL', '560 SL', '600 SEC', '600 SEL', '600 SL', 'A 220', 'A 35 AMG', 'AMG GT', 'B 250e', 'B-Class Electric Drive', 'C 220', 'C 230', 'C 240', 'C 250', 'C 280', 'C 300', 'C 32 AMG', 'C 320', 'C 350', 'C 350e', 'C 36 AMG', 'C 400', 'C 43 AMG', 'C 450', 'C 55 AMG', 'C 63 AMG', 'CL 500', 'CL 55 AMG', 'CL 550', 'CL 600', 'CL 63 AMG', 'CL 65 AMG', 'CLA 250', 'CLA 35 AMG', 'CLA 45 AMG', 'CLE 300', 'CLE 450', 'CLE 53 AMG', 'CLK 320', 'CLK 350', 'CLK 430', 'CLK 500', 'CLK 55 AMG', 'CLK 550', 'CLK 63 AMG', 'CLS 400', 'CLS 450', 'CLS 500', 'CLS 53 AMG', 'CLS 55 AMG', 'CLS 550', 'CLS 63 AMG', 'E 250', 'E 300', 'E 320', 'E 350', 'E 400', 'E 420', 'E 43 AMG', 'E 430', 'E 450', 'E 500', 'E 53 AMG', 'E 55 AMG', 'E 550', 'E 63 AMG', 'EQB 250+', 'EQB 300', 'EQB 350', 'EQE 350+', 'EQE 500', 'EQE AMG', 'EQS 450+', 'EQS 580', 'EQS AMG', 'eSprinter', 'G 500', 'G 55 AMG', 'G 550', 'G 580', 'G 63 AMG', 'G 65 AMG', 'GL 320', 'GL 350', 'GL 450', 'GL 550', 'GL 63 AMG', 'GLA 250', 'GLA 35 AMG', 'GLA 45 AMG', 'GLB 250', 'GLB 35 AMG', 'GLC 300', 'GLC 350e', 'GLC 43 AMG', 'GLC 63 AMG', 'GLE 300d', 'GLE 350', 'GLE 400', 'GLE 43 AMG', 'GLE 450', 'GLE 450e', 'GLE 53 AMG', 'GLE 550e', 'GLE 580', 'GLE 63 AMG', 'GLK 250', 'GLK 350', 'GLS 350d', 'GLS 450', 'GLS 550', 'GLS 580', 'GLS 63 AMG', 'Maybach EQS 680', 'Maybach GLS 600', 'Maybach S 550', 'Maybach S 560', 'Maybach S 580', 'Maybach S 600', 'Maybach S 650', 'Maybach S 680', 'Metris', 'ML 250', 'ML 320', 'ML 350', 'ML 400', 'ML 430', 'ML 450', 'ML 500', 'ML 55 AMG', 'ML 550', 'ML 63 AMG', 'R 320', 'R 350', 'R 500', 'R 63 AMG', 'S 320', 'S 350', 'S 400', 'S 420', 'S 430', 'S 450', 'S 500', 'S 55 AMG', 'S 550', 'S 550e', 'S 560', 'S 560e', 'S 580', 'S 580e', 'S 600', 'S 63 AMG', 'S 65 AMG', 'SL 320', 'SL 400', 'SL 43 AMG', 'SL 450', 'SL 500', 'SL 55 AMG', 'SL 550', 'SL 600', 'SL 63 AMG', 'SL 65 AMG', 'SLC 300', 'SLC 43 AMG', 'SLK 230', 'SLK 250', 'SLK 280', 'SLK 300', 'SLK 32 AMG', 'SLK 320', 'SLK 350', 'SLK 55 AMG', 'SLR', 'SLS AMG', 'Sprinter'],
    'MINI': ['Clubman', 'Hardtop 4 Door', 'Hardtop 2 Door', 'Convertible', 'Countryman'],
    'Mitsubishi': ['3000GT', 'Cordia', 'Diamante', 'Eclipse', 'Eclipse Cross', 'Endeavor', 'Expo', 'Galant', 'i', 'Lancer', 'Lancer Evolution', 'Mighty Max', 'Mirage', 'Mirage G4', 'Montero', 'Montero Sport', 'Outlander', 'Outlander Sport', 'Precis', 'Raider', 'Sigma', 'Starion', 'Tredia', 'Van'],
    'Nissan': ['200SX', '240SX', '300ZX', '350Z', '370Z', 'Altima', 'Ariya', 'Armada', 'Axxess', 'Cube', 'Frontier', 'GT-R', 'Juke', 'Kicks', 'Leaf', 'Maxima', 'Murano', 'Murano CrossCabriolet', 'NV', 'NV200', 'NX', 'Pathfinder', 'Pickup', 'Pulsar', 'Quest', 'Rogue', 'Rogue Sport', 'Sentra', 'Stanza', 'Titan', 'Van', 'Versa', 'Versa Note', 'Xterra', 'Z'],
    'Polestar': ['1', '2', '3'],
    'Porsche': ['718 Boxster', '718 Cayman', '911', '918 Spyder', '924', '928', '944', '968', 'Boxster', 'Carrera GT', 'Cayenne', 'Cayman', 'Macan', 'Panamera', 'Taycan'],
    'Rivian': ['R1S', 'R1T', 'R2', 'R3', 'Fleet'],
    'Ram': ['1500', '2500', '3500', '4500', '5500', 'C/V', 'ProMaster', 'ProMaster City'],
    'Rolls-Royce': ['Camargue', 'Corniche', 'Cullinan', 'Dawn', 'Ghost', 'Park Ward', 'Phantom', 'Silver Dawn', 'Silver Seraph', 'Silver Spirit', 'Silver Spur', 'Spectre', 'Wraith'],
    'Subaru': ['Ascent', 'Baja', 'Brat', 'BRZ', 'Crosstrek', 'Forester', 'Impreza', 'Impreza WRX', 'Justy', 'L Series', 'Legacy', 'Loyale', 'Outback', 'Solterra', 'SVX', 'Tribeca', 'WRX', 'XT', 'XV Crosstrek'],
    'Tesla': ['Cybertruck', 'Model 3', 'Model S', 'Model X', 'Model Y', 'Roadster'],
    'Toyota': ['4Runner', '86', 'Avalon', 'bZ4X', 'C-HR', 'Camry', 'Celica', 'Corolla', 'Corolla Cross', 'Corona', 'Cressida', 'Crown', 'Crown Signia', 'Echo', 'FJ Cruiser', 'GR86', 'Grand Highlander', 'Highlander', 'Land Cruiser', 'Matrix', 'Mirai', 'MR2', 'MR2 Spyder', 'Paseo', 'Pickup', 'Previa', 'Prius', 'Prius C', 'Prius Prime', 'Prius V', 'RAV4', 'Sequoia', 'Sienna', 'Solara', 'Starlet', 'Supra', 'T100', 'Tacoma', 'Tercel', 'Tundra', 'Van', 'Venza', 'Yaris'],
    'Volkswagen': ['Arteon', 'Atlas', 'Beetle', 'Cabrio', 'Cabriolet', 'CC', 'Corrado', 'Dasher', 'e-Golf', 'Eos', 'Eurovan', 'Fox', 'Golf', 'Golf R', 'GTI', 'ID. Buzz', 'ID.4', 'Jetta', 'Passat', 'Phaeton', 'Pickup', 'Quantum', 'R32', 'Rabbit', 'Routan', 'Scirocco', 'Taos', 'Tiguan', 'Touareg', 'Vanagon'],
    'Volvo': ['240', '260', '740', '760', '780', '850', '940', '960', 'C30', 'C40', 'C70', 'EC40', 'EX30', 'EX40', 'EX90', 'S40', 'S60', 'S70', 'S80', 'S90', 'V40', 'V50', 'V60', 'V70', 'V90', 'XC40', 'XC60', 'XC70', 'XC90'],
  };

  @override
  void initState() {
    super.initState();

    final vehicleParts = _parseVehicle(widget.tow.vehicle);
    _selectedYear = _sanitize(vehicleParts['year']);
    _selectedMake = _sanitize(vehicleParts['make']);
    _selectedModel = null;

    // If parsed model is valid for parsed make, pre-select it
    final parsedModel = _sanitize(vehicleParts['model']);
    if (_selectedMake != null && parsedModel != null) {
      final models = _getModelsForMake(_selectedMake!);
      if (models.contains(parsedModel)) {
        _selectedModel = parsedModel;
      }
    }

    _selectedState = null; // Initialize state selection
    _licensePlateController = TextEditingController();
  }

  @override
  void dispose() {
    _licensePlateController.dispose();
    super.dispose();
  }

  String? _sanitize(String? s) =>
      (s == null || s.trim().isEmpty || s.trim() == '—') ? null : s.trim();

  // Generate years from current year back to 1980
  List<String> _getYears() {
    final currentYear = DateTime.now().year;
    return List.generate(currentYear - 1979, (i) => (currentYear - i).toString());
  }

  List<String> _getMakes() {
    final makes = modelMap.keys.toList();
    makes.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return makes;
  }

  List<String> _getModelsForMake(String make) {
    final models = modelMap[make] ?? const [];
    return List.of(models); // copy for safety
  }

  // Get list of all 50 US states
  List<String> _getStates() {
    return [
      'Alabama', 'Alaska', 'Arizona', 'Arkansas', 'California', 'Colorado', 'Connecticut', 'Delaware',
      'Florida', 'Georgia', 'Hawaii', 'Idaho', 'Illinois', 'Indiana', 'Iowa', 'Kansas', 'Kentucky',
      'Louisiana', 'Maine', 'Maryland', 'Massachusetts', 'Michigan', 'Minnesota', 'Mississippi',
      'Missouri', 'Montana', 'Nebraska', 'Nevada', 'New Hampshire', 'New Jersey', 'New Mexico',
      'New York', 'North Carolina', 'North Dakota', 'Ohio', 'Oklahoma', 'Oregon', 'Pennsylvania',
      'Rhode Island', 'South Carolina', 'South Dakota', 'Tennessee', 'Texas', 'Utah', 'Vermont',
      'Virginia', 'Washington', 'West Virginia', 'Wisconsin', 'Wyoming', 'District of Columbia'
    ];
  }

  Map<String, String> _parseVehicle(String? vehicle) {
    if (vehicle == null || vehicle.isEmpty || vehicle == '—') return {};
    final parts = vehicle.trim().split(RegExp(r'\s+'));
    if (parts.length >= 3) {
      final year = parts[0];
      final make = parts[1];
      final model = parts.sublist(2).join(' ');
      return {'year': year, 'make': make, 'model': model};
    } else if (parts.length == 2) {
      return {'year': '', 'make': parts[0], 'model': parts[1]};
    } else {
      return {'year': '', 'make': '', 'model': vehicle};
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final years = _getYears();
    final makes = _getMakes();
    final models = _selectedMake == null ? <String>[] : _getModelsForMake(_selectedMake!);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title with icon
          Row(
            children: [
              Text(
                'Vehicle',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Year, Make, Model in a row with vertical dividers
          Row(
            children: [
              Expanded(
                child: _VehicleDropdownField(
                  label: 'Year',
                  value: _selectedYear,
                  items: years,
                  onChanged: (value) => setState(() => _selectedYear = value),
                ),
              ),
              _vDivider(theme),
              Expanded(
                child: _VehicleDropdownField(
                  label: 'Make',
                  value: _selectedMake,
                  items: makes,
                  onChanged: (value) => setState(() {
                    _selectedMake = value;
                    _selectedModel = null; // reset model when make changes
                  }),
                ),
              ),
              _vDivider(theme),
              Expanded(
                child: _VehicleDropdownField(
                  label: 'Model',
                  value: _selectedModel,
                  items: models,
                  onChanged: (value) => setState(() => _selectedModel = value),
                  enabled: _selectedMake != null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // License Plate and State in a row
          Row(
            children: [
              Expanded(
                child: _VehicleDropdownField(
                  label: 'State',
                  value: _selectedState,
                  items: _getStates(),
                  onChanged: (value) => setState(() => _selectedState = value),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _VehicleTextField(
                  label: 'License Plate',
                  controller: _licensePlateController,
                  onChanged: (value) {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _vDivider(ThemeData theme) => Container(
    width: 1,
    margin: const EdgeInsets.symmetric(horizontal: 8),
    color: theme.dividerColor.withOpacity(0.3),
  );
}

class _VehicleDropdownField extends StatelessWidget {
  const _VehicleDropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.enabled = true,
  });

  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down, color: theme.colorScheme.onSurfaceVariant),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: theme.dividerColor.withOpacity(0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: theme.dividerColor.withOpacity(0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5),
            ),
          ),
          hint: Text('Select', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          items: [
            const DropdownMenuItem<String>(
              value: null,
              child: Text('Select'),
            ),
            ...items.map(
                  (e) => DropdownMenuItem<String>(
                value: e,
                child: Text(e, style: textStyle),
              ),
            ),
          ],
          onChanged: enabled ? onChanged : null,
        ),
      ],
    );
  }
}

class _VehicleTextField extends StatelessWidget {
  const _VehicleTextField({
    required this.label,
    required this.controller,
    required this.onChanged,
  });

  final String label;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          onChanged: onChanged,
          style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: theme.dividerColor.withOpacity(0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: theme.dividerColor.withOpacity(0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
