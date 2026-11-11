// Modelos do Explorar. Sem dependência de Flutter: só Dart puro, para
// facilitar testes.

enum TipoConteudo { video, dica, material, exercicio }

enum ProvedorVideo { youtube, arquivo }

/// Como o conteúdo aparece no feed.
/// - curto: vídeo de até 5 min
/// - video: vídeo entre 5 e 10 min (só aparece em "Recomendados")
/// - aula: vídeo de 10 min ou mais
/// - leitura: dica, material ou exercício (sem vídeo)
enum FormatoConteudo { curto, video, aula, leitura }

const int _limiteCurtoSegundos = 5 * 60;
const int _minimoAulaSegundos = 10 * 60;

/// Minúsculas e sem acentos, para a pesquisa ("Equações" casa com "equacoes").
String normalizarTexto(String s) {
  const de = 'áàâãäéèêëíìîïóòôõöúùûüçñ';
  const para = 'aaaaaeeeeiiiiooooouuuucn';
  final b = StringBuffer();
  for (final r in s.toLowerCase().runes) {
    final ch = String.fromCharCode(r);
    final i = de.indexOf(ch);
    b.write(i >= 0 ? para[i] : ch);
  }
  return b.toString().trim();
}

/// 5:30 ou 1:02:03 (formato de relógio, para selos de duração).
String formatarRelogio(int totalSegundos) {
  final s = totalSegundos < 0 ? 0 : totalSegundos;
  final h = s ~/ 3600;
  final m = (s % 3600) ~/ 60;
  final sec = s % 60;
  String dois(int n) => n.toString().padLeft(2, '0');
  return h > 0 ? '$h:${dois(m)}:${dois(sec)}' : '$m:${dois(sec)}';
}

class ConteudoExplorar {
  final String id;
  final String objetivoId;
  final String categoriaId;
  final TipoConteudo tipo;
  final String titulo;
  final String descricao;
  final int? duracaoSegundos;

  /// Nome do canal, autor ou fonte, quando disponível.
  final String? fonteNome;
  final String? urlMiniatura;

  // Vídeo
  final ProvedorVideo? provedor;
  final String? videoId; // YouTube
  final String? urlVideo; // arquivo/HLS (https)

  // Leitura (dica, material, exercício)
  final String? corpo;

  final List<String> tags;
  final bool destaque;

  ConteudoExplorar({
    required this.id,
    required this.objetivoId,
    required this.categoriaId,
    required this.tipo,
    required this.titulo,
    this.descricao = '',
    this.duracaoSegundos,
    this.fonteNome,
    this.urlMiniatura,
    this.provedor,
    this.videoId,
    this.urlVideo,
    this.corpo,
    this.tags = const [],
    this.destaque = false,
  });

  /// Texto já normalizado usado pela pesquisa.
  late final String textoBusca = normalizarTexto(
    '$titulo $descricao ${tags.join(' ')} ${fonteNome ?? ''}',
  );

  bool get ehVideo => tipo == TipoConteudo.video;

  FormatoConteudo get formato {
    if (!ehVideo) return FormatoConteudo.leitura;
    final d = duracaoSegundos ?? 0;
    if (d <= _limiteCurtoSegundos) return FormatoConteudo.curto;
    if (d >= _minimoAulaSegundos) return FormatoConteudo.aula;
    return FormatoConteudo.video;
  }

  String get rotuloFormato {
    switch (formato) {
      case FormatoConteudo.curto:
        return 'Vídeo curto';
      case FormatoConteudo.video:
        return 'Vídeo';
      case FormatoConteudo.aula:
        return 'Aula completa';
      case FormatoConteudo.leitura:
        switch (tipo) {
          case TipoConteudo.dica:
            return 'Dica';
          case TipoConteudo.material:
            return 'Material';
          case TipoConteudo.exercicio:
            return 'Exercício';
          case TipoConteudo.video:
            return 'Vídeo';
        }
    }
  }

  /// Miniatura informada no catálogo ou, para YouTube, a miniatura oficial
  /// do próprio vídeo.
  String? get miniaturaEfetiva {
    if (urlMiniatura != null) return urlMiniatura;
    if (provedor == ProvedorVideo.youtube && videoId != null) {
      return 'https://i.ytimg.com/vi/$videoId/hqdefault.jpg';
    }
    return null;
  }

  static final RegExp _idYoutube = RegExp(r'^[A-Za-z0-9_-]{11}$');

