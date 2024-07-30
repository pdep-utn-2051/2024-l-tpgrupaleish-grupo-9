%Comienzo del tp

%CIVILIZACIONES Y TECNOLOGIAS
/*
1). Modelar lo necesario para representar los jugadores, las civilizaciones y las tecnologías, de la 
forma más conveniente para resolver los siguientes puntos. Incluir los siguientes ejemplos.
a. Ana, que juega con los romanos y ya desarrolló las tecnologías de herrería, forja, emplumado y 
láminas.
b. Beto, que juega con los incas y ya desarrolló herrería, forja y fundición.
c. Carola, que juega con los romanos y sólo desarrolló la herrería.
d. Dimitri, que juega con los romanos y ya desarrolló herrería y fundición.
e. Elsa no juega esta partida.
*/
jugador(ana).
jugador(dimitri).
jugador(beto).
jugador(carola).

civilizacion(romanos).
civilizacion(incas).

tecnologia(herreria).
tecnologia(forja).
tecnologia(fundicion).
tecnologia(emplumado).
tecnologia(laminas).
tecnologia(collera).
tecnologia(molino).
tecnologia(aradoPesado).
tecnologia(puntaAcero).
tecnologia(altoHorno).
tecnologia(cotaMalla).
tecnologia(placaMalla).

juegaCon(ana, romanos).
juegaCon(beto, incas).
juegaCon(carola, romanos).
juegaCon(dimitri, romanos).

desarrollo(ana, herreria).
desarrollo(ana, forja).
desarrollo(ana, emplumado).
desarrollo(ana, laminas).
desarrollo(beto, herreria).
desarrollo(beto, forja).
desarrollo(beto, fundicion).
desarrollo(carola, herreria).
desarrollo(dimitri, herreria).
desarrollo(dimitri, fundicion).

/*
2). Saber si un jugador es experto en metales, que sucede cuando desarrolló las tecnologías de herrería, 
forja y o bien desarrolló fundición o bien juega con los romanos.
En los ejemplos, Ana y Beto son expertos en metales, pero Carola y Dimitri no.
*/
expertoEnMetales(Jugador) :-
    jugador(Jugador), 
    desarrollo(Jugador, herreria), 
    desarrollo(Jugador, forja),
    (desarrollo(Jugador, fundicion); juegaCon(Jugador, romanos)).

/*
3). Saber si una civilización es popular, que se cumple cuando la eligen varios jugadores (más de uno).
En los ejemplos, los romanos son una civilización popular, pero los incas no
*/
civilizacionPopular(Civilizacion) :-
    civilizacion(Civilizacion),
    findall(Jugador, juegaCon(Jugador, Civilizacion), Jugadores),
    length(Jugadores, Cant), Cant>1.

/*
4). Saber si una tecnología tiene alcance global, que sucede cuando a nadie le falta desarrollarla.
En los ejemplos, la herrería tiene alcance global, pues Ana, Beto, Carola y Dimitri la desarrollaron.
*/
tecnologiaGlobal(Tecnologia) :-
    tecnologia(Tecnologia),
    forall(jugador(Jugador), desarrollo(Jugador, Tecnologia)).

/*5). Saber cuándo una civilización es líder. Se cumple cuando esa civilización alcanzó todas las 
tecnologías que alcanzaron las demás. Una civilización alcanzó una tecnología cuando algún jugador 
de esa civilización la desarrolló.
En los ejemplos, los romanos son una civilización líder pues entre Ana y Dimitri, que juegan con 
romanos, ya tienen todas las tecnologías que se alcanzaron
*/
alcanzoTecnologia(Civilizacion, Tecnologia) :-
    civilizacion(Civilizacion),
    tecnologia(Tecnologia),
    juegaCon(Jugador, Civilizacion),
    desarrollo(Jugador, Tecnologia).

civilizacionLider(Civilizacion) :-
    civilizacion(Civilizacion),
    forall(tecnologia(Tecnologia), alcanzoTecnologia(Civilizacion, Tecnologia)).

/*
UNIDADES
No se puede ganar la guerra sin soldados. Las unidades que existen son los campeones (con vida de 1 a 
100), los jinetes (que los puede haber a caballo o a camello) y los piqueros, que tienen un nivel de 1 a 3, y 
pueden o no tener escudo.
*/

/*
6). Modelar lo necesario para representar las distintas unidades de cada jugador de la forma más 
conveniente para resolver los siguientes puntos. Incluir los siguientes ejemplos:
● Ana tiene un jinete a caballo, un piquero con escudo de nivel 1, y un piquero sin escudo de 
nivel 2.
● Beto tiene un campeón de 100 de vida, otro de 80 de vida, un piquero con escudo nivel 1 y un 
jinete a camello.
● Carola tiene un piquero sin escudo de nivel 3 y uno con escudo de nivel 2.
● Dimitri no tiene unidades.
*/
unidad(campeon(Vida)) :- between(1, 100, Vida).

unidad(jinete(caballo)).
unidad(jinete(camello)).

unidad(piquero(Nivel, Escudo)) :- 
    Nivel >=1, Nivel =<3,
    (Escudo = conEscudo; Escudo = sinEscudo).

unidades(ana, [jinete(caballo), piquero(1, conEscudo), piquero(2, sinEscudo)]).
unidades(beto, [campeon(100), campeon(80), piquero(1, conEscudo), jinete(camello)]).
unidades(carola, [piquero(3, sinEscudo), piquero(2, conEscudo)]).

