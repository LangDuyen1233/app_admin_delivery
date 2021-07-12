class Discount {
  final String name;
  final String content;
  final double percent;
  final String startDate;
  final String endDate;

  Discount(
      {this.name, this.content, this.percent, this.startDate, this.endDate});
}

List<Discount> list = [
  Discount(
      name: 'Khuyen mai cho nguoi dung moi',
      content: 'Ap dung cho tat ca nguoi dung',
      percent: 20.0,
      startDate: '20/1/2021',
      endDate: '3/06/2021')
];
