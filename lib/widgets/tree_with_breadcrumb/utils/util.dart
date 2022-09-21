class MStack {
  int top = 0;
  List items = [];

  push(item) {
    top++;
    items.add(item);
  }

  pop() {
    --top;
    return items.removeLast();
  }

  peek() {
    return items[top - 1];
  }
}
