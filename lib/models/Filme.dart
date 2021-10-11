class Filme{
  final int id;
  String nome;
  String ano;
  String linkOnline;
  int checked;
  Filme(this.id,this.nome,this.ano,this.linkOnline,[this.checked=0]);

  @override
  String toString(){
    return 'Filme{nome:$nome, ano: $ano, linkOnline: $linkOnline}';
  }
}