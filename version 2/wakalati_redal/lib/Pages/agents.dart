import 'package:flutter/material.dart';

class Agent{
  final String image, title, description;
  final int size, id;
  final Color color;

  const Agent({
    this.id,
    this.image,
    this.size,
    this.color,
    this.title,
    this.description,
  });
}

final List<Agent> agents = [
  Agent(
    id: 1,
    title: "Redal",
    description: "",
    image: "assets/logos/redal.png",
    color: Colors.grey[300],
  ),
  Agent(
    id: 2,
    title: "Attijariwafa Bank",
    description: "",
    image: "assets/logos/attijariwafabank.png",
    color: Colors.grey[300],
  ),
  Agent(
    id: 2,
    title: "CIH Bank",
    description: "",
    image: "assets/logos/cih.jpg",
    color: Colors.grey[300],
  ),
  Agent(
    id: 2,
    title: "BANQUE POPULAIRE",
    description: "",
    image: "assets/logos/bank_populaire.png",
    color: Colors.grey[300],
  ),
  Agent(
    id: 2,
    title: "BMCE Bank",
    description: "",
    image: "assets/logos/bmce.png",
    color: Colors.grey[300],
  ),
  Agent(
    id: 2,
    title: "BMCI Bank",
    description: "",
    image: "assets/logos/bmci.jpg",
    color: Colors.grey[300],
  ),
];

//assets/logos/bmci.jpg