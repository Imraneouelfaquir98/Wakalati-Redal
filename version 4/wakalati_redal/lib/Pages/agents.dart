import 'dart:ffi';

import 'package:flutter/material.dart';

class Agent{
  final String image, title, description, id, address, tele;
  final List lat_long;
  final int num;
  int distance;
  String timer;
  static List order = [[ 0, 0], [ 1, 0], [ 2, 0], [ 3, 0], [ 4, 0], [ 5, 0], [ 6, 0], [ 7, 0], [ 8, 0], [ 9, 0], [ 10, 0], [ 11, 0], [ 12, 0], [ 13, 0]]; //[index, distance]
  Agent({
    this.id,
    this.image,
    this.address,
    this.title,
    this.distance = 0,
    this.timer = "",
    this.tele,
    this.num,
    this.lat_long,
    this.description,
  });
}

final List<Agent> agents = [
  Agent(
      num: 0,
      id: "ChIJO39UgJJrpw0RdzfBFRpueDY",
      title: "REDAL",
      tele: "+212 537 238 383",
      address: "6 Rue Al Hoceima, Rabat 10000, Maroc",
      distance : 0,
      timer : "",
      description: "",
      image: "assets/logos/redal.png",
      lat_long: [34.0234755,-6.831185199999999]
  ),
  Agent(
      num: 1,
      id: "ChIJT1QcJ1Brpw0Re87asFwj7vo",
      title: "Redal Agence Nahda",
      tele: "Indisponible",
      address: "Rue Ouarfel Hay Nahda, P4014, Rabat, Maroc",
      distance : 0,
      timer : "",
      description: "",
      image: "assets/logos/redal.png",
      lat_long: [33.9734148,-6.824537299999999]
  ),
  Agent(
      num: 2,
      id: "ChIJNVRuBWprpw0R8Hdj93gcz84",
      title: "Agence REDAL Taqadoum",
      tele: "+212 537 202 080",
      address: "Avenue Hoummane Al Fatouaki, Rabat, Maroc",
      distance : 0,
      timer : "",
      description: "",
      image: "assets/logos/redal.png",
      lat_long: [33.9875146,-6.818253800000001]
  ),
  Agent(
      num: 3,
      id: "ChIJSyzGpcgSpw0R9-cavKw-1hM",
      title: "Mouline Reda (Étude), Témara",
      tele: "+212 537 741 541",
      address: "Av. Hassan II, Ang. My Rachid , Imm.28 Appt.2, 1° Ét., Témara 12000, Maroc",
      distance : 0,
      timer : "",
      description: "",
      image: "assets/logos/redal.png",
      lat_long: [33.9257422,-6.9169911]
  ),
  Agent(
      num: 4,
      id: "ChIJE01044trpw0R_Fz9JVG0uRE",
      title: "Redal Agence Hassan",
      distance : 0,
      timer : "",
      tele: "+212 537 202 080",
      address: "Rabat, Maroc",
      description: "",
      image: "assets/logos/redal.png",
      lat_long: [34.0234824,-6.8312165]
  ),
  Agent(
      num: 5,
      id: "ChIJKUQtgL8Jpw0Rv7MnDBuVXBQ",
      title: "REDAL Skhirat",
      tele: "+212 663 552 944",
      address: "ain el hayat 1, Skhirat, Maroc",
      distance : 0,
      timer : "",
      description: "",
      image: "assets/logos/redal.png",
      lat_long: [33.8566064,-7.028705599999999]
  ),
  Agent(
      num: 6,
      id: "ChIJAQAAwJlCpw0R-u4_s_yAGu0",
      title: "Redal Sidi Bouknadel",
      tele: "+212 537 202 080",
      address: "Sidi Bouknadel, Maroc",
      distance : 0,
      timer : "",
      description: "",
      image: "assets/logos/redal.png",
      lat_long: [34.1203155,-6.738426199999999]
  ),
  Agent(
      num: 7,
      id: "ChIJNWgX7JkSpw0RY1aSP_Rz1nE",
      title: "Rédal Temara",
      tele: "+212 537 741 164",
      address: "bd Hassan II 12000، Temara, Maroc",
      distance : 0,
      timer : "",
      description: "",
      image: "assets/logos/redal.png",
      lat_long: [33.9325404,-6.9112706]
  ),
  Agent(
      num: 8,
      id: "ChIJ3U80g41spw0RPgbYMhZYHos",
      title: "Agence commerciale REDAL",
      tele: "Indisponible",
      address: "Rabat, Maroc",
      distance : 0,
      timer : "",
      description: "",
      image: "assets/logos/redal.png",
      lat_long: [33.99787477989273,-6.852335970107278]
  ),
  Agent(
      num: 9,
      id: "ChIJq6rWqGhrpw0R5tEenQAhk6s",
      title: "Redal Sa",
      tele: "+212 537 238 380",
      address: "Avenue Fkih Ben Ali Doukkali, Salé Al-Jadida, Maroc",
      distance : 0,
      timer : "",
      description: "",
      image: "assets/logos/redal.png",
      lat_long: [33.9913928,-6.8240672]
  ),
  Agent(
      num: 10,
      id: "ChIJi2L7YCVqpw0Ra-DI5bKmtEk",
      title: "Agence Hay Salam Redal",
      tele: "+212 537 202 080",
      address: "Avenue Mokhtar Souissi, Salé, Maroc",
      distance : 0,
      timer : "",
      description: "",
      image: "assets/logos/redal.png",
      lat_long: [34.0457434,-6.7813218]
  ),
  Agent(
      num: 11,
      id: "ChIJ5bEv4QVrpw0RJYqcLvGycCE",
      title: "Redal",
      tele: "Indisponible",
      address: "P4006, Salé, Maroc",
      distance : 0,
      timer : "",
      description: "",
      image: "assets/logos/redal.png",
      lat_long: [34.0247006,-6.7535891]
  ),
  Agent(
      num: 12,
      id: "ChIJKWgSMRWmpw0Rxu8Ze9CvNQ8",
      title: "REDAL",
      tele: "+212 537 745 203",
      address: "N1, Bouznika, Maroc",
      distance : 0,
      timer : "",
      description: "",
      image: "assets/logos/redal.png",
      lat_long: [33.7892605,-7.1592826]
  ),
  Agent(
      num: 13,
      id: "ChIJfVcLj9Brpw0RHyzU6EQumac",
      title: "Redal Tabriquet",
      tele: "Indisponible",
      address: "Salé, Maroc",
      distance : 0,
      timer : "",
      description: "",
      image: "assets/logos/redal.png",
      lat_long: [34.0463201,-6.8022408]
  ),
];