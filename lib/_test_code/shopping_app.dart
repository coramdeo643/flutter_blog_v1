import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blog/_test_code/provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Riverpod System - STL Extension --> ConsumerWidget
class ShoppingApp extends ConsumerWidget {
  const ShoppingApp({super.key});

  // WidgetRef ref - Bridge
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<String> products = ref.read(productsProvider);
    final Cart cart = ref.watch(cartProvider);
    String buy = "Buy";
    // 방금 내가 만들 창고에 접근해
    //List<String> products = ref.read(productsProvider);
    //ref.watch(provider) : keep alive
    //ref.read(provider) : immutable, read once only
    //ref.listen(provider, listener)
    return Scaffold(
      appBar: AppBar(
        title: Text("Store01"),
        actions: [
          Center(child: Text("Shoppingcart : ${cart.items.length} ")),
          const SizedBox(width: 20),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final String product = products[index];
                return ListTile(
                  title: Text(product),
                  trailing: ElevatedButton(
                    onPressed: () {
                      // State share = synchronization
                      // ref.read(provider)
                      ref.read(cartProvider.notifier).add(product);
                      // Access to the provider
                    },
                    child: Text(buy),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text("= = = = = Shoppingcart = = = = =",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final String item = cart.items[index];
                      return ListTile(
                          title: Text(item),
                          trailing: IconButton(
                              onPressed: () {
                                ref.read(cartProvider.notifier).remove(item);
                              },
                              icon: Icon(Icons.remove_shopping_cart)));
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
