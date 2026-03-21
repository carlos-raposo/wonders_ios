import Foundation

struct MiniaturaCard: Identifiable {
    let id: Int
    let imagem: String // nome do asset
    let categoria: String
    let ordem: Int
    let translations: [String: MiniaturaCardTranslation]
    let locations: [(name: [String: String], latitude: Double, longitude: Double)]? // lista de localizações multi-idioma
    // Custom zoom and center for map
    let zoomSpan: (latitudeDelta: Double, longitudeDelta: Double)?
    let customCenter: (latitude: Double, longitude: Double)?
}

struct MiniaturaCardTranslation {
    let titulo: String
    let shortDescription: String
    let description: String?
    let history: String?
    let destaques: String?
    let adress: String?
    let usage: String?
    let pronunciation: String?

    init(
        titulo: String,
        shortDescription: String,
        description: String? = nil,
        history: String? = nil,
        destaques: String? = nil,
        adress: String? = nil,
        usage: String? = nil,
        pronunciation: String? = nil
    ) {
        self.titulo = titulo
        self.shortDescription = shortDescription
        self.description = description
        self.history = history
        self.destaques = destaques
        self.adress = adress
        self.usage = usage
        self.pronunciation = pronunciation
    }
}

extension String {
    // Remove accents, lowercase, and trim whitespace for robust comparison
    var normalized: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
                   .folding(options: .diacriticInsensitive, locale: .current)
                   .lowercased()
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
                let uniqueCard = MiniaturaCard(
                    id: globalId,
                    imagem: card.imagem,
                    categoria: cat,
                    ordem: card.ordem,
                    translations: card.translations,
                    locations: card.locations, // new unified locations
                    zoomSpan: card.zoomSpan, // Adicionado explicitamente
                    customCenter: card.customCenter // Adicionado explicitamente
                )
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
                            titulo: "São Jorge Castle ⛫ ",
                            shortDescription: "Founded in the 10th by the Moors and conquered by the first king of 🇵🇹 Portugal in 1147.",
                            description: "An imposing medieval fortification in the Gothic style stands on the highest hill in Lisbon, offering panoramic views over the Portuguese capital. Originally built in the 5th century, with Arab and Christian influences, the structure is made of limestone, with robust walls and defensive towers.\n A visit to this iconic monument is an immersion in the history of Portugal, with the opportunity to appreciate the stunning landscapes of the city and the Tagus River.",
                            history: "While its original construction dates back to the 5th century, the castle underwent several expansions and adaptations over the centuries, notably in the 11th and 12th centuries. Its initial purpose was to defend the city of Lisbon, protecting it from invasions and attacks. Later, the castle served as a royal residence and was the scene of important historical events. One of the most significant milestones in the city's history and the formation of Portugal was the conquest of the castle by D. Afonso Henriques from the Moors in 1147.",
                            adress: "Rua de Santa Cruz do Castelo, 1100-129 Lisboa, Portugal"
                        ),
                        "pt": MiniaturaCardTranslation(
                            titulo: "Castelo de São Jorge ⛫ ",
                            shortDescription: "Fundado nos séculos X pelos mouros e conquistado pelo primeiro rei de 🇵🇹 Portugal em 1147.",
                            description: "Uma imponente fortificação medieval de estilo gótico situada na colina mais alta de Lisboa, oferecendo vistas panorâmicas sobre a capital portuguesa. Originalmente construído no século V, com influências árabes e cristãs, a estrutura é feita de calcário, com robustas muralhas e torres defensivas.\n A visita a este monumento icônico é uma imersão na história de Portugal, com a oportunidade de apreciar as paisagens deslumbrantes da cidade e do Rio Tejo.",
                            history: "Embora sua construção original remonte ao século V, o castelo passou por várias expansões e adaptações ao longo dos séculos, notavelmente nos séculos XI e XII. Seu propósito inicial era defender a cidade de Lisboa, protegendo-a de invasões e ataques. Posteriormente, o castelo serviu como residência real e foi palco de importantes eventos históricos. Um dos marcos mais significativos na história da cidade e na formação de Portugal foi a conquista do castelo por D. Afonso Henriques aos mouros em 1147.",
                            adress: "Rua de Santa Cruz do Castelo, 1100-129 Lisboa, Portugal"
                        ),
                        "fr": MiniaturaCardTranslation(
                            titulo: "Château de Saint-Georges ⛫ ",
                            shortDescription: "Fondé au Xe siècle par les Maures et conquis par le premier roi du 🇵🇹 Portugal en 1147.",
                            description: "Imposante forteresse médiévale de style gothique, elle s'élève sur la plus haute colline de Lisbonne, offrant des vues panoramiques sur la capitale portugaise. Construite à l'origine au 5ème siècle, avec des influences arabes et chrétiennes, la structure est faite de calcaire, avec de robustes remparts et des tours de défense.\nUne visite à ce monument emblématique est une immersion dans l'histoire du Portugal, avec l'occasion d'apprécier les paysages éblouissants de la ville et du fleuve Tejo.",
                            history: "Bien que sa construction originale remonte au Ve siècle, le château a subi plusieurs expansions et adaptations au fil des siècles, notamment aux XIe et XIIe siècles. Son objectif initial était de défendre la ville de Lisbonne, la protégeant des invasions et des attaques. Plus tard, le château a servi de résidence royale et a été le théâtre d'événements historiques importants. L'un des jalons les plus significatifs de l'histoire de la ville et de la formation du Portugal a été la conquête du château par D. Afonso Henriques aux Maures en 1147.",
                            adress: "Rua de Santa Cruz do Castelo, 1100-129 Lisbonne, Portugal"
                        ),
                        "es": MiniaturaCardTranslation(
                            titulo: "Castillo de São Jorge ⛫ ",
                            shortDescription: "Conquistado por D. Afonso Henriques en 1147, es un ejemplo impresionante de la arquitectura manuelina.",
                            description: "Este impresionante castillo de estilo manuelino se erige en la cima de uma colina, ofreciendo vistas panorámicas de Lisboa. Fundado en el siglo XV con influencias árabes y cristianas, el castillo es un testimonio de la historia de Portugal y un lugar imprescindible para los amantes de la historia y la arquitectura.",
                            history: "El castillo de São Jorge fue construido en el siglo XV, durante el reinado de D. Afonso Henriques, como una fortaleza para proteger la ciudad de Lisboa. A lo largo de los siglos, el castillo ha sido testigo de importantes eventos históricos, como la invasión napoleónica y la Revolución de los Claveles. Hoy en día, el castillo es un importante destino turístico y un símbolo de la historia y la cultura portuguesa.",
                            adress: "Rua de Santa Cruz do Castelo, 1100-129 Lisboa, Portugal"
                            ),
                    ],
                    locations: [
                        (name: ["en": "São Jorge Castle", "pt": "Castelo de São Jorge", "es": "Castillo de São Jorge", "fr": "Château de São Jorge"], latitude: 38.713909, longitude: -9.133476)
                    ],
                    zoomSpan: (latitudeDelta: 0.01, longitudeDelta: 0.01),
                    customCenter: nil
                ),
                MiniaturaCard(
                    id: 2,
                    imagem: "torre_belem",
                    categoria: categoria,
                    ordem: 2,
                    translations: [
                        "en": MiniaturaCardTranslation(
                            titulo: "Belém Tower ⛫ ",
                            shortDescription: "Built in the early 16th century, it is a portal to Portugal’s maritime past.",
                            description: "An emblematic 15th-century Manueline-style fortification, formerly the gateway to Lisbon. The structure is made of limestone, with ornate details and sculptures of maritime and nationalist themes.\n A must-see monument to learn about Portugal's maritime history, appreciate its unique architecture, and enjoy the views of the Tagus River.",
                            history: "The Manueline style is a unique and exuberant artistic style that flourished in Portugal during the reign of King Manuel I in the 16th century. This style is closely linked to the golden age of Portuguese maritime discoveries, a period of great prosperity and territorial expansion for the country. The tower was built at a time when Portugal was a maritime power, and its strategic location in the Tagus estuary made it a starting point for the great navigations. Construction was completed in 1519, with the function of defending the city. Later, it served as a customs house and lighthouse.\n It was classified as a UNESCO World Heritage Site in 1983, recognizing its historical and cultural importance.",
                            adress: "Av. Brasília, 1400-038 Lisboa, Portugal"
                        ),
                        "pt": MiniaturaCardTranslation(
                            titulo: "Torre de Belém ⛫ ",
                            shortDescription: "Construído no início do século 16, é um portal para o passado marítimo de Portugal.",
                            description: "Uma emblemática fortificação de estilo manuelino do século XV, que antigamente servia como porta de entrada para Lisboa. A estrutura é feita de calcário, com detalhes ornamentais e esculturas de temas marítimos e nacionalistas.\n Um monumento imperdível para conhecer a história marítima de Portugal, apreciar sua arquitetura única e desfrutar das vistas do Rio Tejo.",
                            history: "O estilo manuelino é um estilo artístico único e exuberante que floresceu em Portugal durante o reinado do rei Manuel I no século XVI. Este estilo está intimamente ligado à era dourada das descobertas marítimas portuguesas, um período de grande prosperidade e expansão territorial para o país. A torre foi construída numa época em que Portugal era uma potência marítima, e sua localização estratégica na foz do Tejo a tornava um ponto de partida para as grandes navegações. A construção foi concluída em 1519, com a função de defender a cidade. Posteriormente, serviu como alfândega e farol.\n Foi classificada como Patrimônio Mundial da UNESCO em 1983, reconhecendo sua importância histórica e cultural.",
                            adress: "Av. Brasília, 1400-038 Lisboa, Portugal"
                        ),
                        "fr": MiniaturaCardTranslation(
                            titulo: "Tour de Belém ⛫ ",
                            shortDescription: "Construit au début du XVIe siècle, c'est un portail vers le passé maritime du Portugal.",
                            description: "Forteresse emblématique du 15ème siècle de style Manuel, autrefois porte d'entrée de Lisbonne. La structure est construite en calcaire, avec des détails ornementés et des sculptures de thèmes maritimes et nationalistes. Un monument incontournable pour connaître l'histoire maritime du Portugal, apprécier l'architecture unique et les vues sur le Tage.",
                            history: "Le style manuélin est un style artistique unique et exubérant qui a prospéré au Portugal sous le règne du roi Manuel Ier au XVIe siècle. Ce style est étroitement lié à l'âge d'or des découvertes maritimes portugaises, une période de grande prospérité et d'expansion territoriale pour le pays. La tour a été construite à une époque où le Portugal était une puissance maritime, et sa position stratégique à l'embouchure du Tage en faisait un point de départ pour les grandes explorations. La construction a été achevée en 1519, avec pour fonction de défendre la ville. Par la suite, elle a servi de douane et de phare. Elle a été classée au patrimoine mondial de l'UNESCO en 1983, reconnaissant son importance historique et culturelle.",
                            adress: "Av. Brasília, 1400-038 Lisboa, Portugal"
                        ),
                        "es": MiniaturaCardTranslation(
                            titulo: "Torre de Belém ⛫ ",
                            shortDescription: "Construida a principios del siglo XVI, es un portal al pasado marítimo de Portugal.",
                            description: "Una emblemática fortificación de estilo manuelino del siglo XV, que antiguamente servía como puerta de entrada para Lisboa. La estructura está hecha de piedra caliza, con detalles ornamentales y esculturas de temas marítimos y nacionalistas. Un monumento imprescindible para conocer la historia marítima de Portugal, apreciar su arquitectura única y disfrutar de las vistas del río Tajo.",
                            history: "El estilo manuelino es un estilo artístico único y exuberante que floreció en Portugal durante el reinado del rey Manuel I en el siglo XVI. Este estilo está estrechamente ligado a la era dorada de los descubrimientos marítimos portugueses, un período de gran prosperidad y expansión territorial para el país. La torre fue construida en una época en que Portugal era una potencia marítima, y su ubicación estratégica en la desembocadura del Tajo la convertía en un punto de partida para las grandes exploraciones. La construcción se completó en 1519, con la función de defender la ciudad. Posteriormente, sirvió como aduana y faro. Fue clasificada como Patrimonio Mundial por la UNESCO en 1983, reconociendo su importancia histórica y cultural.",
                            adress: "Av. Brasília, 1400-038 Lisboa, Portugal"
                            )
                    ],
                    locations: [
                        (name: ["en": "Belém Tower", "pt": "Torre de Belém", "es": "Torre de Belém", "fr": "Tour de Belém"], latitude: 38.691584, longitude: -9.215821)
                    ],
                    zoomSpan: (latitudeDelta: 0.5, longitudeDelta: 0.5),
                    customCenter: nil
                ),
                MiniaturaCard(
                    id: 3,
                    imagem: "aqueduto",
                    categoria: categoria,
                    ordem: 3,
                    translations: [
                        "en": MiniaturaCardTranslation(
                            titulo: "Águas Livres Aqueduct 💧 ",
                            shortDescription: "An 18th-century aqueduct that is a remarkable example of hydraulic engineering.",
                            description: "It´s a monumental hydraulic engineering work that supplied the city of Lisbon with potable water. Built in the 18th century, it is a remarkable example of Baroque architecture and a testament to the ingenuity and organizational capacity of the Portuguese people at the time. The aqueduct consists of an extensive network of channels and arches, with the most iconic part being the arcade that crosses the Alcântara valley with its 21 perfect round arches and 14 ogival arches",
                            history: "The construction of the Águas Livres Aqueduct was ordered by King João V in the early 18th century. The need to guarantee the water supply to the growing population of Lisbon, due to urban growth and the expansion of the city, motivatedhis grand work. Construction began in 1732 and continued for several decades, ending in 1799. The design and construction of the aqueduct involved Portuguese and foreign engineers and architects, who used innovative techniques for the time. The aqueduct is a testament to the importance of water for urban life and the ability of the Portuguese people to overcome complex technical challenges.",
                            adress: "Calçada da Quintinha 6, 1070-225 Lisboa, Portugal"
                        ),
                        "pt": MiniaturaCardTranslation(
                            titulo: "Aqueduto das Águas Livres 💧 ",
                            shortDescription: "Um aqueduto do século 18 que é um exemplo notável de engenharia hidráulica.",
                            description: "É uma monumental obra de engenharia hidráulica que abasteceu a cidade de Lisboa com água potável. Construído no século XVIII, é um exemplo notável da arquitetura barroca e um testemunho da engenhosidade e capacidade organizacional do povo português na época. O aqueduto é composto por uma extensa rede de canais e arcos, sendo a parte mais icônica o arco que atravessa o vale de Alcântara com seus 21 arcos redondos perfeitos e 14 arcos ogivais.",
                            history: "A construção do Aqueduto das Águas Livres foi ordenada pelo rei João V no início do século XVIII. A necessidade de garantir o abastecimento de água à crescente população de Lisboa, devido ao crescimento urbano e à expansão da cidade, motivou esta grandiosa obra. A construção começou em 1732 e continuou por várias décadas, terminando em 1799. O projeto e a construção do aqueduto envolveram engenheiros e arquitetos portugueses e estrangeiros, que utilizaram técnicas inovadoras para a época. O aqueduto é um testemunho da importância da água para a vida urbana e da capacidade do povo português de superar desafios técnicos complexos.",
                            adress: "Calçada da Quintinha 6, 1070-225 Lisboa, Portugal"
                        ),
                        "fr": MiniaturaCardTranslation(
                            titulo: "Aqueduc des Eaux Libres",
                            shortDescription: "Un aqueduc du XVIIIe siècle qui est un exemple remarquable d'ingénierie hydraulique.",
                            description: "C'est une œuvre monumentale d'ingénierie hydraulique qui a approvisionné la ville de Lisbonne en eau potable. Construit au XVIIIe siècle, c'est un exemple remarquable de l'architecture baroque et un témoignage de l'ingéniosité et de la capacité organisationnelle du peuple portugais à l'époque. L'aqueduc se compose d'un vaste réseau de canaux et d'arcs, la partie la plus emblématique étant l'arcade qui traverse la vallée d'Alcântara avec ses 21 arcs ronds parfaits et 14 arcs ogivaux.",
                            history: "Inauguré en 1748, il a résisté au tremblement de terre de 1755 et a fonctionné jusqu'au XXe siècle.",
                            destaques: "Arcades d'Alcântara, longueur totale de 58 km, 21 arcs ronds et 14 arcs ogivaux.",
                            adress: "Rua das Amoreiras, Lisboa"
                        ),
                        "es": MiniaturaCardTranslation(
                            titulo: "Acueducto de Águas Livres 💧 ",
                            shortDescription: "Un acueducto del siglo XVIII que es un ejemplo notable de ingeniería hidráulica.",
                            description: "Es una obra monumental de ingeniería hidráulica que abasteció a la ciudad de Lisboa con agua potable. Construido en el siglo XVIII, es un ejemplo notable de la arquitectura barroca y un testimonio de la ingeniosidad y capacidad organizativa del pueblo portugués en ese momento. El acueducto consta de una extensa red de canales y arcos, siendo la parte más icónica el arco que cruza el valle de Alcântara con sus 21 arcos redondos perfectos y 14 arcos ojivales.",
                            history: "La construcción del Acueducto de Águas Livres fue ordenada por el rey João V a principios del siglo XVIII. La necesidad de garantizar el suministro de agua a la creciente población de Lisboa, debido al crecimiento urbano y la expansión de la ciudad, motivó esta gran obra. La construcción comenzó en 1732 y continuó durante varias décadas, terminando en 1799. El diseño y la construcción del acueducto involucraron a ingenieros y arquitectos portugueses y extranjeros, que utilizaron técnicas innovadoras para la época. El acueducto es un testimonio de la importancia del agua para la vida urbana y la capacidad del pueblo portugués para superar desafíos técnicos complejos.",
                            adress: "Calçada da Quintinha 6, 1070-225 Lisboa, Portugal"
                            )

                    ],
                    locations: [
                        (name: ["en": "Águas Livres Aqueduct", "pt": "Aqueduto das Águas Livres", "es": "Acueducto de Águas Livres", "fr": "Aqueduc des Águas Livres"], latitude: 38.72660, longitude: -9.16623)
                    ],
                    zoomSpan: (latitudeDelta: 0.08, longitudeDelta: 0.08),
                    customCenter: nil
                ),
                MiniaturaCard(
                    id: 4,
                    imagem: "comercio",
                    categoria: categoria,
                    ordem: 4,
                    translations: [
                        "en": MiniaturaCardTranslation(
                            titulo: "Comércio Square 𖼆 ",
                            shortDescription: "Conceived by the Marquis of Pombal in the 18th century, it is a majestic square that symbolizes Lisbon’s resilience.",
                            description: "It's one of Lisbon's most emblematic squares, located by the Tagus River. With its grand arcades, colorful buildings, and a monumental statue of King José I, the square is a symbol of the city's history and power. It has been the site of important events, such as royal receptions, political demonstrations, and public celebrations.",
                            history: "The Praça do Comércio has a long history, dating back to the reconstruction of Lisbon after the 1755 earthquake. The square was designed as a symbol of the city's rebirth and prosperity, with its grand architecture and open space facing the river. It was originally known as Terreiro do Paço, as it was the location of the royal palace before the earthquake. Over the years, the square has been the scene of important events, such as the assassination of King Carlos I in 1908 and the Carnation Revolution in 1974. Today, it is a vibrant public space, frequented by locals and tourists alike.",
                            adress: "Praça do Comércio, 1100-148 Lisboa, Portugal"
                        ),
                        "pt": MiniaturaCardTranslation(
                            titulo: "Praça do Comércio 𖼆 ",
                            shortDescription: "Concebida pelo Marquês de Pombal no século 18, é uma praça majestosa que simboliza a resiliência de Lisboa.",
                            description: "É uma das praças mais emblemáticas de Lisboa, localizada à beira do Rio Tejo. Com suas grandiosas arcadas, edifícios coloridos e uma estátua monumental do rei José I, a praça é um símbolo da história e do poder da cidade. Foi palco de eventos importantes, como recepções reais, manifestações políticas e celebrações públicas.",
                            history: "A Praça do Comércio tem uma longa história, remontando à reconstrução de Lisboa após o terremoto de 1755. A praça foi projetada como um símbolo do renascimento e da prosperidade da cidade, com sua arquitetura grandiosa e espaço aberto voltado para o rio. Originalmente era conhecida como Terreiro do Paço, pois foi o local do palácio real antes do terremoto. Ao longo dos anos, a praça foi cenário de eventos importantes, como o assassinato do rei Carlos I em 1908 e a Revolução dos Cravos em 1974. Hoje, é um espaço público vibrante, frequentado tanto por moradores quanto por turistas.",
                            adress: "Praça do Comércio, 1100-148 Lisboa, Portugal"
                        ),
                        "fr": MiniaturaCardTranslation(
                            titulo: "Place du Commerce 𖼆 ",
                            shortDescription: "Conçue par le Marquis de Pombal au XVIIIe siècle, c'est une place majestueuse qui symbolise la résilience de Lisbonne.",
                            description: "C'est l'une des places les plus emblématiques de Lisbonne, située au bord du fleuve Tejo. Avec ses grandes arcades, ses bâtiments colorés et une statue monumentale du roi José I, la place est un symbole de l'histoire et du pouvoir de la ville. Elle a été le site d'événements importants, tels que des réceptions royales, des manifestations politiques et des célébrations publiques.",
                            history: "La Praça do Comércio a une longue histoire, remontant à la reconstruction de Lisbonne après le tremblement de terre de 1755. La place a été conçue comme un symbole de la renaissance et de la prospérité de la ville, avec son architecture grandiose et son espace ouvert face au fleuve. Elle était à l'origine connue sous le nom de Terreiro do Paço, car elle était l'emplacement du palais royal avant le tremblement de terre. Au fil des ans, la place a été le théâtre d'événements importants, tels que l'assassinat du roi Carlos I en 1908 et la Révolution des Œillets en 1974. Aujourd'hui, c'est un espace public vibrant, fréquenté à la fois par les habitants et les touristes.",
                            adress: "Praça do Comércio, 1100-148 Lisboa, Portugal"
                        ),
                        "es": MiniaturaCardTranslation(
                            titulo: "Plaza del Comercio 𖼆 ",
                            shortDescription: "Concebida por el Marqués de Pombal en el siglo XVIII, es una plaza majestuosa que simboliza la resiliencia de Lisboa.",
                            description: "Es una de las plazas más emblemáticas de Lisboa, ubicada junto al río Tajo. Con sus grandes arcadas, edificios coloridos y una estatua monumental del rey José I, la plaza es un símbolo de la historia y el poder de la ciudad. Ha sido el sitio de eventos importantes, como recepciones reales, manifestaciones políticas y celebraciones públicas.",
                            history: "La Praça do Comércio tiene una larga historia que se remonta a la reconstrucción de Lisboa después del terremoto de 1755. La plaza fue diseñada como un símbolo del renacimiento y la prosperidad de la ciudad, con su arquitectura grandiosa y espacio abierto frente al río. Originalmente se conocía como Terreiro do Paço, ya que era el lugar del palacio real antes del terremoto. A lo largo de los años, la plaza ha sido escenario de eventos importantes, como el asesinato del rey Carlos I en 1908 y la Revolución de los Claveles en 1974. Hoy en día, es un espacio público vibrante, frecuentado tanto por residentes como por turistas.",
                            adress: "Praça do Comércio, 1100-148 Lisboa, Portugal"
                            )
                    ],
                    locations: [
                        (name: ["en": "Comércio Square", "pt": "Praça do Comércio", "fr": "Place du Commerce", "es": "Plaza del Comercio"], latitude: 38.707750, longitude: -9.136592)
                    ],
                    zoomSpan: (latitudeDelta: 0.05, longitudeDelta: 0.05),
                    customCenter: nil
                ),
                MiniaturaCard(
                    id: 5,
                    imagem: "santa_justa",
                    categoria: categoria,
                    ordem: 5,
                    translations: [
                        "en": MiniaturaCardTranslation(
                            titulo: "Santa Justa Elevator 🛗 ",
                            shortDescription: "A wrought-iron wonder erected in 1902 blending historic charm and modern utility.",
                            description: "It's an iconic elevator in the heart of Lisbon, connecting the lower Baixa district with the upper Carmo Square. Designed by the Portuguese engineer Raoul Mesnier du Ponsard, it is a masterpiece of iron architecture, with a neo-Gothic style and intricate details. The elevator offers panoramic views of the city and is a popular attraction for tourists.",
                            history: "The Santa Justa Elevator, also known as the Carmo Lift, was inaugurated in 1902 as a way to connect the Baixa district with the Carmo Square and the ruins of the Carmo Convent. The elevator was designed to facilitate the movement of people between the lower and upper parts of the city, avoiding the steep hills and narrow streets. The iron structure of the elevator was inspired by the Eiffel Tower in Paris and is a testament to the industrial and technological progress of the time. Today, the Santa Justa Elevator is a popular tourist attraction, offering visitors a unique perspective of Lisbon.",
                            adress: "R. do Ouro, 1150-060 Lisboa, Portugal"
                        ),
                        "pt": MiniaturaCardTranslation(
                            titulo: "Elevador de Santa Justa 🛗 ",
                            shortDescription: "Uma maravilha de ferro erguida em 1902 combina apelo histórico e moderno.",
                            description: "É um elevador icônico no coração de Lisboa, que conecta o bairro da Baixa, mais baixo, com a Praça do Carmo, mais alta. Projetado pelo engenheiro português Raoul Mesnier du Ponsard, é uma obra-prima da arquitetura em ferro, com um estilo neogótico e detalhes intrincados. O elevador oferece vistas panorâmicas da cidade e é uma atração popular para turistas.",
                            history: "O Elevador de Santa Justa, também conhecido como Elevador do Carmo, foi inaugurado em 1902 como uma forma de conectar o bairro da Baixa com a Praça do Carmo e as ruínas do Convento do Carmo. O elevador foi projetado para facilitar o movimento das pessoas entre as partes mais baixa e alta da cidade, evitando as colinas íngremes e ruas estreitas. A estrutura de ferro do elevador foi inspirada na Torre Eiffel em Paris e é um testemunho do progresso industrial e tecnológico da época. Hoje, o Elevador de Santa Justa é uma atração turística popular, oferecendo aos visitantes uma perspectiva única de Lisboa.",
                            adress: "R. do Ouro, 1150-060 Lisboa, Portugal"
                        ),
                        "fr": MiniaturaCardTranslation(
                            titulo: "Ascenseur de Santa Justa 🛗 ",
                            shortDescription: "Une merveille de fer érigée en 1902 alliant charme historique et utilité moderne.",
                            description: "C'est un ascenseur emblématique au cœur de Lisbonne, reliant le quartier inférieur de Baixa à la place supérieure du Carmo. Conçu par l'ingénieur portugais Raoul Mesnier du Ponsard, c'est un chef-d'œuvre d'architecture en fer, avec un style néogothique et des détails complexes. L'ascenseur offre des vues panoramiques sur la ville et est une attraction populaire pour les touristes.",
                            history: "L'ascenseur de Santa Justa, également connu sous le nom d'ascenseur du Carmo, a été inauguré en 1902 comme moyen de connecter le quartier de Baixa à la place du Carmo et aux ruines du couvent du Carmo. L'ascenseur a été conçu pour faciliter le déplacement des personnes entre les parties inférieure et supérieure de la ville, évitant les collines escarpées et les rues étroites. La structure en fer de l'ascenseur s'inspire de la tour Eiffel à Paris et témoigne du progrès industriel et technologique de l'époque. Aujourd'hui, l'ascenseur de Santa Justa est une attraction touristique populaire, offrant aux visiteurs une perspective unique sur Lisbonne.",
                            adress: "R. do Ouro, 1150-060 Lisboa, Portugal"
                        ),
                        "es": MiniaturaCardTranslation(
                            titulo: "Ascensor de Santa Justa 🛗 ",
                            shortDescription: "Una maravilla de hierro erigida en 1902 que combina encanto histórico y utilidad moderna.",
                            description: "Es un ascensor icónico en el corazón de Lisboa, que conecta el distrito más bajo de Baixa con la Plaza del Carmo, más alta. Diseñado por el ingeniero portugués Raoul Mesnier du Ponsard, es una obra maestra de la arquitectura en hierro, con un estilo neogótico y detalles intrincados. El ascensor ofrece vistas panorámicas de la ciudad y es una atracción popular para los turistas.",
                            history: "El Ascensor de Santa Justa, también conocido como Elevador do Carmo, fue inaugurado en 1902 como una forma de conectar el distrito de Baixa con la Plaza del Carmo y las ruinas del Convento del Carmo. El ascensor fue diseñado para facilitar el movimiento de las personas entre las partes más baja y alta de la ciudad, evitando las colinas empinadas y las calles estrechas. La estructura de hierro del ascensor se inspiró en la Torre Eiffel en París y es un testimonio del progreso industrial y tecnológico de la época. Hoy en día, el Ascensor de Santa Justa es una atracción turística popular, ofreciendo a los visitantes una perspectiva única de Lisboa.",
                            adress: "R. do Ouro, 1150-060 Lisboa, Portugal"
                        )
                    ],
                    locations: [
                        (name: ["en": "Santa Justa Elevator", "pt": "Elevador de Santa Justa", "es": "Ascensor de Santa Justa", "fr": "Élevateur de Santa Justa"], latitude: 38.712130, longitude: -9.139343)
                    ],
                    zoomSpan: (latitudeDelta: 0.05, longitudeDelta: 0.05),
                    customCenter: nil
                ),
                MiniaturaCard(
                    id: 6,
                    imagem: "padrao",
                    categoria: categoria,
                    ordem: 6,
                    translations: [
                        "en": MiniaturaCardTranslation(
                            titulo: "Discoveries Monument ⛵︎ ",
                            shortDescription: "A tribute to the Portuguese Age of Discovery.",
                            description: "It's a monumental tribute to the Portuguese Age of Discovery, located on the banks of the Tagus River. Shaped like a caravel ship, the monument features statues of prominent figures from the era, such as explorers, cartographers, and royalty. The Discoveries Monument celebrates Portugal's maritime history and its role in the exploration of the world.",
                            history: "The Discoveries Monument was built in 1960 to commemorate the 500th anniversary of the death of Prince Henry the Navigator, a key figure in the Portuguese Age of Discovery. The monument was designed by architect Cottinelli Telmo and sculptor Leopoldo de Almeida, with the collaboration of other artists and craftsmen. The structure is shaped like a caravel ship, with a stylized prow pointing towards the sea. The monument features statues of prominent figures from the Age of Discovery, such as Vasco da Gama, Pedro Álvares Cabral, and Luís de Camões. The Discoveries Monument is a symbol of Portugal's maritime heritage and its contributions to world history.",
                            adress: "Av. Brasília, 1400-038 Lisboa, Portugal"
                        ),
                        "pt": MiniaturaCardTranslation(
                            titulo: "Padrão dos Descobrimentos ⚓️ ",
                            shortDescription: "Uma homenagem à Era dos Descobrimentos de Portugal.",
                            description: "É uma homenagem monumental à Era dos Descobrimentos de Portugal, localizada às margens do Rio Tejo. Com a forma de uma caravela, o monumento apresenta estátuas de figuras proeminentes da época, como exploradores, cartógrafos e membros da realeza. O Padrão dos Descobrimentos celebra a história marítima de Portugal e seu papel na exploração do mundo.",
                            history: "O Padrão dos Descobrimentos foi construído em 1960 para comemorar o 500º aniversário da morte do Infante Dom Henrique, uma figura-chave na Era dos Descobrimentos de Portugal. O monumento foi projetado pelo arquiteto Cottinelli Telmo e pelo escultor Leopoldo de Almeida, com a colaboração de outros artistas e artesãos. A estrutura tem a forma de uma caravela, com uma proa estilizada apontando para o mar. O monumento apresenta estátuas de figuras proeminentes da Era dos Descobrimentos, como Vasco da Gama, Pedro Álvares Cabral e Luís de Camões. O Padrão dos Descobrimentos é um símbolo do patrimônio marítimo de Portugal e suas contribuições para a história mundial.",
                            adress: "Av. Brasília, 1400-038 Lisboa, Portugal"
                        ),
                        "fr": MiniaturaCardTranslation(
                            titulo: "Monument des Découvertes ⚓️ ",
                            shortDescription: "Un hommage à l'Âge des Découvertes portugais.",
                            description: "C'est un hommage monumental à l'Âge des Découvertes portugais, situé sur les rives du fleuve Tejo. En forme de caravelle, le monument présente des statues de figures éminentes de l'époque, telles que des explorateurs, des cartographes et des membres de la royauté. Le Monument des Découvertes célèbre l'histoire maritime du Portugal et son rôle dans l'exploration du monde.",
                            history: "Le Monument des Découvertes a été construit en 1960 pour commémorer le 500e anniversaire de la mort du Prince Henri le Navigateur, une figure clé de l'Âge des Découvertes portugais. Le monument a été conçu par l'architecte Cottinelli Telmo et le sculpteur Leopoldo de Almeida, avec la collaboration d'autres artistes et artisans. La structure a la forme d'une caravelle, avec une proue stylisée pointant vers la mer. Le monument présente des statues de figures éminentes de l'Âge des Découvertes, telles que Vasco da Gama, Pedro Álvares Cabral et Luís de Camões. Le Monument des Découvertes est un symbole du patrimoine maritime du Portugal et de ses contributions à l'histoire mondiale.",
                            adress: "Av. Brasília, 1400-038 Lisboa, Portugal"
                        ),
                        "es": MiniaturaCardTranslation(
                            titulo: "Monumento a los Descubrimientos ⚓️ ",
                            shortDescription: "Un homenaje a la Era de los Descubrimientos portuguesa.",
                            description: "Es un homenaje monumental a la Era de los Descubrimientos portuguesa, ubicado a orillas del río Tajo. Con forma de carabela, el monumento presenta estatuas de figuras prominentes de la época, como exploradores, cartógrafos y miembros de la realeza. El Monumento a los Descubrimientos celebra la historia marítima de Portugal y su papel en la exploración del mundo.",
                            history: "El Monumento a los Descubrimientos fue construido en 1960 para conmemorar el 500 aniversario de la muerte del Príncipe Enrique el Navegante, una figura clave en la Era de los Descubrimientos portuguesa. El monumento fue diseñado por el arquitecto Cottinelli Telmo y el escultor Leopoldo de Almeida, con la colaboración de otros artistas y artesanos. La estructura tiene forma de carabela, con una proa estilizada apuntando hacia el mar. El monumento presenta estatuas de figuras prominentes de la Era de los Descubrimientos, como Vasco da Gama, Pedro Álvares Cabral y Luís de Camões. El Monumento a los Descubrimientos es un símbolo del patrimonio marítimo de Portugal y sus contribuciones a la historia mundial.",
                            adress: "Av. Brasília, 1400-038 Lisboa, Portugal"
                            )
                    ],
                    locations: [
                        (name: ["en": "Discoveries Monument", "pt": "Padrão dos Descobrimentos", "es": "Monumento a los Descubrimientos", "fr": "Monument des Découvertes"], latitude: 38.693056, longitude: -9.205556)
                    ],
                    zoomSpan: (latitudeDelta: 0.01, longitudeDelta: 0.01),
                    customCenter: nil
                ),
                
                MiniaturaCard(
                    id: 7,
                    imagem: "ponte_25_abril",
                    categoria: categoria,
                    ordem: 7,
                    translations: [
                        "en": MiniaturaCardTranslation(
                            titulo: "Lisbon Bridges 🌉 ",
                            shortDescription: "The two bridges connect the south with the north, the past with the future.",
                            description: "Lisbon is known for its iconic bridges that span the Tagus River, connecting the city with the south bank. The most famous bridges are the 25 de Abril Bridge, a suspension bridge reminiscent of the Golden Gate Bridge in San Francisco, and the Vasco da Gama Bridge, one of the longest bridges in Europe. These bridges are not only essential transportation links but also architectural landmarks that contribute to the city's skyline.",
                            history: "The construction of the Lisbon bridges was a significant engineering challenge, given the width and depth of the Tagus River. The 25 de Abril Bridge, originally named the Salazar Bridge, was inaugurated in 1966 and was the longest suspension bridge in Europe at the time. It was later renamed to commemorate the Carnation Revolution of 1974. The Vasco da Gama Bridge, inaugurated in 1998, was built to relieve traffic congestion on the 25 de Abril Bridge and is one of the longest bridges in Europe. Both bridges are essential transportation links for the city and have become iconic symbols of Lisbon.",
                            adress: "Ponte 25 de Abril\nPonte Vasco da Gama\nLisboa, Portugal"
                        ),
                        "pt": MiniaturaCardTranslation(
                            titulo: "Pontes de Lisboa 🌉 ",
                            shortDescription: "As duas pontes ligam o sul com o norte, o passado com o futuro.",
                            description: "Lisboa é conhecida por suas pontes icônicas que atravessam o Rio Tejo, conectando a cidade com a margem sul. As pontes mais famosas são a Ponte 25 de Abril, uma ponte suspensa que lembra a Ponte Golden Gate em São Francisco, e a Ponte Vasco da Gama, uma das pontes mais longas da Europa. Essas pontes não são apenas ligações de transporte essenciais, mas também marcos arquitetônicos que contribuem para a linha do horizonte da cidade.",
                            history: "A construção das pontes de Lisboa foi um desafio significativo de engenharia, dada a largura e profundidade do Rio Tejo. A Ponte 25 de Abril, originalmente chamada de Ponte Salazar, foi inaugurada em 1966 e foi a ponte suspensa mais longa da Europa na época. Posteriormente, foi renomeada para comemorar a Revolução dos Cravos de 1974. A Ponte Vasco da Gama, inaugurada em 1998, foi construída para aliviar o congestionamento de tráfego na Ponte 25 de Abril e é uma das pontes mais longas da Europa. Ambas as pontes são ligações de transporte essenciais para a cidade e se tornaram símbolos icônicos de Lisboa.",
                            adress: "Ponte 25 de Abril\nPonte Vasco da Gama\nLisboa, Portugal"
                        ),
                        "fr": MiniaturaCardTranslation(
                            titulo: "Ponts de Lisbonne 🌉 ",
                            shortDescription: "Les deux ponts relient le sud au nord, le passé à l'avenir.",
                            description: "Lisbonne est connue pour ses ponts emblématiques qui enjambent le Tage, reliant la ville à la rive sud. Les ponts les plus célèbres sont le Pont 25 Avril, un pont suspendu qui rappelle le Golden Gate à San Francisco, et le Pont Vasco da Gama, l'un des plus longs ponts d'Europe. Ces ponts ne sont pas seulement des liaisons essentielles pour le transport, mais aussi des monuments architecturaux qui contribuent à la skyline de la ville.",
                            history: "La construction des ponts de Lisbonne a été un défi important d'ingénierie, compte tenu de la largeur et de la profondeur du Tage. Le Pont 25 Avril, initialement nommé Pont Salazar, a été inauguré en 1966 et était le pont suspendu le plus long d'Europe à l'époque. Il a été renommé par la suite pour commémorer la Révolution des Œillets de 1974. Le Pont Vasco da Gama, inauguré en 1998, a été construit pour soulager la congestion routière du Pont 25 Avril et est l'un des plus longs ponts d'Europe. Les deux ponts sont des liaisons de transport essentielles pour la ville et sont devenus des symboles emblématiques de Lisbonne.",
                            adress: "Ponte 25 de Abril\nPonte Vasco da Gama\nLisboa, Portugal"
                        ),
                        "es": MiniaturaCardTranslation(
                            titulo: "Puentes de Lisboa 🌉 ",
                            shortDescription: "Los dos puentes conectan el sur con el norte, el pasado con el futuro.",
                            description: "Lisboa es conocida por sus puentes icónicos que cruzan el río Tajo, conectando la ciudad con la margen sur. Los puentes más famosos son el Puente 25 de Abril, un puente colgante que recuerda al Golden Gate de San Francisco, y el Puente Vasco da Gama, uno de los puentes más largos de Europa. Estos puentes no solo son enlaces de transporte esenciales, sino también monumentos arquitectónicos que contribuyen al horizonte de la ciudad.",
                            history: "La construcción de los puentes de Lisboa fue un desafío importante de ingeniería, dada la anchura y profundidad del río Tajo. El Puente 25 de Abril, originalmente llamado Puente Salazar, fue inaugurado en 1966 y fue el puente colgante más largo de Europa en ese momento. Posteriormente fue renombrado para conmemorar la Revolución de los Claveles de 1974. El Puente Vasco da Gama, inaugurado en 1998, fue construido para aliviar la congestión del tráfico en el Puente 25 de Abril y es uno de los puentes más largos de Europa. Ambos puentes son enlaces de transporte esenciales para la ciudad y se han convertido en símbolos icónicos de Lisboa.",
                            adress: "Ponte 25 de Abril\nPonte Vasco da Gama\nLisboa, Portugal"
                            )
                    ],
                    locations: [
                        (name: ["en": "25 de Abril Bridge", "pt": "Ponte 25 de Abril", "es": "Puente 25 de Abril", "fr": "Pont 25 Avril"], latitude: 38.689167, longitude: -9.177778),
                        (name: ["en": "Vasco da Gama Bridge", "pt": "Ponte Vasco da Gama", "es": "Puente Vasco da Gama", "fr": "Pont Vasco da Gama"], latitude: 38.762303, longitude: -9.043198)
                    ],
                    zoomSpan: (latitudeDelta: 0.45, longitudeDelta: 0.45),
                    customCenter: nil
                ),
                MiniaturaCard(
                    id: 8,
                    imagem: "plus_monuments",
                    categoria: categoria,
                    ordem: 8,
                    translations: [
                        "en": MiniaturaCardTranslation(
                            titulo: "More Monuments ✚ ",
                            shortDescription: "Explore more incredible monuments in Lisbon!",
                            description: "For those interested in exploring more monumental wonders, these four palaces are worth considering. \n\nPalácio de Ajuda: Situated on top of the Ajuda hill, with stunning views over the river, this magnificent palace in Lisbon preserves the layout and decoration of its rooms in the style of the 19th century, notably the monarchs' apartments and the Throne Room. A neoclassical building from the first half of the 19th century, it was the official residence of the Portuguese royal family from the reign of D. Luís I (1861-89) until the end of the Monarchy in 1910. \n\nPalácio de Queluz (in the picture): Located between Lisbon and Sintra, this 18th-century palace is one of the finest examples of the Rococo style in Portugal, with its sumptuous halls, ornate tiles and lush gardens. Built as a summer retreat for D. Pedro de Bragança, it became the official residence of the Portuguese royal family from the reign of D. Maria I, who transformed it into a royal palace. Its royal apartments, the Throne Room and the meticulously manicured gardens transport visitors to the golden age of the Portuguese monarchy. \n\nPena Palace:- Perched atop the Sintra Mountains, with panoramic views of the surrounding landscape, Pena Palace is a vibrant testament to 19th-century Romanticism. This unique palace, with its eclectic mix of architectural styles, from neo-Gothic to neo-Manueline, is one of the most visited in Portugal. Once the residence of the Portuguese royal family, Pena Palace has been masterfully restored to its original glory, offering visitors a fascinating glimpse into the life of Portuguese royalty in the 19th century.\n\nMafra Palace: - This UNESCO World Heritage-listed complex of palace, basilica and convent is one of the largest royal buildings in Europe, with over 1,200 rooms and an impressive façade that dominates the landscape. \nInside, visitors can marvel at the richness of detail, from the sumptuous library, with its collection of thousands of ancient books, to the impressive basilica, with its six historic organs and two carillons. The richly decorated royal apartments offer a glimpse into the life of the Portuguese royal family in the 18th century.",
                            history: "The palaces of Ajuda, Queluz, Pena, and Mafra are architectural gems that reflect the grandeur and opulence of the Portuguese monarchy. These palaces were built during different periods of Portuguese history, from the 18th to the 19th centuries, and each has its unique style and character. The Palácio de Ajuda is a neoclassical masterpiece, with elegant interiors and stunning views over the river. The Palácio de Queluz is a Rococo jewel, with sumptuous halls and lush gardens. The Pena Palace is a vibrant testament to Romanticism, with its eclectic mix of architectural styles. The Mafra Palace is a UNESCO World Heritage site, with over 1,200 rooms and a richly decorated basilica. Together, these palaces offer a fascinating glimpse into the history and culture of Portugal.",
                            adress: "- Palácio da Ajuda\n- Palácio de Queluz\n- Palácio de Pena\n- Palácio de Mafra"
                        ),
                        "pt": MiniaturaCardTranslation(
                            titulo: "Mais Monumentos ✚ ",
                            shortDescription: "Explore mais dos deslumbrantes monumentos de Lisboa.",
                            description: " Para quem deseja explorar mais maravilhas monumentais, estes quatro palácios valem a pena ser considerados. \n\nPalácio de Ajuda: Situado no topo da colina da Ajuda, com vistas deslumbrantes sobre o rio, este magnífico palácio em Lisboa preserva a disposição e decoração de seus aposentos no estilo do século XIX, notadamente os aposentos dos monarcas e o Salão do Trono. Um edifício neoclássico da primeira metade do século XIX, foi a residência oficial da família real portuguesa desde o reinado de D. Luís I (1861-89) até o fim da Monarquia em 1910. \n\nPalácio de Queluz (na foto): Localizado entre Lisboa e Sintra, este palácio do século XVIII é um dos melhores exemplos do estilo rococó em Portugal, com seus salões suntuosos, azulejos ornamentados e jardins exuberantes. Construído como um retiro de verão para D. Pedro de Bragança, tornou-se a residência oficial da família real portuguesa desde o reinado de D. Maria I, que o transformou em um palácio real. Seus aposentos reais, o Salão do Trono e os jardins meticulosamente cuidados transportam os visitantes para a era dourada da monarquia portuguesa. \n\nPalácio da Pena:- Empoleirado no topo das Montanhas de Sintra, com vistas panorâmicas da paisagem circundante, o Palácio da Pena é um vibrante testemunho do Romantismo do século XIX. Este palácio único, com sua mistura eclética de estilos arquitetônicos, do neogótico ao neo-manuelino, é um dos mais visitados em Portugal. Uma vez residência da família real portuguesa, o Palácio da Pena foi magistralmente restaurado à sua glória original, oferecendo aos visitantes um vislumbre fascinante da vida da realeza portuguesa no século XIX.\n\nPalácio de Mafra: - Este complexo listado como Patrimônio Mundial pela UNESCO, composto por palácio, basílica e convento, é um dos maiores edifícios reais da Europa, com mais de 1.200 quartos e uma impressionante fachada que domina a paisagem.\nDentro, os visitantes podem admirar a riqueza de detalhes, desde a suntuosa biblioteca, com sua coleção de milhares de livros antigos, até a impressionante basílica, com seus seis órgãos históricos e duas carrilhões. Os aposentos reais ricamente decorados oferecem um vislumbre da vida da família real portuguesa no século XVIII.",
                            history: "Os palácios de Ajuda, Queluz, Pena e Mafra são joias arquitetônicas que refletem a grandiosidade e opulência da monarquia portuguesa. Esses palácios foram construídos em diferentes períodos da história de Portugal, do século XVIII ao século XIX, e cada um possui seu estilo e caráter únicos. O Palácio de Ajuda é uma obra-prima neoclássica, com interiores elegantes e vistas deslumbrantes sobre o rio. O Palácio de Queluz é uma joia rococó, com salões suntuosos e jardins exuberantes. O Palácio da Pena é um vibrante testemunho do Romantismo, com sua mistura eclética de estilos arquitetônicos. O Palácio de Mafra é um sítio do Patrimônio Mundial da UNESCO, com mais de 1.200 quartos e uma basílica ricamente decorada. Juntos, esses palácios oferecem um vislumbre fascinante da história e cultura de Portugal.",
                            adress: "- Palácio da Ajuda\n- Palácio de Queluz\n- Palácio da Pena\n- Palácio de Mafra"
                        ),
                        "fr": MiniaturaCardTranslation(
                            titulo: "Plus de Monuments ✚ ",
                            shortDescription: "Explorez plus de monuments incroyables à Lisbonne !",
                            description: "Pour ceux qui souhaitent explorer plus de merveilles monumentales, ces quatre palais valent la peine d'être considérés. \n\nPalácio de Ajuda : Situé au sommet de la colline d'Ajuda, avec une vue imprenable sur le fleuve, ce magnifique palais à Lisbonne préserve la disposition et la décoration de ses pièces dans le style du XIXe siècle, notamment les appartements des monarques et la Salle du Trône. Un bâtiment néoclassique de la première moitié du XIXe siècle, il a été la résidence officielle de la famille royale portugaise depuis le règne de D. Luís I (1861-89) jusqu'à la fin de la monarchie en 1910. \n\nPalácio de Queluz (sur la photo) : Situé entre Lisbonne et Sintra, ce palais du XVIIIe siècle est l'un des meilleurs exemples du style rococo au Portugal, avec ses salles somptueuses, ses azulejos ornés et ses jardins luxuriants. Construit comme une retraite d'été pour D. Pedro de Bragança, il est devenu la résidence officielle de la famille royale portugaise depuis le règne de D. Maria I, qui l'a transformé en palais royal. Ses appartements royaux, la Salle du Trône et les jardins méticuleusement entretenus transportent les visiteurs à l'âge d'or de la monarchie portugaise. \n\nPalácio da Pena : Perché au sommet des montagnes de Sintra, avec une vue panoramique sur le paysage environnant, le Palácio da Pena est un vibrant témoignage du romantisme du XIXe siècle. Ce palais unique, avec son mélange éclectique de styles architecturaux, du néogothique au néo-manuelin, est l'un des plus visités au Portugal. Ancienne résidence de la famille royale portugaise, le Palácio da Pena a été magistralement restauré à sa gloire originale, offrant aux visiteurs un aperçu fascinant de la vie de la royauté portugaise au XIXe siècle.\n\nPalácio de Mafra : Ce complexe classé au patrimoine mondial de l'UNESCO, composé d'un palais, d'une basilique et d'un couvent, est l'un des plus grands bâtiments royaux d'Europe, avec plus de 1 200 pièces et une façade impressionnante qui domine le paysage.\nÀ l'intérieur, les visiteurs peuvent admirer la richesse des détails, de la somptueuse bibliothèque, avec sa collection de milliers de livres anciens, à l'impressionnante basilique, avec ses six orgues historiques et deux carillons. Les appartements royaux richement décorés offrent un aperçu de la vie de la famille royale portugaise au XVIIIe siècle.",
                            adress: "- Palácio da Ajuda\n- Palácio de Queluz\n- Palácio da Pena\n- Palácio de Mafra"
                        ),
                        "es": MiniaturaCardTranslation(
                            titulo: "Más Monumentos ✚ ",
                            shortDescription: "¡Explora más monumentos increíbles en Lisboa!",
                            description: "Para aquellos interesados en explorar más maravillas monumentales, estos cuatro palacios valen la pena ser considerados. \n\nPalácio de Ajuda: Situado en la cima de la colina de Ajuda, con impresionantes vistas sobre el río, este magnífico palacio en Lisboa conserva la disposición y decoración de sus habitaciones al estilo del siglo XIX, especialmente los apartamentos de los monarcas y el Salón del Trono. Un edificio neoclásico de la primera mitad del siglo XIX, fue la residencia oficial de la familia real portuguesa desde el reinado de D. Luís I (1861-89) hasta el fin de la Monarquía en 1910. \n\nPalácio de Queluz (en la foto): Ubicado entre Lisboa y Sintra, este palacio del siglo XVIII es uno de los mejores ejemplos del estilo rococó en Portugal, con sus suntuosos salones, azulejos ornamentados y exuberantes jardines. Construido como un retiro de verano para D. Pedro de Bragança, se convirtió en la residencia oficial de la familia real portuguesa desde el reinado de D. Maria I, quien lo transformó en un palacio real. Sus apartamentos reales, el Salón del Trono y los jardines meticulosamente cuidados transportan a los visitantes a la edad dorada de la monarquía portuguesa. \n\nPalácio da Pena:- Perchado en lo alto de las Montañas de Sintra, con vistas panorámicas del paisaje circundante, el Palácio da Pena es un vibrante testimonio del Romanticismo del siglo XIX. Este palacio único, con su mezcla ecléctica de estilos arquitectónicos, desde el neogótico hasta el neo-manuelino, es uno de los más visitados en Portugal. Una vez residencia de la familia real portuguesa, el Palácio da Pena ha sido magistralmente restaurado a su gloria original, ofreciendo a los visitantes una fascinante visión de la vida de la realeza portuguesa en el siglo XIX.\n\nPalácio de Mafra: - Este complejo declarado Patrimonio Mundial por la UNESCO, compuesto por palacio, basílica y convento es uno de los edificios reales más grandes de Europa, con más de 1.200 habitaciones y una impresionante fachada que domina el paisaje.\nDentro, los visitantes pueden maravillarse con la riqueza de los detalles, desde la suntuosa biblioteca, con su colección de miles de libros antiguos, hasta la impresionante basílica, con sus seis órganos históricos y dos carillones. Los ricamente decorados apartamentos reales ofrecen una visión de la vida de la familia real portuguesa en el siglo XVIII.",
                            adress: "- Palácio da Ajuda\n- Palácio de Queluz\n- Palácio da Pena\n- Palácio de Mafra"
                            )
                        
                    ],
                    locations: [
                        (name: ["en": "Palácio de Ajuda", "pt": "Palácio de Ajuda", "es": "Palacio de Ajuda", "fr": "Palais de l'Ajuda"], latitude: 38.707403, longitude: -9.198642),
                        (name: ["en": "Palácio de Queluz", "pt": "Palácio de Queluz", "es": "Palacio de Queluz", "fr": "Palais de Queluz"], latitude: 38.750397, longitude: -9.257947),
                        (name: ["en": "Palácio da Pena", "pt": "Palácio da Pena", "es": "Palacio da Pena", "fr": "Palais de Pena"], latitude: 38.787605, longitude: -9.390496),
                        (name: ["en": "Palácio de Mafra", "pt": "Palácio de Mafra", "es": "Palacio de Mafra", "fr": "Palais de Mafra"], latitude: 38.936972, longitude: -9.326943)
                    ],
                    zoomSpan: (latitudeDelta: 0.9, longitudeDelta: 0.9),
                    customCenter: nil
                )
            ]
        }
        if cat == "natureza" || cat == "nature" {
            return [
                MiniaturaCard(
                    id: 1,
                    imagem: "rio_tejo",
                    categoria: categoria,
                    ordem: 1,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Rio Tejo 🐟 ",
                            shortDescription: "O maior rio da Península Ibérica nasce na Espanha e deságua no Oceano Atlântico em Lisboa. 🚣‍♀️",
                            description: "O Rio Tejo é o maior rio da Península Ibérica, com cerca de 1.000 km de comprimento. Nasce em Espanha, na Serra de Albarracín, e desagua no Oceano Atlântico, em Lisboa. O Tejo é um rio navegável, com uma extensa bacia hidrográfica, que desempenhou um papel importante na história de Portugal, como meio de transporte e comunicação entre o interior e a costa. Hoje, o Rio Tejo é um símbolo do património marítimo de Lisboa e um ponto focal para atividades de lazer, como passeios de barco, cruzeiros e passeios à beira-rio. 🚣‍♀️",
                            history: "The Tagus River has a long history of human occupation, from prehistoric times to the present day. The river served as a natural harbor for Phoenician, Roman, and Moorish settlements and Portuguese explorers during the Age of Discovery. The Tagus was an important transport and trade route, providing connections between the interior and the coast of Portugal. Over the centuries, the river has been the scene of battles, maritime discoveries and historical events, playing a central role in the lives of the Portuguese.",
                            adress: "Lisboa, Portugal"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Tagus River 🐟 ",
                            shortDescription: "The largest river in the Iberian Peninsula rises in Spain and flows into the Atlantic Ocean in Lisbon. 🚣‍♀️",
                            description: "The Tagus River (Pt: Rio Tejo) is the largest river in the Iberian Peninsula, with a length of around 1,000 km. It rises in Spain, in the Albarracín Mountains, and flows into the Atlantic Ocean, in Lisbon. The Tagus is a navigable river, with an extensive river basin, which played an important role in the history of Portugal, as a means of transport and communication between the interior and the coast. Today, the Tagus River is a symbol of Lisbon's maritime heritage and a focal point for leisure activities, such as boat tours, cruises, and waterfront promenades.",
                            history: "O Rio Tejo tem uma longa história de ocupação humana, desde os tempos pré-históricos até os dias atuais. O rio serviu como um porto natural para assentamentos fenícios, romanos e mouros, bem como para exploradores portugueses durante a Era dos Descobrimentos. O Tejo foi uma importante rota de transporte e comércio, proporcionando conexões entre o interior e a costa de Portugal. Ao longo dos séculos, o rio foi palco de batalhas, descobertas marítimas e eventos históricos, desempenhando um papel central na vida dos portugueses.",
                            adress: "Lisbon, Portugal"
                        ),
                        "fr": MiniaturaCardTranslation(
                            titulo: "Fleuve Tage 🐟 ",
                            shortDescription: "Le plus grand fleuve de la péninsule ibérique prend sa source en Espagne et se jette dans l'océan Atlantique à Lisbonne. 🚣‍♀️",
                            description: "Le fleuve Tage (Pt : Rio Tejo) est le plus grand fleuve de la péninsule ibérique, avec une longueur d'environ 1 000 km. Il prend sa source en Espagne, dans les montagnes d'Albarracín, et se jette dans l'océan Atlantique, à Lisbonne. Le Tage est un fleuve navigable, avec un bassin fluvial étendu, qui a joué un rôle important dans l'histoire du Portugal, en tant que moyen de transport et de communication entre l'intérieur et la côte. Aujourd'hui, le fleuve Tage est un symbole du patrimoine maritime de Lisbonne et un point focal pour les activités de loisirs, telles que les visites en bateau, les croisières et les promenades au bord de l'eau.",
                            history: "Le fleuve Tage a une longue histoire d'occupation humaine, depuis les temps préhistoriques jusqu'à nos jours. Le fleuve a servi de port naturel pour les établissements phéniciens, romains et mauresques, ainsi que pour les explorateurs portugais pendant l'ère des découvertes. Le Tage était une importante route de transport et de commerce, fournissant des connexions entre l'intérieur et la côte du Portugal. Au fil des siècles, le fleuve a été le théâtre de batailles, de découvertes maritimes et d'événements historiques, jouant un rôle central dans la vie des Portugais.",
                            adress: "Lisbonne, Portugal"
                        ),
                        "es": MiniaturaCardTranslation(
                            titulo: "Río Tajo 🐟 ",
                            shortDescription: "El río más grande de la península ibérica nace en España y desemboca en el océano Atlántico en Lisboa. 🚣‍♀️",
                            description: "El río Tajo (Pt: Rio Tejo) es el río más grande de la península ibérica, con una longitud de alrededor de 1.000 km. Nace en España, en las montañas de Albarracín, y desemboca en el océano Atlántico, en Lisboa. El Tajo es un río navegable, con una extensa cuenca fluvial, que desempeñó un papel importante en la historia de Portugal, como medio de transporte y comunicación entre el interior y la costa. Hoy en día, el río Tajo es un símbolo del patrimonio marítimo de Lisboa y un punto focal para las actividades de ocio, como los paseos en barco, los cruceros y los paseos por la orilla del agua.",
                            history: "El río Tajo tiene una larga historia de ocupación humana, desde tiempos prehistóricos hasta la actualidad. El río sirvió como puerto natural para asentamientos fenicios, romanos y moriscos, así como para exploradores portugueses durante la Era de los Descubrimientos. El Tajo fue una importante ruta de transporte y comercio, proporcionando conexiones entre el interior y la costa de Portugal. A lo largo de los siglos, el río ha sido escenario de batallas, descubrimientos marítimos y eventos históricos, desempeñando un papel central en la vida de los portugueses.",
                            adress: "Lisboa, Portugal"
                            )
                    ],
                    locations: [
                        (name: ["en": "Tejo River", "pt": "Rio Tejo", "es": "Río Tajo", "fr": "Río Tejo"], latitude: 38.835068, longitude: -9.011688)
                    ],
                    zoomSpan: (latitudeDelta: 0.9, longitudeDelta: 0.9),
                    customCenter: nil
                ),
                MiniaturaCard(
                    id: 2,
                    imagem: "miradouros",
                    categoria: categoria,
                    ordem: 2,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Miradouros 😎 ",
                            shortDescription: "Pontos altos de Lisboa com vistas deslumbrantes sobre a cidade e o rio.",
                            description: "Os miradouros de Lisboa são conhecidos pelas suas vistas panorâmicas da cidade e do Rio Tejo. A partir destes pontos elevados, os visitantes podem admirar os bairros históricos da cidade, os telhados vermelhos e os marcos icônicos. Alguns dos miradouros mais populares de Lisboa incluem o Miradouro da Senhora do Monte, o Miradouro de Santa Catarina e o Miradouro de São Pedro de Alcântara.",
                            history: "Os Miradouros em Lisboa têm uma longa história, remontando à ocupação mourisca da cidade. Os pontos de vista elevados eram originalmente usados para fins defensivos, proporcionando uma vantagem estratégica para monitorar a cidade e seus arredores. Ao longo dos séculos, os miradouros tornaram-se locais de encontro populares para moradores e visitantes, oferecendo um refúgio do agito da cidade. Hoje, os miradouros são uma característica adorada da paisagem urbana de Lisboa, proporcionando vistas deslumbrantes e uma sensação de tranquilidade em meio aos bairros históricos da cidade.",
                            adress: "- Miradouro da Senhora do Monte\n- Miradouro de Santa Catarina (Adamastor)\n- Miradouro de São Pedro de Alcântara\n- Miradouro das Portas do Sol"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Viewpoints 😎 ",
                            shortDescription: "High points in Lisbon with breathtaking views over the city and river.",
                            description: "Lisbon is known for its stunning viewpoints, or miradouros, which offer panoramic views of the city and the Tagus River. From these elevated vantage points, visitors can admire the city's historic neighborhoods, red-tiled rooftops, and iconic landmarks. Some of the most popular viewpoints in Lisbon include the Miradouro da Senhora do Monte, the Miradouro de Santa Catarina, and the Miradouro de São Pedro de Alcântara.",
                        
                            history: "The miradouros in Lisbon have a long history, dating back to the Moorish occupation of the city. The elevated viewpoints were originally used for defensive purposes, providing a strategic advantage for monitoring the city and its surroundings. Over the centuries, the miradouros became popular gathering places for locals and visitors, offering a respite from the city's hustle and bustle. Today, the miradouros are a beloved feature of Lisbon's urban landscape, providing stunning views and a sense of tranquility amidst the city's historic neighborhoods.",
                            adress: "- Miradouro da Senhora do Monte\n- Miradouro de Santa Catarina (Adamastor)\n- Miradouro de São Pedro de Alcântara"
                        ),
                        "fr": MiniaturaCardTranslation(
                            titulo: "Points de vue 😎 ",
                            shortDescription: "Points élevés à Lisbonne avec des vues à couper le souffle sur la ville et le fleuve.",
                            description: "Lisbonne est connue pour ses magnifiques points de vue, ou miradouros, qui offrent des panoramas sur la ville et le fleuve Tage. Depuis ces points de vue élevés, les visiteurs peuvent admirer les quartiers historiques de la ville, les toits en tuiles rouges et les monuments emblématiques. Certains des points de vue les plus populaires à Lisbonne incluent le Miradouro da Senhora do Monte, le Miradouro de Santa Catarina et le Miradouro de São Pedro de Alcântara.",
                            history: "Les miradouros à Lisbonne ont une longue histoire, remontant à l'occupation mauresque de la ville. Les points de vue élevés étaient à l'origine utilisés à des fins défensives, offrant un avantage stratégique pour surveiller la ville et ses environs. Au fil des siècles, les miradouros sont devenus des lieux de rassemblement populaires pour les habitants et les visiteurs, offrant un répit face à l'agitation de la ville. Aujourd'hui, les miradouros sont une caractéristique appréciée du paysage urbain de Lisbonne, offrant des vues magnifiques et une sensation de tranquillité au milieu des quartiers historiques de la ville.",
                            adress: "- Miradouro da Senhora do Monte\n- Miradouro de Santa Catarina (Adamastor)\n- Miradouro de São Pedro de Alcântara"
                        ),
                        "es": MiniaturaCardTranslation(
                            titulo: "Miradores 😎 ",
                            shortDescription: "Puntos altos en Lisboa con vistas impresionantes sobre la ciudad y el río.",
                            description: "Lisboa es conocida por sus impresionantes miradores, o miradouros, que ofrecen vistas panorámicas de la ciudad y el río Tajo. Desde estos puntos elevados, los visitantes pueden admirar los barrios históricos de la ciudad, los tejados rojos y los monumentos icónicos. Algunos de los miradores más populares en Lisboa incluyen el Miradouro da Senhora do Monte, el Miradouro de Santa Catarina y el Miradouro de São Pedro de Alcântara.",
                            history: "Los miradouros en Lisboa tienen una larga historia, que se remonta a la ocupación morisca de la ciudad. Los puntos de vista elevados se usaban originalmente con fines defensivos, proporcionando una ventaja estratégica para monitorear la ciudad y sus alrededores. A lo largo de los siglos, los miradouros se convirtieron en lugares de encuentro populares para locales y visitantes, ofreciendo un respiro del bullicio de la ciudad. Hoy en día, los miradouros son una característica querida del paisaje urbano de Lisboa, proporcionando vistas impresionantes y una sensación de tranquilidad en medio de los barrios históricos de la ciudad.",
                            adress: "- Miradouro da Senhora do Monte\n- Miradouro de Santa Catarina (Adamastor)\n- Miradouro de São Pedro de Alcântara"
                            )
                    ],
                    locations: [
                        (name: ["en": "São Jorge Castle Viewpoint", "pt": "Miradouro do Castelo de São Jorge", "es": "Mirador del Castelo de São Jorge", "fr": "Mirage du Château de São Jorge"], latitude: 38.712585, longitude: -9.133726),
                        (name: ["en": "Senhora do Monte Viewpoint", "pt": "Miradouro da Senhora do Monte"], latitude: 38.7181, longitude: -9.1336),
                        (name: ["en": "Santa Catarina Viewpoint", "pt": "Miradouro de Santa Catarina", "es": "Mirador de Santa Catarina", "fr": "Mirage de Sainte-Catherine"], latitude: 38.7132, longitude: -9.1393),
                        (name: ["en": "São Pedro de Alcântara Viewpoint", "pt": "Miradouro de São Pedro de Alcântara"], latitude: 38.7147, longitude: -9.1371),
                        (name: ["en": "Portas do Sol Viewpoint", "pt": "Miradouro das Portas do Sol", "es": "Mirador de las Puertas del Sol", "fr": "Mirage des Portes du Soleil"], latitude: 38.711929, longitude: -9.129969),
                        (name: ["en": "Graça Viewpoint", "pt": "Miradouro de Graça", "es": "Mirador de la Gracia", "fr": "Mirage de la Grace"], latitude: 38.716373, longitude: -9.131520),
                        (name: ["en": "Santa Luzia Viewpoint", "pt": "Miradouro dE Santa Luzia", "es": "Mirador de Santa Luzia", "fr": "Mirage de Santa Luzia"], latitude: 38.711706, longitude: -9.1397)
                        
                    ],
                    zoomSpan: (latitudeDelta: 0.03, longitudeDelta: 0.03),
                    customCenter: nil
                ),
                MiniaturaCard(
                    id: 3,
                    imagem: "monsanto",
                    categoria: categoria,
                    ordem: 3,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Jardins e Parques 🌼 ",
                            shortDescription: "Os jardins e parques de Lisboa proporcionam autênticos oásis verdes na cidade. 🌲🌲🌲",
                            description: "Lisboa é dotada de uma coleção diversificada de jardins e parques. Visitar os jardins de Lisboa é uma maneira maravilhosa de se conectar com a natureza, apreciar a beleza da cidade e desfrutar de momentos de paz e tranquilidade.\nAlguns jardins remontam ao século XVIII, criados para a realeza e abertos ao público ao longo dos séculos. \n\n- Parque Monsanto: Considerado o pulmão de Lisboa é uma vasta área verde com trilhos, áreas de lazer e vistas panorâmicas da cidade. \n\n - Jardim da Estrela: Localizado no coração do bairro da Estrela, este charmoso jardim oferece um ambiente relaxante, com um coreto, um lago e uma variedade de plantas e flores. \n\n- Estufa Fria: Um espaço único em Lisboa, a Estufa Fria abriga uma exuberante coleção de plantas exóticas de todo o mundo, criando um ambiente mágico e tropical. \n\n- Jardim do Príncipe Real: Este charmoso jardim é um ponto de encontro para moradores e turistas, com um quiosque, um lago e uma vista deslumbrante sobre a cidade. \n\nAlém destes, Lisboa possui muitos outros jardins e parques encantadores, como o Jardim Botânico da Ajuda, o Parque Eduardo VII e os Jardins da Fundação Calouste Gulbenkian.\n- Jardim da Estrela \n- Parque Eduardo VII \n- Parque Monsanto"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Gardens and Parks 🌼 ",
                            shortDescription: "Green spaces perfect for relaxing, strolling, and enjoying urban nature. 🌲🌲🌲",
                            description: "Lisbon is endowed with a diverse collection of gardens and parks. Visiting the gardens of Lisbon is a wonderful way to connect with nature, appreciate the beauty of the city, and enjoy moments of peace and tranquility.",
                            history: "Some gardens date back to the 18th century, created for royalty and opened to the public over the centuries. \n\nMonsanto Park: Considered the lung of Lisbon it's a vast green area with trails, leisure areas, and panoramic views of the city. \n\n Estrela Garden: Located in the heart of the Estrela neighborhood, this charming garden offers a relaxing environment, with a bandstand, a lake, and a variety of plants and flowers. \n\nEstufa Fria: A unique space in Lisbon, the Estufa Fria houses an exuberant collection of exotic plants from all over the world, creating a magical and tropical environment. \n\nJardim do Príncipe Real: This charming garden is a meeting point for locals and tourists, with a kiosk, a lake, and a stunning view over the city. \n\nIn addition to these, Lisbon has many other charming gardens and parks, such as the Jardim Botânico da Ajuda, the Parque Eduardo VII, and the Gardens of the Calouste Gulbenkian.",
                            adress:"- Jardim da Estrela \n- Parque Eduardo VII \n- Parque Monsanto"
                        ),
                        "fr": MiniaturaCardTranslation(
                            titulo: "Jardins et Parcs 🌼 ",
                            shortDescription: "Des espaces verts parfaits pour se détendre, se promener et profiter de la nature urbaine. 🌲🌲🌲",
                            description: "Lisbonne est dotée d'une collection diversifiée de jardins et de parcs. Visiter les jardins de Lisbonne est une merveilleuse façon de se connecter avec la nature, d'apprécier la beauté de la ville et de profiter de moments de paix et de tranquillité.",
                            history: "Certains jardins remontent au XVIIIe siècle, créés pour la royauté et ouverts au public au fil des siècles. \n\nParque Monsanto : Considéré comme le poumon de Lisbonne, c'est une vaste zone verte avec des sentiers, des espaces de loisirs et des vues panoramiques sur la ville. \n\nJardim da Estrela : Situé au cœur du quartier d'Estrela, ce charmant jardin offre un environnement relaxant, avec un kiosque à musique, un lac et une variété de plantes et de fleurs. \n\nEstufa Fria : Un espace unique à Lisbonne, l'Estufa Fria abrite une collection exubérante de plantes exotiques du monde entier, créant un environnement magique et tropical. \n\nJardim do Príncipe Real : Ce charmant jardin est un point de rencontre pour les habitants et les touristes, avec un kiosque, un lac et une vue imprenable sur la ville. \n\nEn plus de ceux-ci, Lisbonne possède de nombreux autres jardins et parcs charmants, tels que le Jardim Botânico da Ajuda, le Parque Eduardo VII et les Jardins de la Calouste Gulbenkian.",
                            adress:"- Jardim da Estrela \n- Parque Eduardo VII \n- Parque Monsanto"
                        ),
                        "es": MiniaturaCardTranslation(
                            titulo: "Jardines y Parques 🌼 ",
                            shortDescription: "Espacios verdes perfectos para relajarse, pasear y disfrutar de la naturaleza urbana. 🌲🌲🌲",
                            description: "Lisboa cuenta con una diversa colección de jardines y parques. Visitar los jardines de Lisboa es una maravillosa manera de conectarse con la naturaleza, apreciar la belleza de la ciudad y disfrutar de momentos de paz y tranquilidad.",
                            history: "Algunos jardines datan del siglo XVIII, creados para la realeza y abiertos al público a lo largo de los siglos. \n\nParque Monsanto: Considerado el pulmón de Lisboa, es una vasta área verde con senderos, áreas de ocio y vistas panorámicas de la ciudad. \n\nJardín de Estrela: Ubicado en el corazón del barrio de Estrela, este encantador jardín ofrece un ambiente relajante, con un quiosco, un lago y una variedad de plantas y flores. \n\nEstufa Fria: Un espacio único en Lisboa, la Estufa Fria alberga una exuberante colección de plantas exóticas de todo el mundo, creando un ambiente mágico y tropical. \n\nJardín do Príncipe Real: Este encantador jardín es un punto de encuentro para locales y turistas, con un quiosco, un lago y una impresionante vista sobre la ciudad. \n\nAdemás de estos, Lisboa tiene muchos otros jardines y parques encantadores, como el Jardim Botânico da Ajuda, el Parque Eduardo VII y los Jardines de la Calouste Gulbenkian.",
                            adress:"- Jardim da Estrela \n- Parque Eduardo VII \n- Parque Monsanto"
                            )
                    ],
                    locations: [
                        (name: ["en": "Eduardo VII Park", "pt": "Parque Eduardo VII", "es": "Parque Eduardo VII", "fr": "Parc Eduardo VII"], latitude: 38.7262, longitude: -9.1506),
                        (name: ["en": "Estrela Garden", "pt": "Jardim da Estrela", "es": "Jardín de la Estrela", "fr": "Jardin de l'Estrela"], latitude: 38.714713, longitude: -9.159183),
                        (name: ["en": "Monsanto Park", "pt": "Parque Monsanto", "es": "Parque Monsanto", "fr": "Parc Monsanto"], latitude: 38.727683, longitude: -9.190777)
                    ],
                    zoomSpan: (latitudeDelta: 0.1, longitudeDelta: 0.1),
                    customCenter: nil
                ),
                MiniaturaCard(
                    id: 4,
                    imagem: "serra_sintra",
                    categoria: categoria,
                    ordem: 4,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Serra de Sintra ⛰ ",
                            shortDescription: "A Serra de Sintra é Patrimônio Mundial da UNESCO pelo seu conjunto natural e arquitectonico.",
                            description: "É uma cadeia montanhosa localizada perto da cidade de Sintra, um Patrimônio Mundial da UNESCO. As montanhas são conhecidas por sua vegetação exuberante, flora e fauna diversificadas e paisagens deslumbrantes, com vistas panorâmicas do Oceano Atlântico e do campo circundante. A Serra de Sintra é um destino popular para amantes da natureza, caminhantes e entusiastas de atividades ao ar livre.",
                            history: "Considerada sagrada pelos celtas e romanos, as montanhas foram palco de várias atividades religiosas e culturais ao longo dos séculos, com inúmeras capelas, santuários e eremitérios espalhados pela região. No século XIX, as montanhas tornaram-se um destino popular para a nobreza e artistas europeus, atraídos pelas paisagens românticas e pela atmosfera mística. Hoje, a Serra de Sintra é um parque natural protegido, oferecendo aos visitantes uma combinação única de beleza natural, patrimônio cultural e atividades ao ar livre.",
                            adress: "Sintra, Portugal"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Sintra Mountains ⛰ ",
                            shortDescription: "Mystical mountains covered in forest, palaces, and enchanting trails.",
                            description: "It's a mountain range located near the town of Sintra, a UNESCO World Heritage Site. The mountains are known for their lush vegetation, diverse flora and fauna, and stunning landscapes, with panoramic views of the Atlantic Ocean and the surrounding countryside. The Sintra Mountains are a popular destination for nature lovers, hikers, and outdoor enthusiasts.",
                            history: "Considered sacred by the Celts and Romans, the mountains have been the site of various religious and cultural activities over the centuries, with numerous chapels, shrines, and hermitages scattered throughout the region. In the 19th century, the mountains became a popular destination for European nobility and artists, who were drawn to the romantic landscapes and mystical atmosphere. Today, the Sintra Mountains are a protected natural park, offering visitors a unique combination of natural beauty, cultural heritage, and outdoor activities.",
                            adress: "Sintra, Portugal"
                        ),
                        "es": MiniaturaCardTranslation(
                            titulo: "Sierra de Sintra ⛰ ",
                            shortDescription: "Sierra mística cubierta de bosques, palacios y senderos encantadores.",
                            description: "Es una cadena montañosa ubicada cerca de la ciudad de Sintra, un sitio del Patrimonio Mundial de la UNESCO. Las montañas son conocidas por su vegetación exuberante, flora y fauna diversa, y paisajes impresionantes, con vistas panorámicas del Océano Atlántico y el campo circundante. La Sierra de Sintra es un destino popular para los amantes de la naturaleza, excursionistas y entusiastas de las actividades al aire libre.",
                            history: "Consideradas sagradas por los celtas y romanos, las montañas han sido el sitio de diversas actividades religiosas y culturales a lo largo de los siglos, con numerosas capillas, santuarios y ermitas dispersas por toda la región. En el siglo XIX, las montañas se convirtieron en un destino popular para la nobleza y los artistas europeos, atraídos por los paisajes románticos y la atmósfera mística. Hoy en día, la Sierra de Sintra es un parque natural protegido, que ofrece a los visitantes una combinación única de belleza natural, patrimonio cultural y actividades al aire libre.",
                            adress: "Sintra, Portugal"
                        ),
                        "fr": MiniaturaCardTranslation(
                            titulo: "Serra de Sintra ⛰ ",
                            shortDescription: "Montagnes mystiques couvertes de forêts, de palais et de sentiers enchanteurs.",
                            description: "C'est une chaîne de montagnes située près de la ville de Sintra, un site du patrimoine mondial de l'UNESCO. Les montagnes sont connues pour leur végétation luxuriante, leur flore et leur faune diversifiées, et leurs paysages à couper le souffle, avec des vues panoramiques sur l'océan Atlantique et la campagne environnante. Les montagnes de Sintra sont une destination populaire pour les amoureux de la nature, les randonneurs et les amateurs d'activités de plein air.",
                            history: "Considérées comme sacrées par les Celtes et les Romains, les montagnes ont été le site de diverses activités religieuses et culturelles au fil des siècles, avec de nombreuses chapelles, sanctuaires et ermitages dispersés dans toute la région. Au XIXe siècle, les montagnes sont devenues une destination populaire pour la noblesse et les artistes européens, attirés par les paysages romantiques et l'atmosphère mystique. Aujourd'hui, les montagnes de Sintra sont un parc naturel protégé, offrant aux visiteurs une combinaison unique de beauté naturelle, de patrimoine culturel et d'activités de plein air.",
                            adress: "Sintra, Portugal"
                        ),
                            
                    ],
                    locations: [
                        (name: ["en": "Serra de Sintra", "pt": "Serra de Sintra", "es": "Sierra de Sintra", "fr": "Serra de Sintra"], latitude: 38.7939, longitude: -9.3907)
                    ],
                    zoomSpan: (latitudeDelta: 0.8, longitudeDelta: 0.8),
                    customCenter: nil
                ),
                MiniaturaCard(
                    id: 5,
                    imagem: "praias",
                    categoria: categoria,
                    ordem: 5,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Praias de Lisboa ⛱️ ",
                            shortDescription: "Areias douradas e mar refrescante a poucos minutos do centro da cidade.",
                            description: "Lisboa é rodeada por belas praias ao longo da costa atlântica, oferecendo uma variedade de paisagens e oportunidades recreativas. Desde enseadas arenosas e falésias rochosas até ondas para surf e resorts à beira-mar, as praias próximas a Lisboa atendem a todos os gostos e preferências. Algumas das praias mais populares incluem Cascais, Estoril e Costa da Caparica, cada uma com seu charme e atrações únicas.",
                            history: "As praias próximas a Lisboa têm sido um destino popular para moradores e turistas há séculos, oferecendo um refúgio do agito da cidade. As cidades costeiras de Cascais e Estoril tornaram-se resorts da moda no século XIX, atraindo a realeza e aristocracia europeias. A Costa da Caparica, com suas longas praias de areia e vilarejos de pescadores tradicionais, tem sido um local favorito para os residentes de Lisboa que buscam sol, mar e frutos do mar frescos. Hoje, as praias próximas a Lisboa são um destino durante todo o ano, oferecendo uma ampla gama de atividades, desde banhos de sol e natação até surf e esportes aquáticos.",
                            adress: "⛱️ Costa da Caparica\n⛱️  Carcavelos\n⛱️  Estoril"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Lisbon Beaches ⛱️ ",
                            shortDescription: "Golden sands and refreshing sea just minutes from the city center.",
                            description: "Lisbon is surrounded by beautiful beaches along the Atlantic coast, offering a variety of landscapes and recreational opportunities. From sandy coves and rocky cliffs to surf breaks and seaside resorts, the beaches near Lisbon cater to all tastes and preferences. Some of the most popular beaches include Cascais, Estoril, and Costa da Caparica, each with its unique charm and attractions.",
                            history: "The beaches near Lisbon have been a popular destination for locals and tourists for centuries, offering a respite from the city's hustle and bustle. The coastal towns of Cascais and Estoril became fashionable resorts in the 19th century, attracting European royalty and aristocracy. The Costa da Caparica, with its long sandy beaches and traditional fishing villages, has been a favorite spot for Lisbon residents seeking sun, sea, and fresh seafood. Today, the beaches near Lisbon are a year-round destination, offering a wide range of activities, from sunbathing and swimming to surfing and water sports.",
                            adress: "⛱️ Costa da Caparica\n⛱️  Carcavelos\n⛱️  Estoril"
                        ),
                        "es": MiniaturaCardTranslation(
                            titulo: "Playas de Lisboa ⛱️ ",
                            shortDescription: "Arenas doradas y mar refrescante a pocos minutos del centro de la ciudad.",
                            description: "Lisboa está rodeada de hermosas playas a lo largo de la costa atlántica, ofreciendo una variedad de paisajes y oportunidades recreativas. Desde calas arenosas y acantilados rocosos hasta rompientes para surfear y resorts junto al mar, las playas cercanas a Lisboa satisfacen todos los gustos y preferencias. Algunas de las playas más populares incluyen Cascais, Estoril y Costa da Caparica, cada una con su encanto y atracciones únicas.",
                            history: "Las playas cercanas a Lisboa han sido un destino popular para locales y turistas durante siglos, ofreciendo un respiro del bullicio de la ciudad. Las ciudades costeras de Cascais y Estoril se convirtieron en resorts de moda en el siglo XIX, atrayendo a la realeza y aristocracia europea. La Costa da Caparica, con sus largas playas de arena y pueblos pesqueros tradicionales, ha sido un lugar favorito para los residentes de Lisboa que buscan sol, mar y mariscos frescos. Hoy en día, las playas cercanas a Lisboa son un destino durante todo el año, ofreciendo una amplia gama de actividades, desde tomar el sol y nadar hasta surfear y practicar deportes acuáticos.",
                            adress: "⛱️ Costa da Caparica\n⛱️  Carcavelos\n⛱️  Estoril"
                        ),
                        "fr": MiniaturaCardTranslation(
                            titulo: "Plages de Lisbonne ⛱️ ",
                            shortDescription: "Sables dorés et mer rafraîchissante à quelques minutes du centre-ville.",
                            description: "Lisbonne est entourée de belles plages le long de la côte atlantique, offrant une variété de paysages et d'opportunités récréatives. Des criques sablonneuses et des falaises rocheuses aux spots de surf et aux stations balnéaires, les plages près de Lisbonne répondent à tous les goûts et préférences. Certaines des plages les plus populaires incluent Cascais, Estoril et Costa da Caparica, chacune avec son charme et ses attractions uniques.",
                            history: "Les plages près de Lisbonne ont été une destination populaire pour les habitants et les touristes pendant des siècles, offrant un refuge du tumulte de la ville. Les villes côtières de Cascais et Estoril sont devenues des stations balnéaires à la mode au 19ème siècle, attirant la royauté et l'aristocratie européennes. La Costa da Caparica, avec ses longues plages de sable et ses villages de pêcheurs traditionnels, a été un endroit préféré pour les résidents de Lisbonne à la recherche de soleil, de mer et de fruits de mer frais. Aujourd'hui, les plages près de Lisbonne sont une destination toute l'année, offrant une large gamme d'activités, du bronzage et de la natation au surf et aux sports nautiques.",
                            adress: "⛱️ Costa da Caparica\n⛱️  Carcavelos\n⛱️  Estoril"
                        )
                    ],
                    locations: [
                        (name: ["en": "Caparica Beach", "pt": "Praias da Caparica", "fr": "Caparica", "es": "Caparica"], latitude: 38.552982, longitude: -9.188481),
                        (name: ["en": "Cascais-Estoril", "pt": "Cascais-Estoril", "fr": "Cascais-Estoril", "es": "Cascais-Estoril"], latitude: 38.703130, longitude: -9.399608),
                        (name: ["en": "Sintra", "pt": "Sintra", "fr": "Sintra", "es": "Sintra"], latitude: 38.827308, longitude: -9.463803)
                    ],
                    zoomSpan: (latitudeDelta: 0.8, longitudeDelta: 0.8),
                    customCenter: nil
                ),
                MiniaturaCard(
                    id: 6,
                    imagem: "cabo_roca",
                    categoria: categoria,
                    ordem: 6,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Cabo da Roca 😮 ",
                            shortDescription: "Onde a terra acaba e o mar começa. O Cabo da Roca é o ponto mais ocidental da Europa continental.",
                            description: "É o ponto mais ocidental da Europa continental, localizado na costa acidentada de Sintra. O cabo é marcado por um farol e um monumento, oferecendo vistas deslumbrantes do Oceano Atlântico e das falésias circundantes. O Cabo da Roca é um destino popular para turistas e caminhantes, conhecido por suas paisagens dramáticas e pores do sol românticos.",
                            history: "O Cabo da Roca tem sido um ponto de referência para marinheiros e exploradores desde os tempos antigos, marcando o fim do mundo conhecido e o início do desconhecido. O cabo foi mencionado por geógrafos romanos e árabes como o ponto mais ocidental da massa terrestre eurasiática. No século XVI, exploradores portugueses partiram do Cabo da Roca em suas viagens de descoberta, abrindo novas rotas comerciais e estabelecendo Portugal como uma potência marítima. Hoje, o Cabo da Roca é uma atração turística popular, oferecendo aos visitantes um vislumbre da beleza natural e da importância histórica da região.",
                            adress: "Estrada do Cabo da Roca, Colares, Sintra"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Cape Roca 😮 ",
                            shortDescription: "The westernmost point of mainland Europe, with impressive cliffs.",
                            description: "It's the westernmost point of continental Europe, located on the rugged coastline of Sintra. The cape is marked by a lighthouse and a monument, offering breathtaking views of the Atlantic Ocean and the surrounding cliffs. Cabo da Roca is a popular destination for tourists and hikers, known for its dramatic landscapes and romantic sunsets.",
                            history: "Cabo da Roca has been a point of reference for sailors and explorers since ancient times, marking the end of the known world and the beginning of the unknown. The cape was mentioned by Roman and Arab geographers as the westernmost point of the Eurasian landmass. In the 16th century, Portuguese explorers set sail from Cabo da Roca on their voyages of discovery, opening up new trade routes and establishing Portugal as a maritime power. Today, Cabo da Roca is a popular tourist attraction, offering visitors a glimpse into the region's natural beauty and historical significance.",
                            adress: "Estrada do Cabo da Roca, Colares, Sintra"
                        ),
                        "es": MiniaturaCardTranslation(
                            titulo: "Cabo da Roca 😮 ",
                            shortDescription: "El punto más occidental de Europa continental, con impresionantes acantilados.",
                            description: "Es el punto más occidental de Europa continental, ubicado en la accidentada costa de Sintra. El cabo está marcado por un faro y un monumento, ofreciendo vistas impresionantes del Océano Atlántico y los acantilados circundantes. Cabo da Roca es un destino popular para turistas y excursionistas, conocido por sus paisajes dramáticos y románticos atardeceres.",
                            history: "Cabo da Roca ha sido un punto de referencia para marineros y exploradores desde tiempos antiguos, marcando el fin del mundo conocido y el comienzo de lo desconocido. El cabo fue mencionado por geógrafos romanos y árabes como el punto más occidental de la masa terrestre euroasiática. En el siglo XVI, los exploradores portugueses zarparon desde Cabo da Roca en sus viajes de descubrimiento, abriendo nuevas rutas comerciales y estableciendo a Portugal como una potencia marítima. Hoy en día, Cabo da Roca es una atracción turística popular, ofreciendo a los visitantes una visión de la belleza natural y la importancia histórica de la región.",
                            adress: "Estrada do Cabo da Roca, Colares, Sintra"
                        ),
                        "fr": MiniaturaCardTranslation(
                            titulo: "Cabo da Roca 😮 ",
                            shortDescription: "Le point le plus occidental de l'Europe continentale, avec des falaises impressionnantes.",
                            description: "C'est le point le plus occidental de l'Europe continentale, situé sur la côte accidentée de Sintra. Le cap est marqué par un phare et un monument, offrant des vues à couper le souffle sur l'océan Atlantique et les falaises environnantes. Cabo da Roca est une destination populaire pour les touristes et les randonneurs, connue pour ses paysages dramatiques et ses couchers de soleil romantiques.",
                            history: "Cabo da Roca a été un point de référence pour les marins et les explorateurs depuis les temps anciens, marquant la fin du monde connu et le début de l'inconnu. Le cap a été mentionné par des géographes romains et arabes comme le point le plus occidental de la masse terrestre eurasienne. Au 16ème siècle, les explorateurs portugais ont mis les voiles depuis Cabo da Roca lors de leurs voyages de découverte, ouvrant de nouvelles routes commerciales et établissant le Portugal comme une puissance maritime. Aujourd'hui, Cabo da Roca est une attraction touristique populaire, offrant aux visiteurs un aperçu de la beauté naturelle et de l'importance historique de la région.",
                            adress: "Estrada do Cabo da Roca, Colares, Sintra"
                        )
                    ],
                    locations: [
                        (name: ["en": "Cabo da Roca", "pt": "Cabo da Roca", "es": "Cabo da Roca", "fr": "Cabo da Roca"], latitude: 38.7804, longitude: -9.4989)
                    ],
                    zoomSpan: (latitudeDelta: 1, longitudeDelta: 1),
                    customCenter: (38.789711, -9.304144)
                ),
                MiniaturaCard(
                    id: 7,
                    imagem: "onda_nazare",
                    categoria: categoria,
                    ordem: 7,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Ondas da Nazaré 🌊 ",
                            shortDescription: "As maiores ondas do mundo são surfadas 🏄🏽‍♂️ na Nazaré.",
                            description: "A Nazaré é uma vila de pescadores conhecida pelas suas ondas gigantes, que atraem surfistas de todo o mundo. As ondas na Praia do Norte podem atingir alturas superiores a 30 metros, tornando-as algumas das maiores do mundo. A topografia submarina única e as condições meteorológicas ao largo da costa da Nazaré criam as condições perfeitas para estas ondas massivas.",
                            history: "As ondas gigantes na Nazaré são um fenómeno natural há séculos, mas foi apenas nos últimos anos que ganharam fama internacional. As ondas são criadas por uma combinação de fatores, incluindo o Canhão da Nazaré, um abismo subaquático que canaliza e amplifica a ondulação, e o Oceano Atlântico Norte, que produz tempestades e ondulações poderosas. Em 2011, o surfista havaiano Garrett McNamara estabeleceu um recorde mundial ao surfar uma onda de 23,77 metros na Praia do Norte, colocando a Nazaré no mapa como um destino de surf de ondas grandes de primeira linha. Desde então, a vila tornou-se um paraíso para surfistas e espetadores que vêm testemunhar as ondas impressionantes e os surfistas destemidos que as enfrentam.",
                            adress: "Praia do Norte, Nazaré"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Nazaré Waves 🌊 ",
                            shortDescription: "Famous for the biggest surfed waves 🏄🏽‍♂️ in the world, attracting international surfers.",
                            description: "Nazaré is a fishing village known for its giant waves, which attract surfers from around the world. The waves at Praia do Norte can reach heights of over 100 feet, making them some of the biggest in the world. The unique underwater topography and weather conditions off the coast of Nazaré create the perfect conditions for these massive waves.",
                            history: "The giant waves at Nazaré have been a natural phenomenon for centuries, but it was only in recent years that they gained international fame. The waves are created by a combination of factors, including the Nazaré Canyon, an underwater chasm that funnels and amplifies the swell, and the North Atlantic Ocean, which produces powerful storms and swells. In 2011, Hawaiian surfer Garrett McNamara set a world record by riding a 78-foot wave at Praia do Norte, putting Nazaré on the map as a premier big wave surfing destination. Since then, the village has become a mecca for surfers and spectators, who come to witness the awe-inspiring waves and the daring surfers who ride them.",
                            adress: "Praia do Norte, Nazaré"   //39.019635, -9.151986
                        ),
                        "es": MiniaturaCardTranslation(
                            titulo: "Olas de Nazaré 🌊 ",
                            shortDescription: "Famosas por las olas más grandes surfeadas 🏄🏽‍♂️ del mundo, atrayendo a surfistas internacionales.",
                            description: "Nazaré es un pueblo pesquero conocido por sus olas gigantes, que atraen a surfistas de todo el mundo. Las olas en Praia do Norte pueden alcanzar alturas de más de 30 metros, lo que las convierte en algunas de las más grandes del mundo. La topografía submarina única y las condiciones climáticas frente a la costa de Nazaré crean las condiciones perfectas para estas olas masivas.",
                            history: "Las olas gigantes en Nazaré son un fenómeno natural desde hace siglos, pero fue solo en los últimos años que ganaron fama internacional. Las olas son creadas por una combinación de factores, incluido el Cañón de Nazaré, un abismo submarino que canaliza y amplifica el oleaje, y el Océano Atlántico Norte, que produce poderosas tormentas y oleajes. En 2011, el surfista hawaiano Garrett McNamara estableció un récord mundial al surfear una ola de 23,77 metros en Praia do Norte, poniendo a Nazaré en el mapa como un destino principal para el surf de olas grandes. Desde entonces, el pueblo se ha convertido en una meca para los surfistas y espectadores que vienen a presenciar las impresionantes olas y los valientes surfistas que las montan.",
                            adress: "Praia do Norte, Nazaré"
                        ),
                        "fr": MiniaturaCardTranslation(
                            titulo: "Vagues de Nazaré 🌊 ",
                            shortDescription: "Célèbres pour les plus grandes vagues surfées 🏄🏽‍♂️ du monde, attirant des surfeurs internationaux.",
                            description: "Nazaré est un village de pêcheurs connu pour ses vagues géantes, qui attirent des surfeurs du monde entier. Les vagues à Praia do Norte peuvent atteindre des hauteurs de plus de 30 mètres, ce qui en fait certaines des plus grandes au monde. La topographie sous-marine unique et les conditions météorologiques au large de la côte de Nazaré créent les conditions parfaites pour ces vagues massives.",
                            history: "Les vagues géantes à Nazaré sont un phénomène naturel depuis des siècles, mais ce n'est que ces dernières années qu'elles ont gagné une renommée internationale. Les vagues sont créées par une combinaison de facteurs, notamment le Canyon de Nazaré, un gouffre sous-marin qui canalise et amplifie la houle, et l'océan Atlantique Nord, qui produit des tempêtes puissantes et des houles. En 2011, le surfeur hawaïen Garrett McNamara a établi un record mondial en surfant une vague de 23,77 mètres à Praia do Norte, mettant Nazaré sur la carte comme une destination de surf de grosses vagues de premier plan. Depuis lors, le village est devenu une Mecque pour les surfeurs et les spectateurs qui viennent assister aux vagues impressionnantes et aux surfeurs audacieux qui les montent.",
                            adress: "Praia do Norte, Nazaré"
                        )
                    ],
                    locations: [
                        (name: ["en": "Ondas da Nazaré", "pt": "Ondas da Nazaré", "es": "Olas de Nazaré", "fr": "Vagues de Nazaré"], latitude: 39.6102, longitude: -9.0856)
                    ],
                    zoomSpan: (latitudeDelta: 1, longitudeDelta: 1),
                    customCenter: (39.019635, -9.151986)
                ),
                MiniaturaCard(
                    id: 8,
                    imagem: "plus_nature",
                    categoria: categoria,
                    ordem: 8,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Mais Natureza 🌿 ",
                            shortDescription: "Descubra mais das maravilhas naturais de Portugal.",
                            description: "Além das 7 maravilhas naturais que mencionamos, existem outros locais próximos a Lisboa que vale a pena destacar. \n\nSerra da Arrábida destaca-se pela sua vegetação mediterrânica densa e bem preservada, que confere à serra uma notável riqueza botânica, com espécies endémicas e outras de grande valor ecológico. As praias da Arrábida, com suas areias brancas e águas cristalinas, são consideradas algumas das mais belas de Portugal, oferecendo um contraste harmonioso entre as montanhas e o mar. \n\nAs Ilhas Berlengas (na foto), por sua vez, constituem um arquipélago de alto valor ecológico, localizado a cerca de 10 quilómetros da costa de Peniche. A Berlenga Grande, a ilha principal, é a única habitada e aberta a visitantes, oferecendo cenários naturais preservados e uma rica história. O arquipélago é renomado pela sua biodiversidade marinha, com uma ampla variedade de espécies de peixes, crustáceos e moluscos. A avifauna das Berlengas também é notável, com várias espécies de aves marinhas nidificando nas ilhas.",
                            history: "A Serra da Arrábida oferece inúmeros trilhos para caminhadas, com diferentes níveis de dificuldade, que permitem explorar sua paisagem diversificada e desfrutar de vistas panorâmicas. As águas da Arrábida são ideais para mergulho e snorkeling, devido à sua clareza e rica biodiversidade marinha. A observação de aves é outra atividade popular nas montanhas, que abrigam várias espécies de aves marinhas e terrestres. \n\nO mergulho é uma das principais atividades nas Ilhas Berlengas, devido à clareza das águas e à riqueza da vida marinha. Os passeios de barco permitem explorar as grutas e enseadas da ilha, bem como observar a fauna marinha e as aves marinhas. Uma visita ao Forte de São João Baptista, uma fortificação histórica localizada na ilha, é outra atração popular. A observação da natureza permite observar a fauna e flora locais.",
                            adress: "- Serra da Arrábida\n- Ilhas Berlengas"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "More Nature 🌿 ",
                            shortDescription: "Discover even more natural wonders in Portugal and around Lisbon.",
                            description: "In addition to the 7 natural wonders we mentioned, there are other places close to Lisbon that are worth mentioning. \n\nSerra da Arrábida stands out for its dense and well-preserved Mediterranean vegetation, which gives the mountain range a remarkable botanical richness, with endemic species and others of great ecological value. The beaches of Arrábida, with their white sands and crystal-clear waters, are considered some of the most beautiful in Portugal, offering a harmonious contrast between the mountains and the sea. \n\n Berlengas Islands (in the picture), in turn, constitute an archipelago of high ecological value, located about 10 kilometres off the coast of Peniche. Berlenga Grande, the main island, is the only one that is inhabited and open to visitors, offering preserved natural scenery and a rich history. The archipelago is renowned for its marine biodiversity, with a wide variety of species of fish, crustaceans and molluscs. The birdlife of the Berlengas is also notable, with several species of seabirds nesting on the islands.",
                            history: "The Serra da Arrábida offers numerous hiking trails, with different levels of difficulty, which allow you to explore its diverse landscape and enjoy panoramic views. The waters of Arrábida are ideal for diving and snorkeling, due to their clarity and rich marine biodiversity. Birdwatching is another popular activity in the mountains, which are home to several species of sea and land birds. \n\nDiving is one of the main activities in the Berlengas Islands, due to the clarity of the waters and the richness of marine life. Boat trips allow you to explore the island's caves and coves, as well as observe marine fauna and seabirds. A visit to Forte de São João Baptista, a historic fortification located on the island, is another popular attraction. Nature observation allows you to observe the local fauna and flora.",
                            adress: "- Serra da Arrábida\n- Ilhas Berlengas"
                        ),
                        "fr": MiniaturaCardTranslation(
                            titulo: "Plus de Nature 🌿 ",
                            shortDescription: "Découvrez encore plus de merveilles naturelles au Portugal et autour de Lisbonne.",
                            description: "En plus des 7 merveilles naturelles que nous avons mentionnées, il existe d'autres endroits proches de Lisbonne qui méritent d'être mentionnés. \n\nLa Serra da Arrábida se distingue par sa végétation méditerranéenne dense et bien préservée, qui confère à la chaîne de montagnes une richesse botanique remarquable, avec des espèces endémiques et d'autres d'une grande valeur écologique. Les plages de l'Arrábida, avec leurs sables blancs et leurs eaux cristallines, sont considérées comme parmi les plus belles du Portugal, offrant un contraste harmonieux entre les montagnes et la mer. \n\nLes îles Berlengas (sur la photo), quant à elles, constituent un archipel de grande valeur écologique, situé à environ 10 kilomètres au large de la côte de Peniche. Berlenga Grande, l'île principale, est la seule habitée et ouverte aux visiteurs, offrant des paysages naturels préservés et une riche histoire. L'archipel est réputé pour sa biodiversité marine, avec une grande variété d'espèces de poissons, crustacés et mollusques. La avifaune des Berlengas est également notable, avec plusieurs espèces d'oiseaux marins nichant sur les îles.",
                            history: "La Serra da Arrábida offre de nombreux sentiers de randonnée, avec différents niveaux de difficulté, qui permettent d'explorer son paysage diversifié et de profiter de vues panoramiques. Les eaux de l'Arrábida sont idéales pour la plongée et le snorkeling, en raison de leur clarté et de leur riche biodiversité marine. L'observation des oiseaux est une autre activité populaire dans les montagnes, qui abritent plusieurs espèces d'oiseaux marins et terrestres. \n\nLa plongée est l'une des principales activités dans les îles Berlengas, en raison de la clarté des eaux et de la richesse de la vie marine. Les excursions en bateau permettent d'explorer les grottes et les criques de l'île, ainsi que d'observer la faune marine et les oiseaux marins. Une visite au Forte de São João Baptista, une fortification historique située sur l'île, est uneutre attraction populaire. L'observation de la nature permet d'observer la faune et la flore locales.",
                            adress: "- Serra da Arrábida\n- Ilhas Berlengas"
                        ),
                        "es": MiniaturaCardTranslation(
                            titulo: "Más Naturaleza 🌿 ",
                            shortDescription: "Descubre aún más maravillas naturales en Portugal y alrededor de Lisboa.",
                            description: "Además de las 7 maravillas naturales que mencionamos, hay otros lugares cerca de Lisboa que vale la pena mencionar. \n\nSerra da Arrábida se destaca por su densa y bien conservada vegetación mediterránea, que le da a la cadena montañosa una notable riqueza botánica, con especies endémicas y otras de gran valor ecológico. Las playas de Arrábida, con sus arenas blancas y aguas cristalinas, son consideradas algunas de las más hermosas de Portugal, ofreciendo un contraste armonioso entre las montañas y el mar. \n\nLas Islas Berlengas (en la foto), a su vez, constituyen un archipiélago de alto valor ecológico, ubicado a unos 10 kilómetros de la costa de Peniche. Berlenga Grande, la isla principal, es la única habitada y abierta a los visitantes, ofreciendo paisajes naturales preservados y una rica historia. El archipiélago es conocido por su biodiversidad marina, con una gran variedad de especies de peces, crustáceos y moluscos. La avifauna de las Berlengas también es notable, con varias especies de aves marinas anidando en las islas.",
                            history: "La Serra da Arrábida ofrece numerosos senderos para caminatas, con diferentes niveles de dificultad, que permiten explorar su paisaje diverso y disfrutar de vistas panorámicas. Las aguas de Arrábida son ideales para el buceo y el snorkel, debido a su claridad y rica biodiversidad marina. La observación de aves es otra actividad popular en las montañas, que albergan varias especies de aves marinas y terrestres. \n\nEl buceo es una de las principales actividades en las Islas Berlengas, debido a la claridad de las aguas y la riqueza de la vida marina. Los paseos en barco permiten explorar las cuevas y calas de la isla, así como observar la fauna marina y las aves marinas. Una visita al Forte de São João Baptista, una fortificación histórica ubicada en la isla, es otra atracción popular. La observación de la naturaleza permite observar la fauna y flora locales.",
                            adress: "- Serra da Arrábida\n- Ilhas Berlengas"
                        )
                    ],
                    locations: [
                        (name: ["en": "Serra da Arrábida", "pt": "Serra da Arrábida", "fr": "Serra da Arrábida", "es": "Serra da Arrábida"], latitude: 38.537618, longitude: -9.007129),
                        (name: ["en": "Ilhas Berlengas", "pt": "Ilhas Berlengas", "fr": "Iles Berlengas", "es": "Islas Berlengas"], latitude: 39.417097, longitude: -9.506463)
                    ],
                    zoomSpan: (latitudeDelta: 2, longitudeDelta: 2),
                    customCenter: (39.014298, -9.168949)
                )
            ]
        }
        if cat == "gastronomia" || cat == "gastronomy" {
            return [
                MiniaturaCard(
                    id: 1,
                    imagem: "pasteis",
                    categoria: categoria,
                    ordem: 1,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Pastéis de Nata 🥧 ",
                            shortDescription: "Os Pastéis de Nata são deliciosos pastéis de nata portugueses.",
                            description: "Os Pastéis de Nata, também conhecidos como Pastéis de Belém, são um pequeno milagre da pastelaria portuguesa, consistindo numa massa folhada crocante e um recheio cremoso de nata feito com ovos, leite, açúcar e canela. A sua textura delicada e sabor doce fazem deles uma das pastelarias mais populares do mundo.",
                            history: "A receita original foi desenvolvida pelos monges do Mosteiro dos Jerónimos na zona de Belém, provavelmente no século XVIII. Para angariar fundos para a restauração do mosteiro, os monges começaram a vender os pastéis numa padaria próxima, popularizando-os rapidamente. Hoje em dia, apenas os pastéis vendidos em Belém estão autorizados a usar o nome \"Pastéis de Belém\". Assim, todos os outros pastéis de nata são variações da receita original dos monges de Belém. A receita original permanece um segredo bem guardado, mas o Pastel de Nata tornou-se um símbolo da identidade culinária portuguesa e é agora apreciado em todo o mundo.",
                            adress: "Pastéis de Belém, Rua de Belém 84-92, Lisboa"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Pastéis de Nata 🥧 ",
                            shortDescription: "Portugal's most famous pastry, with creamy custard and crispy puff pastry.",
                            description: "\"Pastel de Nata\" also known as \"Pastel de Belém\" or \"Custard Tarts\" in english. It's a small Portuguese pastry marvel, consisting of a crispy puff pastry and a creamy custard filling made with eggs, milk, sugar, and cinnamon. Its delicate texture and sweet flavor make it one of the world's most popular pastries.",
                            history: "The original recipe was developed by the monks of the Jerónimos Monastery in the area of Belém, probably in the 18th century.To raise funds for the restoration of the monastery, the monks began selling the pastries in a nearby bakery, quickly popularizing them. Today, only pastries sold in Belém are authorized to use the name \"Pasteis de Belém\". Thus, all other pasteis de nata are variations of the original recipe from the monks of Belém. The original recipe remains a closely guarded secret, but the Pastel de Nata has become a symbol of Portuguese culinary identity and is now enjoyed worldwide.",
                            adress: "Pastéis de Belém, Rua de Belém 84-92, Lisbon"
                        ),
                        "es": MiniaturaCardTranslation(
                            titulo: "Pastéis de Nata 🥧 ",
                            shortDescription: "El pastel más famoso de Portugal, con crema pastelera y masa de hojaldre crujiente.",
                            description: "\"Pastel de Nata\" también conocido como \"Pastel de Belém\" o \"Tarta de Crema\" en español. Es una pequeña maravilla de la pastelería portuguesa, que consiste en una masa de hojaldre crujiente y un relleno cremoso de crema pastelera hecho con huevos, leche, azúcar y canela. Su textura delicada y su sabor dulce lo convierten en uno de los pasteles más populares del mundo.",
                            history: "La receta original fue desarrollada por los monjes del Monasterio de los Jerónimos en el área de Belém, probablemente en el siglo XVIII. Para recaudar fondos para la restauración del monasterio, los monjes comenzaron a vender los pasteles en una panadería cercana, popularizándolos rápidamente. Hoy en día, solo los pasteles vendidos en Belém están autorizados a usar el nombre \"Pastéis de Belém\". Por lo tanto, todos los demás pasteles de nata son variaciones de la receta original de los monjes de Belém. La receta original sigue siendo un secreto muy bien guardado, pero el Pastel de Nata se ha convertido en un símbolo de la identidad culinaria portuguesa y ahora se disfruta en todo el mundo.",
                            adress: "Pastéis de Belém, Rua de Belém 84-92, Lisboa"
                        ),
                        "fr": MiniaturaCardTranslation(
                            titulo: "Pastéis de Nata 🥧 ",
                            shortDescription: "La pâtisserie la plus célèbre du Portugal, avec une crème pâtissière onctueuse et une pâte feuilletée croustillante.",
                            description: "\"Pastel de Nata\" également connu sous le nom de \"Pastel de Belém\" ou \"Tarte à la Crème\" en français. C'est une petite merveille de la pâtisserie portugaise, composée d'une pâte feuilletée croustillante et d'une garniture crémeuse de crème pâtissière faite avec des œufs, du lait, du sucre et de la cannelle. Sa texture délicate et son goût sucré en font l'une des pâtisseries les plus populaires au monde.",
                            history: "La recette originale a été développée par les moines du monastère des Hiéronymites dans la région de Belém, probablement au XVIIIe siècle. Pour collecter des fonds pour la restauration du monastère, les moines ont commencé à vendre les pâtisseries dans une boulangerie voisine, les popularisant rapidement. Aujourd'hui, seules les pâtisseries vendues à Belém sont autorisées à utiliser le nom \"Pastéis de Belém\". Ainsi, tous les autres pastéis de nata sont des variations de la recette originale des moines de Belém. La recette originale reste un secret bien gardé, mais le Pastel de Nata est devenu un symbole de l'identité culinaire portugaise et est maintenant apprécié dans le monde entier.",
                            adress: "Pastéis de Belém, Rua de Belém 84-92, Lisbonne"
                        )
                    ],
                    locations: [
                        (name: ["en": "Pastéis de Belém", "pt": "Pastéis de Belém", "es": "Pasteles de Belém", "fr": "Pastéis de Belém"], latitude: 38.6972, longitude: -9.2036)
                    ],
                    zoomSpan: nil,
                    customCenter: nil
                ),
                MiniaturaCard(
                    id: 2,
                    imagem: "bacalhau",
                    categoria: categoria,
                    ordem: 2,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Bacalhau 🐟 ",
                            shortDescription: "O Bacalhau é um prato tradicional português feito com bacalhau salgado.", // L10n_slogan18
                            description: "Por poder ser conservado sem refrigeração e, portanto, estar disponível a qualquer momento, o bacalhau é chamado de \"o fiel amigo\" pelos portugueses. O bacalhau pode ser preparado de várias maneiras e é um peixe muito popular na culinária portuguesa. Existem várias espécies de bacalhau, mas as mais comuns em Portugal são o Gadus morhua e o Gadus macrocephalus. O bacalhau é pescado em águas frias do Atlântico Norte, salgado e seco para conservação. Em Portugal, o bacalhau é preparado de diferentes formas, como assado, cozido ou frito.",
                            history: " O bacalhau é um peixe de águas frias, abundante nos mares do Atlântico Norte, que foi introduzido na dieta portuguesa no século XV. Devido à sua capacidade de conservação, o bacalhau tornou-se um alimento essencial durante a Era dos Descobrimentos, sendo consumido pelos marinheiros durante longas viagens marítimas. Com o tempo, o bacalhau foi integrado na culinária portuguesa, dando origem a uma grande variedade de pratos típicos. Hoje em dia, o bacalhau é um dos símbolos da gastronomia nacional, apreciado tanto por portugueses como por estrangeiros. Algumas das receitas mais conhecidas com bacalhau são o Bacalhau à Brás, Bacalhau à Lagareiro, Bacalhau com Natas e Pastéis de Bacalhau.",
                            adress: "As zonas do Bairro Alto e da Baixa são conhecidas pelo número de bons restaurantes. Mas encontrará bacalhau em qualquer restaurante com cozinha portuguesa."
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Codfish 🐟 ",
                            shortDescription: "The most versatile fish in Portuguese cuisine, prepared in countless ways.",
                            description: "Because it can be preserved without refrigeration and can therefore be available at any time, cod is called \"the faithful friend\" by the Portuguese. Cod can be prepared in many ways and is a very popular fish used in Portuguese cuisine. There are several species of cod, but the most common in Portugal are Gadus morhua and Gadus macrocephalus. Cod is fished in cold waters of the North Atlantic, salted and dried for preservation. In Portugal, cod is prepared in different ways, such as baked, boiled or fried.",
                            history: "Cod is a cold-water fish, abundant in the North Atlantic seas, which was introduced into the Portuguese diet in the 15th century. Due to its ability to preserve, cod became an essential food during the Age of Discovery, being consumed by sailors during long sea voyages. Over time, cod was integrated into Portuguese cuisine, giving rise to a wide variety of typical dishes. Today, cod is one of the symbols of national gastronomy, appreciated by Portuguese and foreigners alike. Some of the best-known recipes with cod are Bacalhau à Brás, Bacalhau à Lagareiro, Bacalhau com Natas and Pastéis de Bacalhau",
                            adress: "The Bairro Alto and Baixa areas are known for their number of good restaurants. But you will find cod in any restaurant with Portuguese cuisine."
                        ),
                        "es": MiniaturaCardTranslation(
                            titulo: "Bacalao 🐟 ",
                            shortDescription: "El bacalao es un plato tradicional portugués hecho con bacalao salado.",
                            description: "Debido a que se puede conservar sin refrigeración y, por lo tanto, estar disponible en cualquier momento, el bacalao es llamado \"el amigo fiel\" por los portugueses. El bacalao se puede preparar de muchas maneras y es un pescado muy popular en la cocina portuguesa. Hay varias especies de bacalao, pero las más comunes en Portugal son Gadus morhua y Gadus macrocephalus. El bacalao se pesca en aguas frías del Atlántico Norte, se sala y seca para su conservación. En Portugal, el bacalao se prepara de diferentes maneras, como al horno, cocido o frito.",
                            history: "El bacalao es un pez de aguas frías, abundante en los mares del Atlántico Norte, que fue introducido en la dieta portuguesa en el siglo XV. Debido a su capacidad de conservación, el bacalao se convirtió en un alimento esencial durante la Era de los Descubrimientos, siendo consumido por los marineros durante largos viajes marítimos. Con el tiempo, el bacalao se integró en la cocina portuguesa, dando lugar a una gran variedad de platos típicos. Hoy en día, el bacalao es uno de los símbolos de la gastronomía nacional, apreciado tanto por portugueses como por extranjeros. Algunas de las recetas más conocidas con bacalao son Bacalhau à Brás, Bacalhau à Lagareiro, Bacalhau com Natas y Pastéis de Bacalhau.",
                            adress: "Las zonas del Bairro Alto y Baixa son conocidas por su número de buenos restaurantes. Pero encontrarás bacalao en cualquier restaurante con cocina portuguesa."
                        ),
                        "fr": MiniaturaCardTranslation(
                            titulo: "Morue 🐟 ",
                            shortDescription: "Le poisson le plus polyvalent de la cuisine portugaise, préparé de mille façons.",
                            description: "Parce qu'elle peut être conservée sans réfrigération et peut donc être disponible à tout moment, la morue est appelée \"l'ami fidèle\" par les Portugais. La morue peut être préparée de nombreuses façons et est un poisson très populaire utilisé dans la cuisine portugaise. Il existe plusieurs espèces de morue, mais les plus courantes au Portugal sont Gadus morhua et Gadus macrocephalus. La morue est pêchée dans les eaux froides de l'Atlantique Nord, salée et séchée pour la conservation. Au Portugal, la morue est préparée de différentes manières, comme au four, bouillie ou frite.",
                            history: "La morue est un poisson d'eau froide, abondant dans les mers de l'Atlantique Nord, qui a été introduit dans l'alimentation portugaise au XVe siècle. En raison de sa capacité à se conserver, la morue est devenue un aliment essentiel pendant l'ère des découvertes, consommé par les marins lors de longs voyages en mer. Avec le temps, la morue a été intégrée à la cuisine portugaise, donnant lieu à une grande variété de plats typiques. Aujourd'hui, la morue est l'un des symboles de la gastronomie nationale, appréciée tant par les Portugais que par les étrangers. Certaines des recettes les plus connues avec la morue sont Bacalhau à Brás, Bacalhau à Lagareiro, Bacalhau com Natas et Pastéis de Bacalhau.",
                            adress: "Les zones du Bairro Alto et Baixa sont connues pour leur nombre de bons restaurants. Mais vous trouverez de la morue dans n'importe quel restaurant avec une cuisine portugaise."
                        )
                    ],
                    locations: [
                        (name: ["en": "Bairro Alto", "pt": "Bairro Alto", "es": "Bairro Alto", "fr": "Bairro Alto"], latitude: 38.711793, longitude: -9.144885),
                        (name: ["en": "Baixa", "pt": "Baixa", "es": "Baixa", "fr": "Baixa"], latitude: 38.7079, longitude: -9.1366)
                    ],
                    zoomSpan: (latitudeDelta: 0.03, longitudeDelta: 0.03),
                    customCenter: (38.711187, -9.137893)
                ),
                MiniaturaCard(
                    id: 3,
                    imagem: "ginja",
                    categoria: categoria,
                    ordem: 3,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Ginjinha 🍒 ",
                            shortDescription: "A Ginjinha é um licor popular português feito de ginjas.",
                            description: "A Ginjinha, também conhecida como ginja, é um licor tradicional português feito a partir da maceração de ginjas, um tipo de cereja amarga, em aguardente, com a adição de açúcar e especiarias como canela. Este processo de maceração confere à ginjinha a sua cor rubi intensa, sabor doce e aroma frutado. Tradicionalmente, a pessoa que serve a ginjinha pergunta se \"quer com ou sem ela\", para que o cliente possa dizer se quer ou não um pouco de fruta no copo.",
                            history: "A ginjinha é uma bebida tradicional portuguesa com origens antigas. Provavelmente foram os monges os primeiros a produzir licor de ginja para fins medicinais. Mais tarde, foi vendida em farmácias como um remédio para problemas estomacais. Com o tempo, a ginjinha tornou-se popular entre a população, sendo consumida como aperitivo ou digestivo. Hoje em dia, a ginjinha é uma das bebidas mais populares em Portugal, servida em bares e pubs por todo o país. Existem várias variações da receita original, com diferentes tipos de ginjas e especiarias, que conferem à bebida um sabor único e característico.",
                            adress: "A Ginjinha, Largo de São Domingos 8, Lisboa"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Ginjinha 🍒 ",
                            shortDescription: "Lisbon's traditional cherry liqueur, served in a small glass.",
                            description: "Ginginha, also known as ginja, is a traditional Portuguese liqueur made from the maceration of ginja, a type of bitter cherry, in brandy, with the addition of sugar and spices such as cinnamon. This maceration process gives the ginginha its intense ruby color, sweet flavor and fruity aroma. Traditionally, the person serving the ginjinha asks if you want it with or without it so the customer can say whether they want some fruit in the glass or not.",
                            history: "A ginjinha é uma bebida tradicional portuguesa com origens antigas. Provavelmente foram os monges os primeiros a produzir licor de ginja para fins medicinais. Mais tarde, foi vendida em farmácias como um remédio para problemas estomacais. Com o tempo, a ginjinha tornou-se popular entre a população, sendo consumida como aperitivo ou digestivo. Hoje em dia, a ginjinha é uma das bebidas mais populares em Portugal, servida em bares e pubs por todo o país. Existem várias variações da receita original, com diferentes tipos de ginjas e especiarias, que conferem à bebida um sabor único e característico.",
                            adress: "A Ginjinha, Largo de São Domingos 8, Lisbon"
                        ),
                        "es": MiniaturaCardTranslation(
                            titulo: "Ginjinha 🍒 ",
                            shortDescription: "El licor de cereza tradicional de Lisboa, servido en un vaso pequeño.",
                            description: "Ginginha, también conocida como ginja, es un licor portugués tradicional hecho a partir de la maceración de ginja, un tipo de cereza amarga, en brandy, con la adición de azúcar y especias como canela. Este proceso de maceración le da a la ginginha su intenso color rubí, sabor dulce y aroma afrutado. Tradicionalmente, la persona que sirve la ginjinha pregunta si la quieres con o sin ella para que el cliente pueda decir si quiere algo de fruta en el vaso o no.",
                            history: "A ginjinha é uma bebida tradicional portuguesa com origens antigas. Provavelmente foram os monges os primeiros a produzir licor de ginja para fins medicinais. Mais tarde, foi vendida em farmácias como um remédio para problemas estomacais. Com o tempo, a ginjinha tornou-se popular entre a população, sendo consumida como aperitivo ou digestivo. Hoje em dia, a ginjinha é uma das bebidas mais populares em Portugal, servida em bares e pubs por todo o país. Existem várias variações da receita original, com diferentes tipos de ginjas e especiarias, que conferem à bebida um sabor único e característico.",
                            adress: "A Ginjinha, Largo de São Domingos 8, Lisboa"
                        ),
                        "fr": MiniaturaCardTranslation(
                            titulo: "Ginjinha 🍒 ",
                            shortDescription: "Le liqueur de cerise traditionnel de Lisbonne, servi dans un petit verre.",
                            description: "Ginginha, également connue sous le nom de ginja, est une liqueur portugaise traditionnelle fabriquée à partir de la macération de ginja, un type de cerise amère, dans du brandy, avec l'ajout de sucre et d'épices telles que la cannelle. Ce processus de macération donne à la ginginha sa couleur rubis intense, son goût sucré et son arôme fruité. Traditionnellement, la personne qui sert la ginjinha demande si vous la voulez avec ou sans elle pour que le client puisse dire s'il veut ou non des fruits dans le verre.",
                            history: "Le ginjinha est une boisson traditionnelle portugaise aux origines anciennes. Probablement les moines ont été les premiers à produire de la liqueur de ginja à des fins médicinales. Plus tard, il a été vendu dans les pharmacies comme remède pour les problèmes d'estomac. Avec le temps, le ginjinha est devenu populaire parmi la population, consommé comme apéritif ou digestif. Aujourd'hui, le ginjinha est l'une des boissons les plus populaires au Portugal, servi dans des bars et des pubs à travers le pays. Il existe plusieurs variations de la recette originale, avec différents types de ginjas et d'épices, qui confèrent à la boisson une saveur unique et caractéristique.",
                            adress: "A Ginjinha, Largo de São Domingos 8, Lisbonne"
                        )
                            
                    ],
                    locations: [
                        (name: ["en": "Ginjinha", "pt": "Ginjinha", "fr": "Ginjinha", "es": "Ginjinha"], latitude: 38.714720, longitude: -9.139076)
                    ],
                    zoomSpan: nil,
                    customCenter: nil
                ),
                MiniaturaCard(
                    id: 4,
                    imagem: "peixe",
                    categoria: categoria,
                    ordem: 4,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Peixe 🐟 ",
                            shortDescription: "A culinária portuguesa apresenta uma variedade de pratos de peixe fresco.", // L10n_slogan20
                            description: "Portugal é conhecido pela sua culinária baseada em peixe fresco, com uma grande variedade de espécies e formas de prepará-lo. Desde o tradicional bacalhau, ao saboroso robalo, às suculentas sardinhas, o peixe é um ingrediente essencial na cozinha portuguesa. Os pratos de peixe são geralmente simples e saudáveis, preparados com azeite, alho, ervas e legumes frescos.",
                            history: "A pesca é uma atividade antiga em Portugal, com uma longa tradição de captura e consumo de peixe fresco. A localização geográfica do país, próximo ao Oceano Atlântico, proporciona uma grande diversidade de espécies marinhas, que são pescadas ao longo da costa e nos rios. O peixe fresco é um dos pilares da culinária portuguesa, consumido em todo o país, desde as aldeias piscatórias até aos restaurantes de luxo. Os portugueses têm uma relação especial com o peixe, que é apreciado pela sua frescura, sabor e versatilidade.",
                            adress: "Zonas da cidade com muitas opções para peixe\n - Bairro Alto \n- Baixa \n- Rua das Portas de Santo Antão"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Fish 🐟 ",
                            shortDescription: "Fresh Atlantic fish are the base of typical Portuguese dishes.",
                            description: "Portugal is known for its cuisine based on fresh fish, with a wide variety of species and ways of preparing it. From traditional cod, to tasty sea bass, to succulent sardines, fish is an essential ingredient in Portuguese cuisine. Fish dishes are generally simple and healthy, cooked with olive oil, garlic, herbs and fresh vegetables.",
                            history: "Fishing is an ancient activity in Portugal, with a long tradition of catching and consuming fresh fish. The country's geographical location, close to the Atlantic Ocean, provides a great diversity of marine species, which are fished along the coast and in the rivers. Fresh fish is one of the pillars of Portuguese cuisine, consumed throughout the country, from fishing villages to luxury restaurants. The Portuguese have a special relationship with fish, which is appreciated for its freshness, flavor and versatility.",
                            adress: "Areas of the city with many options for seafood o\n - Bairro Alto \n- Bairro Alto \n- Baixa \n- Rua das Portas de Santo Antão"
                        ),
                        "es": MiniaturaCardTranslation(
                            titulo: "Pescado 🐟 ",
                            shortDescription: "El pescado fresco del Atlántico es la base de los platos típicos portugueses.",
                            description: "Portugal es conocido por su cocina basada en pescado fresco, con una amplia variedad de especies y formas de prepararlo. Desde el tradicional bacalao, hasta la sabrosa lubina, pasando por las suculentas sardinas, el pescado es un ingrediente esencial en la cocina portuguesa. Los platos de pescado son generalmente simples y saludables, cocinados con aceite de oliva, ajo, hierbas y verduras frescas.",
                            history: "La pesca es una actividad antigua en Portugal, con una larga tradición de captura y consumo de pescado fresco. La ubicación geográfica del país, cerca del Océano Atlántico, proporciona una gran diversidad de especies marinas, que se pescan a lo largo de la costa y en los ríos. El pescado fresco es uno de los pilares de la cocina portuguesa, consumido en todo el país, desde las aldeas pesqueras hasta los restaurantes de lujo. Los portugueses tienen una relación especial con el pescado, que se aprecia por su frescura, sabor y versatilidad.",
                            adress: "Zonas de la ciudad con muchas opciones para pescado\n - Bairro Alto \n- Baixa \n- Rua das Portas de Santo Antão"
                        ),
                        "fr": MiniaturaCardTranslation(
                            titulo: "Poisson 🐟 ",
                            shortDescription: "Le poisson frais de l'Atlantique est la base des plats typiques portugais.",
                            description: "Le Portugal est connu pour sa cuisine basée sur le poisson frais, avec une grande variété d'espèces et de façons de le préparer. Du traditionnel morue, à la savoureuse bar, en passant par les succulentes sardines, le poisson est un ingrédient essentiel de la cuisine portugaise. Les plats de poisson sont généralement simples et sains, cuisinés avec de l'huile d'olive, de l'ail, des herbes et des légumes frais.",
                            history: "La pêche est une activité ancienne au Portugal, avec une longue tradition de capture et de consommation de poisson frais. La situation géographique du pays, proche de l'océan Atlantique, offre une grande diversité d'espèces marines, qui sont pêchées le long de la côte et dans les rivières. Le poisson frais est l'un des piliers de la cuisine portugaise, consommé dans tout le pays, des villages de pêcheurs aux restaurants de luxe. Les Portugais ont une relation spéciale avec le poisson, qui est apprécié pour sa fraîcheur, sa saveur et sa polyvalence.",
                            adress: "Zones de la ville avec beaucoup d'options pour le poisson\n - Bairro Alto \n- Baixa \n- Rua das Portas de Santo Antão"
                        )
                    ],
                    locations: [
                        (name: ["en": "Portas de Santo Antão", "pt": "Portas de Santo Antão", "es": "Portas de Santo Antão", "fr": "Portas de Santo Antão"], latitude: 38.717779, longitude: -9.141762),
                        (name: ["en": "Baixa", "pt": "Baixa", "es": "Baixa", "fr": "Baixa"], latitude: 38.709554, longitude: -9.137325),
                        (name: ["en": "Bairro Alto", "pt": "Bairro Alto", "es": "Bairro Alto", "fr": "Bairro Alto"], latitude: 38.712380, longitude: -9.143391)
                    ],
                    zoomSpan: (latitudeDelta: 0.03, longitudeDelta: 0.03),
                    customCenter: (nil)
                ),
                MiniaturaCard(
                    id: 5,
                    imagem: "carne",
                    categoria: categoria,
                    ordem: 5,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Carne 🥩 🍗 ",
                            shortDescription: "A culinária portuguesa inclui uma variedade de deliciosos pratos de carne.", // L10n_slogan21
                            description: "A carne é um ingrediente essencial na culinária portuguesa, com uma grande variedade de pratos tradicionais e regionais. Desde o saboroso cozido à portuguesa, ao picante arroz de cabidela, ao suculento leitão assado, a carne é apreciada em todas as regiões do país. Os pratos de carne são geralmente acompanhados por batatas, arroz, vegetais e saladas, e temperados com ervas aromáticas e especiarias.",
                            history: "A carne é um ingrediente importante na culinária portuguesa, com uma longa tradição de consumo e preparação.A carne de porco é uma das carnes mais populares e é usada numa variedade de pratos típicos, como o leitão assado, a feijoada à transmontana e o cozido à portuguesa. A carne de vaca, o borrego e as aves também são populares. A carne é tipicamente marinada numa mistura de azeite, alho e especiarias e depois é grelhada, assada no forno, estufada ou frita e servida com batatas, arroz ou salada, acompanhada por um copo de vinho tinto.",
                            adress: "Zonas da cidade com muitas opções para carne\n - Bairro Alto \n- Baixa \n- Rua das Portas de Santo Antão"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Meat 🥩 🍗",
                            shortDescription: "Meat dishes like cozido and roast suckling pig are icons of national cuisine.",
                            description: "Meat is an essential ingredient in Portuguese cuisine, with a wide variety of traditional and regional dishes. From the tasty Portuguese stew, to the spicy arroz de cabidela, to the succulent roast suckling pig, meat is enjoyed in all regions of the country. Meat dishes are usually accompanied by potatoes, rice, vegetables and salads, and seasoned with aromatic herbs and spices.",
                            history: "Meat is an important ingredient in Portuguese cuisine, with a long tradition of consumption and preparation. Pork is one of the most popular meats, and is used in a variety of typical dishes, such as roast suckling pig, feijoada à transmontana and cozido à portuguesa. Beef, lamb and poultry are also popular. The meat is typically marinated in a mixture of olive oil, garlic, and spices then are grilled, baked in the oven, stewed or fried and served with potatoes, rice, or salad, accompanied by a glass of red wine.",
                            adress: "Areas of the city with many options for meat\n - Bairro Alto \n- Baixa \n- Rua das Portas de Santo Antão"
                        ),
                        "es": MiniaturaCardTranslation(
                            titulo: "Carne 🥩 🍗",
                            shortDescription: "Los platos de carne como el cozido y el lechón asado son iconos de la cocina nacional.",
                            description: "La carne es un ingrediente esencial en la cocina portuguesa, con una gran variedad de platos tradicionales y regionales. Desde el sabroso estofado portugués, hasta el picante arroz de cabidela, pasando por el suculento lechón asado, la carne se disfruta en todas las regiones del país. Los platos de carne suelen ir acompañados de patatas, arroz, verduras y ensaladas, y sazonados con hierbas aromáticas y especias.",
                            history: "La carne es un ingrediente importante en la cocina portuguesa, con una larga tradición de consumo y preparación. El cerdo es una de las carnes más populares, y se utiliza en una variedad de platos típicos, como el lechón asado, la feijoada à transmontana y el cozido à portuguesa. La carne de vaca, cordero y aves también son populares. La carne se marina típicamente en una mezcla de aceite de oliva, ajo y especias luego se grillan, hornean, guisan o fríen y se sirven con patatas, arroz o ensalada, acompañados por una copa de vino tinto.",
                            adress: "Zonas de la ciudad con muchas opciones para carne\n - Bairro Alto \n- Baixa \n- Rua das Portas de Santo Antão"
                        ),
                        "fr": MiniaturaCardTranslation(
                            titulo: "Viande 🥩 🍗",
                            shortDescription: "Les plats de viande comme le cozido et le cochon de lait rôti sont des icônes de la cuisine nationale.",
                            description: "La viande est un ingrédient essentiel de la cuisine portugaise, avec une grande variété de plats traditionnels et régionaux. Du savoureux ragoût portugais, à l'épicé arroz de cabidela, en passant par le succulent cochon de lait rôti, la viande est appréciée dans toutes les régions du pays. Les plats de viande sont généralement accompagnés de pommes de terre, de riz, de légumes et de salades, et assaisonnés avec des herbes aromatiques et des épices.",
                            history: "La viande est un ingrédient important de la cuisine portugaise, avec une longue tradition de consommation et de préparation. Le porc est l'une des viandes les plus populaires, et est utilisé dans une variété de plats typiques, tels que le cochon de lait rôti, la feijoada à transmontana et le cozido à portuguesa. Le bœuf, l'agneau et la volaille sont également populaires. La viande est généralement marinée dans un mélange d'huile d'olive, d'ail et d'épices puis grillée, cuite au four, mijotée ou frite et servie avec des pommes de terre, du riz ou de la salade, accompagnée d'un verre de vin rouge.",
                            adress: "Zones de la ville avec beaucoup d'options pour la viande\n - Bairro Alto \n- Baixa \n- Rua das Portas de Santo Antão"
                        )
                    ],
                    locations: [
                        (name: ["en": "Portas de Santo Antão", "pt": "Portas de Santo Antão", "es": "Portas de Santo Antão", "fr": "Portas de Santo Antão"], latitude: 38.717779, longitude: -9.141762),
                        (name: ["en": "Baixa", "pt": "Baixa", "es": "Baixa", "fr": "Baixa"], latitude: 38.709554, longitude: -9.137325),
                        (name: ["en": "Bairro Alto", "pt": "Bairro Alto", "es": "Bairro Alto", "fr": "Bairro Alto"], latitude: 38.712380, longitude: -9.143391)
                    ],
                    zoomSpan: (latitudeDelta: 0.03, longitudeDelta: 0.03),
                    customCenter: (nil)
                ),
                MiniaturaCard(
                    id: 6,
                    imagem: "sopa",
                    categoria: categoria,
                    ordem: 6,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Sopas 🍲 ",
                            shortDescription: "As sopas portuguesas são substanciais e saborosas.", // L10n_slogan22
                            description: "É um pilar da culinária portuguesa, com uma grande variedade de receitas e sabores. Algumas das sopas mais populares em Portugal incluem o caldo verde, uma sopa substanciosa feita com couve, batatas e chouriço; a sopa de peixe, uma rica sopa de peixe com vegetais e ervas; e a canja de galinha, uma reconfortante sopa de galinha com arroz. As sopas são essenciais às refeições portuguesas, apreciadas durante todo o ano.",
                            history: "As sopas fazem parte da culinária portuguesa há séculos, refletindo as tradições agrícolas e o património culinário do país. A tradição de fazer sopas com ingredientes locais, como vegetais, leguminosas e carnes, remonta a tempos antigos, quando as sopas eram um alimento básico para camponeses e nobreza. Em Portugal, as sopas são apreciadas durante todo o ano, com diferentes receitas para cada estação e ocasião. As sopas são frequentemente servidas como primeiro prato, acompanhadas de pão, azeitonas e queijo, e são consideradas um símbolo da hospitalidade e convivialidade portuguesas.",
                            adress: "Zonas da cidade com muitas opções pra sopa\n - Bairro Alto \n- Baixa \n- Rua das Portas de Santo Antão"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Soups 🍲 ",
                            shortDescription: "Soups like 'caldo verde' warm and nourish in any season.",
                            description: "It's a staple of Portuguese cuisine, with a wide variety of recipes and flavors. Some of the most popular soups in Portugal include caldo verde, a hearty soup made with kale, potatoes, and chorizo; sopa de peixe, a rich fish soup with vegetables and herbs; and canja de galinha, a comforting chicken soup with rice. Soups are an essential part of Portuguese meals, enjoyed year-round.",
                            history: "Soups have been a part of Portuguese cuisine for centuries, reflecting the country's agricultural traditions and culinary heritage. The tradition of making soups with local ingredients, such as vegetables, legumes, and meats, dates back to ancient times when soups were a staple food for peasants and nobility alike. In Portugal, soups are enjoyed year-round, with different recipes for each season and occasion. Soups are often served as a first course, accompanied by bread, olives, and cheese, and are considered a symbol of Portuguese hospitality and conviviality.",
                            adress: "Areas of the city with many options for soup: \n- Bairro Alto \n- Baixa \n- Rua das Portas de Santo Antão"
                        ),
                        "es": MiniaturaCardTranslation(
                            titulo: "Sopas 🍲 ",
                            shortDescription: "Las sopas como el 'caldo verde' calientan y nutren en cualquier estación.",
                            description: "Es un pilar de la cocina portuguesa, con una gran variedad de recetas y sabores. Algunas de las sopas más populares en Portugal incluyen el caldo verde, una sopa sustanciosa hecha con col rizada, papas y chorizo; la sopa de pescado, una rica sopa de pescado con verduras y hierbas; y la canja de galinha, una reconfortante sopa de pollo con arroz. Las sopas son esenciales en las comidas portuguesas, disfrutadas durante todo el año.",
                            history: "Las sopas han sido parte de la cocina portuguesa durante siglos, reflejando las tradiciones agrícolas y el patrimonio culinario del país. La tradición de hacer sopas con ingredientes locales, como verduras, legumbres y carnes, se remonta a tiempos antiguos cuando las sopas eran un alimento básico para campesinos y nobleza por igual. En Portugal, las sopas se disfrutan durante todo el año, con diferentes recetas para cada estación y ocasión. Las sopas a menudo se sirven como primer plato, acompañadas de pan, aceitunas y queso, y se consideran un símbolo de la hospitalidad y convivialidad portuguesas.",
                            adress: "Zonas de la ciudad con muchas opciones para sopa\n - Bairro Alto \n- Baixa \n- Rua das Portas de Santo Antão"
                        ),
                        "fr": MiniaturaCardTranslation(
                            titulo: "Soupes 🍲 ",
                            shortDescription: "Des soupes comme le 'caldo verde' réchauffent et nourrissent en toute saison.",
                            description: "C'est un pilier de la cuisine portugaise, avec une grande variété de recettes et de saveurs. Certaines des soupes les plus populaires au Portugal incluent le caldo verde, une soupe copieuse faite de chou frisé, de pommes de terre et de chorizo; la sopa de peixe, une riche soupe de poisson avec des légumes et des herbes; et la canja de galinha, une soupe réconfortante au poulet avec du riz. Les soupes sont une partie essentielle des repas portugais, appréciées toute l'année.",
                            history: "Les soupes font partie de la cuisine portugaise depuis des siècles, reflétant les traditions agricoles et le patrimoine culinaire du pays. La tradition de faire des soupes avec des ingrédients locaux, tels que des légumes, des légumineuses et des viandes, remonte à l'Antiquité lorsque les soupes étaient un aliment de base pour les paysans et la noblesse. Au Portugal, les soupes sont appréciées toute l'année, avec différentes recettes pour chaque saison et occasion. Les soupes sont souvent servies en entrée, accompagnées de pain, d'olives et de fromage, et sont considérées comme un symbole de l'hospitalité et de la convivialité portugaises.",
                            adress: "Zones de la ville avec beaucoup d'options pour la soupe\n- Bairro Alto \n- Baixa \n- Rua das Portas de Santo Antão"
                        )
                    ],
                    locations: [
                        (name: ["en": "Portas de Santo Antão", "pt": "Portas de Santo Antão", "es": "Portas de Santo Antão", "fr": "Portas de Santo Antão"], latitude: 38.717779, longitude: -9.141762),
                        (name: ["en": "Baixa", "pt": "Baixa", "es": "Baixa", "fr": "Baixa"], latitude: 38.709554, longitude: -9.137325),
                        (name: ["en": "Bairro Alto", "pt": "Bairro Alto", "es": "Bairro Alto", "fr": "Bairro Alto"], latitude: 38.712380, longitude: -9.143391)
                    ],
                    zoomSpan: (latitudeDelta: 0.03, longitudeDelta: 0.03),
                    customCenter: (nil)
                ),
                MiniaturaCard(
                    id: 7,
                    imagem: "vinho",
                    categoria: categoria,
                    ordem: 7,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Vinho 🍷 ",
                            shortDescription: "Portugal é conhecido pelos seus excelentes vinhos.", // L10n_slogan23
                            description: "Portugal é conhecido pela sua rica cultura vinícola, com uma longa história de produção de vinho e uma diversidade de variedades de uvas. Alguns dos vinhos portugueses mais famosos incluem o Vinho do Porto, um vinho fortificado do Vale do Douro; o Vinho Verde, um vinho leve e refrescante da região do Minho; e o Madeira, um vinho doce e complexo das Ilhas da Madeira. Os vinhos portugueses são apreciados em todo o mundo pela sua qualidade, variedade e sabores únicos.",
                            history: "Portugal tem uma longa e rica história de produção de vinho, que remonta aos tempos antigos, quando os romanos introduziram a viticultura na Península Ibérica. O clima, o solo e as variedades de uvas diversificadas do país contribuíram para o desenvolvimento de uma ampla gama de vinhos, cada um com suas características e sabores únicos. Os vinhos portugueses são conhecidos pela sua qualidade, autenticidade, e tradição, com muitas regiões produzindo vinhos distintos que refletem o terroir e a cultura da área. O Vale do Douro, o Vinho Verde e o Alentejo são algumas das regiões vinícolas mais famosas de Portugal, cada uma oferecendo uma experiência vinícola diferente.",
                            adress: "Zonas da cidade com muitas opções para provas de vinho\n - Bairro Alto \n- Baixa \n- Rua das Portas de Santo Antão"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Wine 🍷 ",
                            shortDescription: "Portugal is renowned for its excellent wines.",
                            description: "Portugal is known for its rich wine culture, with a long history of winemaking and a diverse range of grape varieties. Some of the most famous Portuguese wines include Port, a fortified wine from the Douro Valley; Vinho Verde, a light and refreshing wine from the Minho region; and Madeira, a sweet and complex wine from the Madeira Islands. Portuguese wines are enjoyed worldwide for their quality, variety, and unique flavors.",
                            history: "Portugal has a long and storied history of winemaking, dating back to ancient times when the Romans introduced viticulture to the Iberian Peninsula. The country's diverse climate, soil, and grape varieties have contributed to the development of a wide range of wines, each with its unique characteristics and flavors. Portuguese wines are known for their quality, authenticity, and tradition, with many regions producing distinctive wines that reflect the terroir and culture of the area. The Douro Valley, Vinho Verde, and Alentejo are some of the most famous wine regions in Portugal, each offering a different wine experience.",
                            adress: "Areas of the city with many options for wine tasting:\n- Bairro Alto \n- Baixa \n- Rua das Portas de Santo Antão"
                        ),
                        "es": MiniaturaCardTranslation(
                            titulo: "Vino 🍷 ",
                            shortDescription: "Portugal es conocido por sus excelentes vinos.",
                            description: "Portugal es conocido por su rica cultura vinícola, con una larga historia de producción de vino y una diversidad de variedades de uvas. Algunos de los vinos portugueses más famosos incluyen el Vinho do Porto, un vino fortificado del Valle del Duero; el Vinho Verde, un vino ligero y refrescante de la región de Minho; y el Madeira, un vino dulce y complejo de las Islas Madeira. Los vinos portugueses son apreciados en todo el mundo por su calidad, variedad y sabores únicos.",
                            history: "Portugal tiene una larga y rica historia de producción de vino, que se remonta a los tiempos antiguos, cuando los romanos introdujeron la viticultura en la Península Ibérica. El clima, el suelo y las variedades de uvas diversificadas del país contribuyeron al desarrollo de una amplia gama de vinos, cada uno con sus características y sabores únicos. Los vinos portugueses son conocidos por su calidad, autenticidad y tradición, con muchas regiones produciendo vinos distintivos que reflejan el terroir y la cultura del área. El Valle del Duero, Vinho Verde y Alentejo son algunas de las regiones vinícolas más famosas de Portugal, cada una ofreciendo una experiencia vinícola diferente.",
                            adress: "Zonas de la ciudad con muchas opciones para pruebas de vino\n- Bairro Alto \n- Baixa \n- Rua das Portas de Santo Antão"
                        ),
                        "fr": MiniaturaCardTranslation(
                            titulo: "Vin 🍷 ",
                            shortDescription: "Le Portugal est réputé pour ses excellents vins.",
                            description: "Le Portugal est connu pour sa riche culture viticole, avec une longue histoire de production de vin et une gamme diversifiée de cépages. Certains des vins portugais les plus célèbres incluent le Vinho do Porto, un vin fortifié de la vallée du Douro; le Vinho Verde, un vin léger et rafraîchissant de la région du Minho; et le Madeira, un vin doux et complexe des îles de Madère. Les vins portugais sont appréciés dans le monde entier pour leur qualité, leur variété et leurs saveurs uniques.",
                            history: "Le Portugal a une longue et riche histoire de production de vin, remontant à l'Antiquité lorsque les Romains ont introduit la viticulture dans la péninsule ibérique. Le climat diversifié du pays, le sol et les cépages ont contribué au développement d'une large gamme de vins, chacun avec ses caractéristiques et ses saveurs uniques. Les vins portugais sont connus pour leur qualité, leur authenticité et leur tradition, avec de nombreuses régions produisant des vins distinctifs qui reflètent le terroir et la culture de la région. La vallée du Douro, Vinho Verde et Alentejo sont quelques-unes des régions viticoles les plus célèbres du Portugal, chacune offrant une expérience viticole différente.",
                            adress: "Zones de la ville avec beaucoup d'options pour les dégustations de vin\n - Bairro Alto \n- Baixa \n- Rua das Portas de Santo Antão"
                            )
                    ],
                    locations: [
                        (name: ["en": "Portas de Santo Antão", "pt": "Portas de Santo Antão", "es": "Portas de Santo Antão", "fr": "Portas de Santo Antão"], latitude: 38.717779, longitude: -9.141762),
                        (name: ["en": "Baixa", "pt": "Baixa", "es": "Baixa", "fr": "Baixa"], latitude: 38.709554, longitude: -9.137325),
                        (name: ["en": "Bairro Alto", "pt": "Bairro Alto", "es": "Bairro Alto", "fr": "Bairro Alto"], latitude: 38.712380, longitude: -9.143391)
                    ],
                    zoomSpan: (latitudeDelta: 0.03, longitudeDelta: 0.03),
                    customCenter: (nil)
                ),
                MiniaturaCard(
                    id: 8,
                    imagem: "plus_gastronomia",
                    categoria: categoria,
                    ordem: 8,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Mais Gastronomia ➕ ",
                            shortDescription: "Explore mais da deliciosa culinária de Portugal em Lisboa.", // L10n_slogan24
                            description: "Além das 7 maravilhas gastronômicas mencionadas, reservamos um espaço especial para 3 confeitos de pastelaria que, embora não sejam da cidade de Lisboa, vêm de locais muito próximos à cidade. - Travesseiros de Sintra (na foto): feitos com massa folhada, gemas de ovo, amêndoas e açúcar e são universalmente reconhecidos como uma das maiores iguarias de Sintra. - Queijadas de Sintra: farinha, queijo fresco, açúcar, gema de ovo e canela para o recheio são os ingredientes das crocantes e crocantes queijadas de Sintra, que adoçam o paladar e a alma. - Tortas de Azeitão: é um doce tradicional de Azeitão, região do município de Setúbal e é um dos ícones representativos desta região. Com um leve sabor a limão e canela, são um exemplo da pastelaria tradicional portuguesa. A torta de Azeitão é feita com ovos moles, gema de ovo, açúcar e água.",
                            history: nil,
                            destaques: nil,
                            adress: "Estes doces podem ser encontrados em alguns lugares de Lisboa mas os originais estão em:\n\n- Travesseiros de Sintra: Piriquita, R. das Padarias 1/7, Sintra \n- Queijadas de Sintra: Volta do Duche 12, Sintra \n- Tortas de Azeitão: Casa das Tortas, R. José Augusto Coelho 11, Azeitão"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "More Gastronomy ➕ ",
                            shortDescription: "Explore more of Portugal's delicious cuisine in Lisbon.",
                            description: "In addition to the 7 gastronomic wonders mentioned, we have reserved a special space for 3 bakers' confections that, although they are not from the city of Lisbon, come from places very close to the city.\n\n- Travesseiros de Sintra (in the picture): made with puff pastry, egg yolks, almonds and sugar and are universally recognized as one of the greatest delicacies of Sintra.\n\n - Queijadas de Sintra: flour, fresh cheese, sugar, egg yolk and cinnamon for the filling are the ingredients of the crispy and crunchy queijadas de Sintra, which sweeten the palate and the soul.\n\n - Tortas de Azeitão: it is a traditional confections from Azeitão, a region of the municipality of Setúbal and is one of the representative icons of this region. With a light lemon and cinnamon flavor, they are an example of traditional Portuguese Confectionery. The Azeitão pie is made with soft eggs, egg yolk, sugar and water.",
                            history: nil,
                            destaques: nil,
                            adress: "These confections can be found in some places in Lisbon. The following addresses are of houses that produce some of the most famous recipes:\n\n - Travesseiros de Sintra: Piriquita, R. das Padarias 1-7, Sintra \n\n- Queijadas de Sintra: Volta do Duche 12, Sintra \n\n- Tortas de Azeitão: Casa das Tortas, R. José Augusto Coelho 11, Azeitão"
                        ),
                        "es": MiniaturaCardTranslation(
                            titulo: "Más Gastronomía ➕ ",
                            shortDescription: "Explore más de la deliciosa cocina de Portugal en Lisboa.",
                            description: "Además de las 7 maravillas gastronómicas mencionadas, hemos reservado un espacio especial para 3 confecciones de pastelería que, aunque no son de la ciudad de Lisboa, provienen de lugares muy cercanos a la ciudad.\n\n- Travesseiros de Sintra (en la foto): hechos con masa de hojaldre, yemas de huevo, almendras y azúcar y son universalmente reconocidos como una de las mayores delicias de Sintra.\n\n - Queijadas de Sintra: harina, queso fresco, azúcar, yema de huevo y canela para el relleno son los ingredientes de las crujientes y crujientes queijadas de Sintra, que endulzan el paladar y el alma.\n\n - Tortas de Azeitão: es un dulce tradicional de Azeitão, una región del municipio de Setúbal y es uno de los íconos representativos de esta región. Con un ligero sabor a limón y canela, son un ejemplo de la pastelería tradicional portuguesa. La torta de Azeitão se hace con huevos suaves, yema de huevo, azúcar y agua.",
                            history: nil,
                            destaques: nil,
                            adress: "Estos dulces se pueden encontrar en algunos lugares de Lisboa. Las siguientes direcciones son de casas que producen algunas de las recetas más famosas:\n\n - Travesseiros de Sintra: Piriquita, R. das Padarias 1-7, Sintra \n\n- Queijadas de Sintra: Volta do Duche 12, Sintra \n\n- Tortas de Azeitão: Casa das Tortas, R. José Augusto Coelho 11, Azeitão"
                        ),
                        "fr": MiniaturaCardTranslation(
                            titulo: "Plus de Gastronomie ➕ ",
                            shortDescription: "Explorez plus de la délicieuse cuisine portugaise à Lisbonne.",
                            description: "En plus des 7 merveilles gastronomiques mentionnées, nous avons réservé un espace spécial pour 3 confiseries de pâtisserie qui, bien qu'elles ne soient pas de la ville de Lisbonne, viennent de lieux très proches de la ville.\n\n- Travesseiros de Sintra (sur la photo): faits avec de la pâte feuilletée, des jaunes d'œufs, des amandes et du sucre et sont universellement reconnus comme l'une des plus grandes délicatesses de Sintra.\n\n - Queijadas de Sintra: farine, fromage frais, sucre, jaune d'œuf et cannelle pour la garniture sont les ingrédients des queijadas de Sintra croustillantes et croquantes, qui adoucissent le palais et l'âme.\n\n - Tortas de Azeitão: c'est une confiserie traditionnelle d'Azeitão, une région de la municipalité de Setúbal et est l'une des icônes représentatives de cette région. Avec une légère saveur de citron et de cannelle, ils sont un exemple de confiserie portugaise traditionnelle. La tarte d'Azeitão est faite avec des œufs mous, du jaune d'œuf, du sucre et de l'eau.",
                            history: nil,
                            destaques: nil,
                            adress: "Ces confiseries peuvent être trouvées dans certains endroits à Lisbonne. Les adresses suivantes sont celles des maisons qui produisent certaines des recettes les plus célèbres:\n\n - Travesseiros de Sintra: Piriquita, R. das Padarias 1-7, Sintra \n\n- Queijadas de Sintra: Volta do Duche 12, Sintra \n\n- Tortas de Azeitão: Casa das Tortas, R. José Augusto Coelho 11, Azeitão"
                        )
                    ],
                    locations: [
                        (name: ["en": "Piriquita (Travesseiros)", "pt": "Piriquita (Travesseiros)", "fr": "Piriquita (Travesseiros)", "es": "Piriquita (Travesseiros)"], latitude: 38.7971, longitude: -9.3907),
                        (name: ["en": "Queijadas de Sintra", "pt": "Queijadas de Sintra", "fr": "Queijadas de Sintra", "es": "Queijadas de Sintra"], latitude: 38.750397, longitude: -9.257947),
                        (name: ["en": "Tortas de Azeitão", "pt": "Tortas de Azeitão", "fr": "Tortas de Azeitão", "es": "Tortas de Azeitão"], latitude: 38.936972, longitude: -9.326943)
                    ],
                    zoomSpan: (latitudeDelta: 1, longitudeDelta: 1),
                    customCenter: (38.676952, -9.121034)
                    ),
            ]
        }
        if cat == "popular" {
            return [
                MiniaturaCard(
                    id: 1,
                    imagem: "azulejos",
                    categoria: categoria,
                    ordem: 1,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Azulejos 🟦 ",
                            shortDescription: "A arte colorida que cobre fachadas e conta histórias em Lisboa.",
                            description: "São azulejos tradicionais portugueses, conhecidos pelos seus padrões intrincados, cores vibrantes e significado histórico. Os azulejos são usados para decorar edifícios, paredes e pisos, criando impressionantes obras de arte que refletem a herança cultural e as tradições artísticas do país. Os azulejos são um símbolo do artesanato e da criatividade de Portugal.",
                            history: "A tradição dos azulejos remonta ao século XV, quando os mouros introduziram a arte dos azulejos cerâmicos vidrados em Portugal. A palavra \"azulejo\" vem da palavra árabe \"al zuleycha\", que significa \"pedra polida\". Ao longo dos séculos, os azulejos tornaram-se parte integrante da arquitetura portuguesa, sendo usados para decorar palácios, igrejas e edifícios públicos. Os azulejos são conhecidos pelos seus padrões geométricos, motivos florais e cenas históricas, refletindo a herança cultural e artística do país. Hoje em dia, os azulejos são um símbolo da identidade portuguesa e uma lembrança popular para os visitantes de Portugal.",
                            adress: "Em quase todas as ruas e bairros da cidade como, por exemplo:\n- Bairro Alto\n- Alfama\n- Baixa\n- Chiado\n- Museu do Azulejo."
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Azulejos 🟦 ",
                            shortDescription: "The colorful art that covers facades and tells stories in Lisbon.",
                            description: "They are traditional Portuguese ceramic tiles, known for their intricate patterns, vibrant colors, and historical significance. Azulejos are used to decorate buildings, walls, and floors, creating stunning works of art that reflect the country's cultural heritage and artistic traditions. The tiles are a symbol of Portugal's craftsmanship and creativity.",
                            history: "The tradition of azulejos dates back to the 15th century when the Moors introduced the art of glazed ceramic tiles to Portugal. The word \"azulejo \" comes from the Arabic word  \"al zuleycha, \" meaning  \"polished stone. \" Over the centuries, azulejos became an integral part of Portuguese architecture, used to decorate palaces, churches, and public buildings. The tiles are known for their geometric patterns, floral motifs, and historical scenes, reflecting the country's cultural and artistic heritage. Today, azulejos are a symbol of Portuguese identity and a popular souvenir for visitors to Portugal.",
                            adress: "In almost every street and neighborhood in the city such as, for example:\n- Bairro Alto\n- Alfama\n- Baixa\n- Chiado\n- Tiles Museum."
                        ),
                        "es": MiniaturaCardTranslation(
                            titulo: "Azulejos 🟦 ",
                            shortDescription: "El arte colorido que cubre fachadas y cuenta historias en Lisboa.",
                            description: "Son azulejos tradicionales portugueses, conocidos por sus intrincados patrones, colores vibrantes y significado histórico. Los azulejos se utilizan para decorar edificios, paredes y pisos, creando impresionantes obras de arte que reflejan la herencia cultural y las tradiciones artísticas del país. Los azulejos son un símbolo de la artesanía y la creatividad de Portugal.",
                            history: "La tradición de los azulejos se remonta al siglo XV, cuando los moros introdujeron el arte de los azulejos cerámicos vidriados en Portugal. La palabra \"azulejo\" proviene de la palabra árabe \"al zuleycha\", que significa \"piedra pulida\". A lo largo de los siglos, los azulejos se convirtieron en una parte integral de la arquitectura portuguesa, siendo utilizados para decorar palacios, iglesias y edificios públicos. Los azulejos son conocidos por sus patrones geométricos, motivos florales y escenas históricas, reflejando la herencia cultural y artística del país. Hoy en día, los azulejos son un símbolo de la identidad portuguesa y un recuerdo popular para los visitantes de Portugal.",
                            adress: "En casi todas las calles y barrios de la ciudad como, por ejemplo:\n- Bairro Alto\n- Alfama\n- Baixa\n- Chiado\n- Museo del Azulejo."
                        ),
                        "fr": MiniaturaCardTranslation(
                            titulo: "Azulejos 🟦 ",
                            shortDescription: "L'art coloré qui couvre les façades et raconte des histoires à Lisbonne.",
                            description: "Ce sont des carreaux de céramique traditionnels portugais, connus pour leurs motifs complexes, leurs couleurs vibrantes et leur signification historique. Les azulejos sont utilisés pour décorer les bâtiments, les murs et les sols, créant des œuvres d'art étonnantes qui reflètent le patrimoine culturel et les traditions artistiques du pays. Les azulejos sont un symbole de l'artisanat et de la créativité du Portugal.",
                            history: "La tradition des azulejos remonte au XVe siècle, lorsque les Maures ont introduit l'art des carreaux de céramique émaillés au Portugal. Le mot \"azulejo\" vient du mot arabe \"al zuleycha\", qui signifie \"pierre polie\". Au fil des siècles, les azulejos sont devenus une partie intégrante de l'architecture portugaise, utilisés pour décorer les palais, les églises et les bâtiments publics. Les azulejos sont connus pour leurs motifs géométriques, leurs motifs floraux et leurs scènes historiques, reflétant le patrimoine culturel et artistique du pays. Aujourd'hui, les azulejos sont un symbole de l'identité portugaise et un souvenir populaire pour les visiteurs du Portugal.",
                            adress: "Dans presque toutes les rues et quartiers de la ville tels que, par exemple:\n- Bairro Alto\n- Alfama\n- Baixa\n- Chiado\n- Musée de l'Azulejo."
                        )
                    ],
                    locations: [
                        (name: ["en": "Alfama", "pt": "Alfama", "fr": "Alfama", "es": "Alfama"], latitude: 38.712566, longitude: -9.127686),
                        (name: ["en": "Baixa", "pt": "Baixa", "fr": "Baixa", "es": "Baixa"], latitude: 38.709554, longitude: -9.137325),
                        (name: ["en": "Bairro Alto", "pt": "Bairro Alto", "fr": "Bairro Alto", "es": "Bairro Alto"], latitude: 38.712380, longitude: -9.143391),
                        (name: ["en": "Chiado", "pt": "Chiado", "fr": "Chiado", "es": "Chiado"], latitude: 38.710668, longitude: -9.141654),
                        (name: ["en": "Museu do Azulejo", "pt": "Museu do Azulejo", "fr": "Musée d'Azulejo", "es": "Museo del Azulejo"], latitude: 38.724933, longitude: -9.113530)
                    ],
                    zoomSpan: (latitudeDelta: 0.06, longitudeDelta: 0.06),
                    customCenter: (nil)
                ),
                MiniaturaCard(
                    id: 2,
                    imagem: "fado",
                    categoria: categoria,
                    ordem: 2,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Fado 🎵 ",
                            shortDescription: "O Fado é um gênero musical tradicional português conhecido por suas melodias melancólicas e sentimentais.",
                            description: "É um gênero musical português caracterizado por letras melancólicas e melodias sentimentais, geralmente acompanhadas por guitarra portuguesa e viola. O fadista, o intérprete, é o protagonista, expressando emoções como saudade, amor e desilusão. O fado é um patrimônio cultural imaterial da humanidade, reconhecido pela UNESCO.",
                            history: "As origens exatas do fado são desconhecidas, mas acredita-se que tenha surgido nos bairros populares de Lisboa no final do século XIX. Suas raízes estão na música popular urbana, influenciada por várias culturas, como a árabe, africana e brasileira. O fado era cantado em tabernas e casas de fado por pessoas comuns, expressando seus sentimentos e experiências através da música. Ao longo dos anos, o fado evoluiu e tornou-se um símbolo da identidade nacional portuguesa, apreciado em todo o mundo.",
                            adress: "As casas de fado estão concentradas nos bairros de Alfama e Bairro Alto."
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Fado 🎵 ",
                            shortDescription: "The nostalgic music that echoes through the city’s alleys.",
                            description: "It's a Portuguese musical genre characterized by melancholic lyrics and sentimental melodies, typically accompanied by Portuguese guitar and viola. The fadista, the performer, is the protagonist, expressing emotions such as longing, love, and disillusionment. Fado is an intangible cultural heritage of humanity, recognized by UNESCO.",
                            history: "The exact origins of fado are unknown, but it is believed to have emerged in the popular neighborhoods of Lisbon in the late 19th century. Its roots lie in urban popular music, influenced by various cultures such as Arab, African, and Brazilian. Fado was sung in taverns and fado houses by ordinary people, expressing their feelings and experiences through music. Over the years, fado evolved and became a symbol of Portuguese national identity, appreciated worldwide.",
                            adress: "Fado houses are concentrated in the Alfama and Bairro Alto neighborhoods."
                        ),
                        "es": MiniaturaCardTranslation(
                            titulo: "Fado 🎵 ",
                            shortDescription: "La música nostálgica que resuena en los callejones de la ciudad.",
                            description: "Es un género musical portugués caracterizado por letras melancólicas y melodías sentimentales, típicamente acompañado por guitarra portuguesa y viola. El fadista, el intérprete, es el protagonista, expresando emociones como anhelo, amor y desilusión. El fado es un patrimonio cultural inmaterial de la humanidad, reconocido por la UNESCO.",
                            history: "Los orígenes exactos del fado son desconocidos, pero se cree que surgió en los barrios populares de Lisboa a finales del siglo XIX. Sus raíces se encuentran en la música popular urbana, influenciada por diversas culturas como la árabe, africana y brasileña. El fado se cantaba en tabernas y casas de fado por personas comunes, expresando sus sentimientos y experiencias a través de la música. Con el paso de los años, el fado evolucionó y se convirtió en un símbolo de la identidad nacional portuguesa, apreciado en todo el mundo.",
                            adress: "Las casas de fado están concentradas en los barrios de Alfama y Bairro Alto."
                        ),
                        "fr": MiniaturaCardTranslation(
                            titulo: "Fado 🎵 ",
                            shortDescription: "La musique nostalgique qui résonne dans les ruelles de la ville.",
                            description: "C'est un genre musical portugais caractérisé par des paroles mélancoliques et des mélodies sentimentales, généralement accompagné de guitare portugaise et de viola. Le fadista, le performeur, est le protagoniste, exprimant des émotions telles que le désir, l'amour et la désillusion. Le fado est un patrimoine culturel immatériel de l'humanité, reconnu par l'UNESCO.",
                            history: "Les origines exactes du fado sont inconnues, mais on pense qu'il a émergé dans les quartiers populaires de Lisbonne à la fin du XIXe siècle. Ses racines se trouvent dans la musique populaire urbaine, influencée par diverses cultures telles que l'arabe, l'africaine et la brésilienne. Le fado était chanté dans les tavernes et les maisons de fado par des gens ordinaires, exprimant leurs sentiments et leurs expériences à travers la musique. Au fil des ans, le fado a évolué et est devenu un symbole de l'identité nationale portugaise, apprécié dans le monde entier.",
                            adress: "Les maisons de fado sont concentrées dans les quartiers d'Alfama et de Bairro Alto."
                        )
                    ],
                    locations: [
                        (name: ["en": "Alfama", "pt": "Alfama", "es": "Barrio Alto", "fr": "Alfama"], latitude: 38.712566, longitude: -9.127686),
                        (name: ["en": "Bairro Alto", "pt": "Bairro Alto", "es": "Barrio Alto", "fr": "Bairro Alto"], latitude: 38.712380, longitude: -9.143391)
                    ],
                    zoomSpan: (latitudeDelta: 0.04, longitudeDelta: 0.04),
                    customCenter: (38.711894, -9.137578)
                ),
                MiniaturaCard(
                    id: 3,
                    imagem: "tram28",
                    categoria: categoria,
                    ordem: 3,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Eléctrico 28 🚋 ",
                            shortDescription: "Uma atração imperdível por seu percurso pelos bairros históricos mais bonitos da cidade.",
                            description: "É uma linha de bonde histórico que percorre as estreitas ruas de Lisboa, ligando a Praça Martim Moniz ao bairro do Campo de Ourique. O Eléctrico 28 passa por alguns dos bairros e marcos mais icônicos da cidade, como Alfama, Baixa e Estrela, oferecendo aos passageiros um passeio panorâmico pelo centro histórico de Lisboa.",
                            history: "O Eléctrico 28 está em operação desde 1914, servindo como um importante meio de transporte para residentes e visitantes de Lisboa.O Eléctrico 28 segue um percurso panorâmico pelos bairros históricos de Lisboa, passando por marcos icônicos como a Sé Catedral, o Castelo de São Jorge e a Basílica da Estrela. Os carros de madeira vintage do bonde e os trilhos rangentes evocam uma sensação de nostalgia e charme, tornando-o uma experiência imperdível para os visitantes de Lisboa.",
                            adress: nil
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Tram 28 🚋 ",
                            shortDescription: "Lisbon’s most famous tram, crossing historic neighborhoods.",
                            description: "It's a historic tram line that runs through the narrow streets of Lisbon, connecting the Martim Moniz Square with the Campo Ourique neighborhood. Tram 28 passes through some of the city's most iconic neighborhoods and landmarks, such as Alfama, Baixa, and Estrela, offering passengers a scenic tour of Lisbon's historic center.",
                            history: "Tram 28 has been in operation since 1914, serving as a vital transportation link for Lisbon residents and visitors.Tram 28 follows a scenic route through the historic neighborhoods of Lisbon, passing by iconic landmarks such as the Sé Cathedral, the São Jorge Castle, and the Estrela Basilica. The tram's vintage wooden cars and rattling tracks evoke a sense of nostalgia and charm, making it a must-do experience for visitors to Lisbon.",
                            adress: nil
                        ),
                        "es": MiniaturaCardTranslation(
                            titulo: "Tranvía 28 🚋 ",
                            shortDescription: "El tranvía más famoso de Lisboa, cruzando barrios históricos.",
                            description: "Es una línea de tranvía histórico que recorre las estrechas calles de Lisboa, conectando la Plaza Martim Moniz con el barrio de Campo de Ourique. El Tranvía 28 pasa por algunos de los barrios y monumentos más icónicos de la ciudad, como Alfama, Baixa y Estrela, ofreciendo a los pasajeros un recorrido panorámico por el centro histórico de Lisboa.",
                            history: "El Tranvía 28 ha estado en operación desde 1914, sirviendo como un enlace vital de transporte para los residentes y visitantes de Lisboa. El Tranvía 28 sigue una ruta panorámica por los barrios históricos de Lisboa, pasando por monumentos icónicos como la Catedral Sé, el Castillo de São Jorge y la Basílica da Estrela. Los vagones de madera vintage del tranvía y las vías traqueteantes evocan una sensación de nostalgia y encanto, convirtiéndolo en una experiencia imprescindible para los visitantes de Lisboa.",
                            adress: nil
                        ),
                        "fr": MiniaturaCardTranslation(
                            titulo: "Tram 28 🚋 ",
                            shortDescription: "Le tramway le plus célèbre de Lisbonne, traversant les quartiers historiques.",
                            description: "C'est une ligne de tramway historique qui traverse les rues étroites de Lisbonne, reliant la place Martim Moniz au quartier de Campo de Ourique. Le Tram 28 passe par certains des quartiers et monuments les plus emblématiques de la ville, tels que Alfama, Baixa et Estrela, offrant aux passagers une visite panoramique du centre historique de Lisbonne.",
                            history: "Le Tram 28 est en service depuis 1914, servant de lien de transport vital pour les résidents et les visiteurs de Lisbonne. Le Tram 28 suit un itinéraire pittoresque à travers les quartiers historiques de Lisbonne, passant par des monuments emblématiques tels que la cathédrale Sé, le château de São Jorge et la basilique Estrela. Les voitures en bois vintage du tramway et les rails grinçants évoquent un sentiment de nostalgie et de charme, en faisant une expérience incontournable pour les visiteurs de Lisbonne.",
                            adress: nil
                        )
                    ],
                    locations: [
                        (name: ["en": "Prazeres", "pt": "Prazeres", "es":"Prazeres", "fr": "Prazeres"], latitude: 38.713223, longitude: -9.169070),
                        (name: ["en": "Estrela", "pt": "Estrela"], latitude: 38.713576, longitude: -9.159786),
                        (name: ["en": "Sao Bento", "pt": "Sao Bento", "es":"São Bento", "fr": "São Bento"], latitude: 38.709898, longitude: -9.151561),
                        (name: ["en": "Camões", "pt": "Camões", "es":"Camões", "fr": "Camões"], latitude: 38.710445, longitude: -9.143795),
                        (name: ["en": "Baixa", "pt": "Baixa", "es":"Baixa", "fr": "Baixa"], latitude: 38.709630, longitude: -9.137041),
                        (name: ["en": "Portas do Sol", "pt": "Portas do Sol", "es":"Portas do Sol", "fr": "Portas do Sol"], latitude: 38.711874, longitude: -9.130478),
                        (name: ["en": "Igreja Sao Vicente", "pt": "Igreja Sao Vicente", "es":"Iglesia de São Vicente", "fr": "Église de São Vicente"], latitude: 38.714634, longitude: -9.128605),
                        (name: ["en": "Graça", "pt": "Graça", "es":"Graça", "fr": "Graça"], latitude: 38.719335, longitude: -9.129800),
                        (name: ["en": "Anjos", "pt": "Anjos", "es":"Anjos", "fr": "Anjos"], latitude: 38.723647, longitude: -9.131794),
                        (name: ["en": "Av. da República", "pt": "Av. da República", "es":"Av. da República", "fr": "Av. da República"], latitude: 38.720326, longitude: -9.135708),
                        (name: ["en": "Martim Moniz", "pt": "Martim Moniz", "es":"Martim Moniz", "fr": "Martim Moniz"], latitude: 38.715025, longitude: -9.136684)
                    ],
                    zoomSpan: (latitudeDelta: 0.07, longitudeDelta: 0.07),
                    customCenter: (38.715079, -9.153965)
                ),
                
                MiniaturaCard(
                    id: 4,
                    imagem: "tascas",
                    categoria: categoria,
                    ordem: 4,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Tascas 🍷 ",
                            shortDescription: "As tascas são tabernas tradicionais portuguesas conhecidas pelo seu ambiente acolhedor e comida deliciosa.",
                            description: "São tabernas ou restaurantes típicos portugueses, conhecidos pelo seu ambiente casual, comida caseira e preços acessíveis. As tascas servem uma variedade de pratos, como petiscos, pequenas porções de aperitivos; bifanas, sanduíches de porco; e \"caldo verde\", sopa de couve. As tascas são uma opção popular de refeição para locais e visitantes que procuram experimentar a autêntica cozinha portuguesa.",
                            history: "As tascas são uma tradição antiga em Portugal, remontando ao século XIX, quando eram frequentadas por marinheiros, trabalhadores e estudantes. Com o tempo, as tascas tornaram-se locais de convívio para pessoas de todas as classes sociais, que apreciavam a comida caseira, o ambiente acolhedor e os preços acessíveis. As tascas são conhecidas pela sua simplicidade e autenticidade, servindo pratos tradicionais portugueses, como bacalhau à brás, feijoada, cozido à portuguesa, entre outros. Hoje em dia, as tascas são pontos populares entre locais e turistas, que procuram uma experiência gastronómica autêntica e genuína.",
                            adress: "Zonas da cidade com algumas opções para tascas\n- Alfama \n- Mouraria"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Tascas 🍷 ",
                            shortDescription: "Small typical restaurants, full of flavor and tradition.",
                            description: "They are traditional Portuguese taverns or eateries, known for their casual atmosphere, hearty food, and affordable prices. Tascas serve a variety of dishes, such as petiscos, small plates of appetizers; bifanas, pork sandwiches; and \"caldo verde\", kale soup. Tascas are a popular dining option for locals and visitors looking to experience authentic Portuguese cuisine.",
                            history: "Tascas are an ancient tradition in Portugal, dating back to the 19th century, when they were frequented by sailors, workers and students. Over time, bars became places for people from all social classes to socialize and eat, who enjoyed home-cooked food, a cozy atmosphere and affordable prices. The taverns are known for their simplicity and authenticity, serving traditional Portuguese dishes, such as bacalhau à brás, feijoada, cozido à portuguesa, among others. Today, taverns are popular spots among locals and tourists alike, seeking an authentic and genuine dining experience.",
                            adress: "Areas of the city with some options for tascas\n- Alfama \n- Mouraria"
                        ),
                        "es": MiniaturaCardTranslation(
                            titulo: "Tascas 🍷 ",
                            shortDescription: "Pequeños restaurantes típicos, llenos de sabor y tradición.",
                            description: "Son tabernas o restaurantes típicos portugueses, conocidos por su ambiente casual, comida casera y precios asequibles. Las tascas sirven una variedad de platos, como petiscos, pequeños platos de aperitivos; bifanas, sándwiches de cerdo; y \"caldo verde\", sopa de col rizada. Las tascas son una opción popular para locales y visitantes que buscan experimentar la auténtica cocina portuguesa.",
                            history: "Las tascas son una tradición antigua en Portugal, que se remonta al siglo XIX, cuando eran frecuentadas por marineros, trabajadores y estudiantes. Con el tiempo, las tascas se convirtieron en lugares de convivencia para personas de todas las clases sociales, que disfrutaban de la comida casera, el ambiente acogedor y los precios asequibles. Las tascas son conocidas por su simplicidad y autenticidad, sirviendo platos tradicionales portugueses, como bacalhau à brás, feijoada, cozido à portuguesa, entre otros. Hoy en día, las tascas son lugares populares entre locales y turistas por igual, que buscan una experiencia gastronómica auténtica y genuina.",
                            adress: "Áreas de la ciudad con algunas opciones para tascas\n- Alfama \n- Mouraria"
                        ),
                        "fr": MiniaturaCardTranslation(
                            titulo: "Tascas 🍷 ",
                            shortDescription: "Petits restaurants typiques, pleins de saveur et de tradition.",
                            
                            description: "Ce sont des tavernes ou des restaurants typiques portugais, connus pour leur atmosphère décontractée, leur nourriture copieuse et leurs prix abordables. Les tascas servent une variété de plats, tels que les petiscos, de petites assiettes d'apéritifs; bifanas, sandwiches au porc; et \"caldo verde\", soupe au chou frisé. Les tascas sont une option de restauration populaire pour les habitants et les visiteurs à la recherche d'une expérience culinaire portugaise authentique.",
                            history: "Les tascas sont une tradition ancienne au Portugal, remontant au XIXe siècle, lorsqu'elles étaient fréquentées par des marins, des travailleurs et des étudiants. Au fil du temps, les tascas sont devenues des lieux de convivialité pour les personnes de toutes les classes sociales, qui appréciaient la nourriture maison, l'atmosphère chaleureuse et les prix abordables. Les tascas sont connues pour leur simplicité et leur authenticité, servant des plats portugais traditionnels, tels que bacalhau à brás, feijoada, cozido à portuguesa, entre autres. Aujourd'hui, les tascas sont des endroits populaires parmi les habitants et les touristes à la recherche d'une expérience culinaire authentique et authentique.",
                            adress: "Zones de la ville avec quelques options pour les tascas\n- Alfama \n- Mouraria"
                        ),
                    ],
                    locations: [
                        (name: ["en": "Alfama", "pt": "Alfama", "fr": "Alfama", "es": "Alfama" ], latitude: 38.712467, longitude: -9.131527),
                        (name: ["en": "Mouraria", "pt": "Mouraria", "fr": "Mouraria", "es": "Mouraria"], latitude: 38.714171, longitude: -9.135225)
                    ],
                    zoomSpan: (latitudeDelta: 0.01, longitudeDelta: 0.01),
                    customCenter: (38.713922, -9.133472)
                ),
                
                MiniaturaCard(
                    id: 5,
                    imagem: "ladra",
                    categoria: categoria,
                    ordem: 5,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Feira da Ladra ",
                            shortDescription: "O mercado mais popular da cidade para artigos usados e antiguidade 👗 👢 🖼️.",
                            description: "É o mercado mais antigo de Lisboa, realizado todas as terças e sábados no bairro de Alfama. O mercado oferece uma grande variedade de itens, desde antiguidades e roupas vintage a artesanato e artigos de segunda mão. É um destino popular para locais e turistas, conhecido pela sua atmosfera animada e achados únicos.",
                            history: "A Feira da Ladra tem uma longa história, remontando ao século XIII, quando foi estabelecida como um local para a venda de bens roubados. Com o tempo, o mercado evoluiu para um local de comércio legítimo, atraindo vendedores e compradores de todas as classes sociais. O nome Feira da Ladra, que significa \"Mercado do Ladrão\", diz-se ter origem na venda de bens roubados no passado. Hoje em dia, o mercado é um centro cultural e social, oferecendo uma experiência de compras única e um vislumbre da vibrante vida de rua de Lisboa.",
                            adress: "Campo de Santa Clara, Alfama, Lisboa"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Feira da Ladra",
                            shortDescription: "The most famous flea market for finds and antiques.👗 👢 🖼️",
                            description: "It's Lisbon's oldest flea market, held every Tuesday and Saturday in the Alfama neighborhood. The market offers a wide variety of items, from antiques and vintage clothing to handicrafts and second-hand goods. It's a popular destination for locals and tourists alike, known for its lively atmosphere and unique finds.",
                            history: "The Feira da Ladra has a long history, dating back to the 13th century when it was established as a place for the sale of stolen goods. Over time, the market evolved into a legitimate trading place, attracting vendors and buyers from all walks of life. The name Feira da Ladra, which means \"Thief's Market\" is said to have originated from the sale of stolen goods in the past. Today, the market is a cultural and social hub, offering a unique shopping experience and a glimpse into Lisbon's vibrant street life.",
                            adress: "Campo de Santa Clara, Alfama, Lisboa"
                        ),
                        "es": MiniaturaCardTranslation(
                            titulo: "Feira da Ladra",
                            shortDescription: "El mercado de pulgas más famoso para hallazgos y antigüedades.👗 👢 🖼️",
                            description: "Es el mercado de pulgas más antiguo de Lisboa, que se celebra todos los martes y sábados en el barrio de Alfama. El mercado ofrece una amplia variedad de artículos, desde antigüedades y ropa vintage hasta artesanías y productos de segunda mano. Es un destino popular tanto para locales como para turistas, conocido por su ambiente animado y sus hallazgos únicos.",
                            history: "La Feira da Ladra tiene una larga historia, que se remonta al siglo XIII, cuando se estableció como un lugar para la venta de bienes robados. Con el tiempo, el mercado evolucionó hasta convertirse en un lugar de comercio legítimo, atrayendo a vendedores y compradores de todas las clases sociales. El nombre Feira da Ladra, que significa \"Mercado del Ladrón\", se dice que se originó por la venta de bienes robados en el pasado. Hoy en día, el mercado es un centro cultural y social, que ofrece una experiencia de compra única y una visión de la vibrante vida callejera de Lisboa.",
                            adress: "Campo de Santa Clara, Alfama, Lisboa"
                        ),
                        "fr": MiniaturaCardTranslation(
                            titulo: "Feira da Ladra",
                            shortDescription: "Le marché aux puces le plus célèbre pour les trouvailles et les antiquités.👗 👢 🖼️",
                            description: "C'est le plus ancien marché aux puces de Lisbonne, qui se tient tous les mardis et samedis dans le quartier d'Alfama. Le marché offre une grande variété d'articles, allant des antiquités et vêtements vintage aux objets artisanaux et articles d'occasion. C'est une destination populaire pour les locaux et les touristes, connue pour son atmosphère animée et ses trouvailles uniques.",
                            history: "La Feira da Ladra a une longue histoire, remontant au XIIIe siècle, lorsqu'elle a été établie comme un lieu de vente de biens volés. Au fil du temps, le marché a évolué pour devenir un lieu de commerce légitime, attirant des vendeurs et des acheteurs de tous horizons. Le nom Feira da Ladra, qui signifie \"Marché du Voleur\", est dit avoir été originaire de la vente de biens volés dans le passé. Aujourd'hui, le marché est un centre culturel et social, offrant une expérience de shopping unique et un aperçu de la vie de rue vibrante de Lisbonne.",
                            adress: "Campo de Santa Clara, Alfama, Lisboa"
                        )
                    ],
                    locations: [
                        (name: ["en": "Feira da Ladra", "pt": "Feira da Ladra", "fr": "Feira da Ladra", "es": "Feira da Ladra"], latitude: 38.715615, longitude: -9.1246)
                    ],
                    zoomSpan: nil,
                    customCenter: nil
                ),
                
                MiniaturaCard(
                    id: 6,
                    imagem: "futebol",
                    categoria: categoria,
                    ordem: 6,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Futebol ⚽ ",
                            shortDescription: "O futebol é um esporte amado em Portugal, com fãs apaixonados e clubes históricos.",
                            description: "O futebol é o esporte mais popular em Portugal, com uma longa história e uma base de fãs apaixonada. Os principais clubes de futebol da cidade são o Benfica e o Sporting. A seleção nacional portuguesa, conhecida como Seleção, também alcançou grande sucesso, vencendo o Campeonato Europeu da UEFA em 2016.",
                            history: "O Estádio da Luz é o maior estádio de Portugal e um dos maiores da Europa, com capacidade para mais de 65.000 espectadores. O Estádio de Alvalade é a casa do Sporting, um dos clubes mais antigos e prestigiados de Portugal. Ambos os estádios são locais de culto para os fãs de futebol, que se reúnem para apoiar suas equipes e celebrar sua paixão pelo esporte.",
                            adress: "⚽ Estádio da Luz (Benfica)\n⚽  Estádio de Alvalade (Sporting)"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Football ⚽ ",
                            shortDescription: "The national passion that brings crowds together in Lisbon.",
                            description: "Football is the most popular sport in Portugal, with a long history and passionate fan base. The city's top football clubs are Benfica and Sporting. The Portuguese national team, known as the Seleção, has also achieved great success, winning the UEFA European Championship in 2016.",
                            history: "Benfica Stadium is the largest stadium in Portugal and one of the largest in Europe, with a capacity for more than 65,000 spectators. Alvalade Stadium is home to Sporting, one of the oldest and most prestigious clubs in Portugal. Both stadiums are places of worship for football fans, who come together to support their teams and celebrate their passion for the sport.",
                            adress: "⚽ Estádio da Luz (Benfica)\n⚽  Estádio de Alvalade (Sporting)"
                        ),
                        "es": MiniaturaCardTranslation(
                            titulo: "Fútbol ⚽ ",
                            shortDescription: "La pasión nacional que reúne multitudes en Lisboa.",
                            description: "El fútbol es el deporte más popular en Portugal, con una larga historia y una base de fanáticos apasionada. Los principales clubes de fútbol de la ciudad son Benfica y Sporting. La selección nacional portuguesa, conocida como Seleção, también ha logrado un gran éxito, ganando el Campeonato Europeo de la UEFA en 2016.",
                            history: "El Estadio da Luz es el estadio más grande de Portugal y uno de los más grandes de Europa, con capacidad para más de 65,000 espectadores. El Estadio de Alvalade es el hogar del Sporting, uno de los clubes más antiguos y prestigiosos de Portugal. Ambos estadios son lugares de culto para los fanáticos del fútbol, que se reúnen para apoyar a sus equipos y celebrar su pasión por el deporte.",
                            adress: "⚽ Estádio da Luz (Benfica)\n⚽  Estádio de Alvalade (Sporting)"
                        ),
                        "fr": MiniaturaCardTranslation(
                            titulo: "Football ⚽ ",
                            shortDescription: "La passion nationale qui rassemble les foules à Lisbonne.",
                            description: "Le football est le sport le plus populaire au Portugal, avec une longue histoire et une base de fans passionnée. Les principaux clubs de football de la ville sont Benfica et Sporting. L'équipe nationale portugaise, connue sous le nom de Seleção, a également connu un grand succès, remportant le Championnat d'Europe de l'UEFA en 2016.",
                            history: "Le stade da Luz est le plus grand stade du Portugal et l'un des plus grands d'Europe, avec une capacité de plus de 65 000 spectateurs. Le stade d'Alvalade est le domicile du Sporting, l'un des clubs les plus anciens et les plus prestigieux du Portugal. Les deux stades sont des lieux de culte pour les fans de football, qui se réunissent pour soutenir leurs équipes et célébrer leur passion pour le sport.",
                            adress: "⚽ Estádio da Luz (Benfica)\n⚽  Estádio de Alvalade (Sporting)"
                        )
                    ],
                    locations: [
                        (name: ["en": "Estádio da Luz", "pt": "Estádio da Luz", "fr": "Stade de la Luz", "es": "Estadio de la Luz" ], latitude: 38.7633, longitude: -9.1847),
                        (name: ["en": "Estádio de Alvalade", "pt": "Estádio de Alvalade", "fr": "Stade d'Alvalade", "es": "Estadio de Alvalade"], latitude: 38.761198, longitude: -9.160803)
                    ],
                    zoomSpan: (latitudeDelta: 0.09, longitudeDelta: 0.09),
                    customCenter: (38.730049, -9.175494)
                ),
                MiniaturaCard(
                    id: 7,
                    imagem: "santos",
                    categoria: categoria,
                    ordem: 7,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Santos Populares 🎉 ",
                            shortDescription: "Os Santos Populares são festas tradicionais portuguesas que celebram santos populares com música, dança e comida.",
                            description: "Os Santos Populares são festas tradicionais que acontecem em Portugal, durante o mês de junho, em honra a três santos católicos: Santo António, São João e São Pedro. A noite de Santo António é o ponto alto das festividades, pois Lisboa é a cidade natal do santo. As festividades incluem desfiles, marchas populares, danças, fogueiras, sardinhas assadas, manjericos e muita diversão.",
                            history: "Os Santos Populares são uma tradição antiga em Portugal, que remonta ao século XVIII, quando eram celebrados em honra a santos católicos. As festividades incluem desfiles, marchas populares, danças, fogueiras, sardinhas assadas, manjericos e muita diversão. É um momento de celebração e convívio, quando as ruas se enchem de cor e alegria, e as pessoas se reúnem para celebrar a vida e a amizade.",
                            adress: "As melhores festas, chamadas \"arraiais\", são realizadas nos bairros mais antigos de Lisboa.\n- Alfama\n- Bairro Alto\n- Mouraria\n- Graça"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Santos Populares 🎉 ",
                            shortDescription: "Lively street festivals with music, sardines, and joy.",
                            description: "The Popular Saints are traditional festivals that take place in Portugal, during the month of June, in honor of three Catholic saints: Saint Anthony, Saint John and Saint Peter. The night of Saint Anthony is the highlight of the festivities as Lisbon is the saint's birthplace. The festivities include parades, popular marches, dances, bonfires, grilled sardines, basil and lots of fun.",
                            history: "Popular Saints are an ancient tradition in Portugal, dating back to the 18th century, when they were celebrated in honor of Catholic saints. The festivities include parades, popular marches, dances, bonfires, grilled sardines, basil and lots of fun. It is a time of celebration and socializing, when the streets are filled with color and joy, and people come together to celebrate life and friendship.",
                            adress: "The best parties, called \"arraiais\", are held in the oldest neighborhoods of Lisbon.\n- Alfama\n- Bairro Alto\n- Mouraria\n- Graça"
                        ),
                        "es": MiniaturaCardTranslation(
                            titulo: "Santos Populares 🎉 ",
                            shortDescription: "Festivales callejeros animados con música, sardinas y alegría.",
                            description: "Los Santos Populares son festivales tradicionales que tienen lugar en Portugal, durante el mes de junio, en honor a tres santos católicos: San Antonio, San Juan y San Pedro. La noche de San Antonio es el punto culminante de las festividades ya que Lisboa es la ciudad natal del santo. Las festividades incluyen desfiles, marchas populares, bailes, hogueras, sardinas a la parrilla, albahaca y mucha diversión.",
                            history: "Los Santos Populares son una antigua tradición en Portugal, que se remonta al siglo XVIII, cuando se celebraban en honor a santos católicos. Las festividades incluyen desfiles, marchas populares, bailes, hogueras, sardinas a la parrilla, albahaca y mucha diversión. Es un momento de celebración y socialización, cuando las calles se llenan de color y alegría, y la gente se reúne para celebrar la vida y la amistad.",
                            adress: "Las mejores fiestas, llamadas \"arraiais\", se llevan a cabo en los barrios más antiguos de Lisboa.\n- Alfama\n- Bairro Alto\n- Mouraria\n- Graça"
                        ),
                        "fr": MiniaturaCardTranslation(
                            titulo: "Santos Populares 🎉 ",
                            shortDescription: "Festivals de rue animés avec de la musique, des sardines et de la joie.",
                            description: "Les Santos Populares sont des festivals traditionnels qui ont lieu au Portugal, pendant le mois de juin, en l'honneur de trois saints catholiques : Saint Antoine, Saint Jean et Saint Pierre. La nuit de Saint Antoine est le point culminant des festivités car Lisbonne est la ville natale du saint. Les festivités comprennent des défilés, des marches populaires, des danses, des feux de joie, des sardines grillées, du basilic et beaucoup de plaisir.",
                            history: "Les Santos Populares sont une ancienne tradition au Portugal, remontant au XVIIIe siècle, lorsqu'ils étaient célébrés en l'honneur de saints catholiques. Les festivités comprennent des défilés, des marches populaires, des danses, des feux de joie, des sardines grillées, du basilic et beaucoup de plaisir. C'est un moment de célébration et de socialisation, lorsque les rues sont remplies de couleur et de joie, et que les gens se réunissent pour célébrer la vie et l'amitié.",
                            adress: "Les meilleures fêtes, appelées \"arraiais\", ont lieu dans les plus anciens quartiers de Lisbonne.\n- Alfama\n- Bairro Alto\n- Mouraria\n- Graça"
                        )
                    ],
                    locations: [
                        (name: ["en": "Alfama", "pt": "Alfama", "fr": "Alfama", "es": "Alfama"], latitude: 38.712566, longitude: -9.127686),
                        (name: ["en": "Bairro Alto", "pt": "Bairro Alto", "fr": "Bairro Alto", "es": "Bairro Alto"], latitude: 38.709200, longitude: -9.146127),
                        (name: ["en": "Mouraria", "pt": "Mouraria", "fr": "Mouraria", "es": "Mouraria"], latitude: 38.716143, longitude: -9.133062),
                        (name: ["en": "Graça", "pt": "Graça", "fr": "Graça", "es": "Graça"], latitude: 38.718483, longitude: -9.129862)
                    ],
                    zoomSpan: (latitudeDelta: 0.03, longitudeDelta: 0.03),
                    customCenter: (38.713573, -9.136948)
                ),
                
                MiniaturaCard(
                    id: 8,
                    imagem: "plus_popular",
                    categoria: categoria,
                    ordem: 8,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Mais Tradições ➕ ",
                            shortDescription: "Explore mais da rica herança cultural de Portugal.",
                            description: "Vida Noturna: A cidade ganha vida à noite, oferecendo uma variedade de opções para todos os gostos. Aqui estão alguns destaques da vida noturna de Lisboa: - Bairro Alto: um dos bairros mais animados de Lisboa, conhecido pelas suas ruas estreitas cheias de bares; - Cais do Sodré (na foto): uma antiga zona portuária que se tornou um ponto quente da vida noturna com muitos restaurantes e bares. Aqui você encontrará a Rua Cor-de-Rosa - famosa por sua rua pintada de rosa e guarda-chuvas coloridos pendurados nela; - Os Docks: Uma área à beira do rio com bares e clubes.",
                            history: nil,
                            adress: "- Bairro Alto: metro Baixa-Chiado\n- Cais do Sodré: metro Cais do Sodré\n- As Docks:Entre o Cais do Sodré e o bairro de Belém. Não há metro. O acesso é de Táxi, Uber ou carro próprio."
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "More Traditions ➕ ",
                            shortDescription: "Discover other Lisbon traditions and customs.",
                            description: "Nightlife: The city comes to life at night, offering a variety of options to suit all tastes. Here are some highlights of Lisbon's nightlife: - Bairro Alto: one of Lisbon's liveliest neighborhoods, known for its narrow streets full of bars; - Cais do Sodré (in the picture): a former port area that has become a nightlife hotspot with many restaurants and bars. Here you will find Pink Street - famous for its pink painted street and colorful umbrellas hanging from it; - The Docks: A riverside area with bars and clubs.",
                            history: nil,
                            adress: "- Bairro Alto: metro Baixa-Chiado\n- Cais do Sodré: metro Cais do Sodré\n- The Docks:Between Cais do Sodré and the Belém neighborhood. There is no subway. Access is by Taxi, Uber or your own car."
                        ),
                        "es": MiniaturaCardTranslation(
                            titulo: "Más tradiciones ➕ ",
                            shortDescription: "Descubre otras tradiciones y costumbres de Lisboa.",
                            description: "Vida nocturna: La ciudad cobra vida por la noche, ofreciendo una variedad de opciones para todos los gustos. Aquí hay algunos aspectos destacados de la vida nocturna de Lisboa: - Bairro Alto: uno de los barrios más animados de Lisboa, conocido por sus calles estrechas llenas de bares; - Cais do Sodré (en la foto): una antigua zona portuaria que se ha convertido en un punto caliente de la vida nocturna con muchos restaurantes y bares. Aquí encontrarás Pink Street, famosa por su calle pintada de rosa y los coloridos paraguas colgados de ella; - The Docks: Un área junto al río con bares y clubes.",
                            history: nil,
                            adress: "- Bairro Alto: metro Baixa-Chiado\n- Cais do Sodré: metro Cais do Sodré\n- The Docks:Entre Cais do Sodré y el barrio de Belém. No hay metro. El acceso es por Taxi, Uber o tu propio coche."
                        ),
                        "fr": MiniaturaCardTranslation(
                            titulo: "Plus de traditions ➕ ",
                            shortDescription: "Découvrez d'autres traditions et coutumes de Lisbonne.",
                            description: "Vie nocturne : La ville s'anime la nuit, offrant une variété d'options pour tous les goûts. Voici quelques points forts de la vie nocturne de Lisbonne : - Bairro Alto : l'un des quartiers les plus animés de Lisbonne, connu pour ses rues étroites pleines de bars; - Cais do Sodré (dans l'image) : une ancienne zone portuaire qui est devenue un point chaud de la vie nocturne avec de nombreux restaurants et bars. Ici vous trouverez Pink Street - célèbre pour sa rue peinte en rose et les parapluies colorés suspendus à celle-ci; - The Docks: Un quartier en bord de rivière avec des bars et des clubs.",
                            history: nil,
                            adress: "- Bairro Alto: métro Baixa-Chiado\n- Cais do Sodré: métro Cais do Sodré\n- The Docks:Entre Cais do Sodré et le quartier de Belém. Il n'y a pas de métro. L'accès se fait en Taxi, Uber ou votre propre voiture."
                        )
                    ],
                    locations: [
                        (name: ["en": "Cais do Sodré", "pt": "Cais do Sodré", "fr": "Cais do Sodré", "es": "Cais do Sodré"], latitude: 38.707529, longitude: -9.145839),
                        (name: ["en": "Bairro Alto", "pt": "Bairro Alto", "fr": "Bairro Alto", "es": "Bairro Alto"], latitude: 38.709200, longitude: -9.146127),
                        (name: ["en": "Docas", "pt": "Docas", "fr": "Docas", "es": "Docas"], latitude: 38.700258, longitude: -9.177473)
                    ],
                    zoomSpan: (latitudeDelta: 0.05, longitudeDelta: 0.05),
                    customCenter: (38.706827, -9.157535)
                )
            ]
        }
        if cat == "churches" || cat == "igrejas" {
            return [
                MiniaturaCard(
                    id: 1,
                    imagem: "se_lisboa",
                    categoria: categoria,
                    ordem: 1,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Sé Catedral ⛪️ ",
                            shortDescription: "A catedral mais antiga de Lisboa, construída no século XII, exibindo uma mistura de estilos arquitetónicos.",
                            description: "A Sé Catedral de Lisboa, oficialmente a Catedral Patriarcal de Santa Maria Maior, é a igreja mais antiga da cidade. Construída no século XII, pouco depois da reconquista cristã da cidade aos mouros, combina elementos de arquitetura românica, gótica e barroca. A catedral sobreviveu a vários terremotos, incluindo o devastador terremoto de 1755, o que lhe confere a sua mistura única de estilos arquitetónicos.",
                            history: "A catedral foi construída no local de uma antiga mesquita, após a reconquista cristã da cidade pelo rei Afonso I em 1147. Ao longo dos séculos, sofreu inúmeras renovações e adições, com cada período deixando a sua marca na estrutura. Apesar dos danos causados pelo terremoto de 1755, a catedral manteve a sua importância religiosa e histórica como sede da Arquidiocese de Lisboa.",
                            adress: "Largo da Sé, 1100-585 Lisboa'"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Sé Cathedral ⛪️ ",
                            shortDescription: "Lisbon's oldest cathedral, a symbol of faith and the city's history.",
                            description: "The Sé Cathedral of Lisbon, officially the Patriarchal Cathedral of St. Mary Major, is the oldest church in the city. Built in the 12th century, shortly after the Christian reconquest of the city from the Moors, it combines elements of Romanesque, Gothic, and Baroque architecture. The cathedral has survived several earthquakes, including the devastating 1755 earthquake, which gives it its unique blend of architectural styles.",
                            history: "The cathedral was built on the site of a former mosque, following the Christian reconquest of the city by King Afonso I in 1147. Over the centuries, it has undergone numerous renovations and additions, with each period leaving its mark on the structure. Despite the damage caused by the 1755 earthquake, the cathedral has maintained its religious and historical significance as the seat of the Archdiocese of Lisbon.",
                            adress: "Largo da Sé, 1100-585 Lisboa'"
                        ),
                        "es": MiniaturaCardTranslation(
                            titulo: "Sé Catedral ⛪️ ",
                            shortDescription: "La catedral más antigua de Lisboa, un símbolo de fe e historia de la ciudad.",
                            description: "La Sé Catedral de Lisboa, oficialmente la Catedral Patriarcal de Santa María Mayor, es la iglesia más antigua de la ciudad. Construida en el siglo XII, poco después de la reconquista cristiana de la ciudad a los moros, combina elementos de arquitectura románica, gótica y barroca. La catedral ha sobrevivido a varios terremotos, incluido el devastador terremoto de 1755, lo que le da su mezcla única de estilos arquitectónicos.",
                            history: "La catedral fue construida en el sitio de una antigua mezquita, después de la reconquista cristiana de la ciudad por el rey Afonso I en 1147. A lo largo de los siglos, ha sufrido numerosas renovaciones y adiciones, con cada período dejando su marca en la estructura. A pesar del daño causado por el terremoto de 1755, la catedral ha mantenido su importancia religiosa e histórica como sede de la Archidiócesis de Lisboa.",
                            adress: "Largo da Sé, 1100-585 Lisboa'"
                        ),
                        "fr": MiniaturaCardTranslation(
                            titulo: "Sé Cathedral ⛪️ ",
                            shortDescription: "La plus ancienne cathédrale de Lisbonne, un symbole de foi et de l'histoire de la ville.",
                            description: "La Sé Cathedral de Lisbonne, officiellement la Cathédrale Patriarcale de Santa Maria Maior, est la plus ancienne église de la ville. Construite au XIIe siècle, peu après la reconquête chrétienne de la ville aux Maures, elle combine des éléments d'architecture romane, gothique et baroque. La cathédrale a survécu à plusieurs tremblements de terre, dont le dévastateur tremblement de terre de 1755, ce qui lui confère son mélange unique de styles architecturaux.",
                            history: "La cathédrale a été construite sur le site d'une ancienne mosquée, à la suite de la reconquête chrétienne de la ville par le roi Afonso I en 1147. Au fil des siècles, elle a subi de nombreuses rénovations et ajouts, chaque période laissant sa marque sur la structure. Malgré les dommages causés par le tremblement de terre de 1755, la cathédrale a maintenu son importance religieuse et historique en tant que siège de l'Archidiocèse de Lisbonne.",
                            adress: "Largo da Sé, 1100-585 Lisboa'"
                        )
                    ],
                    locations: [
                        (name: ["en": "Sé Catedral", "pt": "Sé Catedral", "fr": "Sé Cathedral", "es": "Sé Cathedral"], latitude: 38.7108, longitude: -9.1332)
                    ],
                    zoomSpan: nil,
                    customCenter: nil
                ),
                
                MiniaturaCard(
                    id: 2,
                    imagem: "jeronimos",
                    categoria: categoria,
                    ordem: 2,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Mosteiro dos Jerónimos ⛪️ ",
                            shortDescription: "Um patrimônio mundial da UNESCO que exemplifica o estilo arquitetónico manuelino ornamentado português.",
                            description: "O Mosteiro dos Jerónimos é uma obra-prima da arquitetura manuelina, simbolizando a Era dos Descobrimentos de Portugal. Construído no início do século XVI, foi encomendado pelo rei Manuel I para comemorar a bem-sucedida viagem de Vasco da Gama à Índia e para agradecer à Virgem Maria pelo seu sucesso. O mosteiro é notável pelos seus elaborados motivos marítimos, intrincadas esculturas em pedra e pelo seu design harmonioso.",
                            history: "A construção começou em 1501 e continuou por 100 anos. O mosteiro foi povoado por monges da Ordem de São Jerónimo, que tinham a tarefa de rezar pela alma do rei e fornecer assistência espiritual aos navegadores e marinheiros que partiam da praia próxima de Belém. O mosteiro abriga os túmulos de Vasco da Gama e do poeta Luís de Camões, entre outras figuras portuguesas notáveis. Foi classificado como Patrimônio Mundial da UNESCO em 1983.",
                            adress: "Praça do Império 1400-206 Lisboa'"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Jerónimos Monastery",
                            shortDescription: "A Manueline masterpiece ⛪️ and UNESCO World Heritage Site.",
                            description: "The Jerónimos Monastery is a masterpiece ⛪️ of Manueline architecture, symbolizing Portugal's Age of Discoveries. Built in the early 16th century, it was commissioned by King Manuel I to commemorate Vasco da Gama's successful voyage to India and to thank the Virgin Mary for his success. The monastery is notable for its ornate maritime motifs, intricate stone carvings, and its harmonious design.",
                            history: "Construction began in 1501 and continued for 100 years. The monastery was populated by monks of the Order of Saint Jerome, who were tasked with praying for the king's soul and providing spiritual assistance to navigators and sailors who departed from the nearby beach of Belém. The monastery houses the tombs of Vasco da Gama and the poet Luís de Camões, among other notable Portuguese figures. It was classified as a UNESCO World Heritage Site in 1983.",
                            adress: "Praça do Império 1400-206 Lisboa'"
                        ),
                        "es": MiniaturaCardTranslation(
                            titulo: "Mosteiro dos Jerónimos ⛪️ ",
                            shortDescription: "Una obra maestra del estilo manuelino y Patrimonio Mundial de la UNESCO.",
                            description: "El Monasterio de los Jerónimos es una obra maestra del estilo manuelino, simbolizando la Era de los Descubrimientos de Portugal. Construido a principios del siglo XVI, fue encargado por el rey Manuel I para conmemorar el exitoso viaje de Vasco da Gama a India y para agradecer a la Virgen María por su éxito. El monasterio es notable por sus elaborados motivos marítimos, intrincadas esculturas en piedra y su diseño armonioso.",
                            history: "La construcción comenzó en 1501 y continuó durante 100 años. El monasterio fue habitado por monjes de la Orden de San Jerónimo, quienes tenían la tarea de rezar por el alma del rey y brindar asistencia espiritual a los navegantes y marineros que partían de la cercana playa de Belém. El monasterio alberga las tumbas de Vasco da Gama y el poeta Luís de Camões, entre otras figuras portuguesas notables. Fue clasificado como Patrimonio Mundial de la UNESCO en 1983.",
                            adress: "Praça do Império 1400-206 Lisboa'"
                        ),
                        "fr": MiniaturaCardTranslation(
                            titulo: "Mosteiro dos Jerónimos ⛪️ ",
                            shortDescription: "Un chef-d'œuvre du style manuelin et site du patrimoine mondial de l'UNESCO.",
                            description: "Le Monastère des Jerónimos est un chef-d'œuvre du style manuelin, symbolisant l'ère des découvertes du Portugal. Construit au début du XVIe siècle, il a été commandé par le roi Manuel I pour commémorer le voyage réussi de Vasco da Gama en Inde et pour remercier la Vierge Marie de son succès. Le monastère est remarquable pour ses motifs maritimes ornés, ses sculptures en pierre complexes et son design harmonieux.",
                            history: "La construction a commencé en 1501 et a duré 100 ans. Le monastère était habité par des moines de l'Ordre de Saint Jérôme, qui avaient pour tâche de prier pour l'âme du roi et de fournir une assistance spirituelle aux navigateurs et marins qui partaient de la plage voisine de Belém. Le monastère abrite les tombes de Vasco da Gama et du poète Luís de Camões, parmi d'autres figures portugaises notables. Il a été classé au patrimoine mondial de l'UNESCO en 1983.",
                            adress: "Praça do Império 1400-206 Lisboa'"
                        )
                    ],
                    locations: [
                        (name: ["en": "Mosteiro dos Jerónimos", "pt": "Mosteiro dos Jerónimos", "fr": "Monastère des Jerónims", "es": "Monasterio de los Jerónimos"], latitude: 38.6978, longitude: -9.2065)
                    ],
                    zoomSpan: nil,
                    customCenter: nil
                ),
                MiniaturaCard(
                    id: 3,
                    imagem: "sao_domingos",
                    categoria: categoria,
                    ordem: 3,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "São Domingos 🔥⛪️🔥",
                            shortDescription: "Uma igreja histórica com as marcas do fogo 🔥🔥",
                            description: "A Igreja de São Domingos é uma das igrejas mais históricas de Lisboa, com uma história marcada pela resiliência e sobrevivência. Fundada em 1241, testemunhou casamentos reais, coroações e o infame Massacre de Lisboa de 1506. Apesar de ter sido severamente danificada por terremotos e incêndios, a igreja continua de pé e serve como um local de culto.",
                            history: "Ao longo da sua história, a igreja sobreviveu aos terremotos de 1531 e 1755, bem como a um devastador incêndio em 1959. Em vez de restaurar completamente a igreja após o incêndio, foi tomada a decisão de preservar os pilares e paredes marcados como um testemunho da resiliência da igreja. A igreja contém várias obras de arte valiosas e artefatos religiosos, incluindo um presépio do século XVIII e várias esculturas e pinturas.",
                            adress: "Largo de São Domingos 1, 1150-320 Lisboa'"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "São Domingos 🔥⛪️🔥",
                            shortDescription: "A church marked by tragedies and reconstructions, full of history.",
                            description: "The Church of São Domingos is one of Lisbon's most historic churches, with a history marked by resilience and survival. Founded in 1241, it has witnessed royal weddings, coronations, and the infamous Lisbon Massacre of 1506. Despite being severely damaged by earthquakes and fires, the church continues to stand and serve as a place of worship",
                            history: "Throughout its history, the church has survived the 1531 and 1755 earthquakes, as well as a devastating fire in 1959. Rather than completely restoring the church after the fire, the decision was made to preserve the scarred pillars and walls as a testament to the church's resilience. The church contains several valuable artworks and religious artifacts, including an 18th-century nativity scene and various sculptures and paintings.",
                            adress: "Largo de São Domingos 1, 1150-320 Lisboa'"
                        ),
                        "es": MiniaturaCardTranslation(
                            titulo: "São Domingos 🔥⛪️🔥",
                            shortDescription: "Una iglesia marcada por tragedias y reconstrucciones, llena de historia.",
                            description: "La Iglesia de São Domingos es una de las iglesias más históricas de Lisboa, con una historia marcada por la resiliencia y la supervivencia. Fundada en 1241, ha sido testigo de bodas reales, coronaciones y la infame Masacre de Lisboa de 1506. A pesar de haber sido gravemente dañada por terremotos e incendios, la iglesia continúa en pie y sirve como un lugar de culto.",
                            history: "A lo largo de su historia, la iglesia ha sobrevivido a los terremotos de 1531 y 1755, así como a un devastador incendio en 1959. En lugar de restaurar completamente la iglesia después del incendio, se tomó la decisión de preservar los pilares y paredes marcados como testimonio de la resiliencia de la iglesia. La iglesia contiene varias obras de arte valiosas y artefactos religiosos, incluido un belén del siglo XVIII y varias esculturas y pinturas.",
                            adress: "Largo de São Domingos 1, 1150-320 Lisboa'"
                        ),
                        "fr": MiniaturaCardTranslation(
                            titulo: "São Domingos 🔥⛪️🔥",
                            shortDescription: "Une église marquée par des tragédies et des reconstructions, pleine d'histoire.",
                            description: "L'église de São Domingos est l'une des églises les plus historiques de Lisbonne, avec une histoire marquée par la résilience et la survie. Fondée en 1241, elle a été témoin de mariages royaux, de couronnements et du tristement célèbre massacre de Lisbonne de 1506. Malgré les graves dommages causés par les tremblements de terre et les incendies, l'église continue de se tenir debout et sert de lieu de culte.",
                            history: "Tout au long de son histoire, l'église a survécu aux tremblements de terre de 1531 et 1755, ainsi qu'à un incendie dévastateur en 1959. Plutôt que de restaurer complètement l'église après l'incendie, la décision a été prise de préserver les piliers et les murs marqués comme témoignage de la résilience de l'église. L'église contient plusieurs œuvres d'art précieuses et des artefacts religieux, y compris une scène de la nativité du XVIIIe siècle et diverses sculptures et peintures.",
                            adress: "Largo de São Domingos 1, 1150-320 Lisboa'"
                        )
                    ],
                    locations: [
                        (name: ["en": "São Domingos", "pt": "São Domingos", "fr": "São Domingos", "es": "São Domingos"], latitude: 38.7142, longitude: -9.1392)
                    ],
                    zoomSpan: nil,
                    customCenter: nil
                ),
                
                MiniaturaCard(
                    id: 4,
                    imagem: "sao_roque",
                    categoria: categoria,
                    ordem: 4,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "São Roque 🔔 ",
                            shortDescription: "Abriga capelas barrocas deslumbrantes e uma impressionante coleção de arte religiosa.",
                            description: "A Igreja de São Roque é uma das primeiras igrejas jesuítas do mundo e uma das mais belas de Portugal. Apesar do seu exterior relativamente simples, o interior é um tesouro de arte barroca, apresentando capelas ricamente decoradas, pinturas valiosas e uma impressionante coleção de relíquias.",
                            history: "Construída no século XVI, a igreja foi inicialmente erguida num local que havia sido um cemitério para vítimas da peste, onde um santuário a São Roque (Santo Roque, o santo padroeiro contra a peste) havia sido estabelecido. A igreja foi entregue aos jesuítas que procederam à construção de uma das primeiras igrejas jesuítas do mundo. A característica mais notável da igreja é a Capela de São João Batista, encomendada pelo rei João V no século XVIII. A capela foi projetada em Roma, abençoada pelo Papa e depois desmontada e enviada para Lisboa.",
                            adress: "Largo Trindade Coelho, 1200-470 Lisboa"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "São Roque 🔔 ",
                            shortDescription: "One of the oldest Jesuit churches in the world, with a rich interior.",
                            description: "The Church of São Roque is one of the first Jesuit churches in the world and one of the most beautiful in Portugal. Despite its relatively plain exterior, the interior is a treasure trove of baroque art, featuring richly decorated chapels, valuable paintings, and an impressive collection of relics.",
                            history: "Built in the 16th century, the church was initially erected on a site that had been a cemetery for plague victims, where a shrine to São Roque (Saint Roch, the patron saint against plague) had been established. The church was given to the Jesuits who proceeded to build one of the first Jesuit churches in the world. The church's most remarkable feature is the Chapel of St. John the Baptist, commissioned by King João V in the 18th century. The chapel was designed in Rome, blessed by the Pope, and then dismantled and shipped to Lisbon.",
                            adress: "Largo Trindade Coelho, 1200-470 Lisboa"
                        ),
                        "es": MiniaturaCardTranslation(
                            titulo: "São Roque 🔔 ",
                            shortDescription: "Una de las iglesias jesuitas más antiguas del mundo, con un interior rico.",
                            description: "La Iglesia de São Roque es una de las primeras iglesias jesuitas del mundo y una de las más bellas de Portugal. A pesar de su exterior relativamente sencillo, el interior es un tesoro de arte barroco, con capillas ricamente decoradas, valiosas pinturas y una impresionante colección de reliquias.",
                            history: "Construida en el siglo XVI, la iglesia se erigió inicialmente en un sitio que había sido un cementerio para víctimas de la peste, donde se había establecido un santuario a São Roque (San Roque, el santo patrón contra la peste). La iglesia fue entregada a los jesuitas que procedieron a construir una de las primeras iglesias jesuitas del mundo. La característica más notable de la iglesia es la Capilla de San Juan Bautista, encargada por el rey João V en el siglo XVIII. La capilla fue diseñada en Roma, bendecida por el Papa y luego desmontada y enviada a Lisboa.",
                            adress: "Largo Trindade Coelho, 1200-470 Lisboa"
                        ),
                        "fr": MiniaturaCardTranslation(
                            titulo: "São Roque 🔔 ",
                            shortDescription: "L'une des plus anciennes églises jésuites du monde, avec un intérieur riche.",
                            description: "L'église de São Roque est l'une des premières églises jésuites du monde et l'une des plus belles du Portugal. Malgré son extérieur relativement simple, l'intérieur est un trésor d'art baroque, avec des chapelles richement décorées, de précieuses peintures et une impressionnante collection de reliques.",
                            history: "Construite au XVIe siècle, l'église a été initialement érigée sur un site qui avait été un cimetière pour les victimes de la peste, où un sanctuaire à São Roque (Saint Roch, le saint patron contre la peste) avait été établi. L'église a été donnée aux jésuites qui ont procédé à la construction de l'une des premières églises jésuites du monde. La caractéristique la plus remarquable de l'église est la Chapelle de Saint Jean Baptiste, commandée par le roi João V au XVIIIe siècle. La chapelle a été conçue à Rome, bénie par le pape, puis démontée et expédiée à Lisbonne.",
                            adress: "Largo Trindade Coelho, 1200-470 Lisboa"
                        )
                    ],
                    locations: [
                        (name: ["en": "São Roque", "pt": "São Roque", "fr": "São Roque", "es": "São Roque" ], latitude: 38.7147, longitude: -9.1441)
                    ],
                    zoomSpan: nil,
                    customCenter: nil
                ),
                MiniaturaCard(
                    id: 5,
                    imagem: "basilica_estrela",
                    categoria: categoria,
                    ordem: 5,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Basílica da Estrela ⭐️ ",
                            shortDescription: "Uma magnífica basílica do século XVIII conhecida pela sua grande cúpula e arquitetura neoclássica.",
                            description: "A Basílica da Estrela é uma igreja neoclássica e barroca em Lisboa, conhecida pela sua grande cúpula e interior de mármore. Encomendada pela rainha Maria I para celebrar o nascimento do seu filho e herdeiro, a basílica é um testemunho da gratidão e devoção da rainha.",
                            history: " A basílica foi construída entre 1779 e 1790, cumprindo um voto feito pela rainha Maria I. Ironicamente, o seu filho morreu antes da conclusão da igreja, e a própria rainha começou a mostrar sinais de doença mental na altura da sua conclusão. A basílica é notável pelo seu interior de mármore, belos vitrais e um elaborado presépio composto por mais de 500 figuras de cortiça e terracota criadas por Joaquim Machado de Castro.",
                            adress: "Praça da Estrela, 1200-667 Lisboa"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Estrela Basilica ⭐️ ",
                            shortDescription: "Imposing white-domed basilica, a landmark in Lisbon's skyline.",
                            description: "The Basilica da Estrela is a neoclassical and baroque church in Lisbon, known for its grand dome and marble interior. Commissioned by Queen Maria I to celebrate the birth of her son and heir, the basilica stands as a testament to the queen's gratitude and devotion.",
                            history: "The basilica was built between 1779 and 1790, fulfilling a vow made by Queen Maria I. Ironically, her son died before the church was completed, and the queen herself began showing signs of mental illness by the time of its completion. The basilica is notable for its marble interior, beautiful stained glass windows, and an elaborate nativity scene comprising more than 500 cork and terracotta figures created by Joaquim Machado de Castro.",
                            adress: "Praça da Estrela, 1200-667 Lisboa"
                        ),
                        "es": MiniaturaCardTranslation(
                            titulo: "Basílica da Estrela ⭐️ ",
                            shortDescription: "Una magnífica basílica del siglo XVIII conocida por su gran cúpula y arquitectura neoclásica.",
                            description: "La Basílica da Estrela es una iglesia neoclásica y barroca en Lisboa, conocida por su gran cúpula e interior de mármol. Comisionada por la reina María I para celebrar el nacimiento de su hijo y heredero, la basílica es un testimonio de la gratitud y devoción de la reina.",
                            history: "La basílica fue construida entre 1779 y 1790, cumpliendo un voto hecho por la reina María I. Irónicamente, su hijo murió antes de que se completara la iglesia, y la propia reina comenzó a mostrar signos de enfermedad mental para cuando se completó. La basílica es notable por su interior de mármol, hermosos vitrales y un elaborado belén compuesto por más de 500 figuras de corcho y terracota creadas por Joaquim Machado de Castro.",
                            adress: "Praça da Estrela, 1200-667 Lisboa"
                        ),
                        "fr": MiniaturaCardTranslation(
                            titulo: "Basílica da Estrela ⭐️ ",
                            shortDescription: "Une magnifique basilique du XVIIIe siècle connue pour son grand dôme et son architecture néoclassique.",
                            description: "La Basilique da Estrela est une église néoclassique et baroque à Lisbonne, connue pour son grand dôme et son intérieur en marbre. Commandée par la reine Maria I pour célébrer la naissance de son fils et héritier, la basilique est un témoignage de la gratitude et de la dévotion de la reine.",
                            history: "La basilique a été construite entre 1779 et 1790, accomplissant un vœu fait par la reine Maria I. Ironiquement, son fils est mort avant que l'église ne soit terminée, et la reine elle-même a commencé à montrer des signes de maladie mentale au moment de son achèvement. La basilique est remarquable pour son intérieur en marbre, ses beaux vitraux et une scène de la nativité élaborée composée de plus de 500 figures en liège et en terre cuite créées par Joaquim Machado de Castro.",
                            adress: "Praça da Estrela, 1200-667 Lisboa"
                        )
                    ],
                    locations: [
                        (name: ["en": "Basílica da Estrela", "pt": "Basílica da Estrela", "fr": "Basílica da Estrela", "es": "Basílica da Estrela"], latitude: 38.713384, longitude: -9.160447)
                    ],
                    zoomSpan: nil,
                    customCenter: nil
                ),
                MiniaturaCard(
                    id: 6,
                    imagem: "ruinasdocarmo",
                    categoria: categoria,
                    ordem: 6,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Carmo ⛪︎ ",
                            shortDescription: "As ruínas desta igreja gótica permanecem como uma lembrança comovente do terramoto de 1755.",
                            description: "As ruínas do Convento e Igreja do Carmo permanecem como um lembrete comovente do devastador terramoto de 1755 que destruiu grande parte de Lisboa. A igreja gótica, com a sua nave sem teto aberta ao céu, é agora um museu arqueológico que abriga uma coleção de artefatos e lápides.",
                            history: "Fundado em 1389 pelo cavaleiro português Nuno Álvares Pereira, o Convento do Carmo foi outrora a maior igreja de Lisboa. Foi quase completamente destruído pelo terramoto de 1755, que ocorreu no Dia de Todos os Santos, quando a igreja estava cheia de fiéis, resultando em muitas vítimas. Após o terramoto, a Revolução Liberal de 1834 e a dissolução das ordens religiosas em Portugal, as ruínas foram preservadas como uma memória do desastre. Em 1864, a Associação dos Arqueólogos Portugueses estabeleceu um museu nas ruínas, que continua a funcionar até hoje.",
                            adress: "Largo do Carmo, 1200-092 Lisboa"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Carmo ⛪︎ ",
                            shortDescription: "Gothic ruins that bear witness to the great 1755 earthquake.",
                            description: "The ruins of the Carmo Convent and Church stand as a haunting reminder of the devastating 1755 earthquake that destroyed much of Lisbon. The Gothic church, with its roofless nave open to the sky, is now an archaeological museum housing a collection of artifacts and tombstones.",
                            history: "Fundado em 1389 pelo cavaleiro português Nuno Álvares Pereira, o Convento do Carmo já foi a maior igreja de Lisboa. Foi quase completamente destruído pelo terramoto de 1755, que atingiu a cidade no Dia de Todos os Santos, quando a igreja estava cheia de fiéis, resultando em muitas vítimas. Após o terramoto, a Revolução Liberal de 1834 e a dissolução das ordens religiosas em Portugal, as ruínas foram preservadas como uma memória do desastre. Em 1864, a Associação dos Arqueólogos Portugueses estabeleceu um museu nas ruínas, que continua a funcionar até hoje.",
                            adress: "Largo do Carmo, 1200-092 Lisboa"
                        ),
                        "es": MiniaturaCardTranslation(
                            titulo: "Carmo ⛪︎ ",
                            shortDescription: "Ruinas góticas que son testigos del gran terremoto de 1755.",
                            description: "Las ruinas del Convento e Iglesia del Carmo permanecen como un recordatorio conmovedor del devastador terremoto de 1755 que destruyó gran parte de Lisboa. La iglesia gótica, con su nave sin techo abierta al cielo, es ahora un museo arqueológico que alberga una colección de artefactos y lápidas.",
                            history: "Fundado en 1389 por el caballero portugués Nuno Álvares Pereira, el Convento del Carmo fue una vez la iglesia más grande de Lisboa. Fue casi completamente destruido por el terremoto de 1755, que azotó la ciudad el Día de Todos los Santos, cuando la iglesia estaba llena de fieles, resultando en muchas víctimas. Después del terremoto, la Revolución Liberal de 1834 y la disolución de las órdenes religiosas en Portugal, las ruinas fueron preservadas como un recuerdo del desastre. En 1864, la Asociación de Arqueólogos Portugueses estableció un museo en las ruinas, que continúa funcionando hasta hoy.",
                            adress: "Largo do Carmo, 1200-092 Lisboa"
                        ),
                        "fr": MiniaturaCardTranslation(
                            titulo: "Carmo ⛪︎ ",
                            shortDescription: "Des ruines gothiques qui témoignent du grand tremblement de terre de 1755.",
                            description: "Les ruines du Couvent et de l'Église du Carmo restent un rappel poignant du dévastateur tremblement de terre de 1755 qui a détruit une grande partie de Lisbonne. L'église gothique, avec sa nef sans toit ouverte sur le ciel, est maintenant un musée archéologique abritant une collection d'artefacts et de pierres tombales.",
                            history: "Fondé en 1389 par le chevalier portugais Nuno Álvares Pereira, le Couvent du Carmo fut autrefois la plus grande église de Lisbonne. Il fut presque complètement détruit par le tremblement de terre de 1755, qui frappa la ville le jour de la Toussaint, alors que l'église était pleine de fidèles, entraînant de nombreuses victimes. Après le tremblement de terre, la Révolution libérale de 1834 et la dissolution des ordres religieux au Portugal, les ruines furent préservées comme un souvenir du désastre. En 1864, l'Association des archéologues portugais établit un musée dans les ruines, qui continue à fonctionner jusqu'à aujourd'hui.",
                            adress: "Largo do Carmo, 1200-092 Lisboa"
                        )
                    ],
                    locations: [
                        (name: ["en": "Carmo", "pt": "Carmo", "fr": "Carmo", "es": "Carmo"], latitude: 38.7126, longitude: -9.1416)
                    ],
                    zoomSpan: nil,
                    customCenter: nil
                ),
                MiniaturaCard(
                    id: 7,
                    imagem: "cristo",
                    categoria: categoria,
                    ordem: 7,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Cristo-Rei ✝️ ",
                            shortDescription: "Uma estátua icónica de Cristo que observa a cidade do outro lado do rio Tejo.",
                            description: "Cristo-Rei, ou Cristo Rei, é um monumento e santuário católico que domina a cidade de Lisboa. Situado na margem sul do rio Tejo, na cidade de Almada, o monumento consiste numa estátua de Cristo com 28 metros de altura, com os braços levantados, em cima de um pedestal de 75 metros de altura.",
                            history: "Inspirado na estátua do Cristo Redentor no Rio de Janeiro, Brasil, o monumento Cristo-Rei foi construído como resposta a um apelo do Episcopado Português para que Deus poupasse Portugal aos horrores da Segunda Guerra Mundial. A construção começou em 1949 e foi concluída em 1959. O monumento oferece vistas panorâmicas de Lisboa e da Ponte 25 de Abril, que liga os dois lados do rio Tejo. Tornou-se um símbolo icónico de Lisboa e um importante local de peregrinação para os católicos.",
                            adress: "Av. Cristo Rei, 2800-058 Almada"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Cristo Rei ✝️ ",
                            shortDescription: "Monumental statue with panoramic views over Lisbon and the Tagus.",
                            description: "Cristo-Rei, or Christ the King, is a Catholic monument and shrine overlooking the city of Lisbon. Standing on the southern bank of the Tagus River, in the city of Almada, the monument consists of a 28-meter-tall statue of Christ with arms raised, standing on a 75-meter-tall pedestal.",
                            history: "Inspired by the Christ the Redeemer statue in Rio de Janeiro, Brazil, the Cristo-Rei monument was built as a response to a plea from the Portuguese Episcopate for God to spare Portugal from the horrors of World War II. Construction began in 1949 and was completed in 1959. The monument offers panoramic views of Lisbon and the 25 de Abril Bridge, which connects the two sides of the Tagus River. It has become an iconic symbol of Lisbon and a significant pilgrimage site for Catholics.",
                            adress: "Av. Cristo Rei, 2800-058 Almada"
                        ),
                        "es": MiniaturaCardTranslation(
                            titulo: "Cristo Rei ✝️ ",
                            shortDescription: "Una monumental estatua con vistas panorámicas sobre Lisboa y el Tajo.",
                            description: "Cristo-Rei, o Cristo Rey, es un monumento y santuario católico que domina la ciudad de Lisboa. Situado en la orilla sur del río Tajo, en la ciudad de Almada, el monumento consta de una estatua de Cristo de 28 metros de altura, con los brazos levantados, sobre un pedestal de 75 metros de altura.",
                            history: "Inspirado en la estatua del Cristo Redentor en Río de Janeiro, Brasil, el monumento Cristo-Rei fue construido como respuesta a una súplica del Episcopado Portugués para que Dios protegiera a Portugal de los horrores de la Segunda Guerra Mundial. La construcción comenzó en 1949 y se completó en 1959. El monumento ofrece vistas panorámicas de Lisboa y del Puente 25 de Abril, que conecta ambos lados del río Tajo. Se ha convertido en un símbolo icónico de Lisboa y un importante sitio de peregrinación para los católicos.",
                            adress: "Av. Cristo Rei, 2800-058 Almada"
                        ),
                    ],
                    locations: [
                        (name: ["en": "Cristo-Rei", "pt": "Cristo-Rei", "es": "Cristo-Rei", "fr": "Cristo-Rei"], latitude: 38.6781, longitude: -9.1776)
                    ],
                    zoomSpan: (latitudeDelta: 0.05, longitudeDelta: 0.05),
                    customCenter: nil
                ),
                MiniaturaCard(
                    id: 8,
                    imagem: "fatima",
                    categoria: categoria,
                    ordem: 8,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Mais Igrejas ⛪️ ",
                            shortDescription: "Fátima: visite um dos maiores santuarios do mundo.",
                            description: "O Santuário de Fátima é um dos maiores santuários marianos do mundo, atraindo milhões de peregrinos todos os anos. Localizado na cidade de Fátima, a cerca de 130 km de Lisboa, o santuário é dedicado à Virgem Maria e às aparições que ocorreram em 1917. O santuário inclui a Basílica de Nossa Senhora do Rosário, a Capela das Aparições, a Basílica da Santíssima Trindade e a Casa de Retiros de Nossa Senhora do Carmo.",
                            history: "O santuário foi construído no local onde três crianças afirmaram ter visto a Virgem Maria em seis ocasiões entre maio e outubro de 1917. As aparições de Fátima foram declaradas autênticas pela Igreja Católica em 1930, e o local tornou-se um importante destino de peregrinação para católicos de todo o mundo. O santuário é especialmente popular durante as celebrações anuais de 13 de maio e 13 de outubro, que marcam as datas das aparições.",
                            adress: "O Santuário de Fátima está localizado na cidade de Fátima, a cerca de 130 quilômetros a norte de Lisboa. A maneira mais fácil de chegar lá é de carro ou autocarro, com serviços regulares de Lisboa para Fátima. O santuário está aberto durante todo o ano e acolhe visitantes de todas as fés para rezar, refletir e experienciar a atmosfera espiritual deste lugar sagrado."
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "More Churches ⛪️ ",
                            shortDescription: "Discover other historic churches and temples in Lisbon.",
                            description: "The Sanctuary of Fátima is one of the largest Marian sanctuaries in the world, attracting millions of pilgrims every year. Located in the city of Fátima, about 130 km from Lisbon, the sanctuary is dedicated to the Virgin Mary and the apparitions that occurred in 1917. The sanctuary includes the Basilica of Our Lady of the Rosary, the Chapel of the Apparitions, the Basilica of the Most Holy Trinity and the Retreat House of Our Lady of Mount Carmel.",
                            history: "The shrine was built on the site where three children claimed to have seen the Virgin Mary on six occasions between May and October 1917. The apparitions of Fátima were declared authentic by the Catholic Church in 1930, and the site has become a major pilgrimage destination for Catholics from around the world. The shrine is especially popular during the annual celebrations of May 13 and October 13, which mark the dates of the apparitions.",
                            adress: "The Sanctuary of Fátima is located in the town of Fátima, about 130 kilometers north of Lisbon. The easiest way to get there is by car or bus, with regular services from Lisbon to Fátima. The sanctuary is open year-round and welcomes visitors of all faiths to pray, reflect, and experience the spiritual atmosphere of this sacred place."
                        ),
                        "es": MiniaturaCardTranslation(
                            titulo: "Más Iglesias ⛪️ ",
                            shortDescription: "Fátima: visita uno de los mayores santuarios del mundo.",
                            description: "El Santuario de Fátima es uno de los mayores santuarios marianos del mundo, atrayendo a millones de peregrinos cada año. Ubicado en la ciudad de Fátima, a unos 130 km de Lisboa, el santuario está dedicado a la Virgen María y a las apariciones que ocurrieron en 1917. El santuario incluye la Basílica de Nuestra Señora del Rosario, la Capilla de las Apariciones, la Basílica de la Santísima Trinidad y la Casa de Retiros de Nuestra Señora del Monte Carmelo.",
                            history: "El santuario fue construido en el sitio donde tres niños afirmaron haber visto a la Virgen María en seis ocasiones entre mayo y octubre de 1917. Las apariciones de Fátima fueron declaradas auténticas por la Iglesia Católica en 1930, y el sitio se ha convertido en un importante destino de peregrinación para los católicos de todo el mundo. El santuario es especialmente popular durante las celebraciones anuales del 13 de mayo y el 13 de octubre, que marcan las fechas de las apariciones.",
                            adress: "El Santuario de Fátima está ubicado en la ciudad de Fátima, a unos 130 kilómetros al norte de Lisboa. La forma más fácil de llegar allí es en coche o autobús, con servicios regulares desde Lisboa a Fátima. El santuario está abierto durante todo el año y da la bienvenida a visitantes de todas las fes para rezar, reflexionar y experimentar la atmósfera espiritual de este lugar sagrado."
                        ),
                        "fr": MiniaturaCardTranslation(
                            titulo: "Plus d'Églises ⛪️ ",
                            shortDescription: "Fátima : visitez l'un des plus grands sanctuaires du monde.",
                            description: "Le Sanctuaire de Fátima est l'un des plus grands sanctuaires mariaux du monde, attirant des millions de pèlerins chaque année. Situé dans la ville de Fátima, à environ 130 km de Lisbonne, le sanctuaire est dédié à la Vierge Marie et aux apparitions qui ont eu lieu en 1917. Le sanctuaire comprend la Basilique Notre-Dame du Rosaire, la Chapelle des Apparitions, la Basilique de la Très Sainte Trinité et la Maison de Retraite Notre-Dame du Mont Carmel.",
                            history: "Le sanctuaire a été construit sur le site où trois enfants ont affirmé avoir vu la Vierge Marie à six reprises entre mai et octobre 1917. Les apparitions de Fátima ont été déclarées authentiques par l'Église catholique en 1930, et le site est devenu une destination majeure de pèlerinage pour les catholiques du monde entier. Le sanctuaire est particulièrement populaire lors des célébrations annuelles du 13 mai et du 13 octobre, qui marquent les dates des apparitions.",
                            adress: "Le Sanctuaire de Fátima est situé dans la ville de Fátima, à environ 130 kilomètres au nord de Lisbonne. Le moyen le plus simple d'y parvenir est en voiture ou en bus, avec des services réguliers de Lisbonne à Fátima. Le sanctuaire est ouvert toute l'année et accueille les visiteurs de toutes confessions pour prier, réfléchir et vivre l'atmosphère spirituelle de ce lieu sacré."
                        )
                    ],
                    locations: [
                        (name: ["en": "Santuário de Fátima", "pt": "Santuário de Fátima", "es": "Santuario de Fátima", "fr": "Sanctuaire de Fátima"], latitude: 39.6325, longitude: -8.6718)
                    ],
                    zoomSpan: (latitudeDelta: 2, longitudeDelta: 2),
                    customCenter: (39.265545, -8.792261)
                )
            ]
        }
        if cat == "museus" || cat == "museums" {
            return [
                MiniaturaCard(
                    id: 1,
                    imagem: "azulejos_museu",
                    categoria: categoria,
                    ordem: 1,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Museu dos Azulejos 🔹\nEncerrado para obras",
                            shortDescription: "O Museu Nacional do Azulejo mostra cinco séculos de azulejos decorativos, uma forma de arte portuguesa.",
                            description: "O Museu Nacional do Azulejo é dedicado à arte do azulejo, uma forma de arte decorativa tradicional em Portugal. O museu exibe uma impressionante coleção de azulejos decorativos, datados desde meados do século XV até os dias de hoje, mostrando a evolução desta forma de arte ao longo dos séculos.",
                            destaques: "Azulejos históricos de igrejas, palácios e edifícios públicos, bem como exemplos de azulejos de artistas contemporâneos. O museu também abriga exposições temporárias e programas educativos que exploram a história e a técnica do azulejo, bem como o seu papel na cultura portuguesa.",
                            adress: "Rua da Madre de Deus, 4, 1900-312 Lisbon"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Tile Museum 🔹\nClosed for works",
                            shortDescription: "Celebrates the art of Portuguese tiles from the 15th century to today.",
                            description: "The Tile Museum (Portuguese: Museu Nacional do Azulejo) is dedicated to the art of azulejo, a traditional decorative art form in Portugal. The museum exhibits an impressive collection of decorative tiles, dating from the mid-15th century to the present day, showing the evolution of this art form over the centuries.",
                            destaques: "The museum's highlights include historical tiles from churches, palaces, and public buildings, as well as examples of tiles by contemporary artists. The museum also houses temporary exhibitions and educational programs that explore the history and technique of azulejo, as well as its role in Portuguese culture.",
                            adress: "Rua da Madre de Deus, 4, 1900-312 Lisbon"
                        ),
                        "es": MiniaturaCardTranslation(
                            titulo: "Museo Nacional de Azulejos 🔹\nCerrado por obras",
                            shortDescription: "Celebra la arte de los mosaicos portugueses desde el siglo XV hasta hoy.",
                            description: "El Museo Nacional de Azulejos (Portugués: Museu Nacional do Azulejo) se dedica a la arte del azulejo, un tradicional arte de decoración en Portugal. El museo alberga una impresionante colección de mosaicos decorativos, que van desde la mitad del siglo XV hasta hoy, mostrando la evolución de esta arte durante los siglos.",
                            destaques: "Los destacados del museo incluyen mosaicos históricos de iglesias, palacios y edificios públicos, así como ejemplos de mosaicos de artistas contemporáneos. El museo también alberga exposiciones temporales y programas educativos que exploran la historia y la técnica del azulejo, así como su papel en la cultura portuguesa.",
                            adress: "Rua da Madre de Deus, 4, 1900-312 Lisboa"
                            ),
                        "fr": MiniaturaCardTranslation(
                            titulo: "Musée National des Azulejos 🔹\nFermé pour travaux",
                            shortDescription: "Profitez des œuvres d'art des azulejos portugaise depuis le XVIe siècle à nos jours.",
                            description: "Le Musée National des Azulejos (allemand : Landesmuseum Azulejos) se consacre à l'art de l'azulejo, un art traditionnel de décoration en Portugal. Le musée possède une impressionnante collection de mosaïques décoratifs, qui vont de la moitié du XVIe siècle à nos jours, montrant l'évolution de cet art au fil des siècles.",
                            destaques: "Les œuvres les plus remarquables du musée incluent des mosaïques historiques d'église, de château et d'édifices publics, ainsi que des exemples de mosaïques d'artistes contemporains. Le musée propose également des expositions temporaires et des programmes éducatifs qui explorent l'histoire et la technique de l'azulejo, ainsi que son rôle dans la culture portugaise.",
                            adress: "Rua da Madre de Deus, 4, 1900-312 Lisboa"
                            )
                    ],
                    locations: [
                        (name: ["en": "Museu dos Azulejos", "pt": "Museu dos Azulejos", "fr": "Musée National des Azulejos", "es": "Museo Nacional de los Azulejos"], latitude: 38.7231, longitude: -9.1156)
                    ],
                    zoomSpan: (latitudeDelta: 0.2, longitudeDelta: 0.2),
                    customCenter: nil
                ),
                MiniaturaCard(
                    id: 2,
                    imagem: "fcg",
                    categoria: categoria,
                    ordem: 2,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Museu Gulbenkian 🖼️ ",
                            shortDescription: "Um centro cultural que abriga coleções de arte excepcionais, desde a antiguidade até a era moderna.",
                            description: "O Museu Calouste Gulbenkian é um dos principais museus de arte em Lisboa, com uma coleção diversificada que abrange arte antiga, arte moderna e arte contemporânea. O museu foi fundado por Calouste Gulbenkian, um colecionador de arte e filantropo armênio, que doou sua coleção à nação portuguesa.",
                            destaques: "Pinturas de artistas como Rembrandt, Rubens, Monet e Renoir, esculturas de Rodin e Degas, e arte decorativa de várias culturas. O museu também abriga exposições temporárias, concertos e eventos culturais que enriquecem a experiência dos visitantes.",
                            adress: "Av. de Berna 45A, 1067-001 Lisbon"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Gulbenkian Museum ",
                            shortDescription: "World-class art collection, from Egypt to modern art.",
                            description: "Calouste Gulbenkian Museum is one of the main art museums in Lisbon, with a diverse collection spanning ancient art, modern art, and contemporary art. The museum was founded by Calouste Gulbenkian, an Armenian art collector and philanthropist, who donated his collection to the Portuguese nation.",
                            destaques: "The museum's highlights include paintings by artists such as Rembrandt, Rubens, Monet, and Renoir, sculptures by Rodin and Degas, and decorative art from various cultures. The museum also houses temporary exhibitions, concerts, and cultural events that enrich visitors' experience.",
                            adress: "Av. de Berna 45A, 1067-001 Lisbon"
                        ),
                        "es": MiniaturaCardTranslation(
                            titulo: "Museo Gulbenkian",
                            shortDescription: "Una de las colecciones de arte más prestigiosas del mundo, desde Egipto hasta la arte moderna.",
                            description: "El Museo Gulbenkian es uno de los museos de arte más importantes de Lisboa, con una colección diversa que abarca el arte antiguo, el arte moderno y el arte contemporáneo. Fue fundada por Calouste Gulbenkian, un coleccionista y filantropo armenio que donó su colección a la nación portuguesa.",
                            destaques: "Pinturas de artistas como Rembrandt, Rubens, Monet y Renoir, esculturas de Rodin y Degas, y arte decorativo de diversas culturas. El museo también alberga exposiciones temporales, conciertos y eventos culturales que enriquecen la experiencia de los visitantes.",
                            adress: "Av. de Berna 45A, 1067-001 Lisboa"
                            ),
                        "fr": MiniaturaCardTranslation(
                            titulo: "Musée Gulbenkian",
                            shortDescription: "Une des plus grandes collections d'art du monde, allant de l'Égypte aux œuvres modernes.",
                            description: "Le Musée Gulbenkian est l'un des musées d'art les plus importants de Lisboa, avec une collection variée couvrant l'art ancien, le moderne et le contemporain. Fondé par le collecter et le philanthropiste arménien Calouste Gulbenkian, il a transféré sa collection à la République portuguesa.",
                            destaques: "Peintures d'artistes comme Rembrandt, Rubens, Monet et Renoir, des escultures de Rodin et Degas, ainsi que de l'art décoration de diverses cultures. Le musée accueille également des expositions temporaires, des concerts et des événements culturels qui enrichissent l'expérience des visiteurs.",
                            adress: "Av. de Berna 45A, 1067-001 Lisboa"
                            )
                    ],
                    locations: [
                        (name: ["en": "Museu Gulbenkian", "pt": "Museu Gulbenkian", "fr": "Musée Gulbenkian", "es": "Museo Gulbenkian"], latitude: 38.7371, longitude: -9.1527)
                    ],
                    zoomSpan: (latitudeDelta: 0.2, longitudeDelta: 0.2),
                    customCenter: nil
                ),
                MiniaturaCard(
                    id: 3,
                    imagem: "coches",
                    categoria: categoria,
                    ordem: 3,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Museu dos Coches 🎠🎠 ",
                            shortDescription: "O Museu Nacional dos Coches exibe uma das mais requintadas coleções de carruagens históricas do mundo.",
                            description: "O Museu Nacional dos Coches é um museu dedicado à história das carruagens e cocheiras reais em Portugal. Fundado em 1905, o museu abriga uma das mais importantes coleções de carruagens históricas do mundo, incluindo veículos usados pela realeza portuguesa e outras figuras históricas.",
                            destaques: "Carruagens reais dos séculos XVII ao XIX, incluindo a Carruagem do Rei João V, a Carruagem da Rainha Maria Pia e a Carruagem da Rainha Amélia. O museu também abriga exposições temporárias, oficinas e eventos educativos que exploram a história e a arte das cocheiras.",
                            adress: "Praça Afonso de Albuquerque, 1300-004 Lisbon"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Coach Museum 🎠🎠 ",
                            shortDescription: "The world's largest collection of royal coaches.",
                            description: "The Coach Museum (Portuguese: Museu dos Coches) is a museum dedicated to the history of royal coaches and carriages in Portugal. Founded in 1905, the museum houses one of the most important collections of historical carriages in the world, including vehicles used by Portuguese royalty and other historical figures.",
                            destaques: "The museum's highlights include royal carriages from the 17th to the 19th century, including the Carriage of King João V, the Carriage of Queen Maria Pia, and the Carriage of Queen Amélia. The museum also houses temporary exhibitions, workshops, and educational events that explore the history and art of coaches.",
                            adress: "Praça Afonso de Albuquerque, 1300-004 Lisbon"
                        ),
                        "es": MiniaturaCardTranslation(
                            titulo: "Museo de las Carrozas 🎠🎠 ",
                            shortDescription: "La colección más grande de carrozas reales de corte royal.",
                            description: "El Museo Nacional de las Carrozas (Português: Museu dos Coches) es un museo dedicado a la historia de los carruajes y las caballerizas reales en Portugal. Fundado en 1905, el museo alberga una de las colecciones más importantes de carrozas históricos del mundo, incluyendo vehículos utilizados por la corte portuguesa y otras figuras históricas.",
                            destaques: "Carrozas reales de los siglos XVII a XIX, incluidos la Carroza de Príncipe João V, la Carroza de Reina María Pia y la Carroza de Reina Amelia. El museo también alberga exposiciones temporales, talleres y eventos educativos que exploran la historia y el arte de las carrozas.",
                            adress: "Praça Afonso de Albuquerque, 1300-004 Lisboa"
                        ),
                        "fr": MiniaturaCardTranslation(
                            titulo: "Musée des Carrosses 🎠🎠",
                            shortDescription: "La plus grande collection de carrosses d'époque royale de Portugal.",
                            description: "Le Musée National des Carrosses (Português: Museu dos Coches) est un musée dédié à l'histoire des carrosses et des écuries royales au Portugal. Fondé en 1905, le musée abrite l'une des collections les plus importantes de voitures historiques au monde, comprenant véhicules utilisés par la corte portuguesa et d'autres figures historiques.",
                            destaques: "Les éléments emblématiques du musée incluent les carrosses réelles des siècles XVII à XIX, notamment le carrosse du Prince João V, le carrosse de la reine Marie Pia et le carrosse de la reine Amelia. Le musée propose également des expositions temporaires, des ateliers et des événements éducatifs qui explorent l'histoire et l'art des carrosses.",
                            adress: "Praça Afonso de Albuquerque, 1300-004 Lisboa"
                            )
                    ],
                    locations: [
                        (name: ["en": "Museu dos Coches", "pt": "Museu dos Coches", "fr": "Musée des Carrosses", "es": "Museo de las Carrozas"], latitude: 38.6973, longitude: -9.1976)
                    ],
                    zoomSpan: (latitudeDelta: 0.1, longitudeDelta: 0.1),
                    customCenter: nil
                ),
                MiniaturaCard(
                    id: 4,
                    imagem: "fado",
                    categoria: categoria,
                    ordem: 4,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Museu do Fado 🎵 ",
                            shortDescription: "Conheça a história e a tradição do fado, um género musical português.",
                            description: "O Museu do Fado é dedicado à história e cultura do fado, um género musical tradicional português. Localizado no bairro histórico de Alfama, o museu apresenta exposições interativas, concertos ao vivo e oficinas que celebram a rica tradição do fado.",
                            destaques: "Exposições sobre os grandes cantores de fado de Portugal, instrumentos musicais tradicionais usados no fado e a evolução do género ao longo dos séculos. O museu também abriga concertos regulares de fado, onde os visitantes podem experienciar a emoção e a paixão deste estilo musical único.",
                            adress: "Largo do Chafariz de Dentro, 1, 1100-139 Lisbon"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Fado Museum 🎵 ",
                            shortDescription: "Dedicated to the history and culture of Fado, Lisbon's music.",
                            description: "The Fado Museum (Portuguese: Museu do Fado) is dedicated to the history and culture of fado, a traditional Portuguese musical genre. Located in the historic neighborhood of Alfama, the museum presents interactive exhibitions, live concerts, and workshops that celebrate the rich tradition of fado.",
                            destaques: "The museum's highlights include exhibitions about Portugal's great fado singers, traditional musical instruments used in fado, and the evolution of the genre over the centuries. The museum also houses regular fado concerts, where visitors can experience the emotion and passion of this unique musical style.",
                            adress: "Largo do Chafariz de Dentro, 1, 1100-139 Lisbon"
                        ),
                        "es": MiniaturaCardTranslation(
                            titulo: "Museo del Fado 🎶",
                            shortDescription: "Homenaje a la tradición y la cultura del Fado, con música portuguesa.",
                            description: "El Museo del Fado (en: Museum of Fado) se dedica a preservar la historia y la cultura del fado, un género musical tradicional de Portugal. Situado en el barrio histórico de Alfama, el museo ofrece exposiciones interactivas, conciertos en vivo y talleres que celebran la rica tradición del fado.",
                            destaques: "Eposiciones sobre los grandes cantantes de fado de Portugal, instrumentos musicales tradicionales utilizados en el fado y la evolución del género a lo largo de los siglos. El museo también alberga conciertos regulares de fado, donde los visitantes pueden experimentar la emoción y pasión de este estilo musical único.",
                            adress: "Largo do Chafariz de Dentro, 1, 1100-139 Lisboa"
                        ),
                        "fr": MiniaturaCardTranslation(
                            titulo: "Musée du Fado 🎵",
                            shortDescription: "Découvrez l'histoire et la tradition du fado, un genre musical portugais.",
                            description: "Le Musée du Fado (Portuguese: Museu do Fado) est dédié à l'histoire et à la culture du fado, un genre musical traditionnel portugais. Situé dans le quartier historique de l'Alfama, le musée propose des expositions interactives, des concerts en direct et des ateliers qui célèbrent la riche tradition du fado.",
                            destaques: "Les points forts du musée comprennent des expositions sur les grands chanteurs de fado du Portugal, les instruments de musique traditionnels utilisés dans le fado et l'évolution du genre au fil des siècles. Le musée accueille également des concerts réguliers de fado, où les visiteurs peuvent ressentir l'émotion et la passion de ce style musical unique.",
                            adress: "Largo do Chafariz de Dentro, 1, 1100-139 Lisboa"
                            )
                    ],
                    locations: [
                        (name: ["en": "Museu do Fado", "pt": "Museu do Fado", "fr": "Musée du Fado", "es": "Museo del Fado"], latitude: 38.7132, longitude: -9.1296)
                    ],
                    zoomSpan: nil,
                    customCenter: nil
                ),
                MiniaturaCard(
                    id: 5,
                    imagem: "arte_antiga",
                    categoria: categoria,
                    ordem: 5,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Museu de Arte Antiga\nEncerrado para obras",
                            shortDescription: "Museu Nacional de Arte Antiga 🖼️ abriga as mais refinadas coleções de arte portuguesa e europeia.",
                            description: "O Museu de Arte Antiga 🖼️ é o principal museu de arte de Portugal, com uma coleção abrangente que cobre pintura, escultura, artes decorativas e artes aplicadas. Fundado em 1884, o museu é conhecido pela sua coleção de arte portuguesa e europeia, abrangendo desde a Idade Média até ao século XIX.",
                            destaques: "Pinturas de artistas como Hieronymus Bosch, Albrecht Dürer, Pieter Bruegel, Rembrandt, Rubens e Velázquez, bem como esculturas, cerâmicas, têxteis e mobiliário. O museu também abriga exposições temporárias, concertos e eventos culturais que enriquecem a experiência dos visitantes.",
                            adress: "R. das Janelas Verdes, 1249-017 Lisboa"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Ancient Art Museum\nClosed for renovation",
                            shortDescription: "Masterpieces of Portuguese and European art 🖼️ from the 12th to 19th centuries.",
                            description: "The Museum of Ancient Art 🖼️ is Portugal's main art museum, with a comprehensive collection covering painting, sculpture, decorative arts, and applied arts. Founded in 1884, the museum is known for its collection of Portuguese and European art, spanning from the Middle Ages to the 19th century.",
                            destaques: "The museum's highlights include paintings by artists such as Hieronymus Bosch, Albrecht Dürer, Pieter Bruegel, Rembrandt, Rubens, and Velázquez, as well as sculptures, ceramics, textiles, and furniture. The museum also houses temporary exhibitions, concerts, and cultural events that enrich the visitors' experience.",
                            adress: "R. das Janelas Verdes, 1249-017 Lisboa"
                        ),
                        "fr": MiniaturaCardTranslation(
                            titulo: "Musée National d'Art Ancien\nFermé pour rénovation",
                            shortDescription: "Le plus important musée d'art du Portugal.",
                            description: "Le musée abrite la plus grande collection d'art portugais, européen et oriental du pays, couvrant des œuvres du XIIe au XIXe siècle. Il est situé dans un palais du XVIIe siècle et possède des peintures, sculptures, bijoux et arts décoratifs de grande valeur historique.",
                            history: "Fondé en 1884, il est devenu le principal musée d'art du Portugal.",
                            destaques: "Peintures de Nuno Gonçalves, triptyque des Templiers, collections d'art oriental.",
                            adress: "Rua das Janelas Verdes, Lisboa"
                        ),
                        "es": MiniaturaCardTranslation(
                            titulo: "Museo de Arte Antiguo\nCerrado para rehabilitación",
                            shortDescription: "El Museo Nacional de Arte Antiguo 🖼️ alberga las colecciones más refinadas de arte portugués y europeo.",
                            description: "El Museo de Arte Antiguo 🖼️ es el principal museo de arte de Portugal, con una colección completa que abarca pintura, escultura, artes decorativas y artes aplicadas. Fundado en 1884, el museo es conocido por su colección de arte portugués y europeo, que abarca desde la Edad Media hasta el siglo XIX.",
                            destaques: "Pinturas de artistas como Hieronymus Bosch, Albrecht Dürer, Pieter Bruegel, Rembrandt, Rubens y Velázquez, así como esculturas, cerámicas, textiles y muebles. El museo también alberga exposiciones temporales, conciertos y eventos culturales que enriquecen la experiencia de los visitantes.",
                            adress: "R. das Janelas Verdes, 1249-017 Lisboa"
                        )
                    ],
                    locations: [
                        (name: ["en": "Museu de Arte Antiga", "pt": "Museu de Arte Antiga", "es": "Museo de Arte Antiguo", "fr": "Musée d'Art Ancien"], latitude: 38.7074, longitude: -9.1702)
                    ],
                    zoomSpan: (latitudeDelta: 0.1, longitudeDelta: 0.1),
                    customCenter: nil
                ),
                MiniaturaCard(
                    id: 6,
                    imagem: "ccb",
                    categoria: categoria,
                    ordem: 6,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "CCB 🖼️ ",
                            shortDescription: "Centro Cultural de Belém: exposições, concertos e arte contemporânea.",
                            description: "O CCB (Centro Cultural de Belém) é uma das mais importantes instituições culturais de Lisboa, abrigando uma impressionante coleção de arte contemporânea e design. O museu apresenta obras de alguns dos maiores artistas da arte contemporânea incluindo Andy Warhol, Ai Weiwei, Olafur Eliasson e Anish Kapoor. Os visitantes podem explorar a extensa coleção do museu de pinturas, esculturase instalações, bem como os seus belos jardins e sala de concertos.",
                            destaques: "Os destaques do museu incluem obras de alguns dos maiores artistas da história, como Andy Warhol, Ai Weiwei, Olafur Eliasson e Anish Kapoor, bem como pinturas, esculturas e instalações. O museu também abriga exposições temporárias, concertos e eventos culturais que enriquecem a experiência dos visitantes, para além dos seus belos jardins e sala de concertos.",
                            adress: "Praça do Império, 1449-003 Lisboa"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "CCB 🖼️ ",
                            shortDescription: "Belém Cultural Center: exhibitions, concerts, and contemporary art.",
                            description: "The CCB (Portuguese: Centro Cultural de Belém) is one of Lisbon's most important cultural institutions, housing an impressive collection of contemporary art and design. The museum features works by some of the greatest artists in history, including ANdy Warhol, Ai Weiwei, Olafur Eliasson, and Anish Kapoor. Visitors can explore the museum's extensive collection of paintings, sculptures, and installations, as well as its beautiful gardens and concert hall.",
                            destaques: "The museum's highlights include works by some of the greatest artists in history, such as Andy Warhol, Ai Weiwei, Olafur Eliasson, and Anish Kapoor, as well as paintings, sculptures, and installations. The museum also houses temporary exhibitions, concerts, and cultural events that enrich visitors' experience, in addition to its beautiful gardens and concert hall.",
                            adress: "Praça do Império, 1449-003 Lisboa"
                        ),
                        "es": MiniaturaCardTranslation(
                            titulo: "CCB 🖼️ ",
                            shortDescription: "Centro Cultural de Belém: exposiciones, conciertos y arte contemporáneo.",
                            description: "El CCB (Centro Cultural de Belém) es una de las instituciones culturales más importantes de Lisboa, que alberga una impresionante colección de arte contemporáneo y diseño. El museo presenta obras de algunos de los artistas más grandes de la historia, incluyendo Andy Warhol, Ai Weiwei, Olafur Eliasson y Anish Kapoor. Los visitantes pueden explorar la extensa colección del museo de pinturas, esculturas e instalaciones, así como sus hermosos jardines y sala de conciertos.",
                            destaques: "Obras de algunos de los artistas más grandes del arte contemporáneo como Andy Warhol, Ai Weiwei, Olafur Eliasson y Anish Kapoor, así como pinturas, esculturas e instalaciones. El museo también alberga exposiciones temporales, conciertos y eventos culturales que enriquecen la experiencia de los visitantes, además de sus hermosos jardines y sala de conciertos.",
                            adress: "Praça do Império, 1449-003 Lisboa"
                        ),
                        "fr": MiniaturaCardTranslation(
                            titulo: "CCB 🖼️ ",
                            shortDescription: "Centre Culturel de Belém : expositions, concerts et art contemporain.",
                            description: "Le CCB (Centro Cultural de Belém) est l'une des institutions culturelles les plus importantes de Lisbonne, abritant une impressionnante collection d'art contemporain et de design. Le musée présente des œuvres de certains des plus grands artistes de l'histoire, dont Andy Warhol, Ai Weiwei, Olafur Eliasson et Anish Kapoor. Les visiteurs peuvent explorer la vaste collection du musée de peintures, sculptures et installations, ainsi que ses beaux jardins et sa salle de concert.",
                            destaques: "Les points forts du musée comprennent des œuvres de certains des plus grands artistes de l'histoire, tels qu'Andy Warhol, Ai Weiwei, Olafur Eliasson et Anish Kapoor, ainsi que des peintures, sculptures et installations. Le musée accueille également des expositions temporaires, des concerts et des événements culturels qui enrichissent l'expérience des visiteurs, en plus de ses beaux jardins et de sa salle de concert.",
                            adress: "Praça do Império, 1449-003 Lisboa"
                            )
                    ],
                    locations: [
                        (name: ["en": "CCB", "pt": "CCB", "fr": "CCB", "es": "CCB"], latitude: 38.6956, longitude: -9.2070)
                    ],
                    zoomSpan: nil,
                    customCenter: nil
                ),
                MiniaturaCard(
                    id: 7,
                    imagem: "maat",
                    categoria: categoria,
                    ordem: 7,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "MAAT 🖼️ ",
                            shortDescription: "Museu de Arte, Arquitetura e Tecnologia, que mostra expressões artísticas contemporâneas.",
                            description: "O MAAT (Museu de Arte, Arquitetura e Tecnologia) é um museu de arte, arquitetura e tecnologia em Lisboa, dedicado a explorar as interseções entre arte, ciência e tecnologia. Localizado na zona ribeirinha de Belém, o museu apresenta exposições inovadoras, instalações interativas e eventos culturais que desafiam os limites tradicionais da arte e da tecnologia.",
                            destaques: "Exposições de arte contemporânea, arquitetura experimental, design inovador e tecnologia emergente. O museu também acolhe eventos culturais, oficinas e palestras que exploram as últimas tendências e práticas em arte, arquitetura e tecnologia.",
                            adress: "Av. Brasília, 1300-598 Lisbon"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "MAAT 🖼️ ",
                            shortDescription: "Museum of Art, Architecture and Technology by the Tagus river.",
                            description: "MAAT (Portuguese: Museu de Arte Arquitectura e Tecnologia) is a museum of art, architecture, and technology in Lisbon, dedicated to exploring the intersections between art, science, and technology. Located in the riverside area of Belém, the museum presents innovative exhibitions, interactive installations, and cultural events that challenge the traditional boundaries of art and technology.",
                            destaques: "The museum's highlights include exhibitions of contemporary art, experimental architecture, innovative design, and emerging technology. The museum also hosts cultural events, workshops, and lectures that explore the latest trends and practices in art, architecture, and technology.",
                            adress: "Av. Brasília, 1300-598 Lisbon"
                        ),
                        "es": MiniaturaCardTranslation(
                            titulo: "MAAT 🖼️ ",
                            shortDescription: "Museo de Arte, Arquitectura y Tecnología a orillas del río Tajo.",
                            description: "El MAAT (Museo de Arte, Arquitectura y Tecnología) es un museo de arte, arquitectura y tecnología en Lisboa, dedicado a explorar las intersecciones entre arte, ciencia y tecnología. Ubicado en la zona ribereña de Belém, el museo presenta exposiciones innovadoras, instalaciones interactivas y eventos culturales que desafían los límites tradicionales del arte y la tecnología.",
                            destaques: "Exposiciones de arte contemporáneo, arquitectura experimental, diseño innovador y tecnología emergente. El museo también alberga eventos culturales, talleres y conferencias que exploran las últimas tendencias y prácticas en arte, arquitectura y tecnología.",
                            adress: "Av. Brasília, 1300-598 Lisboa"
                        ),
                        "fr": MiniaturaCardTranslation(
                            titulo: "MAAT 🖼️ ",
                            shortDescription: "Musée d'Art, d'Architecture et de Technologie au bord du fleuve Tage.",
                            description: "Le MAAT (Museu de Arte, Arquitectura e Tecnologia) est un musée d'art, d'architecture et de technologie à Lisbonne, dédié à l'exploration des intersections entre l'art, la science et la technologie. Situé dans la zone riveraine de Belém, le musée présente des expositions innovantes, des installations interactives et des événements culturels qui repoussent les limites traditionnelles de l'art et de la technologie.",
                            destaques: "Expositions d'art contemporain, d'architecture expérimentale, de design innovant et de technologie émergente. Le musée accueille également des événements culturels, des ateliers et des conférences qui explorent les dernières tendances et pratiques en matière d'art, d'architecture et de technologie.",
                            adress: "Av. Brasília, 1300-598 Lisboa"
                            )
                    ],
                    locations: [
                        (name: ["en": "MAAT", "pt": "MAAT", "fr": "MAAT", "es": "MAAT"], latitude: 38.6952, longitude: -9.1970)
                    ],
                    zoomSpan: nil,
                    customCenter: nil
                ),
                MiniaturaCard(
                    id: 8,
                    imagem: "plus_museums",
                    categoria: categoria,
                    ordem: 8,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Mais Museus + ",
                            shortDescription: "Explore  mais museus. Qual é o assunto que mais lhe interessa?",
                            description: "Além dos 7 museus mencionados, Lisboa tem muitos mais museus para visitar. Estes museus cobrem uma ampla gama de tópicos, desde arte e história até ciência e tecnologia, proporcionando uma visão abrangente do rico património cultural de Portugal.",
                            destaques: "Museu do Terramoto, Museu Nacional de Arte Contemporânea, Museu Nacional de História Natural e da Ciência, Museu da Marioneta, Museu da Farmácia e Museu do Oriente. Cada museu oferece exposições únicas, programas educativos e eventos culturais que enriquecem a experiência dos visitantes.",
                            adress: "Vários locais em Lisboa"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "More Museums + ",
                            shortDescription: "Discover other fascinating museums in Lisbon.",
                            description: "In addition to the 7 museums mentioned, Lisbon has many more museums to visit. These museums cover a wide range of topics, from art and history to science and technology, providing a comprehensive view of Portugal's rich cultural heritage.",
                            destaques: "Quake Museum, National Museum of Contemporary Art, National Museum of Natural History and Science, Puppet Museum, Pharmacy Museum and Orient Museum. Each museum offers unique exhibitions, educational programs, and cultural events that enrich the visitors' experience.",
                            adress: "Various locations in Lisbon'"
                        ),
                        "es": MiniaturaCardTranslation(
                            titulo: "Más Museos + ",
                            shortDescription: "Descubre otros fascinantes museos en Lisboa.",
                            description: "Además de los 7 museos mencionados, Lisboa tiene muchos más museos para visitar. Estos museos cubren una amplia gama de temas, desde arte e historia hasta ciencia y tecnología, proporcionando una visión completa del rico patrimonio cultural de Portugal.",
                            destaques: "Museo del Terremoto, Museo Nacional de Arte Contemporáneo, Museo Nacional de Historia Natural y Ciencia, Museo de la Marioneta, Museo de la Farmacia y Museo del Oriente. Cada museo ofrece exposiciones únicas, programas educativos y eventos culturales que enriquecen la experiencia de los visitantes.",
                            adress: "Varios lugares en Lisboa"
                        ),
                        "fr": MiniaturaCardTranslation(
                            titulo: "Plus de Musées + ",
                            shortDescription: "Découvrez d'autres musées fascinants à Lisbonne.",
                            description: "En plus des 7 musées mentionnés, Lisbonne compte de nombreux autres musées à visiter. Ces musées couvrent une large gamme de sujets, de l'art et de l'histoire à la science et à la technologie, offrant une vue complète du riche patrimoine culturel du Portugal.",
                            destaques: "Musée du Tremblement de Terre, Musée National d'Art Contemporain, Musée National d'Histoire Naturelle et des Sciences, Musée de la Marionnette, Musée de la Pharmacie et Musée de l'Orient. Chaque musée propose des expositions uniques, des programmes éducatifs et des événements culturels qui enrichissent l'expérience des visiteurs.",
                            adress: "Divers endroits à Lisbonne"
                            )
                    ],
                    locations: [
                        (name: ["en": "Quake Museum", "pt": "Museu do Terramoto", "fr": "Musée du Tremblement de Terre", "es": "Museo del Terremoto"], latitude: 38.697070, longitude:  -9.196989),
                        (name: ["en": "MNAC", "pt": "MNAC", "fr": "Musée National d'Art Contemporain", "es": "Museo Nacional de Arte Contemporáneo"], latitude: 38.708404, longitude: -9.141254),
                        (name: ["en": "Museu de História Natural", "pt": "Museu de História Natural", "fr": "Musée National d'Histoire Naturelle et des Sciences", "es": "Museo Nacional de Historia Natural y Ciencias"], latitude: 38.717759, longitude: -9.150756),
                        (name: ["en": "Museu do Oriente", "pt": "Museu do Oriente", "fr": "Musée de l'Orient", "es": "Museo del Oriente"], latitude: 38.702849, longitude: -9.170761),
                        (name: ["en": "Museu da Marioneta", "pt": "Museu da Marioneta", "fr": "Musée de la Marionnette", "es": "Museo de la Marioneta"], latitude: 38.707945, longitude: -9.155775),
                        (name: ["en": "Museu da Farmácia", "pt": "Museu da Farmácia", "fr": "Musée de la Pharmacie", "es": "Museo de la Farmacia"], latitude: 38.710158, longitude: -9.147348),
                        (name: ["en": "Museu do Oriente", "pt": "Museu do Oriente", "fr": "Musée de l'Orient", "es": "Museo del Oriente"], latitude: 38.711874, longitude: -9.130478)
                    ],
                    zoomSpan: (latitudeDelta: 0.1, longitudeDelta: 0.1),
                    customCenter: (38.702849, -9.170761)
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
                            titulo: "Pena Palace 🏰 ",
                            shortDescription: "A colorful Romanticist palace on a hilltop, symbol of Sintra.",
                            description: "The National Palace of Pena is a 19th-century Romantic palace made of stone and stucco, situated on the top of the Sintra Mountains. It stands out for its eclectic style, with neo-Gothic, neo-Manueline, and Moorish elements, and for its vibrant colors, visible from the entire surrounding area. The palace is a testament to the king's passion for art and history, combining elements from various periods and cultures.",
                            history: "The Pena Palace was built on the site of an old monastery that was destroyed during the 1755 earthquake. King Ferdinand II acquired the land in 1838 and began construction of the palace in 1842. The palace was completed in 1854 and became the summer residence of the Portuguese royal family. After the fall of the monarchy in 1910, the palace was converted into a museum and opened to the public. The main architect responsible for transforming the monastery into a palace was Baron von Eschwege.",
                            adress: "Estrada da Pena, 2710-609 Sintra"
                        ),
                        "pt": MiniaturaCardTranslation(
                            titulo: "Palácio da Pena 🏰 ",
                            shortDescription: "Palácio romântico e colorido no topo da serra, símbolo de Sintra.",
                            description: "O Palácio Nacional da Pena é um palácio romântico do século XIX, construído em pedra e estuque, situado no topo da Serra de Sintra. Destaca-se pelo seu estilo eclético, com elementos neogóticos, neo-manuelinos e mouriscos, e pelas suas cores vibrantes, visíveis de toda a área circundante. O palácio é um testemunho da paixão do rei pela arte e história, combinando elementos de vários períodos e culturas.",
                            history: "O Palácio da Pena foi construído no local de um antigo mosteiro que foi destruído durante o terramoto de 1755. O rei Fernando II adquiriu o terreno em 1838 e iniciou a construção do palácio em 1842. O palácio foi concluído em 1854 e tornou-se a residência de verão da família real portuguesa. Após a queda da monarquia em 1910, o palácio foi convertido em museu e aberto ao público. O principal arquiteto responsável pela transformação do mosteiro em palácio foi o Barão von Eschwege.",
                            adress: "Estrada da Pena, 2710-609 Sintra"
                        ),
                        "es": MiniaturaCardTranslation(
                            titulo: "Palacio da Pena 🏰 ",
                            shortDescription: "Palacio romántico y colorido en la cima de la sierra, símbolo de Sintra.",
                            description: "El Palacio Nacional da Pena es un palacio romántico del siglo XIX, construido en piedra y estuco, situado en la cima de la Sierra de Sintra. Destaca por su estilo ecléctico, con elementos neogóticos, neo-manuelinos y moriscos, y por sus colores vibrantes, visibles desde toda el área circundante. El palacio es un testimonio de la pasión del rey por el arte y la historia, combinando elementos de varios períodos y culturas.",
                            history: "El Palacio da Pena fue construido en el sitio de un antiguo monasterio que fue destruido durante el terremoto de 1755. El rey Fernando II adquirió el terreno en 1838 e inició la construcción del palacio en 1842. El palacio fue completado en 1854 y se convirtió en la residencia de verano de la familia real portuguesa. Después de la caída de la monarquía en 1910, el palacio fue convertido en museo y abierto al público. El principal arquitecto responsable de transformar el monasterio en palacio fue el Barón von Eschwege.",
                            adress: "Estrada da Pena, 2710-609 Sintra"
                        ),
                        "fr": MiniaturaCardTranslation(
                            titulo: "Palácio da Pena 🏰 ",
                            shortDescription: "Palais romantique et coloré au sommet de la montagne, symbole de Sintra.",
                            description: "Le Palais National de Pena est un palais romantique du XIXe siècle, construit en pierre et en stuc, situé au sommet des montagnes de Sintra. Il se distingue par son style éclectique, avec des éléments néo-gothiques, néo-manuelins et mauresques, et par ses couleurs vibrantes, visibles de toute la région environnante. Le palais est un témoignage de la passion du roi pour l'art et l'histoire, combinant des éléments de différentes périodes et cultures.",
                            history: "Le Palais de Pena a été construit sur le site d'un ancien monastère qui a été détruit lors du tremblement de terre de 1755. Le roi Ferdinand II a acquis le terrain en 1838 et a commencé la construction du palais en 1842. Le palais a été achevé en 1854 et est devenu la résidence d'été de la famille royale portugaise. Après la chute de la monarchie en 1910, le palais a été converti en musée et ouvert au public. Le principal architecte responsable de la transformation du monastère en palais était le Baron von Eschwege.",
                            adress: "Estrada da Pena, 2710-609 Sintra"
                        )
                            
                    ],
                    locations: [
                        (name: ["en": "Palácio da Pena", "pt": "Palácio da Pena", "es": "Palácio da Pena", "fr": "Palácio da Pena"], latitude: 38.7876, longitude: -9.3904)
                    ],
                    zoomSpan: (latitudeDelta: 1, longitudeDelta: 1),
                    customCenter: (38.755108, -9.300003)
                ),
                MiniaturaCard(
                    id: 2,
                    imagem: "travesseiros",
                    categoria: "Sintra",
                    ordem: 2,
                    translations: [
                        "en": MiniaturaCardTranslation(
                            titulo: "Travesseiros and Queijadas 🥧 ",
                            shortDescription: "Traditional Sintra pastries, sweet and unique.",
                            description: "Queijadas and travesseiros are two of Sintra's most traditional sweets, made with puff pastry, almonds, eggs, and sugar. Queijadas are small puff pastry tarts filled with a cheese cream, while travesseiros are puff pastry pillows filled with an almond sweet. Both are handcrafted, following centuries-old recipes, and can be found in traditional Sintra pastry shops, such as Piriquita and Casa da Queijada. In Lisbon and surrounding areas, travesseiros and queijadas are sold in various pastry shops and supermarkets.",
                            history: "The creation of Travesseiros dates back to the 1940s, at the Piriquita pastry shop, by Constância Cunha, while Queijadas originated in the 13th century, being produced by the nuns of the Penha Longa Convent. An interesting fact about Queijadas is that they were used as a form of payment for rents and taxes in medieval times.",
                            adress: "Various pastry shops in Sintra"
                        ),
                        "pt": MiniaturaCardTranslation(
                            titulo: "Travesseiros e Queijadas 🥧 ",
                            shortDescription: "Doces típicos de Sintra, saborosos e únicos.",
                            description: "As queijadas e os travesseiros são dois dos doces mais tradicionais de Sintra, feitos com massa folhada, amêndoas, ovos e açúcar. As queijadas são pequenas tartes de massa folhada recheadas com um creme de queijo, enquanto os travesseiros são almofadas de massa folhada recheadas com um doce de amêndoa. Ambos são feitos artesanalmente, seguindo receitas centenárias, e podem ser encontrados em pastelarias tradicionais de Sintra, como a Piriquita e a Casa da Queijada. Em Lisboa e arredores, travesseiros e queijadas são vendidos em várias pastelarias e supermercados.",
                            history: "A criação dos Travesseiros remonta à década de 1940, na pastelaria Piriquita, pela mão de Constância Cunha, enquanto as Queijadas têm origem no século XIII, sendo produzidas pelas freiras do Convento da Penha Longa. Um facto interessante sobre as Queijadas é que eram usadas como forma de pagamento de rendas e impostos na época medieval.",
                            adress: "Várias pastelarias em Sintra"
                        ),
                        "es": MiniaturaCardTranslation(
                            titulo: "Travesseiros y Queijadas 🥧 ",
                            shortDescription: "Dulces típicos de Sintra, sabrosos y únicos.",
                            description: "Las queijadas y los travesseiros son dos de los dulces más tradicionales de Sintra, hechos con masa de hojaldre, almendras, huevos y azúcar. Las queijadas son pequeñas tartas de masa de hojaldre rellenas con una crema de queso, mientras que los travesseiros son almohadas de masa de hojaldre rellenas con un dulce de almendra. Ambos se hacen artesanalmente, siguiendo recetas centenarias, y se pueden encontrar en pastelerías tradicionales de Sintra, como Piriquita y Casa da Queijada. En Lisboa y alrededores, travesseiros y queijadas se venden en varias pastelerías y supermercados.",
                            history: "La creación de los Travesseiros se remonta a la década de 1940, en la pastelería Piriquita, por Constância Cunha, mientras que las Queijadas tienen su origen en el siglo XIII, siendo producidas por las monjas del Convento da Penha Longa. Un dato curioso sobre las Queijadas es que se usaban como forma de pago de rentas e impuestos en la época medieval.",
                            adress: "Varias pastelerías en Sintra"
                        ),
                        "fr": MiniaturaCardTranslation(
                            titulo: "Travesseiros et Queijadas 🥧 ",
                            shortDescription: "Pâtisseries typiques de Sintra, savoureuses et uniques.",
                            description: "Les queijadas et les travesseiros sont deux des douceurs les plus traditionnelles de Sintra, faites de pâte feuilletée, d'amandes, d'œufs et de sucre. Les queijadas sont de petites tartes en pâte feuilletée remplies d'une crème au fromage, tandis que les travesseiros sont des coussins en pâte feuilletée remplis d'une douceur à l'amande. Les deux sont fabriqués artisanalement, suivant des recettes centenaires, et peuvent être trouvés dans les pâtisseries traditionnelles de Sintra, telles que Piriquita et Casa da Queijada. À Lisbonne et dans les environs, les travesseiros et les queijadas sont vendus dans diverses pâtisseries et supermarchés.",
                            history: "La création des Travesseiros remonte aux années 1940, à la pâtisserie Piriquita, par Constância Cunha, tandis que les Queijadas ont leur origine au XIIIe siècle, étant produites par les religieuses du Couvent de Penha Longa. Un fait intéressant sur les Queijadas est qu'elles étaient utilisées comme forme de paiement pour les loyers et les taxes à l'époque médiévale.",
                            adress: "Diverses pâtisseries à Sintra"
                                )
                    ],
                    locations: [
                        (name: ["en": "Piriquita (Travesseiros)", "pt": "Piriquita (Travesseiros)", "fr": "Piriquita (Travesseiros)", "es": "Piriquita (Travesseiros)"], latitude: 38.7971, longitude: -9.3907),
                        (name: ["en": "Queijadas de Sintra", "pt": "Queijadas de Sintra", "fr": "Queijadas de Sintra", "es": "Queijadas de Sintra"], latitude: 38.750397, longitude: -9.257947),
                        (name: ["en": "Tortas de Azeitão", "pt": "Tortas de Azeitão", "fr": "Tortas de Azeitão", "es": "Tortas de Azeitão"], latitude: 38.936972, longitude: -9.326943)
                    ],
                    zoomSpan: (latitudeDelta: 0.05, longitudeDelta: 0.05),
                    customCenter: (nil)
                ),
                MiniaturaCard(
                    id: 3,
                    imagem: "castelo_mouros",
                    categoria: "Sintra",
                    ordem: 3,
                    translations: [
                        "en": MiniaturaCardTranslation(
                            titulo: "Moorish Castle ⛫ ",
                            shortDescription: "Ancient Moorish castle with panoramic views.",
                            description: "It is a medieval military fortification, built in stone, located at the top of the Sintra Mountains. Dating from the 8th century, during the period of Muslim occupation of the Iberian Peninsula, the castle offers panoramic views of the town of Sintra and the surrounding region. Its walls wind through the mountains, integrating into the natural landscape.",
                            history: "It was built by the Moors to protect the Sintra region, a strategic defense point. In 1147, King Afonso Henriques conquered the castle from the Moors, integrating it into the Kingdom of Portugal. Over the centuries, the castle underwent several renovations and expansions, being restored in the 19th century by King Ferdinand II, who restored its romantic appearance. One of the curiosities is that during the Christian reconquest, the castle was taken by assault during the night, after a long siege.",
                            adress: "Estrada da Pena, 2710-609 Sintra"
                        ),
                        "pt": MiniaturaCardTranslation(
                            titulo: "Castelo dos Mouros ⛫ ",
                            shortDescription: "Castelo mouro antigo com vistas panorâmicas.",
                            description: "É uma fortificação militar medieval, construída em pedra, localizada no topo da Serra de Sintra. Datado do século VIII, durante o período de ocupação muçulmana da Península Ibérica, o castelo oferece vistas panorâmicas sobre a vila de Sintra e a região circundante. As suas muralhas serpenteiam pelas montanhas, integrando-se na paisagem natural.",
                            history: "Foi construído pelos mouros para proteger a região de Sintra, um ponto estratégico de defesa. Em 1147, o rei Afonso Henriques conquistou o castelo aos mouros, integrando-o no Reino de Portugal. Ao longo dos séculos, o castelo sofreu várias reformas e ampliações, sendo restaurado no século XIX pelo rei Fernando II, que lhe deu a sua aparência romântica. Uma das curiosidades é que durante a reconquista cristã, o castelo foi tomado de assalto durante a noite, após um longo cerco.",
                            adress: "Estrada da Pena, 2710-609 Sintra"
                        ),
                        "es": MiniaturaCardTranslation(
                            titulo: "Castelo dos Mouros ⛫ ",
                            shortDescription: "Castillo moro antiguo con vistas panorámicas.",
                            description: "Es una fortificación militar medieval, construida en piedra, ubicada en la cima de las montañas de Sintra. Data del siglo VIII, durante el período de ocupación musulmana de la Península Ibérica, el castillo ofrece vistas panorámicas de la ciudad de Sintra y la región circundante. Sus murallas serpentean por las montañas, integrándose en el paisaje natural.",
                            history: "Fue construido por los moros para proteger la región de Sintra, un punto estratégico de defensa. En 1147, el rey Afonso Henriques conquistó el castillo a los moros, integrándolo en el Reino de Portugal. A lo largo de los siglos, el castillo sufrió varias reformas y ampliaciones, siendo restaurado en el siglo XIX por el rey Fernando II, quien le dio su apariencia romántica. Una de las curiosidades es que durante la reconquista cristiana, el castillo fue tomado por asalto durante la noche, después de un largo asedio.",
                            adress: "Estrada da Pena, 2710-609 Sintra"
                        ),
                        "fr": MiniaturaCardTranslation(
                            titulo: "Castelo dos Mouros ⛫ ",
                            shortDescription: "Château mauresque ancien avec des vues panoramiques.",
                            description: "C'est une fortification militaire médiévale, construite en pierre, située au sommet des montagnes de Sintra. Datant du VIIIe siècle, pendant la période d'occupation musulmane de la péninsule ibérique, le château offre des vues panoramiques sur la ville de Sintra et la région environnante. Ses murs serpentent à travers les montagnes, s'intégrant dans le paysage naturel.",
                            history: "Il a été construit par les Maures pour protéger la région de Sintra, un point stratégique de défense. En 1147, le roi Afonso Henriques a conquis le château aux Maures, l'intégrant dans le Royaume du Portugal. Au fil des siècles, le château a subi plusieurs rénovations et expansions, étant restauré au XIXe siècle par le roi Ferdinand II, qui lui a donné son apparence romantique. Une des curiosités est que pendant la reconquête chrétienne, le château a été pris d'assaut pendant la nuit, après un long siège.",
                            adress: "Estrada da Pena, 2710-609 Sintra"
                            )
                    ],
                    locations: [
                        (name: ["en": "Castelo dos Mouros", "pt": "Castelo dos Mouros", "fr": "Castelo dos Mouros", "es": "Castelo dos Mouros"], latitude: 38.7925, longitude: -9.3867)
                    ],
                    zoomSpan: (latitudeDelta: 0.05, longitudeDelta: 0.05),
                    customCenter: nil
                ),
                MiniaturaCard(
                    id: 4,
                    imagem: "quinta_regaleira",
                    categoria: "Sintra",
                    ordem: 4,
                    translations: [
                        "en": MiniaturaCardTranslation(
                            titulo: "Quinta da Regaleira 🏰 ",
                            shortDescription: "A mystical estate with gardens, tunnels, and symbolism.",
                            description: "It is an architectural and landscape complex from the early 20th century, made of stone and stucco, located in Sintra. It features diverse architectural styles, such as neo-Manueline and romantic, with symbolic and esoteric elements. Its lush gardens, caves, and initiation wells make it a unique place.",
                            history: "The construction of Quinta da Regaleira was started in 1904 by António Augusto Carvalho Monteiro, with the aim of creating a space that reflected his esoteric and philosophical interests. Architect Luigi Manini was responsible for the project. Quinta da Regaleira was the scene of various ceremonies and symbolic rituals, linked to Freemasonry and the Templars. One of the curious facts is that the initiation well, with its spiral staircase, represents a descent into hell and a spiritual rebirth.",
                            adress: "2710-567 Sintra"
                        ),
                        "pt": MiniaturaCardTranslation(
                            titulo: "Quinta da Regaleira 🏰 ",
                            shortDescription: "Propriedade mística com jardins, túneis e simbolismo.",
                            description: "É um complexo arquitetônico e paisagístico do início do século XX, construído em pedra e estuque, localizado em Sintra. Apresenta diversos estilos arquitetônicos, como o neomanuelino e o romântico, com elementos simbólicos e esotéricos. Seus exuberantes jardins, grutas e poços iniciáticos tornam-no um lugar único.",
                            history: "A construção da Quinta da Regaleira foi iniciada em 1904 por António Augusto Carvalho Monteiro, com o objetivo de criar um espaço que refletisse seus interesses esotéricos e filosóficos. O arquiteto Luigi Manini foi o responsável pelo projeto. A Quinta da Regaleira foi palco de várias cerimônias e rituais simbólicos, ligados à Maçonaria e aos Templários. Um dos fatos curiosos é que o poço iniciático, com sua escadaria em espiral, representa uma descida ao inferno e um renascimento espiritual.",
                            adress: "2710-567 Sintra"
                        ),
                        "es": MiniaturaCardTranslation(
                            titulo: "Quinta da Regaleira 🏰 ",
                            shortDescription: "Una propiedad mística con jardines, túneles y simbolismo.",
                            description: "Es un complejo arquitectónico y paisajístico de principios del siglo XX, hecho de piedra y estuco, ubicado en Sintra. Presenta diversos estilos arquitectónicos, como el neomanuelino y el romántico, con elementos simbólicos y esotéricos. Sus exuberantes jardines, grutas y pozos iniciáticos lo convierten en un lugar único.",
                            history: "La construcción de la Quinta da Regaleira comenzó en 1904 por António Augusto Carvalho Monteiro, con el objetivo de crear un espacio que reflejara sus intereses esotéricos y filosóficos. El arquitecto Luigi Manini fue el responsable del proyecto. La Quinta da Regaleira fue el escenario de varias ceremonias y rituales simbólicos, vinculados a la masonería y a los templarios. Uno de los datos curiosos es que el pozo iniciático, con su escalera en espiral, representa un descenso al infierno y un renacimiento espiritual.",
                            adress: "2710-567 Sintra"
                        ),
                        "fr": MiniaturaCardTranslation(
                            titulo: "Quinta da Regaleira 🏰 ",
                            shortDescription: "Une propriété mystique avec des jardins, des tunnels et du symbolisme.",
                            description: "C'est un complexe architectural et paysager du début du XXe siècle, fait de pierre et de stuc, situé à Sintra. Il présente divers styles architecturaux, tels que le néo-manuelin et le romantique, avec des éléments symboliques et ésotériques. Ses jardins luxuriants, ses grottes et ses puits initiatiques en font un lieu unique.",
                            history: "La construction de la Quinta da Regaleira a été commencée en 1904 par António Augusto Carvalho Monteiro, dans le but de créer un espace qui reflète ses intérêts ésotériques et philosophiques. L'architecte Luigi Manini a été responsable du projet. La Quinta da Regaleira a été le théâtre de plusieurs cérémonies et rituels symboliques, liés à la franc-maçonnerie et aux templiers. Un des faits curieux est que le puits initiatique, avec son escalier en spirale, représente une descente aux enfers et une renaissance spirituelle.",
                            adress: "2710-567 Sintra"
                        )
                    ],
                    locations: [
                        (name: ["en": "Quinta da Regaleira", "pt": "Quinta da Regaleira", "fr": "Quinta da Regaleira", "es": "Quinta da Regaleira"], latitude: 38.7976, longitude: -9.3964)
                    ],
                    zoomSpan: (latitudeDelta: 0.05, longitudeDelta: 0.05),
                    customCenter: nil
                ),
                MiniaturaCard(
                    id: 5,
                    imagem: "monserrate_parque",
                    categoria: "Sintra",
                    ordem: 5,
                    translations: [
                        "en": MiniaturaCardTranslation(
                            titulo: "Monserrate Park 🌷 ",
                            shortDescription: "Exotic gardens and a unique palace in Sintra.",
                            description: "It is a 19th-century romantic garden, with an eclectic style palace with neo-Gothic, Moorish, Indian, and romantic influences. The park features a unique botanical collection, with plants from around the world including palms, cacti, ferns, and orchids. Its lakes, waterfalls, and ruins create a magical and mysterious environment.",
                            history: "The creation of Monserrate Park was initiated by Francis Cook, a wealthy English merchant, in the 19th century, between 1858 and 1863, to be his summer residence. Architect James Knowles Jr. was responsible for the palace project and landscape architect William Stockdale designed the park. The park was the scene of various parties and high society events of the time. One of the curious facts is that the park was built on the ruins of an old estate, which belonged to Gerard de Visme, an English merchant from the 18th century.",
                            adress: "Sintra Mountains"
                        ),
                        "pt": MiniaturaCardTranslation(
                            titulo: "Parque de Monserrate 🌷 ",
                            shortDescription: "Jardins exóticos e palácio único em Sintra.",
                            description: "É um jardim romântico do século XIX, com um palácio de estilo eclético com influências neogóticas, mouriscas, indianas e românticas. O parque apresenta uma coleção botânica única, com plantas de todo o mundo, incluindo palmeiras, cactos, samambaias e orquídeas. Seus lagos, cascatas e ruínas criam um ambiente mágico e misterioso.",
                            history: "A criação do Parque de Monserrate foi iniciada por Francis Cook, um rico comerciante inglês, no século XIX, entre 1858 e 1863, para ser sua residência de verão. O arquiteto James Knowles Jr. foi o responsável pelo projeto do palácio e o paisagista William Stockdale desenhou o parque. O parque foi palco de várias festas e eventos da alta sociedade da época. Um dos fatos curiosos é que o parque foi construído sobre as ruínas de uma antiga propriedade, que pertencia a Gerard de Visme, um comerciante inglês do século XVIII.",
                            adress: "Serra de Sintra"
                        ),
                        "es": MiniaturaCardTranslation(
                            titulo: "Parque de Monserrate 🌷 ",
                            shortDescription: "Jardines exóticos y un palacio único en Sintra.",
                            description: "Es un jardín romántico del siglo XIX, con un palacio de estilo ecléctico con influencias neogóticas, moriscas, indias y románticas. El parque presenta una colección botánica única, con plantas de todo el mundo, incluyendo palmeras, cactus, helechos y orquídeas. Sus lagos, cascadas y ruinas crean un ambiente mágico y misterioso.",
                            history: "La creación del Parque de Monserrate fue iniciada por Francis Cook, un rico comerciante inglés, en el siglo XIX, entre 1858 y 1863, para ser su residencia de verano. El arquitecto James Knowles Jr. fue el responsable del proyecto del palacio y el paisajista William Stockdale diseñó el parque. El parque fue el escenario de varias fiestas y eventos de la alta sociedad de la época. Uno de los datos curiosos es que el parque fue construido sobre las ruinas de una antigua propiedad, que pertenecía a Gerard de Visme, un comerciante inglés del siglo XVIII.",
                            adress: "Sierra de Sintra"
                        ),
                        "fr": MiniaturaCardTranslation(
                            titulo: "Parque de Monserrate 🌷 ",
                            shortDescription: "Jardins exotiques et un palais unique à Sintra.",
                            description: "C'est un jardin romantique du XIXe siècle, avec un palais de style éclectique avec des influences néo-gothiques, mauresques, indiennes et romantiques. Le parc présente une collection botanique unique, avec des plantes du monde entier, y compris des palmiers, des cactus, des fougères et des orchidées. Ses lacs, cascades et ruines créent une ambiance magique et mystérieuse.",
                            history: "La création du Parque de Monserrate a été initiée par Francis Cook, un riche marchand anglais, au XIXe siècle, entre 1858 et 1863, pour être sa résidence d'été. L'architecte James Knowles Jr. a été responsable du projet du palais et le paysagiste William Stockdale a conçu le parc. Le parc a été le théâtre de plusieurs fêtes et événements de la haute société de l'époque. Un des faits curieux est que le parc a été construit sur les ruines d'une ancienne propriété, qui appartenait à Gerard de Visme, un marchand anglais du XVIIIe siècle.",
                            adress: "Sierra de Sintra"
                        )
                    ],
                    locations: [
                        (name: ["en": "Parque de Monserrate", "pt": "Parque de Monserrate", "fr": "Parque de Monserrate", "es": "Parque de Monserrate"], latitude: 38.7952, longitude: -9.4056)
                    ],
                    zoomSpan: (latitudeDelta: 0.09, longitudeDelta: 0.09),
                    customCenter: (38.793324, -9.400668)
                ),
                MiniaturaCard(
                    id: 6,
                    imagem: "convento_capuchos",
                    categoria: "Sintra",
                    ordem: 6,
                    translations: [
                        "en": MiniaturaCardTranslation(
                            titulo: "Convent of the Capuchin ⛰ ",
                            shortDescription: "A humble and historic convent surrounded by nature.",
                            description: "It is a 16th-century Franciscan convent, built in stone and integrated into the landscape of the Sintra Mountains. It stands out for its austere architecture, with small cells carved into the rock and lined with cork. It is located in an isolated and densely wooded area, providing an environment of seclusion. The convent is a testament to monastic life and Franciscan spirituality, and is now a place of pilgrimage and meditation.",
                            history: "The construction of the convent was initiated in 1560 by D. Álvaro de Castro, to serve as a retreat for the Franciscan friars of the Order of Capuchos. The convent was designed to promote a life of prayer and penance, with great emphasis on poverty and isolation. One of the curious facts is that the small dimensions of the cells and the use of cork on the walls reflect the friars' ideal of simplicity and detachment.",
                            adress: "Sintra Mountains"
                        ),
                        "pt": MiniaturaCardTranslation(
                            titulo: "Convento dos Capuchos ⛰ ",
                            shortDescription: "Convento humilde e histórico rodeado de natureza.",
                            description: "É um convento franciscano do século XVI, construído em pedra e integrado na paisagem da Serra de Sintra. Destaca-se pela sua arquitetura austera, com pequenas celas escavadas na rocha e revestidas de cortiça. Está localizado numa área isolada e densamente arborizada, proporcionando um ambiente de recolhimento. O convento é um testemunho da vida monástica e da espiritualidade franciscana, sendo atualmente um local de peregrinação e meditação.",
                            history: "A construção do convento foi iniciada em 1560 por D. Álvaro de Castro, para servir como retiro para os frades franciscanos da Ordem dos Capuchos. O convento foi projetado para promover uma vida de oração e penitência, com grande ênfase na pobreza e no isolamento. Um dos fatos curiosos é que as pequenas dimensões das celas e o uso de cortiça nas paredes refletem o ideal dos frades de simplicidade e desapego.",
                            adress: "Serra de Sintra"
                        ),
                        "es": MiniaturaCardTranslation(
                            titulo: "Convento dos Capuchos ⛰ ",
                            shortDescription: "Un convento humilde e histórico rodeado de naturaleza.",
                            description: "Es un convento franciscano del siglo XVI, construido en piedra e integrado en el paisaje de las montañas de Sintra. Destaca por su arquitectura austera, con pequeñas celdas excavadas en la roca y revestidas de corcho. Está ubicado en una zona aislada y densamente arbolada, proporcionando un ambiente de recogimiento. El convento es un testimonio de la vida monástica y la espiritualidad franciscana, siendo actualmente un lugar de peregrinación y meditación.",
                            history: "La construcción del convento fue iniciada en 1560 por D. Álvaro de Castro, para servir como retiro para los frailes franciscanos de la Orden de los Capuchos. El convento fue diseñado para promover una vida de oración y penitencia, con gran énfasis en la pobreza y el aislamiento. Uno de los datos curiosos es que las pequeñas dimensiones de las celdas y el uso de corcho en las paredes reflejan el ideal de los frailes de simplicidad y desapego.",
                            adress: "Sierra de Sintra"
                        ),
                        "fr": MiniaturaCardTranslation(
                            titulo: "Convento dos Capuchos ⛰ ",
                            shortDescription: "Un couvent humble et historique entouré de nature.",
                            description: "C'est un couvent franciscain du XVIe siècle, construit en pierre et intégré dans le paysage des montagnes de Sintra. Il se distingue par son architecture austère, avec de petites cellules creusées dans la roche et revêtues de liège. Il est situé dans une zone isolée et densément boisée, offrant un environnement de recueillement. Le couvent est un témoignage de la vie monastique et de la spiritualité franciscaine, étant actuellement un lieu de pèlerinage et de méditation.",
                            history: "La construction du couvent a été initiée en 1560 par D. Álvaro de Castro, pour servir de retraite aux frères franciscains de l'Ordre des Capuchos. Le couvent a été conçu pour promouvoir une vie de prière et de pénitence, avec une grande emphase sur la pauvreté et l'isolement. Un des faits curieux est que les petites dimensions des cellules et l'utilisation du liège sur les murs reflètent l'idéal des frères de simplicité et de détachement.",
                            adress: "Sierra de Sintra"
                        )
                    ],
                    locations: [
                        (name: ["en": "Convento dos Capuchos", "pt": "Convento dos Capuchos", "fr": "Convento dos Capuchos", "es": "Convento dos Capuchos" ], latitude: 38.7857, longitude: -9.4302)
                    ],
                    zoomSpan: (latitudeDelta: 0.2, longitudeDelta: 0.2),
                    customCenter: (38.785855, -9.425590)
                ),
                MiniaturaCard(
                    id: 7,
                    imagem: "palacio_vila",
                    categoria: "Sintra",
                    ordem: 7,
                    translations: [
                        "en": MiniaturaCardTranslation(
                            titulo: "Palácio da Vila 🏰 ",
                            shortDescription: "The medieval royal palace in the heart of Sintra.",
                            description: "It is a medieval and Renaissance palace, built with various materials such as stone, brick, and tiles, located in the historic center of Sintra. Its architecture reflects different styles, including Gothic, Manueline, and Moorish, the result of centuries of alterations and extensions. Its iconic cone-shaped chimneys are one of its most distinctive features.",
                            history: "The construction of the palace was initiated in the 14th century by King João I, to serve as a summer residence for the Portuguese royal family. Over the centuries, it was the scene of important historical events, such as the marriage of King Manuel I to Maria of Aragon. One of the curiosities is that the palace has a vast collection of Hispano-Moorish tiles, considered among the most important in the country.",
                            adress: "Village of Sintra"
                        ),
                        "pt": MiniaturaCardTranslation(
                            titulo: "Palácio da Vila 🏰 ",
                            shortDescription: "O palácio real medieval no centro de Sintra.",
                            description: "É um palácio medieval e renascentista, construído com vários materiais como pedra, tijolo e azulejos, localizado no centro histórico de Sintra. A sua arquitetura reflete diferentes estilos, incluindo gótico, manuelino e mourisco, resultado de séculos de alterações e ampliações. As suas icónicas chaminés em forma de cone são uma das suas características mais distintivas.",
                            history: "A construção do palácio foi iniciada no século XIV pelo rei João I, para servir como residência de verão da família real portuguesa. Ao longo dos séculos, foi palco de importantes eventos históricos, como o casamento do rei Manuel I com Maria de Aragão. Uma das curiosidades é que o palácio possui uma vasta coleção de azulejos hispano-mouriscos, considerados entre os mais importantes do país.",
                            adress: "Vila de Sintra"
                        ),
                        "es": MiniaturaCardTranslation(
                            titulo: "Palácio da Vila 🏰 ",
                            shortDescription: "El palacio real medieval en el centro de Sintra.",
                            description: "Es un palacio medieval y renacentista, construido con varios materiales como piedra, ladrillo y azulejos, ubicado en el centro histórico de Sintra. Su arquitectura refleja diferentes estilos, incluyendo gótico, manuelino y morisco, resultado de siglos de alteraciones y ampliaciones. Sus icónicas chimeneas en forma de cono son una de sus características más distintivas.",
                            history: "La construcción del palacio fue iniciada en el siglo XIV por el rey João I, para servir como residencia de verano de la familia real portuguesa. A lo largo de los siglos, fue escenario de importantes eventos históricos, como el matrimonio del rey Manuel I con María de Aragón. Una de las curiosidades es que el palacio posee una vasta colección de azulejos hispano-moriscos, considerados entre los más importantes del país.",
                            adress: "Villa de Sintra"
                        ),
                        "fr": MiniaturaCardTranslation(
                            titulo: "Palácio da Vila 🏰 ",
                            shortDescription: "Le palais royal médiéval au cœur de Sintra.",
                            description: "C'est un palais médiéval et renaissance, construit avec divers matériaux tels que la pierre, la brique et les azulejos, situé dans le centre historique de Sintra. Son architecture reflète différents styles, notamment gothique, manuélin et mauresque, résultat de siècles d'altérations et d'extensions. Ses cheminées emblématiques en forme de cône sont l'une de ses caractéristiques les plus distinctives.",
                            history: "La construction du palais a été initiée au XIVe siècle par le roi João I, pour servir de résidence d'été à la famille royale portugaise. Au fil des siècles, il a été le théâtre d'importants événements historiques, tels que le mariage du roi Manuel I avec Maria d'Aragon. Une des curiosités est que le palais possède une vaste collection d'azulejos hispano-mauresques, considérés parmi les plus importants du pays.",
                            adress: "Village de Sintra"
                        )
                    ],
                    locations: [
                        (name: ["en": "Palácio da Vila", "pt": "Palácio da Vila", "fr": "Palácio da Vila", "es": "Palacio da Vila"], latitude: 38.7972, longitude: -9.3907)
                    ],
                    zoomSpan: (latitudeDelta: 0.02, longitudeDelta: 0.02),
                    customCenter: nil
                ),
                MiniaturaCard(
                    id: 8,
                    imagem: "plus_sintra",
                    categoria: "Sintra",
                    ordem: 8,
                    translations: [
                        "en": MiniaturaCardTranslation(
                            titulo: "More Sintra ⛱️☀️🌊 ",
                            shortDescription: "Discover even more wonders in Sintra!",
                            description: "When we talk about Sintra, we may be referring to the Town or the Municipality. The Town of Sintra is a magical place, with a romantic atmosphere and a unique cultural and natural heritage. The Municipality of Sintra is a diverse region, ranging from the Atlantic coast to the mountains of the Sintra Range, with a rich history and breathtaking landscape. In addition to the 7 wonders already mentioned, here are some other emblematic and enchanting places in the region that deserve to be visited and explored.\n\n😮 Cabo da Roca: It is the westernmost point of continental Europe, with 140-meter-high cliffs and breathtaking views over the ocean.\n✝️  Cruz Alta: It is the highest point of the Sintra Mountains, at 528 meters altitude, from where you can see the most beautiful views over Lisbon and Cascais to the south, the Atlantic Ocean to the west, and the rural region to the north.\n⛱️ Adraga Beach: It is one of the most beautiful beaches in the region, with an extensive sandy area, imposing cliffs, and crystal-clear waters.\n⛱️ Praia Grande: It is one of the most popular beaches in the region, with an extensive sandy area, good waves for surfing, and a relaxed atmosphere.\n⛱️ Maçãs Beach: It is a picturesque beach, with a small fishing port, a lively promenade, and a family-friendly atmosphere.\n⛱️  Ursa Beach: It is a wild and isolated beach, with steep cliffs, golden sand, and crystal-clear waters.\n⛱️ Aguda Beach: It is a quiet and isolated beach, with an extensive sandy area, calm waters, and a relaxing atmosphere."
                        ),
                        "pt": MiniaturaCardTranslation(
                            titulo: "Mais Sintra ⛱️☀️🌊 ",
                            shortDescription: "Descubra ainda mais maravilhas em Sintra!",
                            description: "Quando falamos de Sintra, podemos estar a referir-nos à Vila ou ao Concelho. A Vila de Sintra é um lugar mágico, com uma atmosfera romântica e um património cultural e natural único. O Concelho de Sintra é uma região diversa, que vai desde a costa atlântica até às montanhas da Serra de Sintra, com uma rica história e paisagem deslumbrante. Além das 7 maravilhas já mencionadas, aqui estão alguns outros lugares emblemáticos e encantadores da região que merecem ser visitados e explorados.\n\n😮 Cabo da Roca: É o ponto mais ocidental da Europa continental, com falésias de 140 metros de altura e vistas deslumbrantes sobre o oceano.\n✝️ Cruz Alta: É o ponto mais alto da Serra de Sintra, com 528 metros de altitude, de onde se podem ver as vistas mais bonitas sobre Lisboa e Cascais a sul, o Oceano Atlântico a oeste, e a região rural a norte.\n⛱️ Praia da Adraga: É uma das praias mais bonitas da região, com uma extensa área de areia, falésias imponentes e águas cristalinas.\n⛱️ Praia Grande: É uma das praias mais populares da região, com uma extensa área de areia, boas ondas para surf e uma atmosfera descontraída.\n⛱️ Praia das Maçãs: É uma praia pitoresca, com um pequeno porto de pesca, um passeio animado e uma atmosfera familiar.\n⛱️ Praia da Ursa: É uma praia selvagem e isolada, com falésias íngremes, areia dourada e águas cristalinas.\n⛱️ Praia da Aguda: É uma praia tranquila e isolada, com uma extensa área de areia, águas calmas e uma atmosfera relaxante."
                        ),
                        "es": MiniaturaCardTranslation(
                            titulo: "Más Sintra ⛱️☀️🌊 ",
                            shortDescription: "¡Descubre aún más maravillas en Sintra!",
                            description: "Cuando hablamos de Sintra, podemos estar refiriéndonos a la Villa o al Municipio. La Villa de Sintra es un lugar mágico, con una atmósfera romántica y un patrimonio cultural y natural único. El Municipio de Sintra es una región diversa, que va desde la costa atlántica hasta las montañas de la Sierra de Sintra, con una rica historia y paisaje impresionante. Además de las 7 maravillas ya mencionadas, aquí hay algunos otros lugares emblemáticos y encantadores de la región que merecen ser visitados y explorados.\n\n😮 Cabo da Roca: Es el punto más occidental de Europa continental, con acantilados de 140 metros de altura y vistas impresionantes sobre el océano.\n✝️ Cruz Alta: Es el punto más alto de la Sierra de Sintra, con 528 metros de altitud, desde donde se pueden ver las vistas más bonitas sobre Lisboa y Cascais al sur, el Océano Atlántico al oeste, y la región rural al norte.\n⛱️ Playa da Adraga: Es una de las playas más bonitas de la región, con una extensa área de arena, acantilados imponentes y aguas cristalinas.\n⛱️ Playa Grande: Es una de las playas más populares de la región, con una extensa área de arena, buenas olas para surfear y una atmósfera relajada.\n⛱️ Playa das Maçãs: Es una playa pintoresca, con un pequeño puerto pesquero, un paseo animado y una atmósfera familiar.\n⛱️ Playa da Ursa: Es una playa salvaje e aislada, con acantilados empinados, arena dorada y aguas cristalinas.\n⛱️ Playa da Aguda: Es una playa tranquila e aislada, con una extensa área de arena, aguas calmadas y una atmósfera relajante."
                        ),
                        "fr": MiniaturaCardTranslation(
                            titulo: "Plus de Sintra ⛱️☀️🌊 ",
                            shortDescription: "Découvrez encore plus de merveilles à Sintra!",
                            description: "Lorsque nous parlons de Sintra, nous pouvons faire référence à la Ville ou à la Municipalité. La Ville de Sintra est un lieu magique, avec une atmosphère romantique et un patrimoine culturel et naturel unique. La Municipalité de Sintra est une région diversifiée, qui va de la côte atlantique aux montagnes de la Serra de Sintra, avec une riche histoire et un paysage à couper le souffle. En plus des 7 merveilles déjà mentionnées, voici quelques autres lieux emblématiques et charmants de la région qui méritent d'être visités et explorés.\n\n😮 Cabo da Roca : C'est le point le plus occidental de l'Europe continentale, avec des falaises de 140 mètres de haut et une vue imprenable sur l'océan.\n✝️ Cruz Alta : C'est le point culminant de la Serra de Sintra, avec 528 mètres d'altitude, d'où vous pouvez voir les plus belles vues sur Lisbonne et Cascais au sud, l'océan Atlantique à l'ouest, et la région rurale au nord.\n⛱️ Plage da Adraga : C'est l'une des plus belles plages de la région, avec une vaste zone de sable, des falaises imposantes et des eaux cristallines.\n⛱️ Plage Grande : C'est l'une des plages les plus populaires de la région, avec une vaste zone de sable, de bonnes vagues pour le surf et une atmosphère détendue.\n⛱️ Plage das Maçãs : C'est une plage pittoresque, avec un petit port de pêche, une promenade animée et une atmosphère familiale.\n⛱️ Plage da Ursa : C'est une plage sauvage et isolée, avec des falaises escarpées, du sable doré et des eaux cristallines.\n⛱️ Plage da Aguda : C'est une plage tranquille et isolée, avec une vaste zone de sable, des eaux calmes et une atmosphère relaxante."
                        )
                    ],
                    locations: [
                        (name: ["en": "Cabo da Roca", "pt": "Cabo da Roca", "es": "Cabo da Roca", "fr": "Cabo da Roca" ], latitude: 38.780413, longitude: -9.498850),
                        (name: ["en": "Praia da Adraga", "pt": "Praia da Adraga", "es": "Praia da Adraga", "fr": "Praia da Adraga"], latitude: 38.803232, longitude: -9.484940),
                        (name: ["en": "Praia Grande", "pt": "Praia Grande", "es": "Praia Grande", "fr": "Praia Grande"], latitude: 38.811687, longitude: -9.477119),
                        (name: ["en": "Praia das Maçãs", "pt": "Praia das Maçãs", "es": "Praia das Maçãs", "fr": "Praia das Maçãs"], latitude: 38.827308, longitude: -9.463803),
                        (name: ["en": "Praia da Ursa", "pt": "Praia da Ursa", "es": "Praia da Ursa", "fr": "Praia da Ursa"], latitude: 38.790529, longitude: -9.492918),
                        (name: ["en": "Praia da Aguda", "pt": "Praia da Aguda", "es": "Praia da Aguda", "fr": "Praia da Aguda"], latitude: 38.850993, longitude: -9.455793)
                    ],
                    zoomSpan: (latitudeDelta: 0.16, longitudeDelta: 0.16),
                    customCenter: (38.783298, -9.446859)
                )
            ]
        }
        // --- VOCABULÁRIO BLOCK ---
        if cat == "vocabulario" || cat == "vocabulário" {
            return [
                MiniaturaCard(
                    id: 1,
                    imagem: "telemovel",
                    categoria: "Vocabulário",
                    ordem: 1,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Telémovel 📱 ",
                            shortDescription: "Celular",
                            usage: "Posso ligar para o seu telémovel?",
                            pronunciation: "teh-leh-MOH-vel"
                        )
                    ],
                    locations: nil,
                    zoomSpan: nil,
                    customCenter: nil
                ),
                MiniaturaCard(
                    id: 2,
                    imagem: "comboio",
                    categoria: "Vocabulário",
                    ordem: 2,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Comboio 🚆 ",
                            shortDescription: "Trem",
                            usage: "O comboio parte às 8h.",
                            pronunciation: "kom-BOY-oo"
                        )
                    ],
                    locations: nil,
                    zoomSpan: nil,
                    customCenter: nil
                ),
                MiniaturaCard(
                    id: 3,
                    imagem: "autocarro",
                    categoria: "Vocabulário",
                    ordem: 3,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Autocarro 🚌 ",
                            shortDescription: "Ônibus",
                            usage: "Vou apanhar o autocarro para o trabalho.",
                            pronunciation: "ow-toh-KAH-roo"
                        )
                    ],
                    locations: nil,
                    zoomSpan: nil,
                    customCenter: nil
                ),
                MiniaturaCard(
                    id: 4,
                    imagem: "tram28",
                    categoria: "Vocabulário",
                    ordem: 4,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Eléctrico 🚃 ",
                            shortDescription: "Bonde",
                            usage: "O eléctrico 28 é famoso em Lisboa.",
                            pronunciation: "eh-LEK-tree-ko"
                        )
                    ],
                    locations: nil,
                    zoomSpan: nil,
                    customCenter: nil
                ),
                MiniaturaCard(
                    id: 5,
                    imagem: "bicha",
                    categoria: "Vocabulário",
                    ordem: 5,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Bicha 🤭 ",
                            shortDescription: "Fila",
                            usage: "Há uma grande bicha para comprar bilhetes.",
                            pronunciation: "BEE-sha"
                        )
                    ],
                    locations: nil,
                    zoomSpan: nil,
                    customCenter: nil
                ),
                MiniaturaCard(
                    id: 6,
                    imagem: "pequenoAlmoco",
                    categoria: "Vocabulário",
                    ordem: 6,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Pequeno-almoço ☕️ 🥐 ",
                            shortDescription: "Café da manhã",
                            usage: "O pequeno-almoço é servido até às 10h.",
                            pronunciation: "peh-KEN-oo al-MOH-soo"
                        )
                    ],
                    locations: nil,
                    zoomSpan: nil,
                    customCenter: nil
                ),
                MiniaturaCard(
                    id: 7,
                    imagem: "casaBanho",
                    categoria: "Vocabulário",
                    ordem: 7,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Casa de banho 🚻 ",
                            shortDescription: "Banheiro",
                            usage: "Onde fica a casa de banho?",
                            pronunciation: "KAH-za deh BAH-nyoo"
                        )
                    ],
                    locations: nil,
                    zoomSpan: nil,
                    customCenter: nil
                )
            ]
        }
        // --- VOCABULARY BLOCK ---
        if cat == "vocabulary" {
            return [
                MiniaturaCard(
                    id: 1,
                    imagem: "vocabulary_en_64",
                    categoria: "Vocabulary",
                    ordem: 1,
                    translations: [
                        "en": MiniaturaCardTranslation(
                            titulo: "Hi/Hello ✋🏼",
                            shortDescription: "\"Olá\" is the most common way to say \"Hello!\" or \"Hi!\"in Portuguese, used in both formal and informal situations.",
                            description: "It is a friendly and welcoming greeting that can be used with people of all ages and social backgrounds. When meeting someone for the first time, it is polite to say \"Olá\" and introduce yourself, followed by a handshake or a smile. \"Olá\" can also be used to get someone's attention or to start a conversation.",
                            usage: "\"Olá\" is a versatile greeting that can be used in a variety of situations, such as: Meeting someone for the first time: Olá, eu sou o João. Prazer em conhecê-lo. (Hello, I'm João. Nice to meet you.) Greeting friends and family: Olá, como estás? (Hello, how are you?) Answering the phone: Olá, quem fala? (Hello, who's calling?) Getting someone's attention: Olá, desculpe incomodar. (Hello, sorry to bother you.) Starting a conversation: Olá, tudo bem contigo? (Hello, how are you doing?)",
                            pronunciation: "\"Olá\" is pronounced as oh-lah, with the stress on the second syllable. The first syllable is pronounced as the English letter 'o' and the second syllable as the English word 'la.' The 'o' sound is similar to the 'o' in the English word 'go,' and the 'a' sound is similar to the 'a' in the English word 'la.' The 'l' sound is pronounced as a clear 'l' sound, similar to the English letter 'l.'"
                        ),
                        "es": MiniaturaCardTranslation(
                            titulo: "Hola ✋🏼",
                            shortDescription: "\"Olá\" es la forma más común de decir \"¡Hola!\" en portugués, utilizada tanto en situaciones formales como informales.",
                            description: "Es un saludo amigable y acogedor que se puede usar con personas de todas las edades y antecedentes sociales. Al conocer a alguien por primera vez, es cortés decir \"Olá\" e introducirse, seguido de un apretón de manos o una sonrisa. \"Olá\" también se puede usar para llamar la atención de alguien o para iniciar una conversación.",
                            usage: "\"Olá\" es un saludo versátil que se puede usar en una variedad de situaciones, como: Conocer a alguien por primera vez: Olá, soy João. Encantado de conocerte. (Hola, soy João. Encantado de conocerte.) Saludar a amigos y familiares: Olá, ¿cómo estás? (Hola, ¿cómo estás?) Contestar el teléfono: Olá, ¿quién habla? (Hola, ¿quién llama?) Llamar la atención de alguien: Olá, disculpa molestar. (Hola, disculpa molestar.) Iniciar una conversación: Olá, ¿todo bien contigo? (Hola, ¿cómo te va?)",
                            pronunciation: "\"Olá\" se pronuncia como oh-lá, con el acento en la segunda sílaba. La primera sílaba se pronuncia como la letra 'o' en español y la segunda sílaba como la palabra 'la' en español. El sonido 'o' es similar al 'o' en la palabra española «oro», y el sonido 'a' es similar al 'a' en la palabra española «casa». El sonido 'l' se pronuncia como un sonido claro de 'l', similar a la letra 'l' en español."
                        ),
                        "fr": MiniaturaCardTranslation(
                            titulo: "Bonjour ✋🏼",
                            shortDescription: "\"Olá\" est la façon la plus courante de dire \"Bonjour!\" ou \"Salut!\" en portugais, utilisée dans les situations formelles et informelles.",
                            description: "C'est un salut amical et accueillant qui peut être utilisé avec des personnes de tous âges et de tous horizons sociaux. Lors de la rencontre de quelqu'un pour la première fois, il est poli de dire \"Olá\" et de se présenter, suivi d'une poignée de main ou d'un sourire. \"Olá\" peut également être utilisé pour attirer l'attention de quelqu'un ou pour entamer une conversation.",
                            usage: "\"Olá\" est un salut polyvalent qui peut être utilisé dans une variété de situations, telles que : Rencontrer quelqu'un pour la première fois : Olá, je suis João. Enchanté de faire votre connaissance. (Bonjour, je suis João. Enchanté de faire votre connaissance.) Saluer les amis et la famille : Olá, comment ça va? (Bonjour, comment ça va?) Répondre au téléphone : Olá, qui est à l'appareil? (Bonjour, qui est à l'appareil?) Attirer l'attention de quelqu'un : Olá, désolé de vous déranger. (Bonjour, désolé de vous déranger.) Commencer une conversation : Olá, comment vas-tu? (Bonjour, comment vas-tu?)",
                            pronunciation: "\"Olá\" se prononce comme oh-là, avec l'accent sur la deuxième syllabe. La première syllabe se prononce comme la lettre 'o' en français (comme dans le mot « dos ») et la deuxième syllabe comme le mot 'là' en français. Le son 'o' est similaire au 'o' dans le mot français « rose », et le son 'a' est similaire au 'a' dans le mot français « là ». Le son 'l' se prononce comme un son clair de 'l', similaire à la lettre 'l' en français."
                        )
                    ],
                    locations: nil,
                    zoomSpan: nil,
                    customCenter: nil
                ),
                MiniaturaCard(
                    id: 2,
                    imagem: "vocabulary_en_65",
                    categoria: "Vocabulary",
                    ordem: 2,
                    translations: [
                        "en": MiniaturaCardTranslation(
                            titulo: "Please 🙏🏽 ",
                            shortDescription: "\"Por favor\" or \"Se faz favor\" are polite expressions used to make requests, ask for help, or show consideration for others.",
                            description: "It is a versatile word that can be used in a variety of situations, from ordering food in a restaurant to asking for directions on the street. Por favor is a simple and effective way to show respect and courtesy to others.",
                            usage: "\"Por favor\" is a versatile expression that can be used in a variety of situations, such as: Asking for something: Por favor, pode passar-me o sal? (Please, can you pass me the salt?) Making a request: Por favor, pode dizer-me onde fica a estação de comboios? (Please, can you tell me where the train station is?) Ordering food: Por favor, um café e um pastel de nata. (Please, a coffee and a custard tart.) Asking for help: Por favor, pode ajudar-me a encontrar o meu hotel? (Please, can you help me find o meu hotel?) Showing consideration: Por favor, desculpe o atraso. (Thank you very much for everything. Please, accept this gift.)",
                            pronunciation: "Por favor is pronounced as poor fah-vohr, with the stress on the second syllable. The first syllable is pronounced as the English word 'poor' without the 'r' sound, and the second syllable is pronounced as the English word 'fah-vohr.' The 'o' sound is similar to the 'o' in the English word 'go,' and the 'a' sound is similar to the 'a' in the English word 'la.' The 'r' sound is pronounced as a soft 'r' sound, similar to the 'r' in the English word 'car."
                        ),
                        "es": MiniaturaCardTranslation(
                            titulo: "Por favor 🙏🏽 ",
                            shortDescription: "\"Por favor\" o \"Se faz favor\" son expresiones corteses utilizadas para hacer solicitudes, pedir ayuda o mostrar consideración por los demás.",
                            description: "Es una palabra versátil que se puede usar en una variedad de situaciones, desde pedir comida en un restaurante hasta pedir direcciones en la calle. Por favor es una forma simple y efectiva de mostrar respeto y cortesía a los demás.",
                            usage: "\"Por favor\" es una expresión versátil que se puede usar en una variedad de situaciones, como: Pedir algo: Por favor, ¿puede pasarme la sal? (Por favor, ¿puede pasarme la sal?) Hacer una solicitud: Por favor, ¿puede decirme dónde está la estación de tren? (Por favor, ¿puede decirme dónde está la estación de tren?) Pedir comida: Por favor, un café y un pastel de nata. (Por favor, un café y un pastel de nata.) Pedir ayuda: Por favor, ¿puede ayudarme a encontrar mi hotel? (Por favor, ¿puede ayudarme a encontrar mi hotel?) Mostrar consideración: Por favor, disculpe el retraso. (Muchas gracias por todo. Por favor, acepte este regalo.)",
                            pronunciation: "\"Por favor\" se pronuncia como por fa-vór, con el acento en la última sílaba. La primera sílaba se pronuncia como la palabra 'por' en español y la segunda sílaba como la palabra 'favor' en español. El sonido 'o' es similar al 'o' en la palabra española «oro», y el sonido 'a' es similar al 'a' en la palabra española «casa». El sonido 'r' final se pronuncia de forma suave, similar al 'r' en la palabra española «mar»."
                        ),
                        "fr": MiniaturaCardTranslation(
                            titulo: "S'il vous plaît 🙏🏽 ",
                            shortDescription: "\"Por favor\" ou \"Se faz favor\" sont des expressions polies utilisées pour faire des demandes, demander de l'aide ou montrer de la considération pour les autres.",
                            description: "C'est un mot polyvalent qui peut être utilisé dans une variété de situations, de la commande de nourriture dans un restaurant à la demande de directions dans la rue. Por favor est une façon simple et efficace de montrer du respect et de la courtoisie aux autres.",
                            usage: "\"Por favor\" est une expression polyvalente qui peut être utilisée dans une variété de situations, telles que : Demander quelque chose : Por favor, pouvez-vous me passer le sel? (S'il vous plaît, pouvez-vous me passer le sel?) Faire une demande : Por favor, pouvez-vous me dire où se trouve la gare? (S'il vous plaît, pouvez-vous me dire où se trouve la gare?) Commander de la nourriture : Por favor, un café et une tarte à la crème. (S'il vous plaît, un café et une tarte à la crème.) Demander de l'aide : Por favor, pouvez-vous m'aider à trouver mon hôtel? (S'il vous plaît, pouvez-vous m'aider à trouver mon hôtel?) Montrer de la considération: Por favor, excusez le retard. (Merci beaucoup pour tout. S'il vous plaît, acceptez ce cadeau.)",
                            pronunciation: "\"Por favor\" se prononce comme por fa-vohr, avec l'accent sur la dernière syllabe. La première syllabe se prononce comme le mot 'pour' en français (mais avec un son 'o' plus ouvert) et la deuxième syllabe comme le mot 'faveur' en français. Le son 'o' est similaire au 'o' dans le mot français « rose », et le son 'a' est similaire au 'a' dans le mot français « là ». Le son 'r' se prononce de façon douce, similaire au 'r' dans le mot français « mer »."
                            )
                    ],
                    locations: nil,
                    zoomSpan: nil,
                    customCenter: nil
                ),
                MiniaturaCard(
                    id: 3,
                    imagem: "vocabulary_en_66",
                    categoria: "Vocabulary",
                    ordem: 3,
                    translations: [
                        "en": MiniaturaCardTranslation(
                            titulo: "Yes/No 👍🏼👎🏼",
                            shortDescription: "\"Sim\" and \"Não\" are simple and effective words used to express agreement or disagreement, answer questions, or make decisions.",
                            description: "They are versatile words that can be used in a variety of situations, from confirming an appointment to expressing your opinion on a topic. \"Sim\" and \"Não\" are essential words in any conversation, allowing you to communicate clearly and effectively.",
                            usage: "\"Sim\" and \"Não\" are simple and effective words that can be used in a variety of situations, such as: Answering questions: \"Sim, eu gostaria de um café.\" (Yes, I would like a coffee.) Expressing agreement: \"Sim, concordo com a tua opinião.\" (Yes, I agree with your opinion.) Making decisions: \"Sim, vou aceitar o emprego.\" (Yes, I will take the job.) Confirming appointments: \"Sim, estarei lá às 10 horas.\" (Yes, I will be there at 10 o'clock.) Expressing disagreement: \"Não, não concordo com essa ideia.\" (No, I don't agree with that idea.) Declining invitations: \"Não, não posso ir à festa.\" (No, I can't go to the party.",
                            pronunciation: "\"Sim\" is pronounced as seem, with the stress on the first syllable. The 's' sound is pronounced as the English 's' sound, and the 'i' sound is similar to the 'ee' in the English word 'see.' \"Não\" is pronounced as now, with the stress on the first syllable. The 'n' sound is pronounced as the English 'n' sound, and the 'ã' sound is similar to the 'ow' in the English word 'now.'"
                        ),
                        "es": MiniaturaCardTranslation(
                            titulo: "Sí/No 👍🏼👎🏼",
                            shortDescription: "\"Sim\" y \"Não\" son palabras simples y efectivas utilizadas para expresar acuerdo o desacuerdo, responder preguntas o tomar decisiones.",
                            description: "Son palabras versátiles que se pueden usar en una variedad de situaciones, desde confirmar una cita hasta expresar tu opinión sobre un tema. \"Sim\" y \"Não\" son palabras esenciales en cualquier conversación, permitiéndote comunicarte de manera clara y efectiva.",
                            usage: "\"Sim\" y \"Não\" son palabras simples y efectivas que se pueden usar en una variedad de situaciones, como: Responder preguntas: \"Sim, me gustaría un café.\" (Sí, me gustaría un café.) Expresar acuerdo: \"Sim, estoy de acuerdo con tu opinión.\" (Sí, estoy de acuerdo con tu opinión.) Tomar decisiones: \"Sim, aceptaré el trabajo.\" (Sí, aceptaré el trabajo.) Confirmar citas: \"Sim, estaré allí a las 10 horas.\" (Sí, estaré allí a las 10 horas.) Expresar desacuerdo: \"Não, no estoy de acuerdo con esa idea.\" (No, no estoy de acuerdo con esa idea.) Rechazar invitaciones: \"Não, no puedo ir a la fiesta.\" (No, no puedo ir a la fiesta.)",
                            pronunciation: "\"Sim\" se pronuncia como 'sin', con un sonido nasal al final. La primera sílaba se pronuncia como la palabra 'sí' en español, pero terminando con un sonido de 'n' suave que no llega a cerrar los labios. El sonido 'i' es similar al 'i' en la palabra española «isla». \"Não\" se pronuncia como 'na-on', con un sonido fuertemente nasal. La primera parte se pronuncia como la palabra 'na' en español, seguida de un sonido de 'o' nasalizado, similar al sonido que se hace al decir 'pan' con la nariz tapada. El sonido 'n' se pronuncia como un sonido claro de 'n', similar a la letra 'n' en español."
                        ),
                        "fr": MiniaturaCardTranslation(
                            titulo: "Oui/Non 👍🏼👎🏼",
                            shortDescription: "\"Sim\" et \"Não\" sont des mots simples et efficaces utilisés pour exprimer l'accord ou le désaccord, répondre à des questions ou prendre des décisions.",
                            description: "Ce sont des mots polyvalents qui peuvent être utilisés dans une variété de situations, de la confirmation d'un rendez-vous à l'expression de votre opinion sur un sujet. \"Sim\" et \"Não\" sont des mots essentiels dans toute conversation, vous permettant de communiquer clairement et efficacement.",
                            usage: "\"Sim\" et \"Não\" sont des mots simples et efficaces qui peuvent être utilisés dans une variété de situations, telles que : Répondre à des questions : \"Sim, je voudrais un café.\" (Oui, je voudrais un café.) Exprimer l'accord : \"Sim, je suis d'accord avec ton opinion.\" (Oui, je suis d'accord avec ton opinion.) Prendre des décisions : \"Sim, j'accepterai le travail.\" (Oui, j'accepterai le travail.) Confirmer des rendez-vous : \"Sim, je serai là à 10 heures.\" (Oui, je serai là à 10 heures.) Exprimer le désaccord : \"Não, je ne suis pas d'accord avec cette idée.\" (Non, je ne suis pas d'accord avec cette idée.) Refuser des invitations : \"Não, je ne peux pas aller à la fête.\" (Non, je ne peux pas aller à la fête.)",
                            pronunciation: "\"Sim\" se prononce comme 'sin', avec un son nasal à la fin. La première syllabe se prononce comme la lettre 'i' en français, mais se termine par un son 'n' nasal qui ne ferme pas les lèvres, similaire au son 'in' dans le mot français « vin ». \"Não\" se prononce comme 'nan-on', avec un son fortement nasal. La première partie se prononce comme le son 'an' en français (comme dans « maman »), suivi d'un son 'o' nasalisé. Le son 'n' initial se prononce comme un son clair de 'n', similaire à la lettre 'n' en français."
                        )
                    ],
                    locations: nil,
                    zoomSpan: nil,
                    customCenter: nil
                ),
                MiniaturaCard(
                    id: 4,
                    imagem: "vocabulary_en_67",
                    categoria: "Vocabulary",
                    ordem: 4,
                    translations: [
                        "en": MiniaturaCardTranslation(
                            titulo: "Thank you 🙏🏽",
                            shortDescription: "\"Obrigado\" is a polite and friendly expression used to express gratitude, appreciation, and recognition for a favor, gift, or kind gesture.",
                            description: "It is a versatile word that can be used in a variety of situations, from thanking someone for holding the door open to expressing your appreciation for a thoughtful gift. \"Obrigado\" is a simple and effective way to show gratitude and goodwill to others.",
                            usage: "\"Obrigado\" is a versatile expression that can be used in a variety of situations, such as: Thanking someone: Obrigado pela ajuda. (Thank you for the help.) Expressing gratitude: Obrigado pela prenda. (Thank you for the gift.) Showing appreciation: Obrigado pela hospitalidade. (Thank you for the hospitality.) Acknowledging a favor: Obrigado por me ouvires. (Thank you for listening to me.) Responding to a compliment: Obrigado pelo elogio. (Thank you for the compliment.) Expressing recognition: Obrigado pelo apoio. (Thank you for the support.)",
                            pronunciation: "\"Obrigado\" is pronounced as oh-bree-gah-doo, with the stress on the second syllable. The 'o' sound is similar to the 'o' in the English word 'go,' the 'b' sound is pronounced as the English 'b' sound, and the 'r' sound is pronounced as a soft 'r' sound. The 'i' sound is similar to the 'ee' in the English word 'see,' the 'g' sound is pronounced as the English 'g' sound, the 'a' sound is similar to the 'a' in the English word 'la,' and the 'd' sound is pronounced as the English 'd' sound."
                        ),
                        "es": MiniaturaCardTranslation(
                            titulo: "Gracias 🙏🏽",
                            shortDescription: "\"Obrigado\" es una expresión cortés y amigable utilizada para expresar gratitud, aprecio y reconocimiento por un favor, regalo o gesto amable.",
                            description: "Es una palabra versátil que se puede usar en una variedad de situaciones, desde agradecer a alguien por sostener la puerta abierta hasta expresar tu agradecimiento por un regalo considerado. \"Obrigado\" es una forma simple y efectiva de mostrar gratitud y buena voluntad hacia los demás.",
                            usage: "\"Obrigado\" es una expresión versátil que se puede usar en una variedad de situaciones, como: Agradecer a alguien: Obrigado por la ayuda. (Gracias por la ayuda.) Expresar gratitud: Obrigado por el regalo. (Gracias por el regalo.) Mostrar aprecio: Obrigado por la hospitalidad. (Gracias por la hospitalidad.) Reconocer un favor: Obrigado por escucharme. (Gracias por escucharme.) Responder a un cumplido: Obrigado por el elogio. (Gracias por el cumplido.) Expresar reconocimiento: Obrigado por el apoyo. (Gracias por el apoyo.)",
                            pronunciation: "\"Obrigado\" se pronuncia como oh-bree-gah-doo, con el acento en la segunda sílaba. El sonido 'o' es similar al 'o' en la palabra española «oro», el sonido 'b' se pronuncia como el sonido 'b' en español, y el sonido 'r' se pronuncia como un sonido suave de 'r' en español. El sonido 'i' es similar al 'i' en la palabra española «isla», el sonido 'g' se pronuncia como el sonido 'g' en español, el sonido 'a' es similar al 'a' en la palabra española «casa», y el sonido 'd' se pronuncia como el sonido 'd' en español."
                        ),
                        "fr": MiniaturaCardTranslation(
                            titulo: "Merci 🙏🏽",
                            shortDescription: "\"Obrigado\" est une expression polie et amicale utilisée pour exprimer la gratitude, l'appréciation et la reconnaissance pour une faveur, un cadeau ou un geste aimable.",
                            description: "C'est un mot polyvalent qui peut être utilisé dans une variété de situations, de remercier quelqu'un d'avoir tenu la porte ouverte à exprimer votre appréciation pour un cadeau attentionné. \"Obrigado\" est une façon simple et efficace de montrer de la gratitude et de la bonne volonté envers les autres.",
                            usage: "\"Obrigado\" est une expression polyvalente qui peut être utilisée dans une variété de situations, telles que : Remercier quelqu'un : Obrigado pour l'aide. (Merci pour l'aide.) Exprimer sa gratitude : Obrigado pour le cadeau. (Merci pour le cadeau.) Montrer son appréciation : Obrigado pour l'hospitalité. (Merci pour l'hospitalité.) Reconnaître une faveur : Obrigado pour m'avoir écouté. (Merci de m'avoir écouté.) Répondre à un compliment : Obrigado pour le compliment. (Merci pour le compliment.) Exprimer sa reconnaissance : Obrigado pour le soutien. (Merci pour le soutien.)",
                            pronunciation: "\"Obrigado\" se prononce comme oh-bree-gah-doo, avec l'accent sur la deuxième syllabe. Le son 'o' est similaire au 'o' dans le mot français « rose », le son 'b' se prononce comme le son 'b' en français, et le son 'r' se prononce comme un son doux de 'r' en français. Le son 'i' est similaire au 'i' dans le mot français « île », le son 'g' se prononce comme le son 'g' en français, le son 'a' est similaire au 'a' dans le mot français « là », et le son 'd' se prononce comme le son 'd' en français."
                        )
                    ],
                    locations: nil,
                    zoomSpan: nil,
                    customCenter: nil
                ),
                MiniaturaCard(
                    id: 5,
                    imagem: "vocabulary_en_68",
                    categoria: "Vocabulary",
                    ordem: 5,
                    translations: [
                        "en": MiniaturaCardTranslation(
                            titulo: "Bom Dia/ Boa Noite ☀️🌙 ",
                            shortDescription: "\"Bom dia\" and \"Bom dia\" are polite and friendly expressions used to greet someone in the morning or wish them a good day or night.",
                            description: "They are versatile phrases that can be used in a variety of situations, from greeting friends and family to addressing colleagues and strangers. \"Bom dia\" and \"Boa noite\" are essential phrases in any conversation, allowing you to communicate clearly and effectively.",
                            usage: "\"Bom dia\" and \"Boa noite\" are versatile expressions that can be used in a variety of situations, such as: Greeting someone in the morning: Bom dia, como estás? (Good morning, how are you?) Wishing someone a good day: Bom dia, que tenhas um dia maravilhoso. (Good morning, may you have a wonderful day.) Saying good night: Boa noite, dorme bem. (Good night, sleep well.) Wishing someone sweet dreams: Boa noite, sonhos doces. (Good night, sweet dreams.) Saying goodbye in the evening: Boa noite, até amanhã. (Good night, see you tomorrow.) Ending a phone call: Boa noite, falo contigo amanhã. (Good night, I'll talk to you tomorrow.",
                            pronunciation: "\"Bom dia\" is pronounced as bohng dee-ah, with the stress on the first syllable. The 'b' sound is pronounced as the English 'b' sound, the 'o' sound is similar to the 'o' in the English word 'go,' and the 'm' sound is pronounced as the English 'm' sound. The 'd' sound is pronounced as the English 'd' sound, the 'i' sound is similar to the 'ee' in the English word 'see,' and the 'a' sound is similar to the 'a' in the English word 'la.' \"Boa noite\" is pronounced as boh-ah noy-tchee, with the stress on the first syllable. The 'b' sound is pronounced as the English 'b' sound, the 'o' sound is similar to the 'o' in the English word 'go,' and the 'a' sound is similar to the 'a' in the English word 'la.' The 'n' sound is pronounced as the English 'n' sound, the 't' sound is pronounced as the English 't' sound, the 'ch' sound is pronounced as the English 'ch' sound, and the 'ee' sound is similar to the 'ee' in the English word 'see'."
                        ),
                        "es": MiniaturaCardTranslation(
                            titulo: "Buenos días/Buenas noches ☀️🌙 ",
                            shortDescription: "\"Bom dia\" y \"Boa noite\" son expresiones corteses y amigables utilizadas para saludar a alguien por la mañana o desearle un buen día o noche.",
                            description: "Son frases versátiles que se pueden usar en una variedad de situaciones, desde saludar a amigos y familiares hasta dirigirse a colegas y extraños. \"Bom dia\" y \"Boa noite\" son frases esenciales en cualquier conversación, permitiéndote comunicarte de manera clara y efectiva.",
                            usage: "\"Bom dia\" y \"Boa noite\" son expresiones versátiles que se pueden usar en una variedad de situaciones, como: Saludar a alguien por la mañana: Bom dia, ¿cómo estás? (Buenos días, ¿cómo estás?) Desearle a alguien un buen día: Bom dia, que tengas un día maravilloso. (Buenos días, que tengas un día maravilloso.) Decir buenas noches: Boa noite, duerme bien. (Buenas noches, duerme bien.) Desearle a alguien dulces sueños: Boa noite, sueños dulces. (Buenas noches, dulces sueños.) Decir adiós por la noche: Boa noite, hasta mañana. (Buenas noches, hasta mañana.) Terminar una llamada telefónica: Boa noite, hablo contigo mañana. (Buenas noches, hablo contigo mañana.)",
                            pronunciation: "\"Bom dia\" se pronuncia como bo-un dí-ah, con el acento en la segunda sílaba. La primera sílaba se pronuncia como la palabra 'bon' en francés (sonido nasal), y la segunda sílaba como la palabra 'día' en español. El sonido 'o' es nasal, similar al 'on' en la palabra española «acción» pero más suave. \"Boa noite\" se pronuncia como bó-ah nói-chi, con el acento en la primera sílaba de cada palabra. La primera palabra se pronuncia como 'bó-ah' y la segunda como 'nói-chi'. El sonido 'e' final se prononce como una 'i' suave, similar a la letra 'i' en español."
                        ),
                        "fr": MiniaturaCardTranslation(
                            titulo: "Bonjour/Bonsoir ☀️🌙 ",
                            shortDescription: "\"Bom dia\" et \"Boa noite\" sont des expressions polies et amicales utilisées pour saluer quelqu'un le matin ou lui souhaiter une bonne journée ou une bonne nuit.",
                            description: "Ce sont des phrases polyvalentes qui peuvent être utilisées dans une variété de situations, de saluer des amis et de la famille à s'adresser à des collègues et à des étrangers. \"Bom dia\" et \"Boa noite\" sont des phrases essentielles dans toute conversation, vous permettant de communiquer clairement et efficacement.",
                            usage: "\"Bom dia\" et \"Boa noite\" sont des expressions polyvalentes qui peuvent être utilisées dans une variété de situations, telles que : Saluer quelqu'un le matin : Bom dia, comment ça va? (Bonjour, comment ça va?) Souhaiter une bonne journée : Bom dia, que tu aies une journée merveilleuse. (Bonjour, que tu aies une journée merveilleuse.) Dire bonne nuit : Boa noite, dors bien. (Bonsoir, dors bien.) Souhaiter de beaux rêves : Boa noite, beaux rêves. (Bonsoir, beaux rêves.) Dire au revoir le soir : Boa noite, à demain. (Bonsoir, à demain.) Terminer un appel téléphonique : Boa noite, je te parle demain. (Bonsoir, je te parle demain.)",
                            pronunciation: "\"Bom dia\" se prononce comme bon-djia, avec l'accent sur la deuxième syllabe. La première syllabe se prononce comme le mot 'bon' en français, et la deuxième comme 'djia'. Le son 'on' est nasal, identique au 'on' dans le mot français « pont ». \"Boa noite\" se prononce comme bo-ah no-itchi, avec l'accent sur la première syllabe de chaque mot. Le son 'oi' se prononce comme dans le mot français « oignon » (o-i), et le 'e' final se prononce comme un 'i' bref, similaire à la lettre 'i' en français."
                        )
                    ],
                    locations: nil,
                    zoomSpan: nil,
                    customCenter: nil
                ),
                MiniaturaCard(
                    id: 6,
                    imagem: "vocabulary_en_69",
                    categoria: "Vocabulary",
                    ordem: 6,
                    translations: [
                        "en": MiniaturaCardTranslation(
                            titulo: "I´m sorry 😔 ",
                            shortDescription: "\"Desculpe\" is a polite and friendly expression used to apologize, ask for forgiveness, or get someone's attention.",
                            description: "It is a versatile word that can be used in a variety of situations, from bumping into someone on the street to interrupting a conversation. \"Desculpe\" is a simple and effective way to show respect and consideration for others.",
                            usage: "\"Desculpe\" is a versatile expression that can be used in a variety of situations, such as: Apologizing: Desculpe pelo atraso. (Excuse me for being late.) Asking for forgiveness: Desculpe se o ofendi. (Excuse me if I offended you.) Getting someone's attention: Desculpe, pode ajudar-me? (Excuse me, can you help me?) Interrupting a conversation: Desculpe interromper, mas tenho uma pergunta. (Excuse me for interrupting, but I have a question.) Passing through a crowded place: Desculpe, com licença. (Excuse me, excuse me.) Correcting a mistake: Desculpe, enganei-me no número. (Excuse me, I got the number wrong.)",
                            pronunciation: "\"Desculpe\" is pronounced as dehs-kool-peh, with the stress on the second syllable. The 'd' sound is pronounced as the English 'd' sound, the 'e' sound is similar to the 'e' in the English word 'bed,' the 's' sound is pronounced as the English 's' sound, and the 'c' sound is pronounced as the English 'k' sound. The 'u' sound is similar to the 'oo' in the English word 'food,' the 'l' sound is pronounced as the English 'l' sound, and the 'p' sound is pronounced as the English 'p' sound."
                        ),
                        "es": MiniaturaCardTranslation(
                            titulo: "Lo siento 😔 ",
                            shortDescription: "\"Desculpe\" es una expresión cortés y amigable utilizada para disculparse, pedir perdón o llamar la atención de alguien.",
                            description: "Es una palabra versátil que se puede usar en una variedad de situaciones, desde chocar con alguien en la calle hasta interrumpir una conversación. \"Desculpe\" es una forma simple y efectiva de mostrar respeto y consideración por los demás.",
                            usage: "\"Desculpe\" es una expresión versátil que se puede usar en una variedad de situaciones, como: Disculparse: Desculpe por llegar tarde. (Lo siento por llegar tarde.) Pedir perdón: Desculpe si te ofendí. (Lo siento si te ofendí.) Llamar la atención de alguien: Desculpe, ¿puede ayudarme? (Disculpe, ¿puede ayudarme?) Interrumpir una conversación: Desculpe por interrumpir, pero tengo una pregunta. (Lo siento por interrumpir, pero tengo una pregunta.) Pasar por un lugar concurrido: Desculpe, con permiso. (Disculpe, con permiso.) Corregir un error: Desculpe, me equivoqué en el número. (Lo siento, me equivoqué en el número.)",
                            pronunciation: "\"Desculpe\" se pronuncia como des-cul-pe, con el acento en la segunda sílaba. La primera sílaba se pronuncia como la palabra 'des' en español, la segunda como la palabra 'culpe' en español, y la tercera como la sílaba 'pe' en la palabra española «perro». El sonido 'u' es similar al 'u' en la palabra española «luna», y el sonido 'e' final se pronuncia de forma breve y cerrada, similar a la letra 'e' en español."
                        ),
                        "fr": MiniaturaCardTranslation(
                            titulo: "Je suis désolé 😔 ",
                            shortDescription: "\"Desculpe\" est une expression polie et amicale utilisée pour s'excuser, demander pardon ou attirer l'attention de quelqu'un.",
                            description: "C'est un mot polyvalent qui peut être utilisé dans une variété de situations, de heurter quelqu'un dans la rue à interrompre une conversation. \"Desculpe\" est une façon simple et efficace de montrer du respect et de la considération pour les autres.",
                            usage: "\"Desculpe\" est une expression polyvalente qui peut être utilisée dans une variété de situations, telles que : S'excuser : Desculpe pour le retard. ( permiso.) Corregir un error: Desculpe, me equivoqué en el número. (Lo siento, me equivoqué en el número.)",
                            pronunciation: "\"Desculpe\" se prononce comme dess-koul-pé, avec l'accent sur la deuxième syllabe. La première syllabe se prononce comme le mot 'des' en français, la deuxième comme le mot 'coule' en français, et la troisième comme le mot 'pré' en français (mais sans le 'r'). Le son 'ou' est similaire au 'ou' dans le mot français « loup », et le son 'e' final se prononce comme un 'é' fermé, similaire à la lettre 'é' en français."
                        )
                            
                    ],
                    locations: nil,
                    zoomSpan: nil,
                    customCenter: nil
                ),
                MiniaturaCard(
                    id: 7,
                    imagem: "vocabulary_en_70",
                    categoria: "Vocabulary",
                    ordem: 7,
                    translations: [
                        "en": MiniaturaCardTranslation(
                            titulo: "Goodbye 👋🏽 ",
                            shortDescription: "\"Adeus\" is a formal and polite way to say goodbye, parting   with respect, goodwill, and best wishes.",
                            description: "It is a versatile word that can be used in a variety of situations, from saying goodbye to friends and family to ending a business meeting. \"Adeus\" is a simple and effective way to show appreciation and respect for others.",
                            usage: "\"Adeus\" is a versatile expression that can be used in a variety of situations, such as: Saying goodbye to someone: Adeus, até à próxima. (Goodbye, see you next time.) Parting with respect: Adeus, foi um prazer conhecê-lo. (Goodbye, it was a pleasure to meet you.) Ending a conversation: Adeus, tenha um bom dia. (Goodbye, have a good day.) Wishing someone well: Adeus, que tudo corra bem. (Goodbye, may everything go well.) Saying farewell to a friend: Adeus, até breve. (Goodbye, see you soon.) Ending a phone call: Adeus, falo contigo mais tarde. (Goodbye, I'll talk to you later.)",
                            pronunciation: "\"Adeus\" is pronounced as ah-deh-oosh, with the stress on the second syllable. The 'a' sound is similar to the 'a' in the English word 'father,' the 'd' sound is pronounced as the English 'd' sound, the 'e' sound is similar to the 'e' in the English word 'bed,' and the 'u' sound is similar to the 'oo' in the English word 'food.' The 's' sound is pronounced as the English 's' sound."
                        ),
                        "es": MiniaturaCardTranslation(
                            titulo: "Adiós 👋🏽 ",
                            shortDescription: "\"Adeus\" es una forma formal y cortés de decir adiós, partiendo con respeto, buena voluntad y los mejores deseos.",
                            description: "Es una palabra versátil que se puede usar en una variedad de situaciones, desde despedirse de amigos y familiares hasta terminar una reunión de negocios. \"Adeus\" es una forma simple y efectiva de mostrar aprecio y respeto por los demás.",
                            usage: "\"Adeus\" es una expresión versátil que se puede usar en una variedad de situaciones, como: Decir adiós a alguien: Adeus, hasta la próxima. (Adiós, hasta la próxima.) Partir con respeto: Adeus, fue un placer conocerte. (Adiós, fue un placer conocerte.) Terminar una conversación: Adeus, que tengas un buen día. (Adiós, que tengas un buen día.) Desearle a alguien lo mejor: Adeus, que todo vaya bien. (Adiós, que todo vaya bien.) Despedirse de un amigo: Adeus, hasta pronto. (Adiós, hasta pronto.) Terminar una llamada telefónica: Adeus, hablo contigo más tarde. (Adiós, hablo contigo más tarde.)",
                            pronunciation: "\"Adeus\" se pronuncia como ah-dé-ush, con el acento en la segunda sílaba. La primera sílaba se pronuncia como la letra 'a' en español y la segunda como la palabra 'deus'. El sonido 'eu' es un diptongo donde se pronuncia la 'e' y la 'u' seguidas rápidamente. El sonido 's' al final se pronuncia de forma suave y sibilante, similar al sonido que se hace para pedir silencio o al 'sh' en la palabra inglesa 'show'."
                        ),
                        "fr": MiniaturaCardTranslation(
                            titulo: "Au revoir 👋🏽 ",
                            shortDescription: "\"Adeus\" est une façon formelle et polie de dire au revoir, partant avec respect, bonne volonté et meilleurs vœux.",
                            description: "C'est un mot polyvalent qui peut être utilisé dans une variété de situations, de dire au revoir à des amis et à la famille à terminer une réunion d'affaires. \"Adeus\" est une façon simple et efficace de montrer de l'appréciation et du respect pour les autres.",
                            usage: "\"Adeus\" est une expression polyvalente qui peut être utilisée dans une variété de situations, telles que : Dire au revoir à quelqu'un : Adeus, à la prochaine. (Au revoir, à la prochaine.) Partir avec respect : Adeus, ce fut un plaisir de vous rencontrer. (Au revoir, ce fut un plaisir de vous rencontrer.) Terminer une conversation : Adeus, passez une bonne journée. (Au revoir, passez une bonne journée.) Souhaiter le meilleur à quelqu'un : Adeus, que tout se passe bien. (Au revoir, que tout se passe bien.) Dire au revoir à un ami : Adeus, à bientôt. (Au revoir, à bientôt.) Terminer un appel téléphonique : Adeus, je te parle plus tard. (Au revoir, je te parle plus tard.)",
                            pronunciation: "\"Adeus\" se prononce comme a-dé-ouche, avec l'accent sur la deuxième syllabe. La première syllabe se prononce comme la lettre 'a' en français et la deuxième comme 'dé-ouch'. Le son 'eu' se prononce comme les lettres 'é' et 'ou' liées rapidement, et non comme le 'eu' français dans « fleur ». Le son 's' final se prononce comme le son 'ch' dans le mot français « chat »."
                        )
                    ],
                    locations: nil,
                    zoomSpan: nil,
                    customCenter: nil
                )
            ]
        }
        // Fallback logic for unknown categories
        return []

    }
    
    static func allCategories() -> [String] {
        // Retorna todas as categorias originais dos mocks
        let all = [
            mockCards(for: "Monumentos"),
            mockCards(for: "Natureza"),
            mockCards(for: "Gastronomia"),
            mockCards(for: "Popular"),
            mockCards(for: "Igrejas"),
            mockCards(for: "Museus"),
            mockCards(for: "Sintra"),
            mockCards(for: "Vocabulary")
        ].flatMap { $0 }
        let unique = Set(all.map { $0.categoria })
        return Array(unique)
    }
    
    public static func mockCards(for categoria: String) -> [MiniaturaCard] {
        let normalizedCategoria = categoria.normalized
        // Garante que o filtro funcione tanto para nomes normalizados quanto originais
        if normalizedCategoria == "vocabulário" || normalizedCategoria == "vocabulario" {
            return mockCardsRaw(for: "Vocabulário")
        }
        if normalizedCategoria == "vocabulary" {
            return mockCardsRaw(for: "Vocabulary")
        }
        return allCards().filter { $0.categoria.normalized == normalizedCategoria || $0.categoria == categoria }
    }
}

extension MiniaturaCard {
    static func localizedLocationName(_ nameDict: [String: String], lang: String? = nil) -> String {
        let language = lang ?? Locale.current.language.languageCode?.identifier ?? "pt"
        return nameDict[language] ?? nameDict["pt"] ?? nameDict.values.first ?? ""
    }
}
