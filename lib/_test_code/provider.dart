// 1. Provider(Basic)(non-changable)
// 2. No need manual

import 'package:flutter_riverpod/flutter_riverpod.dart';

// Type Stability = Generic state
final productsProvider = Provider<List<String>>((ref) {
  return [
    "Apple",
    "Banana",
    "Milk",
    "Bread",
    "Orange",
    "Watermelon",
    "Mango",
    "Strawberry"
  ];
});

// Smart and Complex Provider
// 상태 먼저 결정해야한다(값 - 객체)
// 사과나 바나나 등을 담을수 있는 객체를 설계해야 한다

// 상태 -- > 객체(불변객체) 왜냐면 다시 접근해서 안에 상태값을 마구...

class Cart {
  List<String> items;

  Cart({required this.items});
}

// Manual
class CartNotifier extends Notifier<Cart> {
  // 중요 변수 - Notifier 클래스를 상속받으면 state 변수가 기본적으로 있다.

  // 반드시 초기 상태가 어떤지 명시해야한다!!!
  @override
  Cart build() {
    return Cart(items: []);
  }

  // 상품을 추가하는 방법
  void add(String item) {
    // 불변 객체로 설계
    final newItems = [...state.items, item]; // 기존 리스트에 + 새 상품 = 완성
    state = Cart(items: newItems); // state 변수를 변경
  }

  // 상품을 제거하는 방법
  void remove(String item) {
    // list. 특정 조건을 확인하고 새로운 list를 만들어주는 메서드 = where
    final List<String> newItems = state.items
        .where((element) => element != item)
        .toList(); // 기존에 list에 담겨있던 값과 다른 값을 필터링
    state = Cart(items: newItems);
  }
}

// 실제 창고 생성(Manual + Provider)
final cartProvider = NotifierProvider<CartNotifier, Cart>(() => CartNotifier());
