# AGENTS.md

## Projeto
App Flutter "Ikai" (Flutter 3.38 / Dart 3.10). Sem backend; estado em memória e histórico em `shared_preferences`.

## Comandos importantes
Todos executados a partir da pasta `TCC_Ikai/`.

### Dependências
```bash
flutter pub get                    # instala/atualiza os pacotes do pubspec.yaml
flutter doctor                     # verifica a instalação do Flutter
```

### Rodar o aplicativo
```bash
flutter devices                    # lista aparelhos/emuladores/navegadores disponíveis
flutter run                        # roda no dispositivo padrão (r = hot reload, R = hot restart, q = sair)
flutter run -d chrome              # roda no navegador
flutter run -d windows             # roda como app Windows
flutter run -d <id_do_aparelho>    # roda em um celular/emulador específico
```

### Testes
```bash
flutter test                                   # todos os testes
flutter test test/unit                         # apenas os unitários
flutter test test/widget                       # apenas os de widget
flutter test test/unit/duracao_test.dart       # um arquivo específico
flutter test --name "expira"                   # testes cujo nome contém "expira"
flutter test -r failures-only                  # mostra só as falhas
flutter test --coverage                        # gera coverage/lcov.info
```

### Análise estática
```bash
flutter analyze                    # projeto inteiro (lib/ tem avisos pré-existentes)
flutter analyze test               # só os testes (deve ficar limpo)
dart format lib test               # formata o código
```

### Swagger / documentação da API (`docs/api/`)
```bash
npx http-server docs/api -p 8099                  # abre o Swagger UI em http://127.0.0.1:8099 (Ctrl+C para parar)
npx @redocly/cli@1.25.0 lint docs/api/openapi.yaml # valida a especificação OpenAPI
```
- Não abra o `index.html` com duplo clique (o navegador bloqueia a leitura do YAML); use o servidor acima
  ou cole o `openapi.yaml` em https://editor.swagger.io.
- O servidor não fica ligado: só funciona enquanto o comando estiver rodando no terminal.
- "Try it out" não funciona porque ainda não existe backend (a spec é o contrato a implementar).

### Erro "EADDRINUSE: address already in use :8099"
A porta já está ocupada (um servidor anterior ainda está rodando).
```bash
netstat -ano | findstr :8099       # descobre o PID que está usando a porta
taskkill /PID <PID> /F             # encerra o processo
# ou simplesmente use outra porta:
npx http-server docs/api -p 8100
```

### Build
```bash
flutter build apk --release        # Android (gera build/app/outputs/flutter-apk/app-release.apk)
flutter build web --release        # Web (gera build/web)
flutter build windows --release    # Windows
flutter clean                      # limpa os arquivos de build (use se o build ficar estranho)
```

## Observações para testes
- `ControleObjetivos`, `AparenciaController` e `PerfilSessao` são singletons: reinicie o estado em `setUp`/`tearDown`.
  O histórico do `ControleObjetivos` é carregado só uma vez por isolate (um arquivo de teste por cenário de histórico).
- Widgets com `GoogleFonts`: chame `configurarFontesParaTeste()` e monte com `montar()` de `test/helpers.dart`
  (área de 800x1400 para evitar overflow causado pela fonte de teste).
- Existem duas cópias de `YkaiCores`/`AparenciaController`: `lib/tema.dart` e
  `lib/pages_home/perfil/botoes_configuracao/aparencia/aparencia.dart` (a usada pelo `main.dart`).
