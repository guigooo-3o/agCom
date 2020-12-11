import 'package:agendador_comunitario/model/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class Activity {
  final String date;
  final String hour;
  final String type;
  final String title;
  final String description;
  final String address;
  final String creator;
  final double price;
  final String typeDescription;
  final int numberParticipants;
  final String documentId;
  final String status;
  Activity({
    @required this.type,
    @required this.title,
    @required this.creator,
    this.date,
    this.hour,
    this.typeDescription,
    this.description,
    this.numberParticipants,
    this.address,
    this.price,
    this.documentId,
    this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'creator': creator,
      'title': title,
      'description': description,
      'typeDescription' : typeDescription,
      'numberParticipants' : numberParticipants,
      'type': type,
      'date': date,
      'hour': hour,
      'address': address,
      'price': price,
      'status': status,
    };
  }

  static Activity fromMap(Map<String, dynamic> map, String documentId) {
    if (map == null) return null;

    return Activity(
      title: map['title'],
      creator: map['creator'],
      description: map['description'],
      typeDescription : map['typeDescription'],
      numberParticipants : map['numberParticipants'],
      type: map['type'],
      date: map['date'],
      hour: map['hour'],
      address: map['address'],
      price: map['price'],
      documentId: documentId,
      status: map['status'],
    );
  }
}
