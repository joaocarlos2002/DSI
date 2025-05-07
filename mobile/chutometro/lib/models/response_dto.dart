class ResponseDTO {
  final String name;
  final String token;

  ResponseDTO({required this.name, required this.token});

  factory ResponseDTO.fromJson(Map<String, dynamic> json) {
    return ResponseDTO(name: json['name'], token: json['token']);
  }
}
