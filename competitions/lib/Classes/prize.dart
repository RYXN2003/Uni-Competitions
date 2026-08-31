class Prize{
  final String title;
  final String imageUrl;
  final String ticketPrice;
  final int winnerCount;
  final int ticketsSold;
  final int totalTickets;
  const Prize({
    required this.title,
    required this.imageUrl,
    required this.ticketPrice,
    required this.ticketsSold,
    required this.totalTickets,
    required this.winnerCount
  });
}