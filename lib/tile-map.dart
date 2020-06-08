class TileMap {
  final List<TileType> tiles;
  final int width;
  final int height;

  TileMap(this.tiles, this.width) : height = tiles.length ~/ width;
}

enum TileType { dirt, grass }

extension TileMapExtensions on TileMap {
  int size() {
    return tiles.length;
  }

  void forEach(void Function(TileType) f) {
    tiles.forEach(f);
  }

  void forEachIndexed(void Function(int, TileType) f) {
    tiles.asMap().forEach(f);
  }

  TileType get(int x, int y) {
    assert(x < width);
    assert(y < height);
    return tiles[x + y * width];
  }
}
