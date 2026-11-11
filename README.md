# Objetivos
- MaterialApp e Tema (Material 3)
- Scaffold
- StatefulWidget e StatelessWidget
- TextField e TextFormField
- TextEditingController e ciclo de vida (dispose)
- ElevatedButton (estilização, cores customizadas Terracota #CB5A34, bordas e ícones)
- TextButton e IconButton
- Checkbox e manipulação de estado com setState
- Row, Column, SizedBox, Padding, Center e SingleChildScrollView
- Divider e divisores personalizados
- GoogleFonts (Inter)
- Navigator.push, Navigator.pop e Rotas Nomeadas (routes)
- Importação de assets (Logo do Google)
- Resolução de estouro de layout (unbounded constraints) e validação de campos
- Exibição de alertas com SnackBar

# Funcionamento
- O sistema permite que o usuário:
- Insira e-mail e senha na tela principal de Login com validação de preenchimento;
- Marque a opção "Remember me" utilizando o Checkbox;
- Faça login social via botão "Continue with Google";
- Navegue para a tela de Resgatar Senha via link "Esqueceu a senha?";
- Navegue para a tela de Cadastro via link "Sign Up";
- Receba confirmação por SnackBar e retorne ao login após solicitar o resgate de senha;
- Seja direcionado para a HomePage de boas-vindas após autenticar com sucesso.

# Checklist
[x] Criar projeto Flutter e estruturar a pasta lib/pages/
[x] Configurar o main.dart apontando para a tela de Login
[x] Estilizar o botão principal de login (Terracota / Cores customizadas)
[x] Criar o bloco "Remember me" com Checkbox e setState
[x] Desenhar a linha divisória com Divider para a seção de login social
[x] Criar botão "Continue with Google" usando Row e imagem nos assets
[x] Resolver erros de restrição de largura (Expanded dentro de Row)
[x] Adicionar o rodapé com o texto e botão "Sign Up"
[x] Declarar os TextEditingController para e-mail e senha no Login
[x] Criar o arquivo e a estrutura da tela resgatar_senha.dart
[x] Adicionar controlador de e-mail e liberar memória com dispose()
[x] Implementar funções de navegação com Navigator.push nos botões
[x] Criar a tela de boas-vindas (home_page.dart) com botão de Logout
[x] Validar preenchimento obrigatório dos campos antes de navegar
[x] Implementar a funcionalidade de ocultar/exibir a senha (obscureText e IconButton)
[x] Adicionar validação do formato de e-mail (presença de @ e .com)
[ ] Testar a aplicação no Chrome/Dispositivo e verificar a navegação completa

# Desafio
[x] Organizar a navegação utilizando rotas nomeadas (routes) no MaterialApp
[x] Adicionar ícone de "olhar senha" dentro do TextField para alternar visibilidade
[ ] Exibir um SnackBar ao clicar em resgatar senha confirmando o envio do link
[ ] Conectar os controladores a um serviço de autenticação (ex: Firebase ou API)
[ ] Adicionar animação personalizada na transição de telas

# Testes
Os testes ficam em `test/`:
- `test/unit/` — testes unitários (duração, catálogo de objetivos, `ControleObjetivos`, aparência, perfil);
- `test/widget/` — testes de widget (validações de login/cadastro/recuperação de senha, fluxo de objetivos, `SessaoGuard`/tela de bloqueio).

```bash
flutter test                 # todos os testes
flutter test test/unit       # apenas os unitários
flutter test --coverage      # gera coverage/lcov.info
```

# Documentação da API (Swagger / OpenAPI)
O contrato da API REST que o backend deve implementar está em `docs/api/openapi.yaml` (OpenAPI 3.0.3).
O aplicativo ainda não possui backend; a especificação segue o modelo de dados proposto no Relatório Técnico (Seção 8.5) e as regras de negócio já implementadas no app.

Para visualizar no Swagger UI, sirva a pasta por HTTP (abrir o arquivo direto no navegador não carrega o YAML):

```bash
npx http-server docs/api -p 8099
# abra http://localhost:8099
```

Também é possível colar o conteúdo de `openapi.yaml` em https://editor.swagger.io.
