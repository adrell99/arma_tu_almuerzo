import '../models/item_menu.dart';

final List<MenuItem> menuFijo = [
  MenuItem(
      nombre: "Pollo Frito",
      descripcion: "arroz, ensalada ,sopa , limonada, Principio, ",
      precio: 15000,
      categoria: "fijo"),
  MenuItem(
      nombre: "Chatas",
      descripcion:
          "Arroz, Ensalada, Patacon, Aguacate, Principio, Sopa, Limonada",
      precio: 21000,
      categoria: "fijo"),
  MenuItem(
      nombre: "Picos sudados",
      descripcion: "Arroz, Ensalada, Principio, Contorno, Sopa , Limonada",
      precio: 13000,
      categoria: "fijo"),
  MenuItem(
      nombre: "Chanfaina",
      descripcion: "Arroz, Ensalada, Yuca, Sopa , Limonada",
      precio: 15000,
      categoria: "fijo"),
  MenuItem(
      nombre: "Pastas con pollo",
      descripcion: "Pasta con pollo, Papa amarilla, Sopa , Limonada",
      precio: 15000,
      categoria: "fijo"),
  MenuItem(
      nombre: "Pastas con bolañesas(carne molidad)",
      descripcion: "Pasta, Carne molidad, Sopa , Limonada",
      precio: 15000,
      categoria: "fijo"),
  MenuItem(
      nombre: "Alitas BBQ",
      descripcion: "Arroz, Ensalada, Principio, Contorno, Sopa , Limonada",
      precio: 13000,
      categoria: "fijo"),
  MenuItem(
      nombre: "Alitas Fritas",
      descripcion: "Arroz, Ensalada, Principio, Contorno, Sopa , Limonada",
      precio: 13000,
      categoria: "fijo"),
  MenuItem(
      nombre: "Costillas BBQ",
      descripcion: "Arroz, Ensalada, Principio, Contorno, Sopa , Limonada",
      precio: 14000,
      categoria: "fijo"),
  MenuItem(
      nombre: "Costillas Fritas",
      descripcion: "Arroz, Ensalada, Principio, Contorno, Sopa , Limonada",
      precio: 14000,
      categoria: "fijo"),
  MenuItem(
      nombre: "Chuleta de cerdad ahumada",
      descripcion: "Arroz, Ensalada, Principio, Contorno, Sopa , Limonada",
      precio: 14000,
      categoria: "fijo"),
  MenuItem(
      nombre: "Lomo de cerdo plancha",
      descripcion: "Arroz, Ensalada, Principio, Contorno, Sopa , Limonada",
      precio: 13000,
      categoria: "fijo"),
  MenuItem(
      nombre: "Lomo de cerdo BBQ",
      descripcion: "Arroz, Ensalada, Principio, Contorno, Sopa , Limonada",
      precio: 13000,
      categoria: "fijo"),
  MenuItem(
      nombre: "Carne a la plancha",
      descripcion: "Arroz, Ensalada, Principio, Contorno, Sopa , Limonada",
      precio: 14000,
      categoria: "fijo"),
  MenuItem(
      nombre: "Carne a la placha + bistec",
      descripcion: "Arroz, Ensalada, Principio, Contorno, Sopa , Limonada",
      precio: 15000,
      categoria: "fijo"),
  MenuItem(
      nombre: "Carne Sudada",
      descripcion: "Arroz, Ensalada, Principio, Contorno, Sopa , Limonada",
      precio: 14000,
      categoria: "fijo"),
  MenuItem(
      nombre: "Mojarra",
      descripcion:
          "Arroz, Patacon, Ensalada, Principio, Contorno, Sopa , Limonada",
      precio: 19000,
      categoria: "fijo"),
  MenuItem(
      nombre: "Sobrebarriga",
      descripcion:
          "Arroz, Patacon, Ensalada, Principio, Contorno, Sopa , Limonada",
      precio: 13000,
      categoria: "fijo"),
  MenuItem(
      nombre: "Pechuga hawaiana",
      descripcion:
          "Pechuga con Piña+jamon+Queso, Arroz, Ensalada, Principio, Contorno, Sopa , Limonada",
      precio: 15000,
      categoria: "fijo"),
  MenuItem(
      nombre: "Arroz con pollo",
      descripcion: "Arroz con pollo, Papa amarilla, Sopa , Limonada",
      precio: 15000,
      categoria: "fijo"),
  MenuItem(
      nombre: "Pollo Apanado",
      descripcion: "Arroz, Principio, Contorno, Sopa , Ensalada, Limonada",
      precio: 15000,
      categoria: "fijo"),
  MenuItem(
      nombre: "Pata sudada",
      descripcion: "Arroz, Yuca, Principio, Sopa , Limonada",
      precio: 15000,
      categoria: "fijo"),
  MenuItem(
      nombre: "Pollo Sudado",
      descripcion: "Arroz, Ensalada, Principio, Contorno, Sopa , Limonada",
      precio: 14000,
      categoria: "fijo"),
  MenuItem(
      nombre: "Higado a la plancha+bistec",
      descripcion: "Arroz, Ensalada, Principio, Contorno, Sopa , Limonada",
      precio: 15000,
      categoria: "fijo"),
  MenuItem(
      nombre: "Pechuga rellena",
      descripcion:
          "pechuga rellena de jamon,queso y verduras + salsa encima,Arroz, Ensalada, Principio, Maduro, Sopa , Limonada",
      precio: 15000,
      categoria: "fijo"),
  MenuItem(
      nombre: "Pechuga milanesa",
      descripcion:
          "Pechuga apanada con (panco+huevo), Arroz, Ensalada, Principio, Maduro, Sopa , Limonada",
      precio: 15000,
      categoria: "fijo"),
  MenuItem(
      nombre: "Lengua en salsa",
      descripcion: "Arroz, Ensalada, Principio, Contorno, Sopa , Limonada",
      precio: 13000,
      categoria: "fijo"),
];

