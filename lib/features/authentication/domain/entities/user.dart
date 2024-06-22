// ignore_for_file: public_member_api_docs, sort_constructors_first
import "package:equatable/equatable.dart";
import "package:flutter/material.dart";

@immutable
class User extends Equatable {
  final String id;
  final String createdAt;
  final String name;
  final String avatar;

  factory User.empty() {
    return const User(id: "", createdAt: "", name: "", avatar: "");
  }

  const User({
    required this.id,
    required this.createdAt,
    required this.name,
    required this.avatar,
  });

//function that will determine whether two instancesof user are the same or not
//same id == same
  @override
  List<Object?> get props => [id, name, avatar];
}
