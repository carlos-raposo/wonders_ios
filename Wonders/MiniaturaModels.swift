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
                let uniqueCard = MiniaturaCard(id: globalId, imagem: card.imagem, categoria: cat, ordem: card.ordem, translations: card.translations, latitude: card.latitude, longitude: card.longitude, extraLocations: card.extraLocations)
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
                            description: "An imposing medieval fortification in the Gothic style stands on the highest hill in Lisbon, offering panoramic views over the Portuguese capital. Originally built in the 5th century, with Arab and Christian influences, the structure is made of limestone, with robust walls and defensive towers.\n A visit to this iconic monument is an immersion in the history of Portugal, with the opportunity to appreciate the stunning landscapes of the city and the Tagus River.",
                            history: "While its original construction dates back to the 5th century, the castle underwent several expansions and adaptations over the centuries, notably in the 11th and 12th centuries. Its initial purpose was to defend the city of Lisbon, protecting it from invasions and attacks. Later, the castle served as a royal residence and was the scene of important historical events. One of the most significant milestones in the city's history and the formation of Portugal was the conquest of the castle by D. Afonso Henriques from the Moors in 1147.",
                            adress: "Rua de Santa Cruz do Castelo, 1100-129 Lisboa, Portugal"
                        ),
                        "pt": MiniaturaCardTranslation(
                            titulo: "Castelo de São Jorge",
                            shortDescription: "Fundado nos séculos X pelos mouros e conquistado pelo primeiro rei de Portugal em 1147.",
                            description: "Uma imponente fortificação medieval de estilo gótico situada na colina mais alta de Lisboa, oferecendo vistas panorâmicas sobre a capital portuguesa. Originalmente construído no século V, com influências árabes e cristãs, a estrutura é feita de calcário, com robustas muralhas e torres defensivas.\n A visita a este monumento icônico é uma imersão na história de Portugal, com a oportunidade de apreciar as paisagens deslumbrantes da cidade e do Rio Tejo.",
                            history: "Embora sua construção original remonte ao século V, o castelo passou por várias expansões e adaptações ao longo dos séculos, notavelmente nos séculos XI e XII. Seu propósito inicial era defender a cidade de Lisboa, protegendo-a de invasões e ataques. Posteriormente, o castelo serviu como residência real e foi palco de importantes eventos históricos. Um dos marcos mais significativos na história da cidade e na formação de Portugal foi a conquista do castelo por D. Afonso Henriques aos mouros em 1147.",
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
                            description: "An emblematic 15th-century Manueline-style fortification, formerly the gateway to Lisbon. The structure is made of limestone, with ornate details and sculptures of maritime and nationalist themes.\n A must-see monument to learn about Portugal's maritime history, appreciate its unique architecture, and enjoy the views of the Tagus River.",
                            history: "The Manueline style is a unique and exuberant artistic style that flourished in Portugal during the reign of King Manuel I in the 16th century. This style is closely linked to the golden age of Portuguese maritime discoveries, a period of great prosperity and territorial expansion for the country. The tower was built at a time when Portugal was a maritime power, and its strategic location in the Tagus estuary made it a starting point for the great navigations. Construction was completed in 1519, with the function of defending the city. Later, it served as a customs house and lighthouse.\n It was classified as a UNESCO World Heritage Site in 1983, recognizing its historical and cultural importance.",
                            adress: "Av. Brasília, 1400-038 Lisboa, Portugal"
                        ),
                        "pt": MiniaturaCardTranslation(
                            titulo: "Torre de Belém",
                            shortDescription: "Construído no início do século 16, é um portal para o passado marítimo de Portugal.",
                            description: "Uma emblemática fortificação de estilo manuelino do século XV, que antigamente servia como porta de entrada para Lisboa. A estrutura é feita de calcário, com detalhes ornamentais e esculturas de temas marítimos e nacionalistas.\n Um monumento imperdível para conhecer a história marítima de Portugal, apreciar sua arquitetura única e desfrutar das vistas do Rio Tejo.",
                            history: "O estilo manuelino é um estilo artístico único e exuberante que floresceu em Portugal durante o reinado do rei Manuel I no século XVI. Este estilo está intimamente ligado à era dourada das descobertas marítimas portuguesas, um período de grande prosperidade e expansão territorial para o país. A torre foi construída numa época em que Portugal era uma potência marítima, e sua localização estratégica na foz do Tejo a tornava um ponto de partida para as grandes navegações. A construção foi concluída em 1519, com a função de defender a cidade. Posteriormente, serviu como alfândega e farol.\n Foi classificada como Patrimônio Mundial da UNESCO em 1983, reconhecendo sua importância histórica e cultural.",
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
                            shortDescription: "An 18th-century aqueduct that is a remarkable example of hydraulic engineering.",
                            description: "It´s a monumental hydraulic engineering work that supplied the city of Lisbon with potable water. Built in the 18th century, it is a remarkable example of Baroque architecture and a testament to the ingenuity and organizational capacity of the Portuguese people at the time. The aqueduct consists of an extensive network of channels and arches, with the most iconic part being the arcade that crosses the Alcântara valley with its 21 perfect round arches and 14 ogival arches",
                            history: "The construction of the Águas Livres Aqueduct was ordered by King João V in the early 18th century. The need to guarantee the water supply to the growing population of Lisbon, due to urban growth and the expansion of the city, motivatedhis grand work. Construction began in 1732 and continued for several decades, ending in 1799. The design and construction of the aqueduct involved Portuguese and foreign engineers and architects, who used innovative techniques for the time. The aqueduct is a testament to the importance of water for urban life and the ability of the Portuguese people to overcome complex technical challenges.",
                            adress: "Calçada da Quintinha 6, 1070-225 Lisboa, Portugal"
                        ),
                        "pt": MiniaturaCardTranslation(
                            titulo: "Aqueduto das Águas Livres",
                            shortDescription: "Um aqueduto do século 18 que é um exemplo notável de engenharia hidráulica.",
                            description: "É uma monumental obra de engenharia hidráulica que abasteceu a cidade de Lisboa com água potável. Construído no século XVIII, é um exemplo notável da arquitetura barroca e um testemunho da engenhosidade e capacidade organizacional do povo português na época. O aqueduto é composto por uma extensa rede de canais e arcos, sendo a parte mais icônica o arco que atravessa o vale de Alcântara com seus 21 arcos redondos perfeitos e 14 arcos ogivais.",
                            history: "A construção do Aqueduto das Águas Livres foi ordenada pelo rei João V no início do século XVIII. A necessidade de garantir o abastecimento de água à crescente população de Lisboa, devido ao crescimento urbano e à expansão da cidade, motivou esta grandiosa obra. A construção começou em 1732 e continuou por várias décadas, terminando em 1799. O projeto e a construção do aqueduto envolveram engenheiros e arquitetos portugueses e estrangeiros, que utilizaram técnicas inovadoras para a época. O aqueduto é um testemunho da importância da água para a vida urbana e da capacidade do povo português de superar desafios técnicos complexos.",
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
                            shortDescription: "Conceived by the Marquis of Pombal in the 18th century, it is a majestic square that symbolizes Lisbon’s resilience.",
                            description: "It's one of Lisbon's most emblematic squares, located by the Tagus River. With its grand arcades, colorful buildings, and a monumental statue of King José I, the square is a symbol of the city's history and power. It has been the site of important events, such as royal receptions, political demonstrations, and public celebrations.",
                            history: "The Praça do Comércio has a long history, dating back to the reconstruction of Lisbon after the 1755 earthquake. The square was designed as a symbol of the city's rebirth and prosperity, with its grand architecture and open space facing the river. It was originally known as Terreiro do Paço, as it was the location of the royal palace before the earthquake. Over the years, the square has been the scene of important events, such as the assassination of King Carlos I in 1908 and the Carnation Revolution in 1974. Today, it is a vibrant public space, frequented by locals and tourists alike.",
                            adress: "Praça do Comércio, 1100-148 Lisboa, Portugal"
                        ),
                        "pt": MiniaturaCardTranslation(
                            titulo: "Praça do Comércio",
                            shortDescription: "Concebida pelo Marquês de Pombal no século 18, é uma praça majestosa que simboliza a resiliência de Lisboa.",
                            description: "É uma das praças mais emblemáticas de Lisboa, localizada à beira do Rio Tejo. Com suas grandiosas arcadas, edifícios coloridos e uma estátua monumental do rei José I, a praça é um símbolo da história e do poder da cidade. Foi palco de eventos importantes, como recepções reais, manifestações políticas e celebrações públicas.",
                            history: "A Praça do Comércio tem uma longa história, remontando à reconstrução de Lisboa após o terremoto de 1755. A praça foi projetada como um símbolo do renascimento e da prosperidade da cidade, com sua arquitetura grandiosa e espaço aberto voltado para o rio. Originalmente era conhecida como Terreiro do Paço, pois foi o local do palácio real antes do terremoto. Ao longo dos anos, a praça foi cenário de eventos importantes, como o assassinato do rei Carlos I em 1908 e a Revolução dos Cravos em 1974. Hoje, é um espaço público vibrante, frequentado tanto por moradores quanto por turistas.",
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
                            shortDescription: "A wrought-iron wonder erected in 1902 blending historic charm and modern utility.",
                            description: "It's an iconic elevator in the heart of Lisbon, connecting the lower Baixa district with the upper Carmo Square. Designed by the Portuguese engineer Raoul Mesnier du Ponsard, it is a masterpiece of iron architecture, with a neo-Gothic style and intricate details. The elevator offers panoramic views of the city and is a popular attraction for tourists.",
                            history: "The Santa Justa Elevator, also known as the Carmo Lift, was inaugurated in 1902 as a way to connect the Baixa district with the Carmo Square and the ruins of the Carmo Convent. The elevator was designed to facilitate the movement of people between the lower and upper parts of the city, avoiding the steep hills and narrow streets. The iron structure of the elevator was inspired by the Eiffel Tower in Paris and is a testament to the industrial and technological progress of the time. Today, the Santa Justa Elevator is a popular tourist attraction, offering visitors a unique perspective of Lisbon.",
                            adress: "R. do Ouro, 1150-060 Lisboa, Portugal"
                        ),
                        "pt": MiniaturaCardTranslation(
                            titulo: "Elevador de Santa Justa",
                            shortDescription: "Uma maravilha de ferro erguida em 1902 combina apelo histórico e moderno.",
                            description: "É um elevador icônico no coração de Lisboa, que conecta o bairro da Baixa, mais baixo, com a Praça do Carmo, mais alta. Projetado pelo engenheiro português Raoul Mesnier du Ponsard, é uma obra-prima da arquitetura em ferro, com um estilo neogótico e detalhes intrincados. O elevador oferece vistas panorâmicas da cidade e é uma atração popular para turistas.",
                            history: "O Elevador de Santa Justa, também conhecido como Elevador do Carmo, foi inaugurado em 1902 como uma forma de conectar o bairro da Baixa com a Praça do Carmo e as ruínas do Convento do Carmo. O elevador foi projetado para facilitar o movimento das pessoas entre as partes mais baixa e alta da cidade, evitando as colinas íngremes e ruas estreitas. A estrutura de ferro do elevador foi inspirada na Torre Eiffel em Paris e é um testemunho do progresso industrial e tecnológico da época. Hoje, o Elevador de Santa Justa é uma atração turística popular, oferecendo aos visitantes uma perspectiva única de Lisboa.",
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
                            shortDescription: "A tribute to the Portuguese Age of Discovery.",
                            description: "It's a monumental tribute to the Portuguese Age of Discovery, located on the banks of the Tagus River. Shaped like a caravel ship, the monument features statues of prominent figures from the era, such as explorers, cartographers, and royalty. The Discoveries Monument celebrates Portugal's maritime history and its role in the exploration of the world.",
                            history: "The Discoveries Monument was built in 1960 to commemorate the 500th anniversary of the death of Prince Henry the Navigator, a key figure in the Portuguese Age of Discovery. The monument was designed by architect Cottinelli Telmo and sculptor Leopoldo de Almeida, with the collaboration of other artists and craftsmen. The structure is shaped like a caravel ship, with a stylized prow pointing towards the sea. The monument features statues of prominent figures from the Age of Discovery, such as Vasco da Gama, Pedro Álvares Cabral, and Luís de Camões. The Discoveries Monument is a symbol of Portugal's maritime heritage and its contributions to world history.",
                            adress: "Av. Brasília, 1400-038 Lisboa, Portugal"
                        ),
                        "pt": MiniaturaCardTranslation(
                            titulo: "Padrão dos Descobrimentos",
                            shortDescription: "Uma homenagem à Era dos Descobrimentos de Portugal.",
                            description: "É uma homenagem monumental à Era dos Descobrimentos de Portugal, localizada às margens do Rio Tejo. Com a forma de uma caravela, o monumento apresenta estátuas de figuras proeminentes da época, como exploradores, cartógrafos e membros da realeza. O Padrão dos Descobrimentos celebra a história marítima de Portugal e seu papel na exploração do mundo.",
                            history: "O Padrão dos Descobrimentos foi construído em 1960 para comemorar o 500º aniversário da morte do Infante Dom Henrique, uma figura-chave na Era dos Descobrimentos de Portugal. O monumento foi projetado pelo arquiteto Cottinelli Telmo e pelo escultor Leopoldo de Almeida, com a colaboração de outros artistas e artesãos. A estrutura tem a forma de uma caravela, com uma proa estilizada apontando para o mar. O monumento apresenta estátuas de figuras proeminentes da Era dos Descobrimentos, como Vasco da Gama, Pedro Álvares Cabral e Luís de Camões. O Padrão dos Descobrimentos é um símbolo do patrimônio marítimo de Portugal e suas contribuições para a história mundial.",
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
                            shortDescription: "The two bridges connect the south with the north, the past with the future.",
                            description: "Lisbon is known for its iconic bridges that span the Tagus River, connecting the city with the south bank. The most famous bridges are the 25 de Abril Bridge, a suspension bridge reminiscent of the Golden Gate Bridge in San Francisco, and the Vasco da Gama Bridge, one of the longest bridges in Europe. These bridges are not only essential transportation links but also architectural landmarks that contribute to the city's skyline.",
                            history: "The construction of the Lisbon bridges was a significant engineering challenge, given the width and depth of the Tagus River. The 25 de Abril Bridge, originally named the Salazar Bridge, was inaugurated in 1966 and was the longest suspension bridge in Europe at the time. It was later renamed to commemorate the Carnation Revolution of 1974. The Vasco da Gama Bridge, inaugurated in 1998, was built to relieve traffic congestion on the 25 de Abril Bridge and is one of the longest bridges in Europe. Both bridges are essential transportation links for the city and have become iconic symbols of Lisbon.",
                            adress: "Lisbon, Portugal"
                        ),
                        "pt": MiniaturaCardTranslation(
                            titulo: "Pontes de Lisboa",
                            shortDescription: "As duas pontes ligam o sul com o norte, o passado com o futuro.",
                            description: "Lisboa é conhecida por suas pontes icônicas que atravessam o Rio Tejo, conectando a cidade com a margem sul. As pontes mais famosas são a Ponte 25 de Abril, uma ponte suspensa que lembra a Ponte Golden Gate em São Francisco, e a Ponte Vasco da Gama, uma das pontes mais longas da Europa. Essas pontes não são apenas ligações de transporte essenciais, mas também marcos arquitetônicos que contribuem para a linha do horizonte da cidade.",
                            history: "A construção das pontes de Lisboa foi um desafio significativo de engenharia, dada a largura e profundidade do Rio Tejo. A Ponte 25 de Abril, originalmente chamada de Ponte Salazar, foi inaugurada em 1966 e foi a ponte suspensa mais longa da Europa na época. Posteriormente, foi renomeada para comemorar a Revolução dos Cravos de 1974. A Ponte Vasco da Gama, inaugurada em 1998, foi construída para aliviar o congestionamento de tráfego na Ponte 25 de Abril e é uma das pontes mais longas da Europa. Ambas as pontes são ligações de transporte essenciais para a cidade e se tornaram símbolos icônicos de Lisboa.",
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
                            shortDescription: "Explore more incredible monuments in Lisbon!",
                            description: "For those interested in exploring more monumental wonders, these four palaces are worth considering. \n\nPalácio de Ajuda: Situated on top of the Ajuda hill, with stunning views over the river, this magnificent palace in Lisbon preserves the layout and decoration of its rooms in the style of the 19th century, notably the monarchs' apartments and the Throne Room. A neoclassical building from the first half of the 19th century, it was the official residence of the Portuguese royal family from the reign of D. Luís I (1861-89) until the end of the Monarchy in 1910. \n\nPalácio de Queluz (in the picture): Located between Lisbon and Sintra, this 18th-century palace is one of the finest examples of the Rococo style in Portugal, with its sumptuous halls, ornate tiles and lush gardens. Built as a summer retreat for D. Pedro de Bragança, it became the official residence of the Portuguese royal family from the reign of D. Maria I, who transformed it into a royal palace. Its royal apartments, the Throne Room and the meticulously manicured gardens transport visitors to the golden age of the Portuguese monarchy. \n\nPena Palace:- Perched atop the Sintra Mountains, with panoramic views of the surrounding landscape, Pena Palace is a vibrant testament to 19th-century Romanticism. This unique palace, with its eclectic mix of architectural styles, from neo-Gothic to neo-Manueline, is one of the most visited in Portugal. Once the residence of the Portuguese royal family, Pena Palace has been masterfully restored to its original glory, offering visitors a fascinating glimpse into the life of Portuguese royalty in the 19th century.\n\nMafra Palace: - This UNESCO World Heritage-listed complex of palace, basilica and convent is one of the largest royal buildings in Europe, with over 1,200 rooms and an impressive façade that dominates the landscape. \nInside, visitors can marvel at the richness of detail, from the sumptuous library, with its collection of thousands of ancient books, to the impressive basilica, with its six historic organs and two carillons. The richly decorated royal apartments offer a glimpse into the life of the Portuguese royal family in the 18th century.",
                            history: "The palaces of Ajuda, Queluz, Pena, and Mafra are architectural gems that reflect the grandeur and opulence of the Portuguese monarchy. These palaces were built during different periods of Portuguese history, from the 18th to the 19th centuries, and each has its unique style and character. The Palácio de Ajuda is a neoclassical masterpiece, with elegant interiors and stunning views over the river. The Palácio de Queluz is a Rococo jewel, with sumptuous halls and lush gardens. The Pena Palace is a vibrant testament to Romanticism, with its eclectic mix of architectural styles. The Mafra Palace is a UNESCO World Heritage site, with over 1,200 rooms and a richly decorated basilica. Together, these palaces offer a fascinating glimpse into the history and culture of Portugal.",
                            adress: nil
                        ),
                        "pt": MiniaturaCardTranslation(
                            titulo: "Mais Monumentos",
                            shortDescription: "Explore mais dos deslumbrantes monumentos de Lisboa.",
                            description: " Para quem deseja explorar mais maravilhas monumentais, estes quatro palácios valem a pena ser considerados. \n\nPalácio de Ajuda: Situado no topo da colina da Ajuda, com vistas deslumbrantes sobre o rio, este magnífico palácio em Lisboa preserva a disposição e decoração de seus aposentos no estilo do século XIX, notadamente os aposentos dos monarcas e o Salão do Trono. Um edifício neoclássico da primeira metade do século XIX, foi a residência oficial da família real portuguesa desde o reinado de D. Luís I (1861-89) até o fim da Monarquia em 1910. \n\nPalácio de Queluz (na foto): Localizado entre Lisboa e Sintra, este palácio do século XVIII é um dos melhores exemplos do estilo rococó em Portugal, com seus salões suntuosos, azulejos ornamentados e jardins exuberantes. Construído como um retiro de verão para D. Pedro de Bragança, tornou-se a residência oficial da família real portuguesa desde o reinado de D. Maria I, que o transformou em um palácio real. Seus aposentos reais, o Salão do Trono e os jardins meticulosamente cuidados transportam os visitantes para a era dourada da monarquia portuguesa. \n\nPalácio da Pena:- Empoleirado no topo das Montanhas de Sintra, com vistas panorâmicas da paisagem circundante, o Palácio da Pena é um vibrante testemunho do Romantismo do século XIX. Este palácio único, com sua mistura eclética de estilos arquitetônicos, do neogótico ao neo-manuelino, é um dos mais visitados em Portugal. Uma vez residência da família real portuguesa, o Palácio da Pena foi magistralmente restaurado à sua glória original, oferecendo aos visitantes um vislumbre fascinante da vida da realeza portuguesa no século XIX.\n\nPalácio de Mafra: - Este complexo listado como Patrimônio Mundial pela UNESCO, composto por palácio, basílica e convento, é um dos maiores edifícios reais da Europa, com mais de 1.200 quartos e uma impressionante fachada que domina a paisagem.\nDentro, os visitantes podem admirar a riqueza de detalhes, desde a suntuosa biblioteca, com sua coleção de milhares de livros antigos, até a impressionante basílica, com seus seis órgãos históricos e duas carrilhões. Os aposentos reais ricamente decorados oferecem um vislumbre da vida da família real portuguesa no século XVIII.",
                            history: "Os palácios de Ajuda, Queluz, Pena e Mafra são joias arquitetônicas que refletem a grandiosidade e opulência da monarquia portuguesa. Esses palácios foram construídos em diferentes períodos da história de Portugal, do século XVIII ao século XIX, e cada um possui seu estilo e caráter únicos. O Palácio de Ajuda é uma obra-prima neoclássica, com interiores elegantes e vistas deslumbrantes sobre o rio. O Palácio de Queluz é uma joia rococó, com salões suntuosos e jardins exuberantes. O Palácio da Pena é um vibrante testemunho do Romantismo, com sua mistura eclética de estilos arquitetônicos. O Palácio de Mafra é um sítio do Patrimônio Mundial da UNESCO, com mais de 1.200 quartos e uma basílica ricamente decorada. Juntos, esses palácios oferecem um vislumbre fascinante da história e cultura de Portugal.",
                            adress: nil
                        )
                    ],
                    latitude: nil,
                    longitude: nil,
                    extraLocations: nil
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
                            titulo: "Rio Tejo",
                            shortDescription: "O maior rio da Península Ibérica nasce na Espanha e deságua no Oceano Atlântico em Lisboa.",
                            description: "O Rio Tejo é o maior rio da Península Ibérica, com cerca de 1.000 km de comprimento. Nasce em Espanha, na Serra de Albarracín, e desagua no Oceano Atlântico, em Lisboa. O Tejo é um rio navegável, com uma extensa bacia hidrográfica, que desempenhou um papel importante na história de Portugal, como meio de transporte e comunicação entre o interior e a costa. Hoje, o Rio Tejo é um símbolo do património marítimo de Lisboa e um ponto focal para atividades de lazer, como passeios de barco, cruzeiros e passeios à beira-rio.",
                            history: "The Tagus River has a long history of human occupation, from prehistoric times to the present day. The river served as a natural harbor for Phoenician, Roman, and Moorish settlements and Portuguese explorers during the Age of Discovery. The Tagus was an important transport and trade route, providing connections between the interior and the coast of Portugal. Over the centuries, the river has been the scene of battles, maritime discoveries and historical events, playing a central role in the lives of the Portuguese.",
                            adress: "Lisboa, Portugal"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Tagus River",
                            shortDescription: "The largest river in the Iberian Peninsula rises in Spain and flows into the Atlantic Ocean in Lisbon.",
                            description: "The Tagus River (Pt: Rio Tejo) is the largest river in the Iberian Peninsula, with a length of around 1,000 km. It rises in Spain, in the Albarracín Mountains, and flows into the Atlantic Ocean, in Lisbon. The Tagus is a navigable river, with an extensive river basin, which played an important role in the history of Portugal, as a means of transport and communication between the interior and the coast. Today, the Tagus River is a symbol of Lisbon's maritime heritage and a focal point for leisure activities, such as boat tours, cruises, and waterfront promenades.",
                            history: "O Rio Tejo tem uma longa história de ocupação humana, desde os tempos pré-históricos até os dias atuais. O rio serviu como um porto natural para assentamentos fenícios, romanos e mouros, bem como para exploradores portugueses durante a Era dos Descobrimentos. O Tejo foi uma importante rota de transporte e comércio, proporcionando conexões entre o interior e a costa de Portugal. Ao longo dos séculos, o rio foi palco de batalhas, descobertas marítimas e eventos históricos, desempenhando um papel central na vida dos portugueses.",
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
                            description: "Os miradouros de Lisboa são conhecidos pelas suas vistas panorâmicas da cidade e do Rio Tejo. A partir destes pontos elevados, os visitantes podem admirar os bairros históricos da cidade, os telhados vermelhos e os marcos icônicos. Alguns dos miradouros mais populares de Lisboa incluem o Miradouro da Senhora do Monte, o Miradouro de Santa Catarina e o Miradouro de São Pedro de Alcântara.",
                            history: "Os Miradouros em Lisboa têm uma longa história, remontando à ocupação mourisca da cidade. Os pontos de vista elevados eram originalmente usados para fins defensivos, proporcionando uma vantagem estratégica para monitorar a cidade e seus arredores. Ao longo dos séculos, os miradouros tornaram-se locais de encontro populares para moradores e visitantes, oferecendo um refúgio do agito da cidade. Hoje, os miradouros são uma característica adorada da paisagem urbana de Lisboa, proporcionando vistas deslumbrantes e uma sensação de tranquilidade em meio aos bairros históricos da cidade.",
                            adress: "Vários locais em Lisboa"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Viewpoints",
                            shortDescription: "High points in Lisbon with breathtaking views over the city and river.",
                            description: "Lisbon is known for its stunning viewpoints, or miradouros, which offer panoramic views of the city and the Tagus River. From these elevated vantage points, visitors can admire the city's historic neighborhoods, red-tiled rooftops, and iconic landmarks. Some of the most popular viewpoints in Lisbon include the Miradouro da Senhora do Monte, the Miradouro de Santa Catarina, and the Miradouro de São Pedro de Alcântara.",
                        
                            history: "The miradouros in Lisbon have a long history, dating back to the Moorish occupation of the city. The elevated viewpoints were originally used for defensive purposes, providing a strategic advantage for monitoring the city and its surroundings. Over the centuries, the miradouros became popular gathering places for locals and visitors, offering a respite from the city's hustle and bustle. Today, the miradouros are a beloved feature of Lisbon's urban landscape, providing stunning views and a sense of tranquility amidst the city's historic neighborhoods.",
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
                            shortDescription: "Os jardins e parques de Lisboa proporcionam autênticos oásis verdes na cidade",
                            description: "Lisboa é dotada de uma coleção diversificada de jardins e parques. Visitar os jardins de Lisboa é uma maneira maravilhosa de se conectar com a natureza, apreciar a beleza da cidade e desfrutar de momentos de paz e tranquilidade.",
                            history: "Alguns jardins remontam ao século XVIII, criados para a realeza e abertos ao público ao longo dos séculos. \n\nParque Monsanto: Considerado o pulmão de Lisboa é uma vasta área verde com trilhos, áreas de lazer e vistas panorâmicas da cidade. \n\n Jardim da Estrela: Localizado no coração do bairro da Estrela, este charmoso jardim oferece um ambiente relaxante, com um coreto, um lago e uma variedade de plantas e flores. \n\nEstufa Fria: Um espaço único em Lisboa, a Estufa Fria abriga uma exuberante coleção de plantas exóticas de todo o mundo, criando um ambiente mágico e tropical. - Jardim do Príncipe Real: Este charmoso jardim é um ponto de encontro para moradores e turistas, com um quiosque, um lago e uma vista deslumbrante sobre a cidade. \n\nAlém destes, Lisboa possui muitos outros jardins e parques encantadores, como o Jardim Botânico da Ajuda, o Parque Eduardo VII e os Jardins da Fundação Calouste Gulbenkian.",
                            adress: "Ex: Jardim da Estrela, Parque Eduardo VII, Lisboa"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Gardens and Parks",
                            shortDescription: "Green spaces perfect for relaxing, strolling, and enjoying urban nature.",
                            description: "Lisbon is endowed with a diverse collection of gardens and parks. Visiting the gardens of Lisbon is a wonderful way to connect with nature, appreciate the beauty of the city, and enjoy moments of peace and tranquility.",
                            history: "Some gardens date back to the 18th century, created for royalty and opened to the public over the centuries. \n\nMonsanto Park: Considered the lung of Lisbon it's a vast green area with trails, leisure areas, and panoramic views of the city. \n\n Estrela Garden: Located in the heart of the Estrela neighborhood, this charming garden offers a relaxing environment, with a bandstand, a lake, and a variety of plants and flowers. \n\nEstufa Fria: A unique space in Lisbon, the Estufa Fria houses an exuberant collection of exotic plants from all over the world, creating a magical and tropical environment. \n\nJardim do Príncipe Real: This charming garden is a meeting point for locals and tourists, with a kiosk, a lake, and a stunning view over the city. \n\nIn addition to these, Lisbon has many other charming gardens and parks, such as the Jardim Botânico da Ajuda, the Parque Eduardo VII, and the Gardens of the Calouste Gulbenkian.",
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
                            shortDescription: "A Serra de Sintra é Patrimônio Mundial da UNESCO pelo seu conjunto natural e arquitectonico.",
                            description: "É uma cadeia montanhosa localizada perto da cidade de Sintra, um Patrimônio Mundial da UNESCO. As montanhas são conhecidas por sua vegetação exuberante, flora e fauna diversificadas e paisagens deslumbrantes, com vistas panorâmicas do Oceano Atlântico e do campo circundante. A Serra de Sintra é um destino popular para amantes da natureza, caminhantes e entusiastas de atividades ao ar livre.",
                            history: "Considerada sagrada pelos celtas e romanos, as montanhas foram palco de várias atividades religiosas e culturais ao longo dos séculos, com inúmeras capelas, santuários e eremitérios espalhados pela região. No século XIX, as montanhas tornaram-se um destino popular para a nobreza e artistas europeus, atraídos pelas paisagens românticas e pela atmosfera mística. Hoje, a Serra de Sintra é um parque natural protegido, oferecendo aos visitantes uma combinação única de beleza natural, patrimônio cultural e atividades ao ar livre.",
                            adress: "Sintra, Portugal"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Sintra Mountains",
                            shortDescription: "Mystical mountains covered in forest, palaces, and enchanting trails.",
                            description: "It's a mountain range located near the town of Sintra, a UNESCO World Heritage Site. The mountains are known for their lush vegetation, diverse flora and fauna, and stunning landscapes, with panoramic views of the Atlantic Ocean and the surrounding countryside. The Sintra Mountains are a popular destination for nature lovers, hikers, and outdoor enthusiasts.",
                            history: "Considered sacred by the Celts and Romans, the mountains have been the site of various religious and cultural activities over the centuries, with numerous chapels, shrines, and hermitages scattered throughout the region. In the 19th century, the mountains became a popular destination for European nobility and artists, who were drawn to the romantic landscapes and mystical atmosphere. Today, the Sintra Mountains are a protected natural park, offering visitors a unique combination of natural beauty, cultural heritage, and outdoor activities.",
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
                            description: "Lisboa é rodeada por belas praias ao longo da costa atlântica, oferecendo uma variedade de paisagens e oportunidades recreativas. Desde enseadas arenosas e falésias rochosas até ondas para surf e resorts à beira-mar, as praias próximas a Lisboa atendem a todos os gostos e preferências. Algumas das praias mais populares incluem Cascais, Estoril e Costa da Caparica, cada uma com seu charme e atrações únicas.",
                            history: "As praias próximas a Lisboa têm sido um destino popular para moradores e turistas há séculos, oferecendo um refúgio do agito da cidade. As cidades costeiras de Cascais e Estoril tornaram-se resorts da moda no século XIX, atraindo a realeza e aristocracia europeias. A Costa da Caparica, com suas longas praias de areia e vilarejos de pescadores tradicionais, tem sido um local favorito para os residentes de Lisboa que buscam sol, mar e frutos do mar frescos. Hoje, as praias próximas a Lisboa são um destino durante todo o ano, oferecendo uma ampla gama de atividades, desde banhos de sol e natação até surf e esportes aquáticos.",
                            adress: "Costa da Caparica, Carcavelos, Estoril"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Lisbon Beaches",
                            shortDescription: "Golden sands and refreshing sea just minutes from the city center.",
                            description: "Lisbon is surrounded by beautiful beaches along the Atlantic coast, offering a variety of landscapes and recreational opportunities. From sandy coves and rocky cliffs to surf breaks and seaside resorts, the beaches near Lisbon cater to all tastes and preferences. Some of the most popular beaches include Cascais, Estoril, and Costa da Caparica, each with its unique charm and attractions.",
                            history: "The beaches near Lisbon have been a popular destination for locals and tourists for centuries, offering a respite from the city's hustle and bustle. The coastal towns of Cascais and Estoril became fashionable resorts in the 19th century, attracting European royalty and aristocracy. The Costa da Caparica, with its long sandy beaches and traditional fishing villages, has been a favorite spot for Lisbon residents seeking sun, sea, and fresh seafood. Today, the beaches near Lisbon are a year-round destination, offering a wide range of activities, from sunbathing and swimming to surfing and water sports.",
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
                            shortDescription: "Onde a terra acaba e o mar começa. O Cabo da Roca é o ponto mais ocidental da Europa continental.",
                            description: "É o ponto mais ocidental da Europa continental, localizado na costa acidentada de Sintra. O cabo é marcado por um farol e um monumento, oferecendo vistas deslumbrantes do Oceano Atlântico e das falésias circundantes. O Cabo da Roca é um destino popular para turistas e caminhantes, conhecido por suas paisagens dramáticas e pores do sol românticos.",
                            history: "O Cabo da Roca tem sido um ponto de referência para marinheiros e exploradores desde os tempos antigos, marcando o fim do mundo conhecido e o início do desconhecido. O cabo foi mencionado por geógrafos romanos e árabes como o ponto mais ocidental da massa terrestre eurasiática. No século XVI, exploradores portugueses partiram do Cabo da Roca em suas viagens de descoberta, abrindo novas rotas comerciais e estabelecendo Portugal como uma potência marítima. Hoje, o Cabo da Roca é uma atração turística popular, oferecendo aos visitantes um vislumbre da beleza natural e da importância histórica da região.",
                            adress: "Estrada do Cabo da Roca, Colares, Sintra"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Cape Roca",
                            shortDescription: "The westernmost point of mainland Europe, with impressive cliffs.",
                            description: "It's the westernmost point of continental Europe, located on the rugged coastline of Sintra. The cape is marked by a lighthouse and a monument, offering breathtaking views of the Atlantic Ocean and the surrounding cliffs. Cabo da Roca is a popular destination for tourists and hikers, known for its dramatic landscapes and romantic sunsets.",
                            history: "Cabo da Roca has been a point of reference for sailors and explorers since ancient times, marking the end of the known world and the beginning of the unknown. The cape was mentioned by Roman and Arab geographers as the westernmost point of the Eurasian landmass. In the 16th century, Portuguese explorers set sail from Cabo da Roca on their voyages of discovery, opening up new trade routes and establishing Portugal as a maritime power. Today, Cabo da Roca is a popular tourist attraction, offering visitors a glimpse into the region's natural beauty and historical significance.",
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
                            shortDescription: "As maiores ondas do mundo são surfadas na Nazaré.",
                            description: "A Nazaré é uma vila de pescadores conhecida pelas suas ondas gigantes, que atraem surfistas de todo o mundo. As ondas na Praia do Norte podem atingir alturas superiores a 30 metros, tornando-as algumas das maiores do mundo. A topografia submarina única e as condições meteorológicas ao largo da costa da Nazaré criam as condições perfeitas para estas ondas massivas.",
                            history: "As ondas gigantes na Nazaré são um fenómeno natural há séculos, mas foi apenas nos últimos anos que ganharam fama internacional. As ondas são criadas por uma combinação de fatores, incluindo o Canhão da Nazaré, um abismo subaquático que canaliza e amplifica a ondulação, e o Oceano Atlântico Norte, que produz tempestades e ondulações poderosas. Em 2011, o surfista havaiano Garrett McNamara estabeleceu um recorde mundial ao surfar uma onda de 23,77 metros na Praia do Norte, colocando a Nazaré no mapa como um destino de surf de ondas grandes de primeira linha. Desde então, a vila tornou-se um paraíso para surfistas e espetadores que vêm testemunhar as ondas impressionantes e os surfistas destemidos que as enfrentam.",
                            adress: "Praia do Norte, Nazaré"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Nazaré Waves",
                            shortDescription: "Famous for the biggest surfed waves in the world, attracting international surfers.",
                            description: "Nazaré is a fishing village known for its giant waves, which attract surfers from around the world. The waves at Praia do Norte can reach heights of over 100 feet, making them some of the biggest in the world. The unique underwater topography and weather conditions off the coast of Nazaré create the perfect conditions for these massive waves.",
                            history: "The giant waves at Nazaré have been a natural phenomenon for centuries, but it was only in recent years that they gained international fame. The waves are created by a combination of factors, including the Nazaré Canyon, an underwater chasm that funnels and amplifies the swell, and the North Atlantic Ocean, which produces powerful storms and swells. In 2011, Hawaiian surfer Garrett McNamara set a world record by riding a 78-foot wave at Praia do Norte, putting Nazaré on the map as a premier big wave surfing destination. Since then, the village has become a mecca for surfers and spectators, who come to witness the awe-inspiring waves and the daring surfers who ride them.",
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
                            shortDescription: "Descubra mais das maravilhas naturais de Portugal.",
                            description: "Além das 7 maravilhas naturais que mencionamos, existem outros locais próximos a Lisboa que vale a pena destacar. \n\nSerra da Arrábida destaca-se pela sua vegetação mediterrânica densa e bem preservada, que confere à serra uma notável riqueza botânica, com espécies endémicas e outras de grande valor ecológico. As praias da Arrábida, com suas areias brancas e águas cristalinas, são consideradas algumas das mais belas de Portugal, oferecendo um contraste harmonioso entre as montanhas e o mar. \n\nAs Ilhas Berlengas (na foto), por sua vez, constituem um arquipélago de alto valor ecológico, localizado a cerca de 10 quilómetros da costa de Peniche. A Berlenga Grande, a ilha principal, é a única habitada e aberta a visitantes, oferecendo cenários naturais preservados e uma rica história. O arquipélago é renomado pela sua biodiversidade marinha, com uma ampla variedade de espécies de peixes, crustáceos e moluscos. A avifauna das Berlengas também é notável, com várias espécies de aves marinhas nidificando nas ilhas.",
                            history: "A Serra da Arrábida oferece inúmeros trilhos para caminhadas, com diferentes níveis de dificuldade, que permitem explorar sua paisagem diversificada e desfrutar de vistas panorâmicas. As águas da Arrábida são ideais para mergulho e snorkeling, devido à sua clareza e rica biodiversidade marinha. A observação de aves é outra atividade popular nas montanhas, que abrigam várias espécies de aves marinhas e terrestres. \n\nO mergulho é uma das principais atividades nas Ilhas Berlengas, devido à clareza das águas e à riqueza da vida marinha. Os passeios de barco permitem explorar as grutas e enseadas da ilha, bem como observar a fauna marinha e as aves marinhas. Uma visita ao Forte de São João Baptista, uma fortificação histórica localizada na ilha, é outra atração popular. A observação da natureza permite observar a fauna e flora locais.",
                            adress: "Diversos locais em Portugal"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "More Nature",
                            shortDescription: "Discover even more natural wonders in Portugal and around Lisbon.",
                            description: "In addition to the 7 natural wonders we mentioned, there are other places close to Lisbon that are worth mentioning. \n\nSerra da Arrábida stands out for its dense and well-preserved Mediterranean vegetation, which gives the mountain range a remarkable botanical richness, with endemic species and others of great ecological value. The beaches of Arrábida, with their white sands and crystal-clear waters, are considered some of the most beautiful in Portugal, offering a harmonious contrast between the mountains and the sea. \n\n Berlengas Islands (in the picture), in turn, constitute an archipelago of high ecological value, located about 10 kilometres off the coast of Peniche. Berlenga Grande, the main island, is the only one that is inhabited and open to visitors, offering preserved natural scenery and a rich history. The archipelago is renowned for its marine biodiversity, with a wide variety of species of fish, crustaceans and molluscs. The birdlife of the Berlengas is also notable, with several species of seabirds nesting on the islands.",
                            history: "The Serra da Arrábida offers numerous hiking trails, with different levels of difficulty, which allow you to explore its diverse landscape and enjoy panoramic views. The waters of Arrábida are ideal for diving and snorkeling, due to their clarity and rich marine biodiversity. Birdwatching is another popular activity in the mountains, which are home to several species of sea and land birds. \n\nDiving is one of the main activities in the Berlengas Islands, due to the clarity of the waters and the richness of marine life. Boat trips allow you to explore the island's caves and coves, as well as observe marine fauna and seabirds. A visit to Forte de São João Baptista, a historic fortification located on the island, is another popular attraction. Nature observation allows you to observe the local fauna and flora.",
                            adress: "Various locations in Portugal"
                        )
                    ],
                    latitude: nil,
                    longitude: nil,
                    extraLocations: nil
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
                            titulo: "Pastéis de Nata",
                            shortDescription: "Os Pastéis de Nata são deliciosos pastéis de nata portugueses.",
                            description: "Os Pastéis de Nata, também conhecidos como Pastéis de Belém, são um pequeno milagre da pastelaria portuguesa, consistindo numa massa folhada crocante e um recheio cremoso de nata feito com ovos, leite, açúcar e canela. A sua textura delicada e sabor doce fazem deles uma das pastelarias mais populares do mundo.",
                            history: "A receita original foi desenvolvida pelos monges do Mosteiro dos Jerónimos na zona de Belém, provavelmente no século XVIII. Para angariar fundos para a restauração do mosteiro, os monges começaram a vender os pastéis numa padaria próxima, popularizando-os rapidamente. Hoje em dia, apenas os pastéis vendidos em Belém estão autorizados a usar o nome \"Pastéis de Belém\". Assim, todos os outros pastéis de nata são variações da receita original dos monges de Belém. A receita original permanece um segredo bem guardado, mas o Pastel de Nata tornou-se um símbolo da identidade culinária portuguesa e é agora apreciado em todo o mundo.",
                            adress: "Pastéis de Belém, Rua de Belém 84-92, Lisboa"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Pastéis de Nata",
                            shortDescription: "Portugal's most famous pastry, with creamy custard and crispy puff pastry.",
                            description: "\"Pastel de Nata\" also known as \"Pastel de Belém\" or \"Custard Tarts\" in english. It's a small Portuguese pastry marvel, consisting of a crispy puff pastry and a creamy custard filling made with eggs, milk, sugar, and cinnamon. Its delicate texture and sweet flavor make it one of the world's most popular pastries.",
                            history: "The original recipe was developed by the monks of the Jerónimos Monastery in the area of Belém, probably in the 18th century.To raise funds for the restoration of the monastery, the monks began selling the pastries in a nearby bakery, quickly popularizing them. Today, only pastries sold in Belém are authorized to use the name \"Pasteis de Belém\". Thus, all other pasteis de nata are variations of the original recipe from the monks of Belém. The original recipe remains a closely guarded secret, but the Pastel de Nata has become a symbol of Portuguese culinary identity and is now enjoyed worldwide.",
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
                            shortDescription: "O Bacalhau é um prato tradicional português feito com bacalhau salgado.", // L10n_slogan18
                            description: "Por poder ser conservado sem refrigeração e, portanto, estar disponível a qualquer momento, o bacalhau é chamado de \"o fiel amigo\" pelos portugueses. O bacalhau pode ser preparado de várias maneiras e é um peixe muito popular na culinária portuguesa. Existem várias espécies de bacalhau, mas as mais comuns em Portugal são o Gadus morhua e o Gadus macrocephalus. O bacalhau é pescado em águas frias do Atlântico Norte, salgado e seco para conservação. Em Portugal, o bacalhau é preparado de diferentes formas, como assado, cozido ou frito.",
                            history: " O bacalhau é um peixe de águas frias, abundante nos mares do Atlântico Norte, que foi introduzido na dieta portuguesa no século XV. Devido à sua capacidade de conservação, o bacalhau tornou-se um alimento essencial durante a Era dos Descobrimentos, sendo consumido pelos marinheiros durante longas viagens marítimas. Com o tempo, o bacalhau foi integrado na culinária portuguesa, dando origem a uma grande variedade de pratos típicos. Hoje em dia, o bacalhau é um dos símbolos da gastronomia nacional, apreciado tanto por portugueses como por estrangeiros. Algumas das receitas mais conhecidas com bacalhau são o Bacalhau à Brás, Bacalhau à Lagareiro, Bacalhau com Natas e Pastéis de Bacalhau.",
                            adress: "As zonas do Bairro Alto e da Baixa são conhecidas pelo número de bons restaurantes. Mas encontrará bacalhau em qualquer restaurante com cozinha portuguesa."
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Codfish",
                            shortDescription: "The most versatile fish in Portuguese cuisine, prepared in countless ways.",
                            description: "Because it can be preserved without refrigeration and can therefore be available at any time, cod is called \"the faithful friend\" by the Portuguese. Cod can be prepared in many ways and is a very popular fish used in Portuguese cuisine. There are several species of cod, but the most common in Portugal are Gadus morhua and Gadus macrocephalus. Cod is fished in cold waters of the North Atlantic, salted and dried for preservation. In Portugal, cod is prepared in different ways, such as baked, boiled or fried.",
                            history: "Cod is a cold-water fish, abundant in the North Atlantic seas, which was introduced into the Portuguese diet in the 15th century. Due to its ability to preserve, cod became an essential food during the Age of Discovery, being consumed by sailors during long sea voyages. Over time, cod was integrated into Portuguese cuisine, giving rise to a wide variety of typical dishes. Today, cod is one of the symbols of national gastronomy, appreciated by Portuguese and foreigners alike. Some of the best-known recipes with cod are Bacalhau à Brás, Bacalhau à Lagareiro, Bacalhau com Natas and Pastéis de Bacalhau",
                            adress: "The Bairro Alto and Baixa areas are known for their number of good restaurants. But you will find cod in any restaurant with Portuguese cuisine."
                        )
                    ],
                    latitude: 38.7138, // Bairro Alto
                    longitude: -9.1335,
                    extraLocations:  [
                        (38.7079, -9.1366)
                    ]  //acrescentar Baixa (38.7079, -9.1366
                ),
                MiniaturaCard(
                    id: 3,
                    imagem: "ginja",
                    categoria: categoria,
                    ordem: 3,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Ginjinha",
                            shortDescription: "A Ginjinha é um licor popular português feito de ginjas.",
                            description: "A Ginjinha, também conhecida como ginja, é um licor tradicional português feito a partir da maceração de ginjas, um tipo de cereja amarga, em aguardente, com a adição de açúcar e especiarias como canela. Este processo de maceração confere à ginjinha a sua cor rubi intensa, sabor doce e aroma frutado. Tradicionalmente, a pessoa que serve a ginjinha pergunta se \"quer com ou sem ela\", para que o cliente possa dizer se quer ou não um pouco de fruta no copo.",
                            history: "A ginjinha é uma bebida tradicional portuguesa com origens antigas. Provavelmente foram os monges os primeiros a produzir licor de ginja para fins medicinais. Mais tarde, foi vendida em farmácias como um remédio para problemas estomacais. Com o tempo, a ginjinha tornou-se popular entre a população, sendo consumida como aperitivo ou digestivo. Hoje em dia, a ginjinha é uma das bebidas mais populares em Portugal, servida em bares e pubs por todo o país. Existem várias variações da receita original, com diferentes tipos de ginjas e especiarias, que conferem à bebida um sabor único e característico.",
                            destaques: nil,
                            adress: "A Ginjinha, Largo de São Domingos 8, Lisboa",
                            usage: nil,
                            pronunciation: nil
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Ginjinha",
                            shortDescription: "Lisbon's traditional cherry liqueur, served in a small glass.",
                            description: "Ginginha, also known as ginja, is a traditional Portuguese liqueur made from the maceration of ginja, a type of bitter cherry, in brandy, with the addition of sugar and spices such as cinnamon. This maceration process gives the ginginha its intense ruby color, sweet flavor and fruity aroma. Traditionally, the person serving the ginjinha asks if \"you want it with or without it\" so the customer can say whether they want some fruit in the glass or not.",
                            history: "Ginjinha is a traditional Portuguese drink with ancient origins. Monks were probably the first to produce cherry liqueur for medicinal purposes. Later it was sold in pharmacies as a remedy for stomach problems. Over time, ginjinha became popular among the population, being consumed as an aperitif or digestive. Today, ginjinha is one of the most popular drinks in Portugal, served in bars and pubs throughout the country. There are several variations of the original recipe, with different types of cherries and spices, which give the drink a unique and characteristic flavor.",
                            destaques: nil,
                            adress: "A Ginjinha, Largo de São Domingos 8, Lisbon",
                            usage: nil,
                            pronunciation: nil
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
                            shortDescription: "A culinária portuguesa apresenta uma variedade de pratos de peixe fresco.", // L10n_slogan20
                            description: "Portugal é conhecido pela sua culinária baseada em peixe fresco, com uma grande variedade de espécies e formas de prepará-lo. Desde o tradicional bacalhau, ao saboroso robalo, às suculentas sardinhas, o peixe é um ingrediente essencial na cozinha portuguesa. Os pratos de peixe são geralmente simples e saudáveis, preparados com azeite, alho, ervas e legumes frescos.",
                            history: "A pesca é uma atividade antiga em Portugal, com uma longa tradição de captura e consumo de peixe fresco. A localização geográfica do país, próximo ao Oceano Atlântico, proporciona uma grande diversidade de espécies marinhas, que são pescadas ao longo da costa e nos rios. O peixe fresco é um dos pilares da culinária portuguesa, consumido em todo o país, desde as aldeias piscatórias até aos restaurantes de luxo. Os portugueses têm uma relação especial com o peixe, que é apreciado pela sua frescura, sabor e versatilidade.",
                            adress: "Cervejaria Ramiro, Av. Almirante Reis 1, Lisboa"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Fish",
                            shortDescription: "Fresh Atlantic fish are the base of typical Portuguese dishes.",
                            description: "Portugal is known for its cuisine based on fresh fish, with a wide variety of species and ways of preparing it. From traditional cod, to tasty sea bass, to succulent sardines, fish is an essential ingredient in Portuguese cuisine. Fish dishes are generally simple and healthy, cooked with olive oil, garlic, herbs and fresh vegetables.",
                            history: "Fishing is an ancient activity in Portugal, with a long tradition of catching and consuming fresh fish. The country's geographical location, close to the Atlantic Ocean, provides a great diversity of marine species, which are fished along the coast and in the rivers. Fresh fish is one of the pillars of Portuguese cuisine, consumed throughout the country, from fishing villages to luxury restaurants. The Portuguese have a special relationship with fish, which is appreciated for its freshness, flavor and versatility.",
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
                            shortDescription: "A culinária portuguesa inclui uma variedade de deliciosos pratos de carne.", // L10n_slogan21
                            description: "Cozido à portuguesa reúne carnes, enchidos e legumes num prato reconfortante.",
                            history: "Receitas de carne refletem influências rurais e festividades tradicionais.",
                            adress: "Solar dos Presuntos, Rua das Portas de Santo Antão 150, Lisboa"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Meat",
                            shortDescription: "Meat dishes like cozido and roast suckling pig are icons of national cuisine.",
                            description: "Meat is an essential ingredient in Portuguese cuisine, with a wide variety of traditional and regional dishes. From the tasty Portuguese stew, to the spicy arroz de cabidela, to the succulent roast suckling pig, meat is enjoyed in all regions of the country. Meat dishes are usually accompanied by potatoes, rice, vegetables and salads, and seasoned with aromatic herbs and spices.",
                            history: "Meat is an important ingredient in Portuguese cuisine, with a long tradition of consumption and preparation. Pork is one of the most popular meats, and is used in a variety of typical dishes, such as roast suckling pig, feijoada à transmontana and cozido à portuguesa. Beef, lamb and poultry are also popular. The meat is typically marinated in a mixture of olive oil, garlic, and spices then are grilled, baked in the oven, stewed or fried and served with potatoes, rice, or salad, accompanied by a glass of red wine.",
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
                            shortDescription: "As sopas portuguesas são substanciais e saborosas.", // L10n_slogan22
                            description: "É um pilar da culinária portuguesa, com uma grande variedade de receitas e sabores. Algumas das sopas mais populares em Portugal incluem o caldo verde, uma sopa substanciosa feita com couve, batatas e chouriço; a sopa de peixe, uma rica sopa de peixe com vegetais e ervas; e a canja de galinha, uma reconfortante sopa de galinha com arroz. As sopas são essenciais às refeições portuguesas, apreciadas durante todo o ano.",
                            history: "As sopas fazem parte da culinária portuguesa há séculos, refletindo as tradições agrícolas e o património culinário do país. A tradição de fazer sopas com ingredientes locais, como vegetais, leguminosas e carnes, remonta a tempos antigos, quando as sopas eram um alimento básico para camponeses e nobreza. Em Portugal, as sopas são apreciadas durante todo o ano, com diferentes receitas para cada estação e ocasião. As sopas são frequentemente servidas como primeiro prato, acompanhadas de pão, azeitonas e queijo, e são consideradas um símbolo da hospitalidade e convivialidade portuguesas.",
                            adress: "Zé dos Cornos, Beco dos Surradores 5, Lisboa"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Soup",
                            shortDescription: "Soups like caldo verde warm and nourish in any season.",
                            description: "It's a staple of Portuguese cuisine, with a wide variety of recipes and flavors. Some of the most popular soups in Portugal include caldo verde, a hearty soup made with kale, potatoes, and chorizo; sopa de peixe, a rich fish soup with vegetables and herbs; and canja de galinha, a comforting chicken soup with rice. Soups are an essential part of Portuguese meals, enjoyed year-round.",
                            history: "Soups have been a part of Portuguese cuisine for centuries, reflecting the country's agricultural traditions and culinary heritage. The tradition of making soups with local ingredients, such as vegetables, legumes, and meats, dates back to ancient times when soups were a staple food for peasants and nobility alike. In Portugal, soups are enjoyed year-round, with different recipes for each season and occasion. Soups are often served as a first course, accompanied by bread, olives, and cheese, and are considered a symbol of Portuguese hospitality and conviviality.",
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
                            shortDescription: "Portugal é conhecido pelos seus excelentes vinhos.", // L10n_slogan23
                            description: "Portugal é conhecido pela sua rica cultura vinícola, com uma longa história de produção de vinho e uma diversidade de variedades de uvas. Alguns dos vinhos portugueses mais famosos incluem o Vinho do Porto, um vinho fortificado do Vale do Douro; o Vinho Verde, um vinho leve e refrescante da região do Minho; e o Madeira, um vinho doce e complexo das Ilhas da Madeira. Os vinhos portugueses são apreciados em todo o mundo pela sua qualidade, variedade e sabores únicos.",
                            history: "Portugal tem uma longa e rica história de produção de vinho, que remonta aos tempos antigos, quando os romanos introduziram a viticultura na Península Ibérica. O clima, o solo e as variedades de uvas diversificadas do país contribuíram para o desenvolvimento de uma ampla gama de vinhos, cada um com suas características e sabores únicos. Os vinhos portugueses são conhecidos pela sua qualidade, autenticidade, e tradição, com muitas regiões produzindo vinhos distintos que refletem o terroir e a cultura da área. O Vale do Douro, o Vinho Verde e o Alentejo são algumas das regiões vinícolas mais famosas de Portugal, cada uma oferecendo uma experiência vinícola diferente.",
                            adress: "Solar do Vinho do Porto, Rua de São Pedro de Alcântara 45, Lisboa"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Wine",
                            shortDescription: "Portugal is renowned for its excellent wines.",
                            description: "Portugal is known for its rich wine culture, with a long history of winemaking and a diverse range of grape varieties. Some of the most famous Portuguese wines include Port, a fortified wine from the Douro Valley; Vinho Verde, a light and refreshing wine from the Minho region; and Madeira, a sweet and complex wine from the Madeira Islands. Portuguese wines are enjoyed worldwide for their quality, variety, and unique flavors.",
                            history: "Portugal has a long and storied history of winemaking, dating back to ancient times when the Romans introduced viticulture to the Iberian Peninsula. The country's diverse climate, soil, and grape varieties have contributed to the development of a wide range of wines, each with its unique characteristics and flavors. Portuguese wines are known for their quality, authenticity, and tradition, with many regions producing distinctive wines that reflect the terroir and culture of the area. The Douro Valley, Vinho Verde, and Alentejo are some of the most famous wine regions in Portugal, each offering a different wine experience.",
                            adress: "Solar do Vinho do Porto, Rua de São Pedro de Alcântara 45, Lisbon"
                        )
                    ],
                    latitude: 38.7150, // Solar do Vinho do Porto
                    longitude: -9.1432,
                    extraLocations: nil
                ),
                MiniaturaCard(
                    id: 8,
                    imagem: "plus_gastronomia",
                    categoria: categoria,
                    ordem: 8,
                    translations: [
                        "pt": MiniaturaCardTranslation(
                            titulo: "Mais Gastronomia",
                            shortDescription: "Explore mais da deliciosa culinária de Portugal em Lisboa.", // L10n_slogan24
                            description: "Além das 7 maravilhas gastronômicas mencionadas, reservamos um espaço especial para 3 confeitos de pastelaria que, embora não sejam da cidade de Lisboa, vêm de locais muito próximos à cidade. - Travesseiros de Sintra (na foto): feitos com massa folhada, gemas de ovo, amêndoas e açúcar e são universalmente reconhecidos como uma das maiores iguarias de Sintra. - Queijadas de Sintra: farinha, queijo fresco, açúcar, gema de ovo e canela para o recheio são os ingredientes das crocantes e crocantes queijadas de Sintra, que adoçam o paladar e a alma. - Tortas de Azeitão: é um doce tradicional de Azeitão, região do município de Setúbal e é um dos ícones representativos desta região. Com um leve sabor a limão e canela, são um exemplo da pastelaria tradicional portuguesa. A torta de Azeitão é feita com ovos moles, gema de ovo, açúcar e água.",
                            history: "Estes confeitos podem ser encontrados em alguns locais de Lisboa. Os seguintes endereços são de casas que produzem algumas das receitas mais famosas: - Travesseiros de Sintra: Piriquita, R. das Padarias 1/7, Sintra - Queijadas de Sintra: Volta do Duche 12, Sintra - Tortas de Azeitão: Casa das Tortas, R. José Augusto Coelho 11, Azeitão",
                            destaques: "These confections can be found in some places in Lisbon. The following addresses are of houses that produce some of the most famous recipes: - Travesseiros de Sintra: Piriquita, R. das Padarias 1/7, Sintra - Queijadas de Sintra: Volta do Duche 12, Sintra - Tortas de Azeitão: Casa das Tortas, R. José Augusto Coelho 11, Azeitão",
                            adress: "Diversos restaurantes e tascas em Portugal"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "More Gastronomy",
                            shortDescription: "Explore more of Portugal's delicious cuisine in Lisbon.",
                            description: "In addition to the 7 gastronomic wonders mentioned, we have reserved a special space for 3 bakers' confections that, although they are not from the city of Lisbon, come from places very close to the city.\n\n  - Travesseiros de Sintra (in the picture): made with puff pastry, egg yolks, almonds and sugar and are universally recognized as one of the greatest delicacies of Sintra.\n\n - Queijadas de Sintra: flour, fresh cheese, sugar, egg yolk and cinnamon for the filling are the ingredients of the crispy and crunchy queijadas de Sintra, which sweeten the palate and the soul.\n\n - Tortas de Azeitão: it is a traditional confections from Azeitão, a region of the municipality of Setúbal and is one of the representative icons of this region. With a light lemon and cinnamon flavor, they are an example of traditional Portuguese Confectionery. The Azeitão pie is made with soft eggs, egg yolk, sugar and water.",
                            history: nil,
                            destaques: nil,
                            adress: "These confections can be found in some places in Lisbon. The following addresses are of houses that produce some of the most famous recipes:\n\n - Travesseiros de Sintra: Piriquita, R. das Padarias 1-7, Sintra \n\n - Queijadas de Sintra: Volta do Duche 12, Sintra \n\n  - Tortas de Azeitão: Casa das Tortas, R. José Augusto Coelho 11, Azeitão"
                        )
                    ],
                    latitude: 38.7225, // Arbitrário, pode ser alterado
                    longitude: -9.1390,
                    extraLocations: nil
                )
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
                            titulo: "Azulejos",
                            shortDescription: "A arte colorida que cobre fachadas e conta histórias em Lisboa.",
                            description: "São azulejos tradicionais portugueses, conhecidos pelos seus padrões intrincados, cores vibrantes e significado histórico. Os azulejos são usados para decorar edifícios, paredes e pisos, criando impressionantes obras de arte que refletem a herança cultural e as tradições artísticas do país. As telhas são um símbolo do artesanato e da criatividade de Portugal.",
                            history: "A tradição dos azulejos remonta ao século XV, quando os mouros introduziram a arte dos azulejos cerâmicos vidrados em Portugal. A palavra \"azulejo\" vem da palavra árabe \"al zuleycha\", que significa \"pedra polida\". Ao longo dos séculos, os azulejos tornaram-se parte integrante da arquitetura portuguesa, sendo usados para decorar palácios, igrejas e edifícios públicos. Os azulejos são conhecidos pelos seus padrões geométricos, motivos florais e cenas históricas, refletindo a herança cultural e artística do país. Hoje em dia, os azulejos são um símbolo da identidade portuguesa e uma lembrança popular para os visitantes de Portugal.",
                            adress: "Em quase todas as ruas e bairros da cidade."
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Azulejos",
                            shortDescription: "The colorful art that covers facades and tells stories in Lisbon.",
                            description: "They are traditional Portuguese ceramic tiles, known for their intricate patterns, vibrant colors, and historical significance. Azulejos are used to decorate buildings, walls, and floors, creating stunning works of art that reflect the country's cultural heritage and artistic traditions. The tiles are a symbol of Portugal's craftsmanship and creativity.",
                            history: "The tradition of azulejos dates back to the 15th century when the Moors introduced the art of glazed ceramic tiles to Portugal. The word \"azulejo \" comes from the Arabic word  \"al zuleycha, \" meaning  \"polished stone. \" Over the centuries, azulejos became an integral part of Portuguese architecture, used to decorate palaces, churches, and public buildings. The tiles are known for their geometric patterns, floral motifs, and historical scenes, reflecting the country's cultural and artistic heritage. Today, azulejos are a symbol of Portuguese identity and a popular souvenir for visitors to Portugal.",
                            adress: "In almost every street and neighborhood in the city."
                        )
                    ],
                    latitude: 38.7139,
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
                            shortDescription: "O Fado é um gênero musical tradicional português conhecido por suas melodias melancólicas e sentimentais.",
                            description: "É um gênero musical português caracterizado por letras melancólicas e melodias sentimentais, geralmente acompanhadas por guitarra portuguesa e viola. O fadista, o intérprete, é o protagonista, expressando emoções como saudade, amor e desilusão. O fado é um patrimônio cultural imaterial da humanidade, reconhecido pela UNESCO.",
                            history: "As origens exatas do fado são desconhecidas, mas acredita-se que tenha surgido nos bairros populares de Lisboa no final do século XIX. Suas raízes estão na música popular urbana, influenciada por várias culturas, como a árabe, africana e brasileira. O fado era cantado em tabernas e casas de fado por pessoas comuns, expressando seus sentimentos e experiências através da música. Ao longo dos anos, o fado evoluiu e tornou-se um símbolo da identidade nacional portuguesa, apreciado em todo o mundo.",
                            adress: "As casas de fado estão concentradas nos bairros de Alfama e Bairro Alto em Lisboa."
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Fado",
                            shortDescription: "The nostalgic music that echoes through the city’s alleys.",
                            description: "It's a Portuguese musical genre characterized by melancholic lyrics and sentimental melodies, typically accompanied by Portuguese guitar and viola. The fadista, the performer, is the protagonist, expressing emotions such as longing, love, and disillusionment. Fado is an intangible cultural heritage of humanity, recognized by UNESCO.",
                            history: "The exact origins of fado are unknown, but it is believed to have emerged in the popular neighborhoods of Lisbon in the late 19th century. Its roots lie in urban popular music, influenced by various cultures such as Arab, African, and Brazilian. Fado was sung in taverns and fado houses by ordinary people, expressing their feelings and experiences through music. Over the years, fado evolved and became a symbol of Portuguese national identity, appreciated worldwide.",
                            adress: "Fado houses are concentrated in the Alfama and Bairro Alto neighborhoods in Lisbon."
                        )
                    ],
                    latitude: 38.7132,
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
                            shortDescription: "Uma atração imperdível por seu percurso pelos bairros históricos mais bonitos da cidade.",
                            description: "É uma linha de bonde histórico que percorre as estreitas ruas de Lisboa, ligando a Praça Martim Moniz ao bairro do Campo de Ourique. O Eléctrico 28 passa por alguns dos bairros e marcos mais icônicos da cidade, como Alfama, Baixa e Estrela, oferecendo aos passageiros um passeio panorâmico pelo centro histórico de Lisboa.",
                            history: "O Eléctrico 28 está em operação desde 1914, servindo como um importante meio de transporte para residentes e visitantes de Lisboa.O Eléctrico 28 segue um percurso panorâmico pelos bairros históricos de Lisboa, passando por marcos icônicos como a Sé Catedral, o Castelo de São Jorge e a Basílica da Estrela. Os carros de madeira vintage do bonde e os trilhos rangentes evocam uma sensação de nostalgia e charme, tornando-o uma experiência imperdível para os visitantes de Lisboa.",
                            adress: nil
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Tram 28",
                            shortDescription: "Lisbon’s most famous tram, crossing historic neighborhoods.",
                            description: "It's a historic tram line that runs through the narrow streets of Lisbon, connecting the Martim Moniz Square with the Campo Ourique neighborhood. Tram 28 passes through some of the city's most iconic neighborhoods and landmarks, such as Alfama, Baixa, and Estrela, offering passengers a scenic tour of Lisbon's historic center.",
                            history: "Tram 28 has been in operation since 1914, serving as a vital transportation link for Lisbon residents and visitors.Tram 28 follows a scenic route through the historic neighborhoods of Lisbon, passing by iconic landmarks such as the Sé Cathedral, the São Jorge Castle, and the Estrela Basilica. The tram's vintage wooden cars and rattling tracks evoke a sense of nostalgia and charm, making it a must-do experience for visitors to Lisbon.",
                            adress: nil
                        )
                    ],
                    latitude: 38.7167,
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
                            shortDescription: "As tascas são tabernas tradicionais portuguesas conhecidas pelo seu ambiente acolhedor e comida deliciosa.",
                            description: "São tabernas ou restaurantes típicos portugueses, conhecidos pelo seu ambiente casual, comida caseira e preços acessíveis. As tascas servem uma variedade de pratos, como petiscos, pequenas porções de aperitivos; bifanas, sanduíches de porco; e \"caldo verde\", sopa de couve. As tascas são uma opção popular de refeição para locais e visitantes que procuram experimentar a autêntica cozinha portuguesa.",
                            history: "As tascas são uma tradição antiga em Portugal, remontando ao século XIX, quando eram frequentadas por marinheiros, trabalhadores e estudantes. Com o tempo, as tascas tornaram-se locais de convívio para pessoas de todas as classes sociais, que apreciavam a comida caseira, o ambiente acolhedor e os preços acessíveis. As tascas são conhecidas pela sua simplicidade e autenticidade, servindo pratos tradicionais portugueses, como bacalhau à brás, feijoada, cozido à portuguesa, entre outros. Hoje em dia, as tascas são pontos populares entre locais e turistas, que procuram uma experiência gastronómica autêntica e genuína.",
                            adress: nil
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Tascas",
                            shortDescription: "Small typical restaurants, full of flavor and tradition.",
                            description: "They are traditional Portuguese taverns or eateries, known for their casual atmosphere, hearty food, and affordable prices. Tascas serve a variety of dishes, such as petiscos, small plates of appetizers; bifanas, pork sandwiches; and \"caldo verde\", kale soup. Tascas are a popular dining option for locals and visitors looking to experience authentic Portuguese cuisine.",
                            history: "Tascas are an ancient tradition in Portugal, dating back to the 19th century, when they were frequented by sailors, workers and students. Over time, bars became places for people from all social classes to socialize and eat, who enjoyed home-cooked food, a cozy atmosphere and affordable prices. The taverns are known for their simplicity and authenticity, serving traditional Portuguese dishes, such as bacalhau à brás, feijoada, cozido à portuguesa, among others. Today, taverns are popular spots among locals and tourists alike, seeking an authentic and genuine dining experience.",
                            adress: nil
                        )
                    ],
                    latitude: 38.7135,
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
                            shortDescription: "A Feira da Ladra é um popular mercado de pulgas em Lisboa, oferecendo uma grande variedade de itens únicos.",
                            description: "É o mercado mais antigo de Lisboa, realizado todas as terças e sábados no bairro de Alfama. O mercado oferece uma grande variedade de itens, desde antiguidades e roupas vintage a artesanato e artigos de segunda mão. É um destino popular para locais e turistas, conhecido pela sua atmosfera animada e achados únicos.",
                            history: "A Feira da Ladra tem uma longa história, remontando ao século XIII, quando foi estabelecida como um local para a venda de bens roubados. Com o tempo, o mercado evoluiu para um local de comércio legítimo, atraindo vendedores e compradores de todas as classes sociais. O nome Feira da Ladra, que significa \"Mercado do Ladrão\", diz-se ter origem na venda de bens roubados no passado. Hoje em dia, o mercado é um centro cultural e social, oferecendo uma experiência de compras única e um vislumbre da vibrante vida de rua de Lisboa.",
                            adress: "Campo de Santa Clara, Alfama, Lisbon"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Feira da Ladra",
                            shortDescription: "The most famous flea market for finds and antiques.",
                            description: "It's Lisbon's oldest flea market, held every Tuesday and Saturday in the Alfama neighborhood. The market offers a wide variety of items, from antiques and vintage clothing to handicrafts and second-hand goods. It's a popular destination for locals and tourists alike, known for its lively atmosphere and unique finds.",
                            history: "The Feira da Ladra has a long history, dating back to the 13th century when it was established as a place for the sale of stolen goods. Over time, the market evolved into a legitimate trading place, attracting vendors and buyers from all walks of life. The name Feira da Ladra, which means \"Thief's Market\" is said to have originated from the sale of stolen goods in the past. Today, the market is a cultural and social hub, offering a unique shopping experience and a glimpse into Lisbon's vibrant street life.",
                            adress: "Campo de Santa Clara, Alfama, Lisbon"
                        )
                    ],
                    latitude: 38.7172,
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
                            titulo: "Futebol",
                            shortDescription: "O futebol é um esporte amado em Portugal, com fãs apaixonados e clubes históricos.",
                            description: "O futebol é o esporte mais popular em Portugal, com uma longa história e uma base de fãs apaixonada. Os principais clubes de futebol da cidade são o Benfica e o Sporting. A seleção nacional portuguesa, conhecida como Seleção, também alcançou grande sucesso, vencendo o Campeonato Europeu da UEFA em 2016.",
                            history: "O Estádio da Luz é o maior estádio de Portugal e um dos maiores da Europa, com capacidade para mais de 65.000 espectadores. O Estádio de Alvalade é a casa do Sporting, um dos clubes mais antigos e prestigiados de Portugal. Ambos os estádios são locais de culto para os fãs de futebol, que se reúnem para apoiar suas equipes e celebrar sua paixão pelo esporte.",
                            adress: "- Estádio da Luz (Benfica)\n- Estádio de Alvalade (Sporting)"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Football",
                            shortDescription: "The national passion that brings crowds together in Lisbon.",
                            description: "Football is the most popular sport in Portugal, with a long history and passionate fan base. The city's top football clubs are Benfica and Sporting. The Portuguese national team, known as the Seleção, has also achieved great success, winning the UEFA European Championship in 2016.",
                            history: "Benfica Stadium is the largest stadium in Portugal and one of the largest in Europe, with a capacity for more than 65,000 spectators. Alvalade Stadium is home to Sporting, one of the oldest and most prestigious clubs in Portugal. Both stadiums are places of worship for football fans, who come together to support their teams and celebrate their passion for the sport.",
                            adress: "- Estádio da Luz (Benfica)\n- Estádio de Alvalade (Sporting)"
                        )
                    ],
                    latitude: 38.7633,
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
                            shortDescription: "Os Santos Populares são festas tradicionais portuguesas que celebram santos populares com música, dança e comida.",
                            description: "Os Santos Populares são festas tradicionais que acontecem em Portugal, durante o mês de junho, em honra a três santos católicos: Santo António, São João e São Pedro. A noite de Santo António é o ponto alto das festividades, pois Lisboa é a cidade natal do santo. As festividades incluem desfiles, marchas populares, danças, fogueiras, sardinhas assadas, manjericos e muita diversão.",
                            history: "Os Santos Populares são uma tradição antiga em Portugal, que remonta ao século XVIII, quando eram celebrados em honra a santos católicos. As festividades incluem desfiles, marchas populares, danças, fogueiras, sardinhas assadas, manjericos e muita diversão. É um momento de celebração e convívio, quando as ruas se enchem de cor e alegria, e as pessoas se reúnem para celebrar a vida e a amizade.",
                            adress: "As melhores festas, chamadas \"arraiais\", são realizadas nos bairros mais antigos de Lisboa."
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Santos Populares",
                            shortDescription: "Lively street festivals with music, sardines, and joy.",
                            description: "The Popular Saints are traditional festivals that take place in Portugal, during the month of June, in honor of three Catholic saints: Saint Anthony, Saint John and Saint Peter. The night of Saint Anthony is the highlight of the festivities as Lisbon is the saint's birthplace. The festivities include parades, popular marches, dances, bonfires, grilled sardines, basil and lots of fun.",
                            history: "Popular Saints are an ancient tradition in Portugal, dating back to the 18th century, when they were celebrated in honor of Catholic saints. The festivities include parades, popular marches, dances, bonfires, grilled sardines, basil and lots of fun. It is a time of celebration and socializing, when the streets are filled with color and joy, and people come together to celebrate life and friendship.",
                            adress: "The best parties, called \"arraiais\", are held in the oldest neighborhoods of Lisbon."
                        )
                    ],
                    latitude: 38.7131,
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
                            shortDescription: "Explore mais da rica herança cultural de Portugal.",
                            description: "Vida Noturna: A cidade ganha vida à noite, oferecendo uma variedade de opções para todos os gostos. Aqui estão alguns destaques da vida noturna de Lisboa: - Bairro Alto: um dos bairros mais animados de Lisboa, conhecido pelas suas ruas estreitas cheias de bares; - Cais do Sodré (na foto): uma antiga zona portuária que se tornou um ponto quente da vida noturna com muitos restaurantes e bares. Aqui você encontrará a Rua Cor-de-Rosa - famosa por sua rua pintada de rosa e guarda-chuvas coloridos pendurados nela; - Os Docks: Uma área à beira do rio com bares e clubes.",
                            history: nil,
                            adress: "- Bairro Alto: metro Baixa-Chiado\n- Cais do Sodré: metro Cais do Sodré\n- Os Docks:Entre o Cais do Sodré e o bairro de Belém. Não há metro. O acesso é de Táxi, Uber ou carro próprio."
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "More Traditions",
                            shortDescription: "Discover other Lisbon traditions and customs.",
                            description: "Nightlife: The city comes to life at night, offering a variety of options to suit all tastes. Here are some highlights of Lisbon's nightlife: - Bairro Alto: one of Lisbon's liveliest neighborhoods, known for its narrow streets full of bars; - Cais do Sodré (in the picture): a former port area that has become a nightlife hotspot with many restaurants and bars. Here you will find Pink Street - famous for its pink painted street and colorful umbrellas hanging from it; - The Docks: A riverside area with bars and clubs.",
                            history: nil,
                            adress: "- Bairro Alto: metro Baixa-Chiado\n- Cais do Sodré: metro Cais do Sodré\n- The Docks:Between Cais do Sodré and the Belém neighborhood. There is no subway. Access is by Taxi, Uber or your own car."
                        )
                    ],
                    latitude: 38.7200,
                    longitude: -9.1400,
                    extraLocations: nil
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
                            titulo: "Sé Catedral",
                            shortDescription: "A catedral mais antiga de Lisboa, construída no século XII, exibindo uma mistura de estilos arquitetónicos.",
                            description: "A Sé Catedral de Lisboa, oficialmente a Catedral Patriarcal de Santa Maria Maior, é a igreja mais antiga da cidade. Construída no século XII, pouco depois da reconquista cristã da cidade aos mouros, combina elementos de arquitetura românica, gótica e barroca. A catedral sobreviveu a vários terremotos, incluindo o devastador terremoto de 1755, o que lhe confere a sua mistura única de estilos arquitetónicos.",
                            history: "A catedral foi construída no local de uma antiga mesquita, após a reconquista cristã da cidade pelo rei Afonso I em 1147. Ao longo dos séculos, sofreu inúmeras renovações e adições, com cada período deixando a sua marca na estrutura. Apesar dos danos causados pelo terremoto de 1755, a catedral manteve a sua importância religiosa e histórica como sede da Arquidiocese de Lisboa.",
                            adress: "Largo da Sé, 1100-585 Lisboa'"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Sé Cathedral",
                            shortDescription: "Lisbon's oldest cathedral, a symbol of faith and the city's history.",
                            description: "The Sé Cathedral of Lisbon, officially the Patriarchal Cathedral of St. Mary Major, is the oldest church in the city. Built in the 12th century, shortly after the Christian reconquest of the city from the Moors, it combines elements of Romanesque, Gothic, and Baroque architecture. The cathedral has survived several earthquakes, including the devastating 1755 earthquake, which gives it its unique blend of architectural styles.",
                            history: "The cathedral was built on the site of a former mosque, following the Christian reconquest of the city by King Afonso I in 1147. Over the centuries, it has undergone numerous renovations and additions, with each period leaving its mark on the structure. Despite the damage caused by the 1755 earthquake, the cathedral has maintained its religious and historical significance as the seat of the Archdiocese of Lisbon.",
                            adress: "Largo da Sé, 1100-585 Lisboa'"
                        )
                    ],
                    latitude: 38.7108,
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
                            shortDescription: "Um patrimônio mundial da UNESCO que exemplifica o estilo arquitetónico manuelino ornamentado português.",
                            description: "O Mosteiro dos Jerónimos é uma obra-prima da arquitetura manuelina, simbolizando a Era dos Descobrimentos de Portugal. Construído no início do século XVI, foi encomendado pelo rei Manuel I para comemorar a bem-sucedida viagem de Vasco da Gama à Índia e para agradecer à Virgem Maria pelo seu sucesso. O mosteiro é notável pelos seus elaborados motivos marítimos, intrincadas esculturas em pedra e pelo seu design harmonioso.",
                            history: "A construção começou em 1501 e continuou por 100 anos. O mosteiro foi povoado por monges da Ordem de São Jerónimo, que tinham a tarefa de rezar pela alma do rei e fornecer assistência espiritual aos navegadores e marinheiros que partiam da praia próxima de Belém. O mosteiro abriga os túmulos de Vasco da Gama e do poeta Luís de Camões, entre outras figuras portuguesas notáveis. Foi classificado como Patrimônio Mundial da UNESCO em 1983.",
                            adress: "Praça do Império 1400-206 Lisboa'"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Jerónimos Monastery",
                            shortDescription: "A Manueline masterpiece and UNESCO World Heritage Site.",
                            description: "The Jerónimos Monastery is a masterpiece of Manueline architecture, symbolizing Portugal's Age of Discoveries. Built in the early 16th century, it was commissioned by King Manuel I to commemorate Vasco da Gama's successful voyage to India and to thank the Virgin Mary for his success. The monastery is notable for its ornate maritime motifs, intricate stone carvings, and its harmonious design.",
                            history: "Construction began in 1501 and continued for 100 years. The monastery was populated by monks of the Order of Saint Jerome, who were tasked with praying for the king's soul and providing spiritual assistance to navigators and sailors who departed from the nearby beach of Belém. The monastery houses the tombs of Vasco da Gama and the poet Luís de Camões, among other notable Portuguese figures. It was classified as a UNESCO World Heritage Site in 1983.",
                            adress: "Praça do Império 1400-206 Lisboa'"
                        )
                    ],
                    latitude: 38.6978,
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
                            shortDescription: "Uma igreja histórica que sobreviveu ao terramoto de 1755 e apresenta belas obras de arte religiosa.",
                            description: "A Igreja de São Domingos é uma das igrejas mais históricas de Lisboa, com uma história marcada pela resiliência e sobrevivência. Fundada em 1241, testemunhou casamentos reais, coroações e o infame Massacre de Lisboa de 1506. Apesar de ter sido severamente danificada por terremotos e incêndios, a igreja continua de pé e serve como um local de culto.",
                            history: "Ao longo da sua história, a igreja sobreviveu aos terremotos de 1531 e 1755, bem como a um devastador incêndio em 1959. Em vez de restaurar completamente a igreja após o incêndio, foi tomada a decisão de preservar os pilares e paredes marcados como um testemunho da resiliência da igreja. A igreja contém várias obras de arte valiosas e artefatos religiosos, incluindo um presépio do século XVIII e várias esculturas e pinturas.",
                            adress: "Largo de São Domingos 1, 1150-320 Lisboa'"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "São Domingos",
                            shortDescription: "A church marked by tragedies and reconstructions, full of history.",
                            description: "The Church of São Domingos is one of Lisbon's most historic churches, with a history marked by resilience and survival. Founded in 1241, it has witnessed royal weddings, coronations, and the infamous Lisbon Massacre of 1506. Despite being severely damaged by earthquakes and fires, the church continues to stand and serve as a place of worship",
                            history: "Throughout its history, the church has survived the 1531 and 1755 earthquakes, as well as a devastating fire in 1959. Rather than completely restoring the church after the fire, the decision was made to preserve the scarred pillars and walls as a testament to the church's resilience. The church contains several valuable artworks and religious artifacts, including an 18th-century nativity scene and various sculptures and paintings.",
                            adress: "Largo de São Domingos 1, 1150-320 Lisboa'"
                        )
                    ],
                    latitude: 38.7142,
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
                            shortDescription: "Abriga capelas barrocas deslumbrantes e uma impressionante coleção de arte religiosa.",
                            description: "A Igreja de São Roque é uma das primeiras igrejas jesuítas do mundo e uma das mais belas de Portugal. Apesar do seu exterior relativamente simples, o interior é um tesouro de arte barroca, apresentando capelas ricamente decoradas, pinturas valiosas e uma impressionante coleção de relíquias.",
                            history: "Construída no século XVI, a igreja foi inicialmente erguida num local que havia sido um cemitério para vítimas da peste, onde um santuário a São Roque (Santo Roque, o santo padroeiro contra a peste) havia sido estabelecido. A igreja foi entregue aos jesuítas que procederam à construção de uma das primeiras igrejas jesuítas do mundo. A característica mais notável da igreja é a Capela de São João Batista, encomendada pelo rei João V no século XVIII. A capela foi projetada em Roma, abençoada pelo Papa e depois desmontada e enviada para Lisboa.",
                            adress: "Largo Trindade Coelho, 1200-470 Lisboa"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "São Roque",
                            shortDescription: "One of the oldest Jesuit churches in the world, with a rich interior.",
                            description: "The Church of São Roque is one of the first Jesuit churches in the world and one of the most beautiful in Portugal. Despite its relatively plain exterior, the interior is a treasure trove of baroque art, featuring richly decorated chapels, valuable paintings, and an impressive collection of relics.",
                            history: "Built in the 16th century, the church was initially erected on a site that had been a cemetery for plague victims, where a shrine to São Roque (Saint Roch, the patron saint against plague) had been established. The church was given to the Jesuits who proceeded to build one of the first Jesuit churches in the world. The church's most remarkable feature is the Chapel of St. John the Baptist, commissioned by King João V in the 18th century. The chapel was designed in Rome, blessed by the Pope, and then dismantled and shipped to Lisbon.",
                            adress: "Largo Trindade Coelho, 1200-470 Lisboa"
                        )
                    ],
                    latitude: 38.7147,
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
                            shortDescription: "Uma magnífica basílica do século XVIII conhecida pela sua grande cúpula e arquitetura neoclássica.",
                            description: "A Basílica da Estrela é uma igreja neoclássica e barroca em Lisboa, conhecida pela sua grande cúpula e interior de mármore. Encomendada pela rainha Maria I para celebrar o nascimento do seu filho e herdeiro, a basílica é um testemunho da gratidão e devoção da rainha.",
                            history: " A basílica foi construída entre 1779 e 1790, cumprindo um voto feito pela rainha Maria I. Ironicamente, o seu filho morreu antes da conclusão da igreja, e a própria rainha começou a mostrar sinais de doença mental na altura da sua conclusão. A basílica é notável pelo seu interior de mármore, belos vitrais e um elaborado presépio composto por mais de 500 figuras de cortiça e terracota criadas por Joaquim Machado de Castro.",
                            adress: "Praça da Estrela, 1200-667 Lisboa"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Estrela Basilica",
                            shortDescription: "Imposing white-domed basilica, a landmark in Lisbon's skyline.",
                            description: "The Basilica da Estrela is a neoclassical and baroque church in Lisbon, known for its grand dome and marble interior. Commissioned by Queen Maria I to celebrate the birth of her son and heir, the basilica stands as a testament to the queen's gratitude and devotion.",
                            history: "The basilica was built between 1779 and 1790, fulfilling a vow made by Queen Maria I. Ironically, her son died before the church was completed, and the queen herself began showing signs of mental illness by the time of its completion. The basilica is notable for its marble interior, beautiful stained glass windows, and an elaborate nativity scene comprising more than 500 cork and terracotta figures created by Joaquim Machado de Castro.",
                            adress: "Praça da Estrela, 1200-667 Lisboa"
                        )
                    ],
                    latitude: 38.7162,
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
                            shortDescription: "As ruínas desta igreja gótica permanecem como uma lembrança comovente do terramoto de 1755.",
                            description: "As ruínas do Convento e Igreja do Carmo permanecem como um lembrete comovente do devastador terramoto de 1755 que destruiu grande parte de Lisboa. A igreja gótica, com a sua nave sem teto aberta ao céu, é agora um museu arqueológico que abriga uma coleção de artefatos e lápides.",
                            history: "Fundado em 1389 pelo cavaleiro português Nuno Álvares Pereira, o Convento do Carmo foi outrora a maior igreja de Lisboa. Foi quase completamente destruído pelo terramoto de 1755, que ocorreu no Dia de Todos os Santos, quando a igreja estava cheia de fiéis, resultando em muitas vítimas. Após o terramoto, a Revolução Liberal de 1834 e a dissolução das ordens religiosas em Portugal, as ruínas foram preservadas como uma memória do desastre. Em 1864, a Associação dos Arqueólogos Portugueses estabeleceu um museu nas ruínas, que continua a funcionar até hoje.",
                            adress: "Largo do Carmo, 1200-092 Lisboa"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Carmo",
                            shortDescription: "Gothic ruins that bear witness to the great 1755 earthquake.",
                            description: "The ruins of the Carmo Convent and Church stand as a haunting reminder of the devastating 1755 earthquake that destroyed much of Lisbon. The Gothic church, with its roofless nave open to the sky, is now an archaeological museum housing a collection of artifacts and tombstones.",
                            history: "Fundado em 1389 pelo cavaleiro português Nuno Álvares Pereira, o Convento do Carmo já foi a maior igreja de Lisboa. Foi quase completamente destruído pelo terramoto de 1755, que atingiu a cidade no Dia de Todos os Santos, quando a igreja estava cheia de fiéis, resultando em muitas vítimas. Após o terramoto, a Revolução Liberal de 1834 e a dissolução das ordens religiosas em Portugal, as ruínas foram preservadas como uma memória do desastre. Em 1864, a Associação dos Arqueólogos Portugueses estabeleceu um museu nas ruínas, que continua a funcionar até hoje.",
                            adress: "Largo do Carmo, 1200-092 Lisboa"
                        )
                    ],
                    latitude: 38.7126,
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
                            shortDescription: "Uma estátua icónica de Cristo que observa a cidade do outro lado do rio Tejo.",
                            description: "Cristo-Rei, ou Cristo Rei, é um monumento e santuário católico que domina a cidade de Lisboa. Situado na margem sul do rio Tejo, na cidade de Almada, o monumento consiste numa estátua de Cristo com 28 metros de altura, com os braços levantados, em cima de um pedestal de 75 metros de altura.",
                            history: "Inspirado na estátua do Cristo Redentor no Rio de Janeiro, Brasil, o monumento Cristo-Rei foi construído como resposta a um apelo do Episcopado Português para que Deus poupasse Portugal aos horrores da Segunda Guerra Mundial. A construção começou em 1949 e foi concluída em 1959. O monumento oferece vistas panorâmicas de Lisboa e da Ponte 25 de Abril, que liga os dois lados do rio Tejo. Tornou-se um símbolo icónico de Lisboa e um importante local de peregrinação para os católicos.",
                            adress: "Av. Cristo Rei, 2800-058 Almada"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Cristo Rei",
                            shortDescription: "Monumental statue with panoramic views over Lisbon and the Tagus.",
                            description: "Cristo-Rei, or Christ the King, is a Catholic monument and shrine overlooking the city of Lisbon. Standing on the southern bank of the Tagus River, in the city of Almada, the monument consists of a 28-meter-tall statue of Christ with arms raised, standing on a 75-meter-tall pedestal.",
                            history: "Inspired by the Christ the Redeemer statue in Rio de Janeiro, Brazil, the Cristo-Rei monument was built as a response to a plea from the Portuguese Episcopate for God to spare Portugal from the horrors of World War II. Construction began in 1949 and was completed in 1959. The monument offers panoramic views of Lisbon and the 25 de Abril Bridge, which connects the two sides of the Tagus River. It has become an iconic symbol of Lisbon and a significant pilgrimage site for Catholics.",
                            adress: "Av. Cristo Rei, 2800-058 Almada"
                        )
                    ],
                    latitude: 38.6781,
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
                            shortDescription: "Fátima: visite um dos maiores santuarios do mundo.",
                            description: "O Santuário de Fátima é um dos maiores santuários marianos do mundo, atraindo milhões de peregrinos todos os anos. Localizado na cidade de Fátima, a cerca de 130 km de Lisboa, o santuário é dedicado à Virgem Maria e às aparições que ocorreram em 1917. O santuário inclui a Basílica de Nossa Senhora do Rosário, a Capela das Aparições, a Basílica da Santíssima Trindade e a Casa de Retiros de Nossa Senhora do Carmo.",
                            history: "O santuário foi construído no local onde três crianças afirmaram ter visto a Virgem Maria em seis ocasiões entre maio e outubro de 1917. As aparições de Fátima foram declaradas autênticas pela Igreja Católica em 1930, e o local tornou-se um importante destino de peregrinação para católicos de todo o mundo. O santuário é especialmente popular durante as celebrações anuais de 13 de maio e 13 de outubro, que marcam as datas das aparições.",
                            adress: "O Santuário de Fátima está localizado na cidade de Fátima, a cerca de 130 quilômetros a norte de Lisboa. A maneira mais fácil de chegar lá é de carro ou autocarro, com serviços regulares de Lisboa para Fátima. O santuário está aberto durante todo o ano e acolhe visitantes de todas as fés para rezar, refletir e experienciar a atmosfera espiritual deste lugar sagrado."
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "More Churches",
                            shortDescription: "Discover other historic churches and temples in Lisbon.",
                            description: "The Sanctuary of Fátima is one of the largest Marian sanctuaries in the world, attracting millions of pilgrims every year. Located in the city of Fátima, about 130 km from Lisbon, the sanctuary is dedicated to the Virgin Mary and the apparitions that occurred in 1917. The sanctuary includes the Basilica of Our Lady of the Rosary, the Chapel of the Apparitions, the Basilica of the Most Holy Trinity and the Retreat House of Our Lady of Mount Carmel.",
                            history: "The shrine was built on the site where three children claimed to have seen the Virgin Mary on six occasions between May and October 1917. The apparitions of Fátima were declared authentic by the Catholic Church in 1930, and the site has become a major pilgrimage destination for Catholics from around the world. The shrine is especially popular during the annual celebrations of May 13 and October 13, which mark the dates of the apparitions.",
                            adress: "The Sanctuary of Fátima is located in the town of Fátima, about 130 kilometers north of Lisbon. The easiest way to get there is by car or bus, with regular services from Lisbon to Fátima. The sanctuary is open year-round and welcomes visitors of all faiths to pray, reflect, and experience the spiritual atmosphere of this sacred place."
                        )
                    ],
                    latitude: 39.6325,
                    longitude: -8.6718,
                    extraLocations: nil
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
                            titulo: "Museu dos Azulejos",
                            shortDescription: "O Museu Nacional do Azulejo mostra cinco séculos de azulejos decorativos, uma forma de arte portuguesa.",
                            description: "O Museu Nacional do Azulejo é dedicado à arte do azulejo, uma forma de arte decorativa tradicional em Portugal. O museu exibe uma impressionante coleção de azulejos decorativos, datados desde meados do século XV até os dias de hoje, mostrando a evolução desta forma de arte ao longo dos séculos.",
                            history: "Os destaques do museu incluem azulejos históricos de igrejas, palácios e edifícios públicos, bem como exemplos de azulejos de artistas contemporâneos. O museu também abriga exposições temporárias e programas educativos que exploram a história e a técnica do azulejo, bem como o seu papel na cultura portuguesa.",
                            adress: "Rua da Madre de Deus, 4, 1900-312 Lisbon"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Tile Museum",
                            shortDescription: "Celebrates the art of Portuguese tiles from the 15th century to today.",
                            description: "The Tile Museum (Portuguese: Museu Nacional do Azulejo) is dedicated to the art of azulejo, a traditional decorative art form in Portugal. The museum exhibits an impressive collection of decorative tiles, dating from the mid-15th century to the present day, showing the evolution of this art form over the centuries.",
                            history: "The museum's highlights include historical tiles from churches, palaces, and public buildings, as well as examples of tiles by contemporary artists. The museum also houses temporary exhibitions and educational programs that explore the history and technique of azulejo, as well as its role in Portuguese culture.",
                            adress: "Rua da Madre de Deus, 4, 1900-312 Lisbon"
                        )
                    ],
                    latitude: 38.7231,
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
                            shortDescription: "Um centro cultural que abriga coleções de arte excepcionais, desde a antiguidade até a era moderna.",
                            description: "O Museu Calouste Gulbenkian é um dos principais museus de arte em Lisboa, com uma coleção diversificada que abrange arte antiga, arte moderna e arte contemporânea. O museu foi fundado por Calouste Gulbenkian, um colecionador de arte e filantropo armênio, que doou sua coleção à nação portuguesa.",
                            history: "Os destaques do museu incluem pinturas de artistas como Rembrandt, Rubens, Monet e Renoir, esculturas de Rodin e Degas, e arte decorativa de várias culturas. O museu também abriga exposições temporárias, concertos e eventos culturais que enriquecem a experiência dos visitantes.",
                            adress: "Av. de Berna 45A, 1067-001 Lisbon"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Gulbenkian Museum",
                            shortDescription: "World-class art collection, from Egypt to modern art.",
                            description: "Calouste Gulbenkian Museum is one of the main art museums in Lisbon, with a diverse collection spanning ancient art, modern art, and contemporary art. The museum was founded by Calouste Gulbenkian, an Armenian art collector and philanthropist, who donated his collection to the Portuguese nation.",
                            history: "The museum's highlights include paintings by artists such as Rembrandt, Rubens, Monet, and Renoir, sculptures by Rodin and Degas, and decorative art from various cultures. The museum also houses temporary exhibitions, concerts, and cultural events that enrich visitors' experience.",
                            adress: "Av. de Berna 45A, 1067-001 Lisbon"
                        )
                    ],
                    latitude: 38.7371,
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
                            shortDescription: "O Museu Nacional dos Coches exibe uma das mais requintadas coleções de carruagens históricas do mundo.",
                            description: "O Museu Nacional dos Coches é um museu dedicado à história das carruagens e cocheiras reais em Portugal. Fundado em 1905, o museu abriga uma das mais importantes coleções de carruagens históricas do mundo, incluindo veículos usados pela realeza portuguesa e outras figuras históricas.",
                            history: "Os destaques do museu incluem carruagens reais dos séculos XVII ao XIX, incluindo a Carruagem do Rei João V, a Carruagem da Rainha Maria Pia e a Carruagem da Rainha Amélia. O museu também abriga exposições temporárias, oficinas e eventos educativos que exploram a história e a arte das cocheiras.",
                            adress: "Praça Afonso de Albuquerque, 1300-004 Lisbon"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Coach Museum",
                            shortDescription: "The world's largest collection of royal coaches.",
                            description: "The Coach Museum (Portuguese: Museu Nacional dos Coches) is a museum dedicated to the history of royal coaches and carriages in Portugal. Founded in 1905, the museum houses one of the most important collections of historical carriages in the world, including vehicles used by Portuguese royalty and other historical figures.",
                            history: "The museum's highlights include royal carriages from the 17th to the 19th century, including the Carriage of King João V, the Carriage of Queen Maria Pia, and the Carriage of Queen Amélia. The museum also houses temporary exhibitions, workshops, and educational events that explore the history and art of coaches.",
                            adress: "Praça Afonso de Albuquerque, 1300-004 Lisbon"
                        )
                    ],
                    latitude: 38.6973,
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
                            shortDescription: "Conheça a história e a tradição do fado, um género musical português.",
                            description: "O Museu do Fado é dedicado à história e cultura do fado, um género musical tradicional português. Localizado no bairro histórico de Alfama, o museu apresenta exposições interativas, concertos ao vivo e oficinas que celebram a rica tradição do fado.",
                            history: "Os destaques do museu incluem exposições sobre os grandes cantores de fado de Portugal, instrumentos musicais tradicionais usados no fado e a evolução do género ao longo dos séculos. O museu também abriga concertos regulares de fado, onde os visitantes podem experienciar a emoção e a paixão deste estilo musical único.",
                            adress: "Largo do Chafariz de Dentro, 1, 1100-139 Lisbon"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Fado Museum",
                            shortDescription: "Dedicated to the history and culture of Fado, Lisbon's music.",
                            description: "The Fado Museum (Portuguese: Museu do Fado) is dedicated to the history and culture of fado, a traditional Portuguese musical genre. Located in the historic neighborhood of Alfama, the museum presents interactive exhibitions, live concerts, and workshops that celebrate the rich tradition of fado.",
                            history: "The museum's highlights include exhibitions about Portugal's great fado singers, traditional musical instruments used in fado, and the evolution of the genre over the centuries. The museum also houses regular fado concerts, where visitors can experience the emotion and passion of this unique musical style.",
                            adress: "Largo do Chafariz de Dentro, 1, 1100-139 Lisbon"
                        )
                    ],
                    latitude: 38.7132,
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
                            shortDescription: "Museu Nacional de Arte Antiga de Portugal, abrigando as mais refinadas coleções de arte portuguesa e europeia.",
                            description: "O Museu de Arte Antiga é o principal museu de arte de Portugal, com uma coleção abrangente que cobre pintura, escultura, artes decorativas e artes aplicadas. Fundado em 1884, o museu é conhecido pela sua coleção de arte portuguesa e europeia, abrangendo desde a Idade Média até ao século XIX.",
                            history: "Os destaques do museu incluem pinturas de artistas como Hieronymus Bosch, Albrecht Dürer, Pieter Bruegel, Rembrandt, Rubens e Velázquez, bem como esculturas, cerâmicas, têxteis e mobiliário. O museu também abriga exposições temporárias, concertos e eventos culturais que enriquecem a experiência dos visitantes.",
                            adress: "R. das Janelas Verdes, 1249-017 Lisboa"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "Ancient Art Museum",
                            shortDescription: "Masterpieces of Portuguese and European art from the 12th to 19th centuries.",
                            description: "The Museum of Ancient Art (Portuguese: Museu Nacional de Arte Antiga) is Portugal's main art museum, with a comprehensive collection covering painting, sculpture, decorative arts, and applied arts. Founded in 1884, the museum is known for its collection of Portuguese and European art, spanning from the Middle Ages to the 19th century.",
                            history: "The museum's highlights include paintings by artists such as Hieronymus Bosch, Albrecht Dürer, Pieter Bruegel, Rembrandt, Rubens, and Velázquez, as well as sculptures, ceramics, textiles, and furniture. The museum also houses temporary exhibitions, concerts, and cultural events that enrich the visitors' experience.",
                            adress: "R. das Janelas Verdes, 1249-017 Lisboa"
                        )
                    ],
                    latitude: 38.7074,
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
                            description: "O CCB (Centro Cultural de Belém) é uma das mais importantes instituições culturais de Lisboa, abrigando uma impressionante coleção de arte contemporânea e design. O museu apresenta obras de alguns dos maiores artistas da história, incluindo Andy Warhol, Ai Weiwei, Olafur Eliasson e Anish Kapoor. Os visitantes podem explorar a extensa coleção do museu de pinturas, esculturas e instalações, bem como os seus belos jardins e sala de concertos.",
                            history: "Os destaques do museu incluem obras de alguns dos maiores artistas da história, como Andy Warhol, Ai Weiwei, Olafur Eliasson e Anish Kapoor, bem como pinturas, esculturas e instalações. O museu também abriga exposições temporárias, concertos e eventos culturais que enriquecem a experiência dos visitantes, para além dos seus belos jardins e sala de concertos.",
                            adress: "Praça do Império, 1449-003 Lisboa"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "CCB",
                            shortDescription: "Belém Cultural Center: exhibitions, concerts, and contemporary art.",
                            description: "The CCB (Portuguese: Centro Cultural de Belém) is one of Lisbon's most important cultural institutions, housing an impressive collection of contemporary art and design. The museum features works by some of the greatest artists in history, including ANdy Warhol, Ai Weiwei, Olafur Eliasson, and Anish Kapoor. Visitors can explore the museum's extensive collection of paintings, sculptures, and installations, as well as its beautiful gardens and concert hall.",
                            history: "The museum's highlights include works by some of the greatest artists in history, such as Andy Warhol, Ai Weiwei, Olafur Eliasson, and Anish Kapoor, as well as paintings, sculptures, and installations. The museum also houses temporary exhibitions, concerts, and cultural events that enrich visitors' experience, in addition to its beautiful gardens and concert hall.",
                            adress: "Praça do Império, 1449-003 Lisboa"
                        )
                    ],
                    latitude: 38.6956,
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
                            shortDescription: "Museu de Arte, Arquitetura e Tecnologia, que mostra expressões artísticas contemporâneas.",
                            description: "O MAAT (Museu de Arte, Arquitetura e Tecnologia) é um museu de arte, arquitetura e tecnologia em Lisboa, dedicado a explorar as interseções entre arte, ciência e tecnologia. Localizado na zona ribeirinha de Belém, o museu apresenta exposições inovadoras, instalações interativas e eventos culturais que desafiam os limites tradicionais da arte e da tecnologia.",
                            history: "Os destaques do museu incluem exposições de arte contemporânea, arquitetura experimental, design inovador e tecnologia emergente. O museu também acolhe eventos culturais, oficinas e palestras que exploram as últimas tendências e práticas em arte, arquitetura e tecnologia.",
                            adress: "Av. Brasília, 1300-598 Lisbon"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "MAAT",
                            shortDescription: "Museum of Art, Architecture and Technology by the Tagus river.",
                            description: "MAAT (Portuguese: Museu de Arte Arquitectura e Tecnologia) is a museum of art, architecture, and technology in Lisbon, dedicated to exploring the intersections between art, science, and technology. Located in the riverside area of Belém, the museum presents innovative exhibitions, interactive installations, and cultural events that challenge the traditional boundaries of art and technology.",
                            history: "The museum's highlights include exhibitions of contemporary art, experimental architecture, innovative design, and emerging technology. The museum also hosts cultural events, workshops, and lectures that explore the latest trends and practices in art, architecture, and technology.",
                            adress: "Av. Brasília, 1300-598 Lisbon"
                        )
                    ],
                    latitude: 38.6952,
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
                            shortDescription: "Explore  mais museus. Qual é o assunto que mais lhe interessa?",
                            description: "Além dos 7 museus mencionados, Lisboa tem muitos mais museus para visitar. Estes museus cobrem uma ampla gama de tópicos, desde arte e história até ciência e tecnologia, proporcionando uma visão abrangente do rico património cultural de Portugal.",
                            history: "Museu do Terramoto, Museu Nacional de Arte Contemporânea, Museu Nacional de História Natural e da Ciência, Museu da Marioneta, Museu da Farmácia e Museu do Oriente. Cada museu oferece exposições únicas, programas educativos e eventos culturais que enriquecem a experiência dos visitantes.",
                            adress: "Vários locais em Lisboa"
                        ),
                        "en": MiniaturaCardTranslation(
                            titulo: "More Museums",
                            shortDescription: "Discover other fascinating museums in Lisbon.",
                            description: "In addition to the 7 museums mentioned, Lisbon has many more museums to visit. These museums cover a wide range of topics, from art and history to science and technology, providing a comprehensive view of Portugal's rich cultural heritage.",
                            history: "Quake Museum, National Museum of Contemporary Art, National Museum of Natural History and Science, Puppet Museum, Pharmacy Museum and Orient Museum. Each museum offers unique exhibitions, educational programs, and cultural events that enrich the visitors' experience.",
                            adress: "Various locations in Lisbon'"
                        )
                    ],
                    latitude: 38.7200,
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
                            description: "The National Palace of Pena is a 19th-century Romantic palace made of stone and stucco, situated on the top of the Sintra Mountains. It stands out for its eclectic style, with neo-Gothic, neo-Manueline, and Moorish elements, and for its vibrant colors, visible from the entire surrounding area. The palace is a testament to the king's passion for art and history, combining elements from various periods and cultures.",
                            history: "The Pena Palace was built on the site of an old monastery that was destroyed during the 1755 earthquake. King Ferdinand II acquired the land in 1838 and began construction of the palace in 1842. The palace was completed in 1854 and became the summer residence of the Portuguese royal family. After the fall of the monarchy in 1910, the palace was converted into a museum and opened to the public. The main architect responsible for transforming the monastery into a palace was Baron von Eschwege.",
                            adress: "Estrada da Pena, 2710-609 Sintra"
                        ),
                        "pt": MiniaturaCardTranslation(
                            titulo: "Palácio da Pena",
                            shortDescription: "Palácio romântico e colorido no topo da serra, símbolo de Sintra.",
                            description: "O Palácio Nacional da Pena é um palácio romântico do século XIX, construído em pedra e estuque, situado no topo da Serra de Sintra. Destaca-se pelo seu estilo eclético, com elementos neogóticos, neo-manuelinos e mouriscos, e pelas suas cores vibrantes, visíveis de toda a área circundante. O palácio é um testemunho da paixão do rei pela arte e história, combinando elementos de vários períodos e culturas.",
                            history: "O Palácio da Pena foi construído no local de um antigo mosteiro que foi destruído durante o terramoto de 1755. O rei Fernando II adquiriu o terreno em 1838 e iniciou a construção do palácio em 1842. O palácio foi concluído em 1854 e tornou-se a residência de verão da família real portuguesa. Após a queda da monarquia em 1910, o palácio foi convertido em museu e aberto ao público. O principal arquiteto responsável pela transformação do mosteiro em palácio foi o Barão von Eschwege.",
                            adress: "Estrada da Pena, 2710-609 Sintra"
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
                            description: "Queijadas and travesseiros are two of Sintra's most traditional sweets, made with puff pastry, almonds, eggs, and sugar. Queijadas are small puff pastry tarts filled with a cheese cream, while travesseiros are puff pastry pillows filled with an almond sweet. Both are handcrafted, following centuries-old recipes, and can be found in traditional Sintra pastry shops, such as Piriquita and Casa da Queijada. In Lisbon and surrounding areas, travesseiros and queijadas are sold in various pastry shops and supermarkets.",
                            history: "The creation of Travesseiros dates back to the 1940s, at the Piriquita pastry shop, by Constância Cunha, while Queijadas originated in the 13th century, being produced by the nuns of the Penha Longa Convent. An interesting fact about Queijadas is that they were used as a form of payment for rents and taxes in medieval times.",
                            adress: "Various pastry shops in Sintra"
                        ),
                        "pt": MiniaturaCardTranslation(
                            titulo: "Travesseiros e Queijadas",
                            shortDescription: "Doces típicos de Sintra, saborosos e únicos.",
                            description: "As queijadas e os travesseiros são dois dos doces mais tradicionais de Sintra, feitos com massa folhada, amêndoas, ovos e açúcar. As queijadas são pequenas tartes de massa folhada recheadas com um creme de queijo, enquanto os travesseiros são almofadas de massa folhada recheadas com um doce de amêndoa. Ambos são feitos artesanalmente, seguindo receitas centenárias, e podem ser encontrados em pastelarias tradicionais de Sintra, como a Piriquita e a Casa da Queijada. Em Lisboa e arredores, travesseiros e queijadas são vendidos em várias pastelarias e supermercados.",
                            history: "A criação dos Travesseiros remonta à década de 1940, na pastelaria Piriquita, pela mão de Constância Cunha, enquanto as Queijadas têm origem no século XIII, sendo produzidas pelas freiras do Convento da Penha Longa. Um facto interessante sobre as Queijadas é que eram usadas como forma de pagamento de rendas e impostos na época medieval.",
                            adress: "Várias pastelarias em Sintra"
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
                            description: "It is a medieval military fortification, built in stone, located at the top of the Sintra Mountains. Dating from the 8th century, during the period of Muslim occupation of the Iberian Peninsula, the castle offers panoramic views of the town of Sintra and the surrounding region. Its walls wind through the mountains, integrating into the natural landscape.",
                            history: "It was built by the Moors to protect the Sintra region, a strategic defense point. In 1147, King Afonso Henriques conquered the castle from the Moors, integrating it into the Kingdom of Portugal. Over the centuries, the castle underwent several renovations and expansions, being restored in the 19th century by King Ferdinand II, who restored its romantic appearance. One of the curiosities is that during the Christian reconquest, the castle was taken by assault during the night, after a long siege.",
                            adress: "Estrada da Pena, 2710-609 Sintra"
                        ),
                        "pt": MiniaturaCardTranslation(
                            titulo: "Castelo dos Mouros",
                            shortDescription: "Castelo mouro antigo com vistas panorâmicas.",
                            description: "É uma fortificação militar medieval, construída em pedra, localizada no topo da Serra de Sintra. Datado do século VIII, durante o período de ocupação muçulmana da Península Ibérica, o castelo oferece vistas panorâmicas sobre a vila de Sintra e a região circundante. As suas muralhas serpenteiam pelas montanhas, integrando-se na paisagem natural.",
                            history: "Foi construído pelos mouros para proteger a região de Sintra, um ponto estratégico de defesa. Em 1147, o rei Afonso Henriques conquistou o castelo aos mouros, integrando-o no Reino de Portugal. Ao longo dos séculos, o castelo sofreu várias reformas e ampliações, sendo restaurado no século XIX pelo rei Fernando II, que lhe deu a sua aparência romântica. Uma das curiosidades é que durante a reconquista cristã, o castelo foi tomado de assalto durante a noite, após um longo cerco.",
                            adress: "Estrada da Pena, 2710-609 Sintra"
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
                            description: "It is an architectural and landscape complex from the early 20th century, made of stone and stucco, located in Sintra. It features diverse architectural styles, such as neo-Manueline and romantic, with symbolic and esoteric elements. Its lush gardens, caves, and initiation wells make it a unique place.",
                            history: "The construction of Quinta da Regaleira was started in 1904 by António Augusto Carvalho Monteiro, with the aim of creating a space that reflected his esoteric and philosophical interests. Architect Luigi Manini was responsible for the project. Quinta da Regaleira was the scene of various ceremonies and symbolic rituals, linked to Freemasonry and the Templars. One of the curious facts is that the initiation well, with its spiral staircase, represents a descent into hell and a spiritual rebirth.",
                            adress: "2710-567 Sintra"
                        ),
                        "pt": MiniaturaCardTranslation(
                            titulo: "Quinta da Regaleira",
                            shortDescription: "Propriedade mística com jardins, túneis e simbolismo.",
                            description: "É um complexo arquitetônico e paisagístico do início do século XX, construído em pedra e estuque, localizado em Sintra. Apresenta diversos estilos arquitetônicos, como o neomanuelino e o romântico, com elementos simbólicos e esotéricos. Seus exuberantes jardins, grutas e poços iniciáticos tornam-no um lugar único.",
                            history: "A construção da Quinta da Regaleira foi iniciada em 1904 por António Augusto Carvalho Monteiro, com o objetivo de criar um espaço que refletisse seus interesses esotéricos e filosóficos. O arquiteto Luigi Manini foi o responsável pelo projeto. A Quinta da Regaleira foi palco de várias cerimônias e rituais simbólicos, ligados à Maçonaria e aos Templários. Um dos fatos curiosos é que o poço iniciático, com sua escadaria em espiral, representa uma descida ao inferno e um renascimento espiritual.",
                            adress: "2710-567 Sintra"
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
                            description: "It is a 19th-century romantic garden, with an eclectic style palace with neo-Gothic, Moorish, Indian, and romantic influences. The park features a unique botanical collection, with plants from around the world including palms, cacti, ferns, and orchids. Its lakes, waterfalls, and ruins create a magical and mysterious environment.",
                            history: "The creation of Monserrate Park was initiated by Francis Cook, a wealthy English merchant, in the 19th century, between 1858 and 1863, to be his summer residence. Architect James Knowles Jr. was responsible for the palace project and landscape architect William Stockdale designed the park. The park was the scene of various parties and high society events of the time. One of the curious facts is that the park was built on the ruins of an old estate, which belonged to Gerard de Visme, an English merchant from the 18th century.",
                            adress: "Sintra Mountains"
                        ),
                        "pt": MiniaturaCardTranslation(
                            titulo: "Parque de Monserrate",
                            shortDescription: "Jardins exóticos e palácio único em Sintra.",
                            description: "É um jardim romântico do século XIX, com um palácio de estilo eclético com influências neogóticas, mouriscas, indianas e românticas. O parque apresenta uma coleção botânica única, com plantas de todo o mundo, incluindo palmeiras, cactos, samambaias e orquídeas. Seus lagos, cascatas e ruínas criam um ambiente mágico e misterioso.",
                            history: "A criação do Parque de Monserrate foi iniciada por Francis Cook, um rico comerciante inglês, no século XIX, entre 1858 e 1863, para ser sua residência de verão. O arquiteto James Knowles Jr. foi o responsável pelo projeto do palácio e o paisagista William Stockdale desenhou o parque. O parque foi palco de várias festas e eventos da alta sociedade da época. Um dos fatos curiosos é que o parque foi construído sobre as ruínas de uma antiga propriedade, que pertencia a Gerard de Visme, um comerciante inglês do século XVIII.",
                            adress: "Serra de Sintra"
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
                            description: "It is a 16th-century Franciscan convent, built in stone and integrated into the landscape of the Sintra Mountains. It stands out for its austere architecture, with small cells carved into the rock and lined with cork. It is located in an isolated and densely wooded area, providing an environment of seclusion. The convent is a testament to monastic life and Franciscan spirituality, and is now a place of pilgrimage and meditation.",
                            history: "The construction of the convent was initiated in 1560 by D. Álvaro de Castro, to serve as a retreat for the Franciscan friars of the Order of Capuchos. The convent was designed to promote a life of prayer and penance, with great emphasis on poverty and isolation. One of the curious facts is that the small dimensions of the cells and the use of cork on the walls reflect the friars' ideal of simplicity and detachment.",
                            adress: "Sintra Mountains"
                        ),
                        "pt": MiniaturaCardTranslation(
                            titulo: "Convento dos Capuchos",
                            shortDescription: "Convento humilde e histórico rodeado de natureza.",
                            description: "É um convento franciscano do século XVI, construído em pedra e integrado na paisagem da Serra de Sintra. Destaca-se pela sua arquitetura austera, com pequenas celas escavadas na rocha e revestidas de cortiça. Está localizado numa área isolada e densamente arborizada, proporcionando um ambiente de recolhimento. O convento é um testemunho da vida monástica e da espiritualidade franciscana, sendo atualmente um local de peregrinação e meditação.",
                            history: "A construção do convento foi iniciada em 1560 por D. Álvaro de Castro, para servir como retiro para os frades franciscanos da Ordem dos Capuchos. O convento foi projetado para promover uma vida de oração e penitência, com grande ênfase na pobreza e no isolamento. Um dos fatos curiosos é que as pequenas dimensões das celas e o uso de cortiça nas paredes refletem o ideal dos frades de simplicidade e desapego.",
                            adress: "Serra de Sintra"
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
                            description: "It is a medieval and Renaissance palace, built with various materials such as stone, brick, and tiles, located in the historic center of Sintra. Its architecture reflects different styles, including Gothic, Manueline, and Moorish, the result of centuries of alterations and extensions. Its iconic cone-shaped chimneys are one of its most distinctive features.",
                            history: "The construction of the palace was initiated in the 14th century by King João I, to serve as a summer residence for the Portuguese royal family. Over the centuries, it was the scene of important historical events, such as the marriage of King Manuel I to Maria of Aragon. One of the curiosities is that the palace has a vast collection of Hispano-Moorish tiles, considered among the most important in the country.",
                            adress: "Village of Sintra"
                        ),
                        "pt": MiniaturaCardTranslation(
                            titulo: "Palácio da Vila",
                            shortDescription: "O palácio real medieval no centro de Sintra.",
                            description: "É um palácio medieval e renascentista, construído com vários materiais como pedra, tijolo e azulejos, localizado no centro histórico de Sintra. A sua arquitetura reflete diferentes estilos, incluindo gótico, manuelino e mourisco, resultado de séculos de alterações e ampliações. As suas icónicas chaminés em forma de cone são uma das suas características mais distintivas.",
                            history: "A construção do palácio foi iniciada no século XIV pelo rei João I, para servir como residência de verão da família real portuguesa. Ao longo dos séculos, foi palco de importantes eventos históricos, como o casamento do rei Manuel I com Maria de Aragão. Uma das curiosidades é que o palácio possui uma vasta coleção de azulejos hispano-mouriscos, considerados entre os mais importantes do país.",
                            adress: "Vila de Sintra"
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
                            description: "When we talk about Sintra, we may be referring to the Town or the Municipality. The Town of Sintra is a magical place, with a romantic atmosphere and a unique cultural and natural heritage. The Municipality of Sintra is a diverse region, ranging from the Atlantic coast to the mountains of the Sintra Range, with a rich history and breathtaking landscape. In addition to the 7 wonders already mentioned, here are some other emblematic and enchanting places in the region that deserve to be visited and explored.",
                            history: "Cabo da Roca: It is the westernmost point of continental Europe, with 140-meter-high cliffs and breathtaking views over the ocean. Cruz Alta: It is the highest point of the Sintra Mountains, at 528 meters altitude, from where you can see the most beautiful views over Lisbon and Cascais to the south, the Atlantic Ocean to the west, and the rural region to the north. Adraga Beach: It is one of the most beautiful beaches in the region, with an extensive sandy area, imposing cliffs, and crystal-clear waters. Praia Grande: It is one of the most popular beaches in the region, with an extensive sandy area, good waves for surfing, and a relaxed atmosphere. Maçãs Beach: It is a picturesque beach, with a small fishing port, a lively promenade, and a family-friendly atmosphere. Ursa Beach: It is a wild and isolated beach, with steep cliffs, golden sand, and crystal-clear waters. Aguda Beach: It is a quiet and isolated beach, with an extensive sandy area, calm waters, and a relaxing atmosphere.",
                            adress: "Diversos locais em Sintra"
                        ),
                        "pt": MiniaturaCardTranslation(
                            titulo: "Mais Sintra",
                            shortDescription: "Descubra ainda mais maravilhas em Sintra!",
                            description: "Quando falamos de Sintra, podemos estar a referir-nos à Vila ou ao Concelho. A Vila de Sintra é um lugar mágico, com uma atmosfera romântica e um património cultural e natural único. O Concelho de Sintra é uma região diversa, que vai desde a costa atlântica até às montanhas da Serra de Sintra, com uma rica história e paisagem deslumbrante. Além das 7 maravilhas já mencionadas, aqui estão alguns outros lugares emblemáticos e encantadores da região que merecem ser visitados e explorados.",
                            history: "Cabo da Roca: É o ponto mais ocidental da Europa continental, com falésias de 140 metros de altura e vistas deslumbrantes sobre o oceano. Cruz Alta: É o ponto mais alto da Serra de Sintra, com 528 metros de altitude, de onde se podem ver as vistas mais bonitas sobre Lisboa e Cascais a sul, o Oceano Atlântico a oeste, e a região rural a norte. Praia da Adraga: É uma das praias mais bonitas da região, com uma extensa área de areia, falésias imponentes e águas cristalinas. Praia Grande: É uma das praias mais populares da região, com uma extensa área de areia, boas ondas para surf e uma atmosfera descontraída. Praia das Maçãs: É uma praia pitoresca, com um pequeno porto de pesca, um passeio animado e uma atmosfera familiar. Praia da Ursa: É uma praia selvagem e isolada, com falésias íngremes, areia dourada e águas cristalinas. Praia da Aguda: É uma praia tranquila e isolada, com uma extensa área de areia, águas calmas e uma atmosfera relaxante.",
                            adress: "Vários locais em Sintra"
                        )
                    ],
                    latitude: nil,
                    longitude: nil,
                    extraLocations: nil
                )
            ]
        }
        if cat == "vocabulario" || cat == "vocabulário" {
            // Return only cards with Portuguese translations
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
                            usage: "Posso ligar para o seu telémovel?",
                            pronunciation: "teh-leh-MOH-vel"
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
                            usage: "O comboio parte às 8h.",
                            pronunciation: "kom-BOY-oo"
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
                            usage: "Vou apanhar o autocarro para o trabalho.",
                            pronunciation: "ow-toh-KAH-roo"
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
                            usage: "O eléctrico 28 é famoso em Lisboa.",
                            pronunciation: "eh-LEK-tree-ko"
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
                            usage: "Há uma grande bicha para comprar bilhetes.",
                            pronunciation: "BEE-sha"
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
                            usage: "O pequeno-almoço é servido até às 10h.",
                            pronunciation: "peh-KEN-oo al-MOH-soo"
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
                            usage: "Onde fica a casa de banho?",
                            pronunciation: "KAH-za deh BAH-nyoo"
                        )
                    ],
                    latitude: nil,
                    longitude: nil,
                    extraLocations: nil
                )
            ]
        }
        if cat == "vocabulary" {
            // Return only cards with English translations
            return [
                MiniaturaCard(
                    id: 1,
                    imagem: "vocabulary_en_64",
                    categoria: "Vocabulary",
                    ordem: 1,
                    translations: [
                        "en": MiniaturaCardTranslation(
                            titulo: "Hi",
                            shortDescription: "Word for cell phone (US) or mobile phone (UK).",
                            usage: "Can I call your mobile phone?",
                            pronunciation: "MOH-bil fone"
                        )
                    ],
                    latitude: nil,
                    longitude: nil,
                    extraLocations: nil
                ),
                MiniaturaCard(
                    id: 2,
                    imagem: "vocabulary_en_65",
                    categoria: "Vocabulary",
                    ordem: 2,
                    translations: [
                        "en": MiniaturaCardTranslation(
                            titulo: "Please",
                            shortDescription: "Word for trem (Brasil) or train (UK/US).",
                            usage: "The train leaves at 8 am.",
                            pronunciation: "tray-n"
                        )
                    ],
                    latitude: nil,
                    longitude: nil,
                    extraLocations: nil
                ),
                MiniaturaCard(
                    id: 3,
                    imagem: "vocabulary_en_66",
                    categoria: "Vocabulary",
                    ordem: 3,
                    translations: [
                        "en": MiniaturaCardTranslation(
                            titulo: "Yes/No",
                            shortDescription: "Word for ônibus (Brasil) or bus (UK/US).",
                            usage: "I'm taking the bus to work.",
                            pronunciation: "buhs"
                        )
                    ],
                    latitude: nil,
                    longitude: nil,
                    extraLocations: nil
                ),
                MiniaturaCard(
                    id: 4,
                    imagem: "vocabulary_en_67",
                    categoria: "Vocabulary",
                    ordem: 4,
                    translations: [
                        "en": MiniaturaCardTranslation(
                            titulo: "Thank you",
                            shortDescription: "Word for bonde (Brasil) or tram (UK).",
                            usage: "The tram 28 is famous in Lisbon.",
                            pronunciation: "tram"
                        )
                    ],
                    latitude: nil,
                    longitude: nil,
                    extraLocations: nil
                ),
                MiniaturaCard(
                    id: 5,
                    imagem: "vocabulary_en_68",
                    categoria: "Vocabulary",
                    ordem: 5,
                    translations: [
                        "en": MiniaturaCardTranslation(
                            titulo: "Bom Dia/ Boa Noite",
                            shortDescription: "Word for fila (Brasil) or queue (UK). Warning: has another meaning in Brazil!",
                            usage: "There's a long queue to buy tickets.",
                            pronunciation: "kyoo"
                        )
                    ],
                    latitude: nil,
                    longitude: nil,
                    extraLocations: nil
                ),
                MiniaturaCard(
                    id: 6,
                    imagem: "vocabulary_en_69",
                    categoria: "Vocabulary",
                    ordem: 6,
                    translations: [
                        "en": MiniaturaCardTranslation(
                            titulo: "I´m sorry",
                            shortDescription: "Word for café da manhã (Brasil) or breakfast (UK/US).",
                            usage: "Breakfast is served until 10 am.",
                            pronunciation: "BREK-fuhst"
                        )
                    ],
                    latitude: nil,
                    longitude: nil,
                    extraLocations: nil
                ),
                MiniaturaCard(
                    id: 7,
                    imagem: "vocabulary_en_70",
                    categoria: "Vocabulary",
                    ordem: 7,
                    translations: [
                        "en": MiniaturaCardTranslation(
                            titulo: "Goodbye",
                            shortDescription: "Word for banheiro (Brasil) or bathroom/restroom (UK/US).",
                            usage: "Where is the bathroom?",
                            pronunciation: "BATH-room"
                        )
                    ],
                    latitude: nil,
                    longitude: nil,
                    extraLocations: nil
                )
            ]
        }
        // Fallback logic for unknown categories
        print("DEBUG: Unknown category '", categoria, "' passed to mockCardsRaw. Returning empty array.")
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
