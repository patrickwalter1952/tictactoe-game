
enum BoardID {
  BoardID_8X8(id: "8x8", rowsCols: 8, size: 64),
  BoardID_7X7(id: "7X7", rowsCols: 7, size: 49),
  BoardID_6X6(id: "6X6", rowsCols: 6, size: 36),
  BoardID_5X5(id: "5X5", rowsCols: 5, size: 25),
  BoardID_4X4(id: "4X4", rowsCols: 4, size: 16),
  BoardID_3X3(id: "3X3", rowsCols: 3, size:  9);

  const BoardID({
    required this.id,
    required this.rowsCols,
    required this.size,
  });

  final String id;
  final int rowsCols;
  final int size;

  static BoardID getBoardID(String id) {
    if (id == BoardID_8X8.id) {
      return BoardID_8X8;
    } else if (id == BoardID_7X7.id) {
      return BoardID_7X7;
    } else if (id == BoardID_6X6.id) {
      return BoardID_6X6;
    } else if (id == BoardID_5X5.id) {
      return BoardID_5X5;
    } else if (id == BoardID_4X4.id) {
      return BoardID_4X4;
    } else if (id == BoardID_3X3.id) {
      return BoardID_3X3;
    } else {
      return BoardID_8X8;
    }
  }
}

class Board {
  final BoardID boardID;

  const Board({
    required this.boardID,
  });

}