class Plan {
  final String title;
  final String price;
  final String description;

  Plan({
    required this.title,
    required this.price,
    required this.description,
  });
}

// Lista de planos com suas descrições
final List<Plan> plans = [
  Plan(
    title: 'Plan One',
    price: '20€',
    description:
        'Este plano oferece acesso básico à academia, com sessões ilimitadas durante a semana.',
  ),
  Plan(
    title: 'Plan Two',
    price: '30€',
    description:
        'Este plano inclui acesso ilimitado e também a possibilidade de treinos personalizados com um coach.',
  ),
  Plan(
    title: 'Plan Three',
    price: '40€',
    description:
        'Plano premium com todos os benefícios do plano anterior e acesso a aulas exclusivas e eventos especiais.',
  ),
];