/*
7). Conocer la unidad con más vida que tiene un jugador, teniendo en cuenta que:
● Los jinetes a camello tienen 80 de vida y los jinetes a caballo tienen 90.
● Cada campeón tiene una vida distinta.
● Los piqueros sin escudo de nivel 1 tienen vida 50, los de nivel 2 tienen vida 65 y los de nivel 3 
tienen 70 de vida.
● Los piqueros con escudo tienen 10% más de vida que los piqueros sin escudo.
En los ejemplos, la unidad más “viva” de Ana es el jinete a caballo, pues tiene 90 de vida, y ninguno de 
sus dos piqueros tiene tanta vida.
*/
vidaUnidad(jinete(caballo), 90).
vidaUnidad(jinete(camello), 80).
vidaUnidad(piquero(1, sinEscudo), 50).
vidaUnidad(piquero(2, sinEscudo), 65).
vidaUnidad(piquero(3, sinEscudo), 70).
vidaUnidad(piquero(1, conEscudo), 55).
vidaUnidad(piquero(2, conEscudo), 71.5).
vidaUnidad(piquero(3, conEscudo), 77).
vidaUnidad(campeon(Vida), Vida).

unidadConMasVida(Jugador, Unidad, VidaMaxima) :-
    unidades(Jugador, Unidades),
    findall((Vida, Unidad), (member(Unidad, Unidades), vidaUnidad(Unidad, Vida)), ListaVidaUnidades),
    max_member((VidaMaxima, Unidad), ListaVidaUnidades).

/*
8). Queremos (saber si una unidad le gana a otra. Las unidades tienen una ventaja por tipo sobre otras.
Cualquier jinete le gana a cualquier campeón, cualquier campeón le gana a cualquier piquero y
cualquier piquero le gana a cualquier jinete, pero los jinetes a camello le ganan a los a caballo. En
caso de que no exista ventaja entre las unidades, se compara la vida (el de mayor vida gana).
Este punto no necesita ser inversible.
por ejemplo, un campeón con 95 de vida le gana a otro con 50, pero un campeón con 100 de vida no
le gana a un jinete a caballo.
*/
ganaContra(Unidad1, Unidad2) :-
    unidad(Unidad1), unidad(Unidad2),
    (gana(Unidad1, Unidad2);
    (vidaUnidad(Unidad1, Vida1),
     vidaUnidad(Unidad2, Vida2), Vida1 > Vida2,
      not(gana(Unidad2, Unidad1))
    )
    ).

gana(jinete(_), campeon(_)).
gana(campeon(_), piquero(_,_)).
gana(piquero(_,_), jinete(_)).
gana(jinete(camello), jinete(caballo)).

/*
9). Saber si un jugador puede sobrevivir a un asedio. Esto ocurre si tiene más piqueros con escudo que
sin escudo.
En los ejemplos, Beto es el único que puede sobrevivir a un asedio, pues tiene 1 piquero con escudo y
0 sin escudo.
*/
sobreviveAsedio(Jugador) :-
    jugador(Jugador),
    unidades(Jugador, UnidadesJugador),
    findall(Piquero, (member(Piquero, UnidadesJugador), Piquero = piquero(_, conEscudo)), PiquerosConEscudo),
    findall(Piquero, (member(Piquero, UnidadesJugador), Piquero = piquero(_, sinEscudo)), PiquerosSinEscudo),
    length(PiquerosConEscudo, Cant1),
    length(PiquerosSinEscudo, Cant2),
    (Cant1 > Cant2).

/*
10). Árbol de tecnologías
a. Se sabe que existe un árbol de tecnologías, que indica dependencias entre ellas. Hasta no 
desarrollar una, no se puede desarrollar la siguiente. Modelar el siguiente árbol de ejemplo:
*/
requiereDe(collera,molino).
requiereDe(aradoPesado,collera).
requiereDe(emplumado, herreria).
requiereDe(puntaAcero, emplumado).
requiereDe(forja, herreria).
requiereDe(fundicion,forja).
requiereDe(altoHorno, fundicion).
requiereDe(laminas, herreria).
requiereDe(cotaMalla,laminas).
requiereDe(placaMalla,cotaMalla).

%Para casos directos
arbolDependencias(TecnologiaPadre, TecnologiaDependiente) :-
    tecnologia(TecnologiaPadre),
    tecnologia(TecnologiaDependiente),
    requiereDe(TecnologiaDependiente, TecnologiaPadre).

%Para casos intermedios
arbolDependencias(TecnologiaPadre, TecnologiaDependiente) :-
    tecnologia(TecnologiaPadre),
    tecnologia(OtraTecnologia),
    requiereDe(OtraTecnologia, TecnologiaPadre),
    arbolDependencias(OtraTecnologia, TecnologiaDependiente).

/*
b. Saber si un jugador puede desarrollar una tecnología, que se cumple cuando ya desarrolló
todas sus dependencias (las directas y las indirectas). Considerar que pueden existir árboles
de cualquier tamaño.
En el ejemplo, beto puede desarrollar el molino (pues no tiene dependencias) pero no la
herrería (porque ya la tiene), y ana puede desarrollar fundición (pues tiene forja y herrería).
*/
puedeDesarrollar(Jugador, Tecnologia) :-
    jugador(Jugador),
    tecnologia(Tecnologia),
    not(desarrollo(Jugador, Tecnologia)),
    forall(arbolDependencias(Dependencias, Tecnologia), desarrollo(Jugador, Dependencias)).
    


 