import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:device_preview/device_preview.dart';

/*-------------------------------------*/

import 'pages_login/cadastro.dart';
import 'pages_login/login.dart';
import 'pages_login/resgatar_senha.dart';
import './pages_login/tela_temporaria4.dart';

/*-------------------------------------*/

import './pages_home/home/notificacao.dart';
import './pages_home/home/home.dart';

/*--------------------------------------*/

import './pages_configurar/controle_objetivo.dart';
import 'pages_configurar/objetivo_leitura.dart';
import 'pages_configurar/objetivo_conteudo.dart';
import 'pages_configurar/objetivo_estudo.dart';
import './pages_configurar/tela_temporaria1.dart';
import './pages_configurar/tela_temporaria2.dart';

/*--------------------------------------*/

import './pages_home/perfil/perfil.dart';
import './pages_home/perfil/configuracao.dart';

import './pages_home/perfil/botoes_configuracao/conta/alterar_informacoes_de_acesso.dart';
import './pages_home/perfil/botoes_configuracao/conta/perfil.dart';

import './pages_home/perfil/botoes_configuracao/ajuda_e_informacoes/ajuda_e_suporte.dart';
import './pages_home/perfil/botoes_configuracao/ajuda_e_informacoes/central_de_ajuda.dart';
import './pages_home/perfil/botoes_configuracao/ajuda_e_informacoes/sobre_ikai.dart';

import './pages_home/perfil/botoes_configuracao/conta_e_sessao/sair_da_conta.dart';
import './pages_home/perfil/botoes_configuracao/conta_e_sessao/excluir_conta.dart';

import './pages_home/perfil/botoes_configuracao/aparencia/aparencia.dart';

import './pages_home/perfil/botoes_configuracao/notificao/notificacao.dart';

import './pages_home/perfil/botoes_configuracao/privacidade_e_segurança/privacidade.dart';
import './pages_home/perfil/botoes_configuracao/privacidade_e_segurança/termos_de_uso.dart';

/*--------------------------------------*/

// Aparência global (tema claro/escuro, alto contraste e tamanho do texto).
import './tema.dart' hide AparenciaController, AparenciaTemas;

/*--------------------------------------*/

void main() {
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) =>  const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Reconstrói o MaterialApp sempre que o usuário muda a aparência.
    return ListenableBuilder(
      listenable: AparenciaController.instancia,
      builder: (context, _) {
        final aparencia = AparenciaController.instancia;

        return MaterialApp(
          locale: DevicePreview.locale(context),
          navigatorKey: navigatorKey,
          builder: (context, child) =>
              AparenciaController.aplicarEscalaDeTexto(
            context,
            SessaoGuard(child: child!),
          ),
          debugShowCheckedModeBanner: false,
          title: 'Ikai',
          theme: AparenciaTemas.claro(
            altoContraste: aparencia.altoContraste,
          ),
          darkTheme: AparenciaTemas.escuro(
            altoContraste: aparencia.altoContraste,
          ),
          themeMode: aparencia.tema,
          home: InicioPage4(),
        );
      },
    );
  }
}