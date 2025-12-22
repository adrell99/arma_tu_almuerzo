import '../models/item_menu.dart';

final List<MenuItem> menuFijo = [
  MenuItem(
      nombre: "Almuerzo Ejecutivo",
      descripcion: "Pollo asado, arroz, ensalada y jugo",
      precio: 15000,
      categoria: "fijo"),
  MenuItem(
      nombre: "Sopa + Carne",
      descripcion: "Sopa de verduras y bistec guisado",
      precio: 18000,
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
