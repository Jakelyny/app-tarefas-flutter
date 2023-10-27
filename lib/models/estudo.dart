class Estudo {
  int id;
  String disciplina;
  String diaSemana;
  bool temAtividade;
  String professor;
  Estudo(this.id, this.disciplina, this.diaSemana, this.temAtividade, this.professor);

  @override
  String toString() {
    return 'Estudo(disciplina: $disciplina, diaSemana: $diaSemana, temAtividade: $temAtividade, professor: $professor)';
  }
}