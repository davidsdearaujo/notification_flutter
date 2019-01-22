# message

Projeto com 3 telas e configuração de notificação.

## Configurando as Notificações

Para utilizar o sistema de notificação, é necessário seguir os seguintes passos:
 - Adicionar os packages *rxdart: ^0.20.0* e *firebase_messaging: ^2.1.0* ao **pubspec.yaml** seu projeto;
 - Adicionar seu arquivo **google-services.json** na pasta `android > app >` de seu projeto;
 - Copiar a pasta `lib > firebase-messaging-receive >` para seu projeto;
 - Adicionar o mixin `FirebaseMessagingReceiveMixin` à sua classe **MyAppState**, conforme demonstrado no arquivo `message > lib > main.dart`;
 - Adicionar a tela #NotificationDisplayScreen (veja instrução de inclusão no projeto um pouco abaixo);

Foi criado um mixin para tratar a notificação recebida dentro do app, pois o cliente não recebe notificação quando o app está fechado.
Para utilizar essa notificação, basta seguir os seguintes passos:
 - Copiar a pasta `message > lib > firebase-messaging-receive` para seu projeto;
 - Adicionar o mixin **ScaffoldNotificationMixin**, conforme demonstrado no arquivo `message > lib > home > home-screen.dart`;

## Utilizando as telas
Para utilizar as telas, basta copiar a pasta **notification_screens** para a mesma pasta do seu projeto, poe exemplo:
 - Se seu projeto se chama *meuprojeto* e está na pasta *src*, adicione a pasta **notification_screens** à pasta *src*. 

#NotificationDisplayScreen
*Responsável por mostrar os detalhes da notificação ao usuário, seja ao clicar na notificação com o app fechado ou aberto;*
 - `import 'package:notification_screens/src/notfication-display/notification-display-screen.dart';`
 - `import 'package:notification_screens/src/notfication-display/notification-display-model.dart';`

Parâmetros de entrada:
 - *NotificationDisplayModel* model;


#NotificationListScreen
*Responsável por mostrar o hitórico de notificações enviadas e recebidas.*
 - `import 'package:notification_screens/src/notifications-list/notifications-list-screen.dart';`

Parâmetros de entrada:
    - *String* uid; ~ *Identificador do usuário*
    - *bool* somenteRecebidos (default *false*); ~ *Booleano não-obrigatório para sinalizar se a listagem envolve apenas as notificações recebidas;


#SendMessageScreen
*Responsável por mostrar o hitórico de notificações enviadas e recebidas.*
 - `import 'package:notification_screens/src/send-message/send-message-screen.dart';`

Parâmetros de entrada:
    - *String* uid; ~ *Identificador do usuário*


##Flutter
This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.io/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.io/docs/cookbook)

For help getting started with Flutter, view our 
[online documentation](https://flutter.io/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.
