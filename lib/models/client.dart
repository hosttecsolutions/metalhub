class Client {
  const Client({
    required this.id,
    required this.personType,
    required this.name,
    required this.document,
    required this.address,
    required this.clientType,
    this.status = 'Ativo',
    this.email = '',
    this.phone = '',
    required this.createdAt,
  });

  final String id,
      personType,
      name,
      document,
      address,
      clientType,
      status,
      email,
      phone,
      createdAt;
  bool get isCompany => personType == 'PJ';
  bool get inactive => status == 'Inativo';
  String get searchText =>
      '$name $document ${document.replaceAll(RegExp(r'\D'), '')} $address $clientType $status';

  Map<String, dynamic> toJson() => {
    'id': id,
    'personType': personType,
    'name': name,
    'document': document,
    'address': address,
    'clientType': clientType,
    'status': status,
    'email': email,
    'phone': phone,
    'createdAt': createdAt,
  };

  factory Client.fromJson(Map<String, dynamic> data) {
    String field(String key) {
      if (data[key] is! String) {
        throw const FormatException('Cadastro de cliente inválido.');
      }
      return data[key] as String;
    }

    final client = Client(
      id: field('id'),
      personType: field('personType'),
      name: field('name'),
      document: field('document'),
      address: field('address'),
      clientType: field('clientType'),
      status: field('status'),
      email: field('email'),
      phone: field('phone'),
      createdAt: field('createdAt'),
    );
    if (client.id.isEmpty ||
        client.name.isEmpty ||
        !['PF', 'PJ'].contains(client.personType) ||
        !['Fornecedor', 'Comprador'].contains(client.clientType) ||
        !['Ativo', 'Inativo'].contains(client.status)) {
      throw const FormatException('Cadastro de cliente inválido.');
    }
    return client;
  }
}

const sampleClients = [
  Client(
    id: 'example-active',
    personType: 'PJ',
    name: 'Metalúrgica Silva Ltda',
    document: '00.000.000/0000-00',
    address: 'São Paulo - SP',
    clientType: 'Comprador',
    email: 'empresa01@email.com',
    phone: '(11) 99999-9999',
    createdAt: '2025-11-24T00:00:00.000Z',
  ),
  Client(
    id: 'example-inactive',
    personType: 'PJ',
    name: 'Metalúrgica Silva Ltda',
    document: '00.000.000/0000-00',
    address: 'São Paulo - SP',
    clientType: 'Fornecedor',
    status: 'Inativo',
    email: 'empresa01@email.com',
    phone: '(11) 99999-9999',
    createdAt: '2025-11-24T00:00:00.000Z',
  ),
];
