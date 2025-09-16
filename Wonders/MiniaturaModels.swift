import Foundation

struct MiniaturaCard: Identifiable {
    let id: Int
    let imagem: String // nome do asset
    let categoria: String
    let ordem: Int
    let translations: [String: MiniaturaCardTranslation]
    let latitude: Double?
    let longitude: Double?
    let extraLocations: [(latitude: Double, longitude: Double)]?
}

struct MiniaturaCardTranslation {
    let titulo: String
    let shortDescription: String
    let description: String?
    let history: String?
    let adress: String?
}

extension String {
    // Remove accents and lowercase for robust comparison
    var normalized: String {
        return self.folding(options: .diacriticInsensitive, locale: .current).lowercased()
    }
}

extension MiniaturaCard {
    static func allCards() -> [MiniaturaCard] {
        let categories = ["Monumentos", "Natureza", "Gastronomia", "Popular", "Churches", "Museus", "Sintra", "Vocabulário", "Vocabulary"]
        var cards: [MiniaturaCard] = []
        var globalId = 1
        for cat in categories {
            let mocks = mockCardsRaw(for: cat)
            for card in mocks {
                let uniqueCard = MiniaturaCard(id: globalId, imagem: card.imagem, categoria: card.categoria, ordem: card.ordem, translations: card.translations, latitude: card.latitude, longitude: card.longitude, extraLocations: card.extraLocations)
                cards.append(uniqueCard)
                globalId += 1
            }
        }
        return cards
    }
    // Raw version for category, used only internally
    static func mockCardsRaw(for categoria: String) -> [MiniaturaCard] {
        let cat = categoria.normalized
        if cat == "monumentos" || cat == "monuments" {
            return [
                MiniaturaCard(
                    id: 1,
                    imagem: "sao_jorge_castle",
                    categoria: "Monumentos",
                    ordem: 1,
                    translations: [
                        "en": MiniaturaCardTranslation(
                            titulo: "São Jorge Castle",
                            shortDescription: "Founded in the 10th by the Moors and conquered by the first king of Portugal in 1147.",
                            description: "A medieval castle with panoramic views over Lisbon.",
                            history: "The castle was built by the Moors in the 10th century and later conquered by King Afonso Henriques in 1147.",
                            adress: "Rua de Santa Cruz do Castelo, 1100-129 Lisboa, Portugal"
                        ),
                        "pt": MiniaturaCardTranslation(
                            titulo: "Castelo de São Jorge",
                            shortDescription: "Fundado no século X pelos mouros e conquistado pelo primeiro rei de Portugal em 1147.",
                            description: "Um castelo medieval com vistas panorâmicas sobre Lisboa.",
                            history: "O castelo foi construído pelos mouros no século X e depois conquistado por D. Afonso Henriques em 1147.",
                            adress: "Rua de Santa Cruz do Castelo, 1100-129 Lisboa, Portugal"
                        )
                    ],
                    latitude: 38.713909,
                    longitude: -9.133476,
                    extraLocations: nil
                ),
                MiniaturaCard(
                    id: 2,
                    imagem: "torre_belem",
                    categoria: categoria,
                    ordem: 2,
                    translations: [
                        "en": MiniaturaCardTranslation(
                            titulo: "Belém Tower",
                            shortDescription: "Built in the early 16th century, it is a portal to Portugal’s maritime past.",
                            description: "A UNESCO World Heritage site and symbol of the Age of Discoveries.",
                            history: "Constructed between 1514 and 1520 as part of the Tagus river defense system.",
                            adress: "Av. Brasília, 1400-038 Lisboa, Portugal"
                        ),
                        "pt": MiniaturaCardTranslation(
                            titulo: "Torre de Belém",
                            shortDescription: "Construída no início do século XVI, é um portal para o passado marítimo de Portugal.",
                            description: "Patrimônio Mundial da UNESCO e símbolo da Era dos Descobrimentos.",
                            history: "Construída entre 1514 e 1520 como parte do sistema de defesa do rio Tejo.",
                            adress: "Av. Brasília, 1400-038 Lisboa, Portugal"
                        )
                    ],
                    latitude: 38.691584,
                    longitude: -9.215821,
                    extraLocations: nil
                ),
                MiniaturaCard(
                    id: 3,
                    imagem: "aqueduto",
                    categoria: categoria,
                    ordem: 3,
                    translations: [
                        "en": MiniaturaCardTranslation(
                            titulo: "Águas Livres Aqueduct",
                            shortDescription: "A remarkable 18th-century aqueduct that supplied Lisbon with water.",
                            description: "An impressive aqueduct spanning the Alcântara valley.",
                            history: "Completed in 1748, it survived the 1755 earthquake.",
                            adress: "Calçada da Quintinha 6, 1070-225 Lisboa, Portugal"
                        ),
                        "pt": MiniaturaCardTranslation(
                            titulo: "Aqueduto das Águas Livres",
                            shortDescription: "Um notável aqueduto do século XVIII que abastecia Lisboa com água.",
                            description: "Um impressionante aqueduto que atravessa o vale de Alcântara.",
                            history: "Concluído em 1748, sobreviveu ao terremoto de 1755.",
                            adress: "Calçada da Quintinha 6, 1070-225 Lisboa, Portugal"
                        )
                    ],
                    latitude: 38.72660,
                    longitude: -9.16623,
                    extraLocations: nil
                ),
                MiniaturaCard(
                    id: 4,
                    imagem: "comercio",
                    categoria: categoria,
                    ordem: 4,
                    translations: [
                        "en": MiniaturaCardTranslation(
                            titulo: "Comércio Square",
                            shortDescription: "A triumphal arch and symbol of Lisbon’s rebirth after the earthquake.",
                            description: "A grand plaza facing the Tagus river.",
                            history: "Rebuilt after the 1755 earthquake as part of the Pombaline downtown.",
                            adress: "Praça do Comércio, 1100-148 Lisboa, Portugal"
                        ),
                        "pt": MiniaturaCardTranslation(
                            titulo: "Praça do Comércio",
                            shortDescription: "Um arco triunfal e símbolo do renascimento de Lisboa após o terremoto.",
                            description: "Uma grande praça voltada para o rio Tejo.",
                            history: "Reconstruída após o terremoto de 1755 como parte do centro pombalino.",
                            adress: "Praça do Comércio, 1100-148 Lisboa, Portugal"
                        )
                    ],
                    latitude: 38.707750,
                    longitude: -9.136592,
                    extraLocations: nil
                ),
                MiniaturaCard(
                    id: 5,
                    imagem: "santa_justa",
                    categoria: categoria,
                    ordem: 5,
                    translations: [
                        "en": MiniaturaCardTranslation(
                            titulo: "Santa Justa Elevator",
                            shortDescription: "A 19th-century elevator with panoramic city views.",
                            description: "A neo-Gothic iron elevator in downtown Lisbon.",
                            history: "Opened in 1902, designed by Raoul Mesnier du Ponsard.",
                            adress: "R. do Ouro, 1150-060 Lisboa, Portugal"
                        ),
                        "pt": MiniaturaCardTranslation(
                            titulo: "Elevador de Santa Justa",
                            shortDescription: "Um elevador do século XIX com vistas panorâmicas da cidade.",
                            description: "Um elevador de ferro neogótico no centro de Lisboa.",
                            history: "Inaugurado em 1902, projetado por Raoul Mesnier du Ponsard.",
                            adress: "R. do Ouro, 1150-060 Lisboa, Portugal"
                        )
                    ],
                    latitude: 38.713909,
                    longitude: -9.139506,
                    extraLocations: nil
                ),
                MiniaturaCard(
                    id: 6,
                    imagem: "padrao",
                    categoria: categoria,
                    ordem: 6,
                    translations: [
                        "en": MiniaturaCardTranslation(
                            titulo: "Discoveries Monument",
                            shortDescription: "A tribute to the Portuguese Age of Discovery, on the Tagus riverbank.",
                            description: "A monument celebrating Portugal’s explorers.",
                            history: "Inaugurated in 1960 for the 500th anniversary of Henry the Navigator’s death.",
                            adress: "Av. Brasília, 1400-038 Lisboa, Portugal"
                        ),
                        "pt": MiniaturaCardTranslation(
                            titulo: "Padrão dos Descobrimentos",
                            shortDescription: "Um tributo à Era dos Descobrimentos Portuguesa, na margem do rio Tejo.",
                            description: "Um monumento que celebra os exploradores de Portugal.",
                            history: "Inaugurado em 1960 para o 500º aniversário da morte de Henrique, o Navegador.",
                            adress: "Av. Brasília, 1400-038 Lisboa, Portugal"
                        )
                    ],
                    latitude: 38.693056,
                    longitude: -9.205556,
                    extraLocations: nil
                ),
                MiniaturaCard(
                    id: 7,
                    imagem: "ponte_25_abril",
                    categoria: categoria,
                    ordem: 7,
                    translations: [
                        "en": MiniaturaCardTranslation(
                            titulo: "Lisbon Bridges",
                            shortDescription: "Pontes de Lisboa maravilhosas e históricas.",
                            description: "Lisbon’s iconic bridges over the Tagus river.",
                            history: "The 25 de Abril Bridge opened in 1966; Vasco da Gama Bridge in 1998.",
                            adress: "Lisbon, Portugal"
                        ),
                        "pt": MiniaturaCardTranslation(
                            titulo: "Pontes de Lisboa",
                            shortDescription: "Wonderful and historic bridges of Lisbon.",
                            description: "As pontes icônicas de Lisboa sobre o rio Tejo.",
                            history: "A Ponte 25 de Abril foi inaugurada em 1966; a Ponte Vasco da Gama em 1998.",
                            adress: "Lisboa, Portugal"
                        )
                    ],
                    latitude: 38.689167,
                    longitude: -9.177778,
                    extraLocations: nil
                ),
                MiniaturaCard(
                    id: 8,
                    imagem: "plus_monuments",
                    categoria: categoria,
                    ordem: 8,
                    translations: [
                        "en": MiniaturaCardTranslation(
                            titulo: "More Monuments",
                            shortDescription: "Lisboa tem muitos monumentos incríveis!",
                            description: "Explore more of Lisbon’s rich heritage.",
                            history: nil,
                            adress: nil
                        ),
                        "pt": MiniaturaCardTranslation(
                            titulo: "Mais Monumentos",
                            shortDescription: "Lisboa tem muitos monumentos incríveis!",
                            description: "Explore mais do rico patrimônio de Lisboa.",
                            history: nil,
                            adress: nil
                        )
                    ],
                    latitude: nil,
                    longitude: nil,
                    extraLocations: nil
                )
            ]
        }
        if categoria == "Natureza" || categoria == "Nature" {
            return [
                MiniaturaCard(
                    id: 1,
                    imagem: "rio_tejo",
                    categoria: categoria,
                    ordem: 1,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Rio Tejo",
                            shortDescription: "O maior rio da Península Ibérica nasce na Espanha e desagua no Oceano Atlântico em Lisboa.",
                            description: "O Rio Tejo atravessa Portugal de leste a oeste, sendo vital para a história, economia e paisagem de Lisboa.",
                            history: "Desde tempos antigos, o Tejo foi rota de navegadores, fonte de inspiração para poetas e palco de batalhas históricas.",
                            adress: "Lisboa, Portugal"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Tagus River",
                            shortDescription: "The largest river in the Iberian Peninsula rises in Spain and flows into the Atlantic Ocean in Lisbon.",
                            description: "The Tagus River crosses Portugal from east to west, vital to Lisbon’s history, economy, and landscape.",
                            history: "Since ancient times, the Tagus has been a route for navigators, a source of inspiration for poets, and the stage for historic battles.",
                            adress: "Lisbon, Portugal"
                        )
                    ],
                    latitude: 38.7071,
                    longitude: -9.1366,
                    extraLocations: nil
                ),
                MiniaturaCard(
                    id: 2,
                    imagem: "miradouros",
                    categoria: categoria,
                    ordem: 2,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Miradouros",
                            shortDescription: "Pontos altos de Lisboa com vistas deslumbrantes sobre a cidade e o rio.",
                            description: "Os miradouros de Lisboa oferecem panoramas únicos sobre a cidade, o rio e as colinas.",
                            history: "Muitos miradouros surgiram junto a antigos baluartes e igrejas, tornando-se pontos de encontro e contemplação.",
                            adress: "Vários pontos em Lisboa"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Viewpoints",
                            shortDescription: "High points in Lisbon with breathtaking views over the city and river.",
                            description: "Lisbon’s viewpoints offer unique panoramas over the city, river, and hills.",
                            history: "Many viewpoints arose near old bastions and churches, becoming places for gathering and contemplation.",
                            adress: "Various locations in Lisbon"
                        )
                    ],
                    latitude: 38.7138,
                    longitude: -9.1335,
                    extraLocations: [
                        (38.7181, -9.1336), // Miradouro da Senhora do Monte
                        (38.7132, -9.1393), // Miradouro de Santa Catarina
                        (38.7147, -9.1371)  // Miradouro de São Pedro de Alcântara
                    ]
                ),
                MiniaturaCard(
                    id: 3,
                    imagem: "monsanto",
                    categoria: categoria,
                    ordem: 3,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Jardins e Parques",
                            shortDescription: "Espaços verdes perfeitos para relaxar, passear e apreciar a natureza urbana.",
                            description: "Espalhados por Lisboa, os jardins e parques são refúgios de tranquilidade e biodiversidade.",
                            history: "Alguns jardins datam do século XVIII, criados para a realeza e abertos ao público ao longo dos séculos.",
                            adress: "Ex: Jardim da Estrela, Parque Eduardo VII, Lisboa"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Gardens and Parks",
                            shortDescription: "Green spaces perfect for relaxing, strolling, and enjoying urban nature.",
                            description: "Scattered throughout Lisbon, gardens and parks are havens of tranquility and biodiversity.",
                            history: "Some gardens date back to the 18th century, created for royalty and opened to the public over the centuries.",
                            adress: "e.g., Jardim da Estrela, Eduardo VII Park, Lisbon"
                        )
                    ],
                    latitude: 38.7262,
                    longitude: -9.1506,
                    extraLocations: nil
                ),
                MiniaturaCard(
                    id: 4,
                    imagem: "serra_sintra",
                    categoria: categoria,
                    ordem: 4,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Serra de Sintra",
                            shortDescription: "Montanhas místicas cobertas de floresta, palácios e trilhos encantadores.",
                            description: "A Serra de Sintra é um local mágico, coberto de vegetação exuberante e monumentos históricos.",
                            history: "Foi refúgio de reis e poetas, inspirando lendas e obras literárias desde a Idade Média.",
                            adress: "Sintra, Portugal"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Sintra Mountains",
                            shortDescription: "Mystical mountains covered in forest, palaces, and enchanting trails.",
                            description: "The Sintra Mountains are a magical place, covered in lush vegetation and historic monuments.",
                            history: "It was a refuge for kings and poets, inspiring legends and literary works since the Middle Ages.",
                            adress: "Sintra, Portugal"
                        )
                    ],
                    latitude: 38.7939,
                    longitude: -9.3907,
                    extraLocations: nil
                ),
                MiniaturaCard(
                    id: 5,
                    imagem: "praias",
                    categoria: categoria,
                    ordem: 5,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Praias de Lisboa",
                            shortDescription: "Areias douradas e mar refrescante a poucos minutos do centro da cidade.",
                            description: "As praias próximas a Lisboa são ideais para banhos de sol, surf e passeios à beira-mar.",
                            history: "Frequentadas desde o século XIX, tornaram-se destinos populares com a chegada dos comboios.",
                            adress: "Costa da Caparica, Carcavelos, Estoril"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Lisbon Beaches",
                            shortDescription: "Golden sands and refreshing sea just minutes from the city center.",
                            description: "The beaches near Lisbon are ideal for sunbathing, surfing, and seaside walks.",
                            history: "Popular since the 19th century, they became accessible destinations with the arrival of trains.",
                            adress: "Costa da Caparica, Carcavelos, Estoril"
                        )
                    ],
                    latitude: 38.6517,
                    longitude: -9.2333,
                    extraLocations: nil
                ),
                MiniaturaCard(
                    id: 6,
                    imagem: "cabo_roca",
                    categoria: categoria,
                    ordem: 6,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Cabo da Roca",
                            shortDescription: "O ponto mais ocidental da Europa continental, com falésias impressionantes.",
                            description: "Cabo da Roca é o ponto mais ocidental da Europa continental, com vistas de cortar a respiração.",
                            history: "Foi considerado o 'fim do mundo' pelos antigos europeus e é citado por Camões em 'Os Lusíadas'.",
                            adress: "Estrada do Cabo da Roca, Colares, Sintra"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Cape Roca",
                            shortDescription: "The westernmost point of mainland Europe, with impressive cliffs.",
                            description: "Cape Roca is the westernmost point of mainland Europe, with breathtaking views.",
                            history: "Once considered the 'end of the world' by ancient Europeans, it is mentioned by Camões in 'The Lusiads'.",
                            adress: "Estrada do Cabo da Roca, Colares, Sintra"
                        )
                    ],
                    latitude: 38.7804,
                    longitude: -9.4989,
                    extraLocations: nil
                ),
                MiniaturaCard(
                    id: 7,
                    imagem: "onda_nazare",
                    categoria: categoria,
                    ordem: 7,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Ondas da Nazaré",
                            shortDescription: "Famosa pelas maiores ondas surfadas do mundo, atraindo surfistas internacionais.",
                            description: "A Nazaré é famosa pelas suas ondas gigantes, atraindo surfistas de todo o mundo.",
                            history: "O fenómeno das ondas gigantes deve-se ao Canhão da Nazaré, um desfiladeiro submarino único.",
                            adress: "Praia do Norte, Nazaré"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Nazaré Waves",
                            shortDescription: "Famous for the biggest surfed waves in the world, attracting international surfers.",
                            description: "Nazaré is famous for its giant waves, attracting surfers from all over the world.",
                            history: "The giant wave phenomenon is due to the Nazaré Canyon, a unique underwater gorge.",
                            adress: "Praia do Norte, Nazaré"
                        )
                    ],
                    latitude: 39.6102,
                    longitude: -9.0856,
                    extraLocations: nil
                ),
                MiniaturaCard(
                    id: 8,
                    imagem: "plus_nature",
                    categoria: categoria,
                    ordem: 8,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Mais Natureza",
                            shortDescription: "Descubra ainda mais belezas naturais em Portugal e arredores de Lisboa.",
                            description: "Explore reservas naturais, trilhos e paisagens protegidas em todo o país.",
                            history: "Portugal investe na preservação ambiental, criando parques e áreas de proteção desde o século XX.",
                            adress: "Diversos locais em Portugal"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "More Nature",
                            shortDescription: "Discover even more natural wonders in Portugal and around Lisbon.",
                            description: "Explore natural reserves, trails, and protected landscapes throughout the country.",
                            history: "Portugal invests in environmental preservation, creating parks and protected areas since the 20th century.",
                            adress: "Various locations in Portugal"
                        )
                    ],
                    latitude: nil,
                    longitude: nil,
                    extraLocations: nil
                )
            ]
        }
        if categoria == "Gastronomia" || categoria == "Gastronomy" {
            return [
                MiniaturaCard(
                    id: 1,
                    imagem: "pasteis",
                    categoria: categoria,
                    ordem: 1,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Pastéis de Nata",
                            shortDescription: "O doce mais famoso de Portugal, com creme e massa folhada crocante.",
                            description: "Os pastéis de nata são pequenas tartes de creme, servidas quentes e polvilhadas com canela. Bla bla bla mais texto para teste. Bla bla bla mais texto para teste. Bla bla bla mais texto para teste. Bla bla bla mais texto para teste.",
                            history: "Criados por monges em Belém no século XIX, tornaram-se símbolo da doçaria portuguesa. Lorum ipsum dolor sit amet, consectetur adipiscing elit. Lorum ipsum dolor sit amet, consectetur adipiscing elit. Lorum ipsum dolor sit amet, consectetur adipiscing elit. Lorum ipsum dolor sit amet, consectetur adipiscing elit. Lorum ipsum dolor sit amet, consectetur adipiscing elit. Lorum ipsum dolor sit amet, consectetur adipiscing elit.",
                            adress: "Pastéis de Belém, Rua de Belém 84-92, Lisboa"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Pastéis de Nata",
                            shortDescription: "Portugal's most famous pastry, with creamy custard and crispy puff pastry.",
                            description: "Pastéis de nata are small custard tarts, served warm and sprinkled with cinnamon.",
                            history: "Created by monks in Belém in the 19th century, they became a symbol of Portuguese sweets.",
                            adress: "Pastéis de Belém, Rua de Belém 84-92, Lisbon"
                        )
                    ],
                    latitude: 38.6972, // Pastéis de Belém
                    longitude: -9.2036,
                    extraLocations: nil
                ),
                MiniaturaCard(
                    id: 2,
                    imagem: "bacalhau",
                    categoria: categoria,
                    ordem: 2,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Bacalhau",
                            shortDescription: "O peixe mais versátil da culinária portuguesa, preparado de mil maneiras.",
                            description: "Bacalhau é servido assado, cozido, frito ou em saladas, sempre presente em festas.",
                            history: "Introduzido no século XVI, tornou-se essencial devido à sua conservação em sal.",
                            adress: "Restaurante Laurentina, Av. Conde Valbom 71A, Lisboa"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Codfish",
                            shortDescription: "The most versatile fish in Portuguese cuisine, prepared in countless ways.",
                            description: "Bacalhau is served baked, boiled, fried, or in salads, always present at celebrations.",
                            history: "Introduced in the 16th century, it became essential due to its preservation in salt.",
                            adress: "Laurentina Restaurant, Av. Conde Valbom 71A, Lisbon"
                        )
                    ],
                    latitude: 38.7369, // Laurentina
                    longitude: -9.1525,
                    extraLocations: nil
                ),
                MiniaturaCard(
                    id: 3,
                    imagem: "ginja",
                    categoria: categoria,
                    ordem: 3,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Ginjinha",
                            shortDescription: "Licor tradicional de Lisboa feito de ginjas, servido em copo pequeno.",
                            description: "A ginjinha é um licor doce de cereja, apreciado como aperitivo ou digestivo.",
                            history: "Popularizada no século XIX, tornou-se tradição nos bares do centro de Lisboa.",
                            adress: "A Ginjinha, Largo de São Domingos 8, Lisboa"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Ginjinha",
                            shortDescription: "Lisbon's traditional cherry liqueur, served in a small glass.",
                            description: "Ginjinha is a sweet cherry liqueur, enjoyed as an aperitif or digestif.",
                            history: "Popularized in the 19th century, it became a tradition in Lisbon's downtown bars.",
                            adress: "A Ginjinha, Largo de São Domingos 8, Lisbon"
                        )
                    ],
                    latitude: 38.7146, // A Ginjinha
                    longitude: -9.1396,
                    extraLocations: nil
                ),
                MiniaturaCard(
                    id: 4,
                    imagem: "peixe",
                    categoria: categoria,
                    ordem: 4,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Peixe",
                            shortDescription: "Peixes frescos do Atlântico são base de pratos típicos portugueses.",
                            description: "Sardinha, robalo e dourada são grelhados ou assados, celebrando o sabor do mar.",
                            history: "A pesca sempre foi vital para a economia e cultura das comunidades costeiras.",
                            adress: "Cervejaria Ramiro, Av. Almirante Reis 1, Lisboa"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Fish",
                            shortDescription: "Fresh Atlantic fish are the base of typical Portuguese dishes.",
                            description: "Sardines, sea bass, and gilt-head bream are grilled or baked, celebrating the taste of the sea.",
                            history: "Fishing has always been vital to the economy and culture of coastal communities.",
                            adress: "Ramiro Seafood, Av. Almirante Reis 1, Lisbon"
                        )
                    ],
                    latitude: 38.7223, // Ramiro
                    longitude: -9.1355,
                    extraLocations: nil
                ),
                MiniaturaCard(
                    id: 5,
                    imagem: "carne",
                    categoria: categoria,
                    ordem: 5,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Carne",
                            shortDescription: "Pratos de carne como cozido e leitão são ícones da gastronomia nacional.",
                            description: "Cozido à portuguesa reúne carnes, enchidos e legumes num prato reconfortante.",
                            history: "Receitas de carne refletem influências rurais e festividades tradicionais.",
                            adress: "Solar dos Presuntos, Rua das Portas de Santo Antão 150, Lisboa"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Meat",
                            shortDescription: "Meat dishes like cozido and roast suckling pig are icons of national cuisine.",
                            description: "Cozido à portuguesa combines meats, sausages, and vegetables in a comforting dish.",
                            history: "Meat recipes reflect rural influences and traditional festivities.",
                            adress: "Solar dos Presuntos, Rua das Portas de Santo Antão 150, Lisbon"
                        )
                    ],
                    latitude: 38.7157, // Solar dos Presuntos
                    longitude: -9.1402,
                    extraLocations: nil
                ),
                MiniaturaCard(
                    id: 6,
                    imagem: "sopa",
                    categoria: categoria,
                    ordem: 6,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Sopa",
                            shortDescription: "Sopas como caldo verde aquecem e alimentam em qualquer estação.",
                            description: "Caldo verde leva couve, batata e chouriço, sendo presença constante nas mesas.",
                            history: "Sopas simples eram base da alimentação popular, evoluindo para receitas regionais.",
                            adress: "Zé dos Cornos, Beco dos Surradores 5, Lisboa"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Soup",
                            shortDescription: "Soups like caldo verde warm and nourish in any season.",
                            description: "Caldo verde is made with kale, potato, and chorizo, a constant presence at the table.",
                            history: "Simple soups were the basis of popular diet, evolving into regional recipes.",
                            adress: "Zé dos Cornos, Beco dos Surradores 5, Lisbon"
                        )
                    ],
                    latitude: 38.7152, // Zé dos Cornos
                    longitude: -9.1377,
                    extraLocations: nil
                ),
                MiniaturaCard(
                    id: 7,
                    imagem: "vinho",
                    categoria: categoria,
                    ordem: 7,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Vinho",
                            shortDescription: "Portugal é terra de vinhos únicos, do Porto ao Alentejo.",
                            description: "Tintos, brancos e verdes acompanham pratos e celebram a diversidade do país.",
                            history: "A produção de vinho remonta à época romana, com regiões demarcadas desde o século XVIII.",
                            adress: "Solar do Vinho do Porto, Rua de São Pedro de Alcântara 45, Lisboa"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Wine",
                            shortDescription: "Portugal is a land of unique wines, from Port to Alentejo.",
                            description: "Red, white, and green wines accompany dishes and celebrate the country's diversity.",
                            history: "Wine production dates back to Roman times, with demarcated regions since the 18th century.",
                            adress: "Solar do Vinho do Porto, Rua de São Pedro de Alcântara 45, Lisbon"
                        )
                    ],
                    latitude: 38.7150, // Solar do Vinho do Porto
                    longitude: -9.1432,
                    extraLocations: nil
                ),
                MiniaturaCard(
                    id: 8,
                    imagem: "plus_gastronomy",
                    categoria: categoria,
                    ordem: 8,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Mais Gastronomia",
                            shortDescription: "Descubra novos sabores e receitas tradicionais em todo o país.",
                            description: "A gastronomia portuguesa é rica em ingredientes frescos e receitas de família.",
                            history: "A fusão de culturas e ingredientes fez da cozinha portuguesa uma das mais variadas da Europa.",
                            adress: "Diversos restaurantes e tascas em Portugal"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "More Gastronomy",
                            shortDescription: "Discover new flavors and traditional recipes throughout the country.",
                            description: "Portuguese gastronomy is rich in fresh ingredients and family recipes.",
                            history: "The fusion of cultures and ingredients made Portuguese cuisine one of the most varied in Europe.",
                            adress: "Various restaurants and taverns in Portugal"
                        )
                    ],
                    latitude: 38.7225, // Arbitrário, pode ser alterado
                    longitude: -9.1390,
                    extraLocations: nil
                )
            ]
        }
        if categoria == "Popular" || categoria == "popular" {
            return [
                MiniaturaCard(
                    id: 1,
                    imagem: "azulejos",
                    categoria: categoria,
                    ordem: 1,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Azulejos",
                            shortDescription: "A arte colorida que cobre fachadas e conta histórias em Lisboa.",
                            description: nil,
                            history: nil,
                            adress: nil
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Azulejos",
                            shortDescription: "The colorful art that covers facades and tells stories in Lisbon.",
                            description: nil,
                            history: nil,
                            adress: nil
                        )
                    ],
                    latitude: 38.7139, // Museu Nacional do Azulejo
                    longitude: -9.1162,
                    extraLocations: nil
                ),
                MiniaturaCard(
                    id: 2,
                    imagem: "fado",
                    categoria: categoria,
                    ordem: 2,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Fado",
                            shortDescription: "A música nostálgica que ecoa pelas vielas da cidade.",
                            description: nil,
                            history: nil,
                            adress: nil
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Fado",
                            shortDescription: "The nostalgic music that echoes through the city’s alleys.",
                            description: nil,
                            history: nil,
                            adress: nil
                        )
                    ],
                    latitude: 38.7132, // Museu do Fado
                    longitude: -9.1296,
                    extraLocations: nil
                ),
                MiniaturaCard(
                    id: 3,
                    imagem: "tram28",
                    categoria: categoria,
                    ordem: 3,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Eléctrico 28",
                            shortDescription: "O bonde mais famoso de Lisboa, cruzando bairros históricos.",
                            description: nil,
                            history: nil,
                            adress: nil
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Tram 28",
                            shortDescription: "Lisbon’s most famous tram, crossing historic neighborhoods.",
                            description: nil,
                            history: nil,
                            adress: nil
                        )
                    ],
                    latitude: 38.7167, // Paragem Martim Moniz
                    longitude: -9.1356,
                    extraLocations: nil
                ),
                MiniaturaCard(
                    id: 4,
                    imagem: "tascas",
                    categoria: categoria,
                    ordem: 4,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Tascas",
                            shortDescription: "Pequenos restaurantes típicos, cheios de sabor e tradição.",
                            description: nil,
                            history: nil,
                            adress: nil
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Tascas",
                            shortDescription: "Small typical restaurants, full of flavor and tradition.",
                            description: nil,
                            history: nil,
                            adress: nil
                        )
                    ],
                    latitude: 38.7135, // Tasca do Chico
                    longitude: -9.1460,
                    extraLocations: nil
                ),
                MiniaturaCard(
                    id: 5,
                    imagem: "ladra",
                    categoria: categoria,
                    ordem: 5,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Feira da Ladra",
                            shortDescription: "O mercado de pulgas mais famoso para achados e antiguidades.",
                            description: nil,
                            history: nil,
                            adress: nil
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Feira da Ladra",
                            shortDescription: "The most famous flea market for finds and antiques.",
                            description: nil,
                            history: nil,
                            adress: nil
                        )
                    ],
                    latitude: 38.7172, // Feira da Ladra
                    longitude: -9.1246,
                    extraLocations: nil
                ),
                MiniaturaCard(
                    id: 6,
                    imagem: "futebol",
                    categoria: categoria,
                    ordem: 6,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Football",
                            shortDescription: "A paixão nacional que une multidões em Lisboa.",
                            description: nil,
                            history: nil,
                            adress: nil
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Football",
                            shortDescription: "The national passion that brings crowds together in Lisbon.",
                            description: nil,
                            history: nil,
                            adress: nil
                        )
                    ],
                    latitude: 38.7633, // Estádio da Luz
                    longitude: -9.1847,
                    extraLocations: nil
                ),
                MiniaturaCard(
                    id: 7,
                    imagem: "santos",
                    categoria: categoria,
                    ordem: 7,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Santos Populares",
                            shortDescription: "Festas de rua animadas com música, sardinha e alegria.",
                            description: nil,
                            history: nil,
                            adress: nil
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Santos Populares",
                            shortDescription: "Lively street festivals with music, sardines, and joy.",
                            description: nil,
                            history: nil,
                            adress: nil
                        )
                    ],
                    latitude: 38.7131, // Bairro Alto (Santos Populares)
                    longitude: -9.1449,
                    extraLocations: nil
                ),
                MiniaturaCard(
                    id: 8,
                    imagem: "plus_popular",
                    categoria: categoria,
                    ordem: 8,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Mais Tradições",
                            shortDescription: "Descubra outras tradições e costumes lisboetas.",
                            description: nil,
                            history: nil,
                            adress: nil
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "More Traditions",
                            shortDescription: "Discover other Lisbon traditions and customs.",
                            description: nil,
                            history: nil,
                            adress: nil
                        )
                    ],
                    latitude: 38.7200, // Arbitrário, pode ser alterado
                    longitude: -9.1400,
                    extraLocations: nil
                )
            ]
        }
        if categoria == "Churches" || categoria == "Igrejas" {
            return [
                MiniaturaCard(
                    id: 1,
                    imagem: "se_lisboa",
                    categoria: categoria,
                    ordem: 1,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Sé Catedral",
                            shortDescription: "A catedral mais antiga de Lisboa, símbolo da fé e da história da cidade.",
                            description: nil,
                            history: nil,
                            adress: nil
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Sé Cathedral",
                            shortDescription: "Lisbon's oldest cathedral, a symbol of faith and the city's history.",
                            description: nil,
                            history: nil,
                            adress: nil
                        )
                    ],
                    latitude: 38.7108, // Sé de Lisboa
                    longitude: -9.1332,
                    extraLocations: nil
                ),
                MiniaturaCard(
                    id: 2,
                    imagem: "jeronimos",
                    categoria: categoria,
                    ordem: 2,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Mosteiro dos Jerónimos",
                            shortDescription: "Obra-prima do manuelino e Patrimônio Mundial da UNESCO.",
                            description: nil,
                            history: nil,
                            adress: nil
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Jerónimos Monastery",
                            shortDescription: "A Manueline masterpiece and UNESCO World Heritage Site.",
                            description: nil,
                            history: nil,
                            adress: nil
                        )
                    ],
                    latitude: 38.6978, // Mosteiro dos Jerónimos
                    longitude: -9.2065,
                    extraLocations: nil
                ),
                MiniaturaCard(
                    id: 3,
                    imagem: "sao_domingos",
                    categoria: categoria,
                    ordem: 3,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "São Domingos",
                            shortDescription: "Igreja marcada por tragédias e reconstruções, cheia de história.",
                            description: nil,
                            history: nil,
                            adress: nil
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "São Domingos",
                            shortDescription: "A church marked by tragedies and reconstructions, full of history.",
                            description: nil,
                            history: nil,
                            adress: nil
                        )
                    ],
                    latitude: 38.7142, // Igreja de São Domingos
                    longitude: -9.1392,
                    extraLocations: nil
                ),
                MiniaturaCard(
                    id: 4,
                    imagem: "sao_roque",
                    categoria: categoria,
                    ordem: 4,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "São Roque",
                            shortDescription: "Uma das igrejas jesuítas mais antigas do mundo, com interior riquíssimo.",
                            description: nil,
                            history: nil,
                            adress: nil
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "São Roque",
                            shortDescription: "One of the oldest Jesuit churches in the world, with a rich interior.",
                            description: nil,
                            history: nil,
                            adress: nil
                        )
                    ],
                    latitude: 38.7147, // Igreja de São Roque
                    longitude: -9.1441,
                    extraLocations: nil
                ),
                MiniaturaCard(
                    id: 5,
                    imagem: "basilica_estrela",
                    categoria: categoria,
                    ordem: 5,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Basílica da Estrela",
                            shortDescription: "Imponente basílica de cúpula branca, referência no horizonte lisboeta.",
                            description: nil,
                            history: nil,
                            adress: nil
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Estrela Basilica",
                            shortDescription: "Imposing white-domed basilica, a landmark in Lisbon's skyline.",
                            description: nil,
                            history: nil,
                            adress: nil
                        )
                    ],
                    latitude: 38.7162, // Basílica da Estrela
                    longitude: -9.1604,
                    extraLocations: nil
                ),
                MiniaturaCard(
                    id: 6,
                    imagem: "ruinasdocarmo",
                    categoria: categoria,
                    ordem: 6,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Carmo",
                            shortDescription: "Ruínas góticas que testemunham o grande terremoto de 1755.",
                            description: nil,
                            history: nil,
                            adress: nil
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Carmo",
                            shortDescription: "Gothic ruins that bear witness to the great 1755 earthquake.",
                            description: nil,
                            history: nil,
                            adress: nil
                        )
                    ],
                    latitude: 38.7126, // Ruínas do Carmo
                    longitude: -9.1416,
                    extraLocations: nil
                ),
                MiniaturaCard(
                    id: 7,
                    imagem: "cristo",
                    categoria: categoria,
                    ordem: 7,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Cristo-Rei",
                            shortDescription: "Estátua monumental com vista panorâmica sobre Lisboa e o Tejo.",
                            description: nil,
                            history: nil,
                            adress: nil
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Cristo Rei",
                            shortDescription: "Monumental statue with panoramic views over Lisbon and the Tagus.",
                            description: nil,
                            history: nil,
                            adress: nil
                        )
                    ],
                    latitude: 38.6781, // Cristo Rei
                    longitude: -9.1776,
                    extraLocations: nil
                ),
                MiniaturaCard(
                    id: 8,
                    imagem: "fatima",
                    categoria: categoria,
                    ordem: 8,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Mais Igrejas",
                            shortDescription: "Descubra outras igrejas e templos históricos de Lisboa.",
                            description: nil,
                            history: nil,
                            adress: nil
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "More Churches",
                            shortDescription: "Discover other historic churches and temples in Lisbon.",
                            description: nil,
                            history: nil,
                            adress: nil
                        )
                    ],
                    latitude: 39.6325, // Santuário de Fátima
                    longitude: -8.6718,
                    extraLocations: nil
                )
            ]
        }
        if categoria == "Museus" || categoria == "Museums" {
            return [
                MiniaturaCard(
                    id: 1,
                    imagem: "azulejos_museu",
                    categoria: categoria,
                    ordem: 1,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Museu dos Azulejos",
                            shortDescription: "Celebra a arte dos azulejos portugueses do século XV ao presente.",
                            description: nil,
                            history: nil,
                            adress: nil
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Tile Museum",
                            shortDescription: "Celebrates the art of Portuguese tiles from the 15th century to today.",
                            description: nil,
                            history: nil,
                            adress: nil
                        )
                    ],
                    latitude: 38.7231, // Museu Nacional do Azulejo
                    longitude: -9.1156,
                    extraLocations: nil
                ),
                MiniaturaCard(
                    id: 2,
                    imagem: "fcg",
                    categoria: categoria,
                    ordem: 2,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Museu Gulbenkian",
                            shortDescription: "Coleção de arte de renome mundial, do Egito à arte moderna.",
                            description: nil,
                            history: nil,
                            adress: nil
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Gulbenkian Museum",
                            shortDescription: "World-class art collection, from Egypt to modern art.",
                            description: nil,
                            history: nil,
                            adress: nil
                        )
                    ],
                    latitude: 38.7371, // Museu Calouste Gulbenkian
                    longitude: -9.1527,
                    extraLocations: nil
                ),
                MiniaturaCard(
                    id: 3,
                    imagem: "coches",
                    categoria: categoria,
                    ordem: 3,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Museu dos Coches",
                            shortDescription: "A maior coleção de coches reais do mundo.",
                            description: nil,
                            history: nil,
                            adress: nil
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Coach Museum",
                            shortDescription: "The world's largest collection of royal coaches.",
                            description: nil,
                            history: nil,
                            adress: nil
                        )
                    ],
                    latitude: 38.6973, // Museu Nacional dos Coches
                    longitude: -9.1976,
                    extraLocations: nil
                ),
                MiniaturaCard(
                    id: 4,
                    imagem: "fado",
                    categoria: categoria,
                    ordem: 4,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Museu do Fado",
                            shortDescription: "Dedicado à história e cultura do Fado, música de Lisboa.",
                            description: nil,
                            history: nil,
                            adress: nil
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Fado Museum",
                            shortDescription: "Dedicated to the history and culture of Fado, Lisbon's music.",
                            description: nil,
                            history: nil,
                            adress: nil
                        )
                    ],
                    latitude: 38.7132, // Museu do Fado
                    longitude: -9.1296,
                    extraLocations: nil
                ),
                MiniaturaCard(
                    id: 5,
                    imagem: "arte_antiga",
                    categoria: categoria,
                    ordem: 5,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Museu de Arte Antiga",
                            shortDescription: "Obras-primas da arte portuguesa e europeia dos séculos XII a XIX.",
                            description: nil,
                            history: nil,
                            adress: nil
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Ancient Art Museum",
                            shortDescription: "Masterpieces of Portuguese and European art from the 12th to 19th centuries.",
                            description: nil,
                            history: nil,
                            adress: nil
                        )
                    ],
                    latitude: 38.7074, // Museu Nacional de Arte Antiga
                    longitude: -9.1702,
                    extraLocations: nil
                ),
                MiniaturaCard(
                    id: 6,
                    imagem: "ccb",
                    categoria: categoria,
                    ordem: 6,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "CCB",
                            shortDescription: "Centro Cultural de Belém: exposições, concertos e arte contemporânea.",
                            description: nil,
                            history: nil,
                            adress: nil
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "CCB",
                            shortDescription: "Belém Cultural Center: exhibitions, concerts, and contemporary art.",
                            description: nil,
                            history: nil,
                            adress: nil
                        )
                    ],
                    latitude: 38.6956, // Centro Cultural de Belém
                    longitude: -9.2070,
                    extraLocations: nil
                ),
                MiniaturaCard(
                    id: 7,
                    imagem: "maat",
                    categoria: categoria,
                    ordem: 7,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "MAAT",
                            shortDescription: "Museu de Arte, Arquitetura e Tecnologia à beira do Tejo.",
                            description: nil,
                            history: nil,
                            adress: nil
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "MAAT",
                            shortDescription: "Museum of Art, Architecture and Technology by the Tagus river.",
                            description: nil,
                            history: nil,
                            adress: nil
                        )
                    ],
                    latitude: 38.6952, // MAAT
                    longitude: -9.1970,
                    extraLocations: nil
                ),
                MiniaturaCard(
                    id: 8,
                    imagem: "plus_museums",
                    categoria: categoria,
                    ordem: 8,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Mais Museus",
                            shortDescription: "Descubra outros museus fascinantes de Lisboa.",
                            description: nil,
                            history: nil,
                            adress: nil
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "More Museums",
                            shortDescription: "Discover other fascinating museums in Lisbon.",
                            description: nil,
                            history: nil,
                            adress: nil
                        )
                    ],
                    latitude: 38.7200, // Arbitrário, pode ser alterado
                    longitude: -9.1400,
                    extraLocations: nil
                )
            ]
        }
        if cat == "sintra" {
            return [
                MiniaturaCard(
                    id: 1,
                    imagem: "palacio_pena",
                    categoria: "Sintra",
                    ordem: 1,
                    translations: [
                        "en": MiniaturaCardTranslation(
                            titulo: "Palácio da Pena",
                            shortDescription: "A colorful Romanticist palace on a hilltop, symbol of Sintra.",
                            description: nil,
                            history: nil,
                            adress: nil
                        ),
                        "pt": MiniaturaCardTranslation(
                            titulo: "Palácio da Pena",
                            shortDescription: "Palácio romântico e colorido no topo da serra, símbolo de Sintra.",
                            description: nil,
                            history: nil,
                            adress: nil
                        )
                    ],
                    latitude: 38.7876, // Palácio da Pena
                    longitude: -9.3904,
                    extraLocations: nil
                ),
                MiniaturaCard(
                    id: 2,
                    imagem: "travesseiros",
                    categoria: "Sintra",
                    ordem: 2,
                    translations: [
                        "en": MiniaturaCardTranslation(
                            titulo: "Travesseiros & Queijadas",
                            shortDescription: "Traditional Sintra pastries, sweet and unique.",
                            description: nil,
                            history: nil,
                            adress: nil
                        ),
                        "pt": MiniaturaCardTranslation(
                            titulo: "Travesseiros e Queijadas",
                            shortDescription: "Doces típicos de Sintra, saborosos e únicos.",
                            description: nil,
                            history: nil,
                            adress: nil
                        )
                    ],
                    latitude: 38.7971, // Piriquita (Travesseiros)
                    longitude: -9.3907,
                    extraLocations: nil
                ),
                MiniaturaCard(
                    id: 3,
                    imagem: "castelo_mouros",
                    categoria: "Sintra",
                    ordem: 3,
                    translations: [
                        "en": MiniaturaCardTranslation(
                            titulo: "Castelo dos Mouros",
                            shortDescription: "Ancient Moorish castle with panoramic views.",
                            description: nil,
                            history: nil,
                            adress: nil
                        ),
                        "pt": MiniaturaCardTranslation(
                            titulo: "Castelo dos Mouros",
                            shortDescription: "Castelo mouro antigo com vistas panorâmicas.",
                            description: nil,
                            history: nil,
                            adress: nil
                        )
                    ],
                    latitude: 38.7925, // Castelo dos Mouros
                    longitude: -9.3867,
                    extraLocations: nil
                ),
                MiniaturaCard(
                    id: 4,
                    imagem: "quinta_regaleira",
                    categoria: "Sintra",
                    ordem: 4,
                    translations: [
                        "en": MiniaturaCardTranslation(
                            titulo: "Quinta da Regaleira",
                            shortDescription: "A mystical estate with gardens, tunnels, and symbolism.",
                            description: nil,
                            history: nil,
                            adress: nil
                        ),
                        "pt": MiniaturaCardTranslation(
                            titulo: "Quinta da Regaleira",
                            shortDescription: "Propriedade mística com jardins, túneis e simbolismo.",
                            description: nil,
                            history: nil,
                            adress: nil
                        )
                    ],
                    latitude: 38.7976, // Quinta da Regaleira
                    longitude: -9.3964,
                    extraLocations: nil
                ),
                MiniaturaCard(
                    id: 5,
                    imagem: "monserrate_parque",
                    categoria: "Sintra",
                    ordem: 5,
                    translations: [
                        "en": MiniaturaCardTranslation(
                            titulo: "Parque de Monserrate",
                            shortDescription: "Exotic gardens and a unique palace in Sintra.",
                            description: nil,
                            history: nil,
                            adress: nil
                        ),
                        "pt": MiniaturaCardTranslation(
                            titulo: "Parque de Monserrate",
                            shortDescription: "Jardins exóticos e palácio único em Sintra.",
                            description: nil,
                            history: nil,
                            adress: nil
                        )
                    ],
                    latitude: 38.7952, // Parque de Monserrate
                    longitude: -9.4056,
                    extraLocations: nil
                ),
                MiniaturaCard(
                    id: 6,
                    imagem: "convento_capuchos",
                    categoria: "Sintra",
                    ordem: 6,
                    translations: [
                        "en": MiniaturaCardTranslation(
                            titulo: "Convento dos Capuchos",
                            shortDescription: "A humble and historic convent surrounded by nature.",
                            description: nil,
                            history: nil,
                            adress: nil
                        ),
                        "pt": MiniaturaCardTranslation(
                            titulo: "Convento dos Capuchos",
                            shortDescription: "Convento humilde e histórico rodeado de natureza.",
                            description: nil,
                            history: nil,
                            adress: nil
                        )
                    ],
                    latitude: 38.7857, // Convento dos Capuchos
                    longitude: -9.4302,
                    extraLocations: nil
                ),
                MiniaturaCard(
                    id: 7,
                    imagem: "palacio_vila",
                    categoria: "Sintra",
                    ordem: 7,
                    translations: [
                        "en": MiniaturaCardTranslation(
                            titulo: "Palácio da Vila",
                            shortDescription: "The medieval royal palace in the heart of Sintra.",
                            description: nil,
                            history: nil,
                            adress: nil
                        ),
                        "pt": MiniaturaCardTranslation(
                            titulo: "Palácio da Vila",
                            shortDescription: "O palácio real medieval no centro de Sintra.",
                            description: nil,
                            history: nil,
                            adress: nil
                        )
                    ],
                    latitude: 38.7972, // Palácio Nacional de Sintra
                    longitude: -9.3907,
                    extraLocations: nil
                ),
                MiniaturaCard(
                    id: 8,
                    imagem: "plus_sintra",
                    categoria: "Sintra",
                    ordem: 8,
                    translations: [
                        "en": MiniaturaCardTranslation(
                            titulo: "Mais Sintra",
                            shortDescription: "Discover even more wonders in Sintra!",
                            description: nil,
                            history: nil,
                            adress: nil
                        ),
                        "pt": MiniaturaCardTranslation(
                            titulo: "Mais Sintra",
                            shortDescription: "Descubra ainda mais maravilhas em Sintra!",
                            description: nil,
                            history: nil,
                            adress: nil
                        )
                    ],
                    latitude: 38.8000, // Arbitrário, pode ser alterado
                    longitude: -9.3900,
                    extraLocations: nil
                )
            ]
        }
        if cat == "vocabulario" {
            return [
                MiniaturaCard(
                    id: 1,
                    imagem: "telemovel",
                    categoria: "Vocabulário",
                    ordem: 1,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Telémovel",
                            shortDescription: "Palavra portuguesa para celular (Brasil) ou mobile phone (UK).",
                            description: nil,
                            history: nil,
                            adress: nil
                        )
                    ],
                    latitude: nil,
                    longitude: nil,
                    extraLocations: nil
                ),
                MiniaturaCard(
                    id: 2,
                    imagem: "comboio",
                    categoria: "Vocabulário",
                    ordem: 2,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Comboio",
                            shortDescription: "Trem (Brasil) ou train (UK/US).",
                            description: nil,
                            history: nil,
                            adress: nil
                        )
                    ],
                    latitude: nil,
                    longitude: nil,
                    extraLocations: nil
                ),
                MiniaturaCard(
                    id: 3,
                    imagem: "autocarro",
                    categoria: "Vocabulário",
                    ordem: 3,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Autocarro",
                            shortDescription: "Ônibus (Brasil) ou bus (UK/US).",
                            description: nil,
                            history: nil,
                            adress: nil
                        )
                    ],
                    latitude: nil,
                    longitude: nil,
                    extraLocations: nil
                ),
                MiniaturaCard(
                    id: 4,
                    imagem: "tram28",
                    categoria: "Vocabulário",
                    ordem: 4,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Eléctrico",
                            shortDescription: "Bonde (Brasil) ou tram (UK).",
                            description: nil,
                            history: nil,
                            adress: nil
                        )
                    ],
                    latitude: nil,
                    longitude: nil,
                    extraLocations: nil
                ),
                MiniaturaCard(
                    id: 5,
                    imagem: "bicha",
                    categoria: "Vocabulário",
                    ordem: 5,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Bicha",
                            shortDescription: "Fila (Brasil) ou queue (UK). Atenção: tem outro significado no Brasil!",
                            description: nil,
                            history: nil,
                            adress: nil
                        )
                    ],
                    latitude: nil,
                    longitude: nil,
                    extraLocations: nil
                ),
                MiniaturaCard(
                    id: 6,
                    imagem: "pequenoAlmoco",
                    categoria: "Vocabulário",
                    ordem: 6,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Pequeno-almoço",
                            shortDescription: "Café da manhã (Brasil) ou breakfast (UK/US).",
                            description: nil,
                            history: nil,
                            adress: nil
                        )
                    ],
                    latitude: nil,
                    longitude: nil,
                    extraLocations: nil
                ),
                MiniaturaCard(
                    id: 7,
                    imagem: "casaBanho",
                    categoria: "Vocabulário",
                    ordem: 7,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Casa de banho",
                            shortDescription: "Banheiro (Brasil) ou bathroom/restroom (UK/US).",
                            description: nil,
                            history: nil,
                            adress: nil
                        )
                    ],
                    latitude: nil,
                    longitude: nil,
                    extraLocations: nil
                )
            ]
        }
        if cat == "vocabulary" {
            return [
                MiniaturaCard(
                    id: 1,
                    imagem: "ola",
                    categoria: "Vocabulary",
                    ordem: 1,
                    translations: [
                        "en": MiniaturaCardTranslation(
                            titulo: "Hello",
                            shortDescription: "A common greeting in English.",
                            description: nil,
                            history: nil,
                            adress: nil
                        )
                    ],
                    latitude: nil,
                    longitude: nil,
                    extraLocations: nil
                ),
                MiniaturaCard(
                    id: 2,
                    imagem: "porFavor",
                    categoria: "Vocabulary",
                    ordem: 2,
                    translations: [
                        "en": MiniaturaCardTranslation(
                            titulo: "Please",
                            shortDescription: "Used to make polite requests.",
                            description: nil,
                            history: nil,
                            adress: nil
                        )
                    ],
                    latitude: nil,
                    longitude: nil,
                    extraLocations: nil
                ),
                MiniaturaCard(
                    id: 3,
                    imagem: "simNao",
                    categoria: "Vocabulary",
                    ordem: 3,
                    translations: [
                        "en": MiniaturaCardTranslation(
                            titulo: "yes / no",
                            shortDescription: "Basic words for affirmation and negation.",
                            description: nil,
                            history: nil,
                            adress: nil
                        )
                    ],
                    latitude: nil,
                    longitude: nil,
                    extraLocations: nil
                ),
                MiniaturaCard(
                    id: 4,
                    imagem: "obrigado",
                    categoria: "Vocabulary",
                    ordem: 4,
                    translations: [
                        "en": MiniaturaCardTranslation(
                            titulo: "Thank you",
                            shortDescription: "To express gratitude.",
                            description: nil,
                            history: nil,
                            adress: nil
                        )
                    ],
                    latitude: nil,
                    longitude: nil,
                    extraLocations: nil
                ),
                MiniaturaCard(
                    id: 5,
                    imagem: "bomDia",
                    categoria: "Vocabulary",
                    ordem: 5,
                    translations: [
                        "en": MiniaturaCardTranslation(
                            titulo: "Good Day / Good Night",
                            shortDescription: "Greetings for different times of the day.",
                            description: nil,
                            history: nil,
                            adress: nil
                        )
                    ],
                    latitude: nil,
                    longitude: nil,
                    extraLocations: nil
                ),
                MiniaturaCard(
                    id: 6,
                    imagem: "desculpe",
                    categoria: "Vocabulary",
                    ordem: 6,
                    translations: [
                        "en": MiniaturaCardTranslation(
                            titulo: "Excuse me",
                            shortDescription: "Used to get attention or apologize.",
                            description: nil,
                            history: nil,
                            adress: nil
                        )
                    ],
                    latitude: nil,
                    longitude: nil,
                    extraLocations: nil
                ),
                MiniaturaCard(
                    id: 7,
                    imagem: "adeus",
                    categoria: "Vocabulary",
                    ordem: 7,
                    translations: [
                        "en": MiniaturaCardTranslation(
                            titulo: "Goodbye",
                            shortDescription: "A way to say farewell.",
                            description: nil,
                            history: nil,
                            adress: nil
                        )
                    ],
                    latitude: nil,
                    longitude: nil,
                    extraLocations: nil
                )
            ]
        }
        let imagePrefix: String
        switch categoria {
        case "Natureza": imagePrefix = "nature"
        case "Gastronomy": imagePrefix = "gastronomy"
        case "Popular": imagePrefix = "popular"
        case "Churches": imagePrefix = "churches"
        case "Museums": imagePrefix = "museums"
        case "Sintra": imagePrefix = "sintra"
        case "Vocabulary": imagePrefix = "vocabulary"
        default: imagePrefix = "monuments"
        }
        return (1...8).map { i in
            MiniaturaCard(
                id: i,
                imagem: "\(imagePrefix)\(i)",
                categoria: categoria,
                ordem: i,
                translations: [
                    "en": MiniaturaCardTranslation(
                        titulo: "Title \(i) - \(categoria)",
                        shortDescription: "Short description for card \(i) in category \(categoria).",
                        description: nil,
                        history: nil,
                        adress: nil
                    ),
                    "pt": MiniaturaCardTranslation(
                        titulo: "Título \(i) - \(categoria)",
                        shortDescription: "Descrição curta do cartão \(i) da categoria \(categoria).",
                        description: nil,
                        history: nil,
                        adress: nil
                    )
                ],
                latitude: nil,
                longitude: nil,
                extraLocations: nil
            )
        }
    }
    
    static func allCategories() -> [String] {
        // Retorna todas as categorias originais dos mocks
        let all = [
            mockCards(for: "Monumentos"),
            mockCards(for: "Natureza"),
            mockCards(for: "Gastronomia"),
            mockCards(for: "Cultura"),
            mockCards(for: "Praias"),
            mockCards(for: "Museus"),
            mockCards(for: "Parques"),
            mockCards(for: "Tradições"),
            mockCards(for: "Vocabulary")
        ].flatMap { $0 }
        let unique = Set(all.map { $0.categoria })
        return Array(unique)
    }
    
    public static func mockCards(for categoria: String) -> [MiniaturaCard] {
        let normalizedCategoria = categoria.normalized
        return allCards().filter { $0.categoria.normalized == normalizedCategoria }
    }
}