final Map<String, List<MenuItem>> opcionesPersonalizadas = {
  "proteina": [
    MenuItem(
        nombre: "Pechuga asada",
        descripcion: "150g a la plancha",
        precio: 8000,
        categoria: "proteina"),
    MenuItem(
        nombre: "Carne molida",
        descripcion: "200g guisada",
        precio: 9000,
        categoria: "proteina"),
    MenuItem(
        nombre: "Pollo guisado",
        descripcion: "Muslo y contramuslo",
        precio: 7500,
        categoria: "proteina"),
    MenuItem(
        nombre: "Vegetariano",
        descripcion: "Lentejas o garbanzos",
        precio: 6000,
        categoria: "proteina"),
  ],
  "arroz": [
    MenuItem(
        nombre: "Arroz blanco",
        descripcion: "Porción normal",
        precio: 3000,
        categoria: "arroz"),
    MenuItem(
        nombre: "Arroz con coco",
        descripcion: "Aromático y delicioso",
        precio: 4000,
        categoria: "arroz"),
    MenuItem(
        nombre: "Papa salada",
        descripcion: "En lugar de arroz",
        precio: 3000,
        categoria: "arroz"),
  ],
  "ensalada": [
    MenuItem(
        nombre: "Ensalada básica",
        descripcion: "Lechuga, tomate, cebolla",
        precio: 2000,
        categoria: "ensalada"),
    MenuItem(
        nombre: "Ensalada mixta",
        descripcion: "+ zanahoria y remolacha",
        precio: 3000,
        categoria: "ensalada"),
  ],
  "bebida": [
    MenuItem(
        nombre: "Jugo natural",
        descripcion: "Naranja o mandarina",
        precio: 3000,
        categoria: "bebida"),
    MenuItem(
        nombre: "Gaseosa",
        descripcion: "Coca-Cola o similar",
        precio: 2500,
        categoria: "bebida"),
    MenuItem(
        nombre: "Agua",
        descripcion: "Botella 600ml",
        precio: 1500,
        categoria: "bebida"),
  ],
  "extra": [
    MenuItem(
        nombre: "Aguacate",
        descripcion: "Media unidad",
        precio: 3000,
        categoria: "extra"),
    MenuItem(
        nombre: "Plátano maduro",
        descripcion: "Porción",
        precio: 2000,
        categoria: "extra"),
  ],
};
