class ResponseDTO {
  final String id;
  final String name;
  final String token;

  ResponseDTO({required this.id, required this.name, required this.token});

  factory ResponseDTO.fromJson(Map<String, dynamic> json) {
    return ResponseDTO(
      id: json['id']?.toString() ?? '',
      name: json['name'],
      token: json['token'],
    );
  }
}