  /// Converte um item do catálogo. Devolve null se o item for inválido
  /// (o catálogo ignora itens inválidos em vez de quebrar o feed).
  static ConteudoExplorar? tentarDeJson(Object? json) {
    if (json is! Map) return null;

    String? texto(String chave) {
      final v = json[chave];
      return (v is String && v.trim().isNotEmpty) ? v.trim() : null;
    }

    final id = texto('id');
    final objetivo = texto('objetivo');
    final categoria = texto('categoria');
    final titulo = texto('titulo');
    if (id == null || objetivo == null || categoria == null || titulo == null) {
      return null;
    }

    final nomeTipo = texto('tipo');
    TipoConteudo? tipo;
    for (final t in TipoConteudo.values) {
      if (t.name == nomeTipo) tipo = t;
    }
    if (tipo == null) return null;

    final d = json['duracaoSegundos'];
    final duracao = (d is num && d > 0) ? d.toInt() : null;

    ProvedorVideo? provedor;
    String? videoId;
    String? urlVideo;
    String? corpo;

    if (tipo == TipoConteudo.video) {
      if (duracao == null) return null;
      final p = texto('provedor');
      if (p == 'youtube') {
        final v = texto('videoId');
        if (v == null || !_idYoutube.hasMatch(v)) return null;
        provedor = ProvedorVideo.youtube;
        videoId = v;
      } else if (p == 'arquivo') {
        final u = texto('urlVideo');
        final uri = u == null ? null : Uri.tryParse(u);
        if (uri == null || uri.scheme != 'https' || uri.host.isEmpty) {
          return null;
        }
        provedor = ProvedorVideo.arquivo;
        urlVideo = u;
      } else {
        return null;
      }
    } else {
      corpo = texto('corpo');
      if (corpo == null) return null;
    }

    final m = texto('miniatura');
    final miniatura =
        (m != null && Uri.tryParse(m)?.scheme == 'https') ? m : null;

    final tagsBrutas = json['tags'];
    final tags = tagsBrutas is List
        ? tagsBrutas
            .whereType<String>()
            .map((t) => t.trim())
            .where((t) => t.isNotEmpty)
            .toList(growable: false)
        : const <String>[];

    return ConteudoExplorar(
      id: id,
      objetivoId: objetivo,
      categoriaId: categoria,
      tipo: tipo,
      titulo: titulo,
      descricao: texto('descricao') ?? '',
      duracaoSegundos: duracao,
      fonteNome: texto('fonte'),
      urlMiniatura: miniatura,
      provedor: provedor,
      videoId: videoId,
      urlVideo: urlVideo,
      corpo: corpo,
      tags: tags,
      destaque: json['destaque'] == true,
    );
  }
}

/// Progresso de um vídeo. Guarda a categoria e o objetivo do conteúdo para
/// manter o histórico associado à categoria correta.
class ProgressoConteudo {
  final String conteudoId;
  final String objetivoId;
  final String categoriaId;
  final int posicaoSegundos;
  final int? duracaoSegundos;

  /// Tempo realmente assistido (soma dos trechos reproduzidos).
  final int assistidoSegundos;
  final bool concluido;
  final DateTime iniciadoEm;
  final DateTime ultimoAcesso;

  const ProgressoConteudo({
    required this.conteudoId,
    required this.objetivoId,
    required this.categoriaId,
    required this.posicaoSegundos,
    required this.duracaoSegundos,
    required this.assistidoSegundos,
    required this.concluido,
    required this.iniciadoEm,
    required this.ultimoAcesso,
  });

  double get fracao {
    final d = duracaoSegundos;
    if (d == null || d <= 0) return 0;
    return (posicaoSegundos / d).clamp(0.0, 1.0).toDouble();
  }

  /// Aparece em "Continue assistindo": começou, passou de 5 s e não terminou.
  bool get emAndamento => !concluido && posicaoSegundos >= 5 && fracao < 0.95;

  Map<String, Object?> toJson() => {
        'id': conteudoId,
        'obj': objetivoId,
        'cat': categoriaId,
        'pos': posicaoSegundos,
        'dur': duracaoSegundos,
        'vis': assistidoSegundos,
        'fim': concluido,
        'ini': iniciadoEm.millisecondsSinceEpoch,
        'ult': ultimoAcesso.millisecondsSinceEpoch,
      };

  static ProgressoConteudo? tentarDeJson(Object? json) {
    if (json is! Map) return null;
    final id = json['id'];
    final obj = json['obj'];
    final cat = json['cat'];
    final pos = json['pos'];
    final vis = json['vis'];
    final ini = json['ini'];
    final ult = json['ult'];
    if (id is! String || obj is! String || cat is! String) return null;
    if (pos is! num || vis is! num || ini is! num || ult is! num) return null;
    final dur = json['dur'];
    return ProgressoConteudo(
      conteudoId: id,
      objetivoId: obj,
      categoriaId: cat,
      posicaoSegundos: pos.toInt(),
      duracaoSegundos: dur is num ? dur.toInt() : null,
      assistidoSegundos: vis.toInt(),
      concluido: json['fim'] == true,
      iniciadoEm: DateTime.fromMillisecondsSinceEpoch(ini.toInt()),
      ultimoAcesso: DateTime.fromMillisecondsSinceEpoch(ult.toInt()),
    );
  }
}