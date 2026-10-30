# Arquitetura

`main.dart` inicializa `MetalHubApp`. O aplicativo configura tema, localização e rotas em `app.dart`.

## Interface

As telas ficam em `lib/screens`. `AppShell` fornece cabeçalho, navegação e área de conteúdo. Cartões, campos visuais e grades responsivas são compartilhados em `lib/widgets`.

`AdaptiveGrid` calcula as colunas conforme a largura disponível. O menu lateral é usado a partir de 1000 pixels; abaixo dessa largura, a navegação usa Drawer.

## Estado

O estado é mantido com `StatefulWidget` e `setState`, próximo de cada interação:

- `AuthScreen`: visibilidade da senha e seleção da caixa de opção.
- `RegistrationScreen`: situação, tipo de cliente e data de admissão.
- `SearchableCards`: consulta digitada e filtragem local, com estado vazio.

Tema, cores, destinos e funções de navegação ficam em `lib/core`.

## Dados e integrações

Clientes PF/PJ usam `lib/models/client.dart` e `lib/data/client_repository.dart`. O repositório serializa os cadastros em JSON e usa `shared_preferences` para persistência local. Os dois registros iniciais são exemplos; novos clientes e suas edições são preservados após reiniciar. Não há API, autenticação remota ou sincronização entre dispositivos. Os demais módulos usam os registros definidos no código.

Quando essas integrações forem adicionadas, os modelos e o acesso a dados devem ficar fora dos widgets. Estados de carregamento, erro e nova tentativa devem acompanhar a operação assíncrona correspondente. A estrutura atual não deve ser apresentada como uma arquitetura com camada de dados já implementada.

## Verificação

`test/metalhub_test.dart` cobre navegação, busca e layouts responsivos. A análise e os testes também estão configurados em `.github/workflows/flutter.yml`.
