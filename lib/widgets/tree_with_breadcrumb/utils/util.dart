class MStack {
  int top = 0;
  List items = [];

  push(item) {
    top++;
    items.add(item);
  }

  dynamic pop() {
    --top;
    return items.removeLast();
  }

  dynamic peek() {
    return items[top - 1];
  }
}
