import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hosco_shop_2/controllers/product_controller.dart';
import 'package:hosco_shop_2/models/product.dart';
import 'package:hosco_shop_2/utils/navigation_drawer.dart';
import 'package:hosco_shop_2/views/common_widgets/item_card.dart';
import 'package:hosco_shop_2/views/products/categories_bottom_sheet.dart';
import 'package:hosco_shop_2/views/products/product_details.dart';

class ProductsManagement extends StatelessWidget {
  final ProductController productController = Get.find<ProductController>();
  final ScrollController scrollController = ScrollController();

  ProductsManagement({super.key}) {
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        productController.loadNextPage();
      }
    });
  }

  void _openSearchScreen() {
    Get.to(() => ProductSearchScreen(productController: productController));
  }

  void _clearSearch() {
    productController.searchQuery.value = '';
    productController.searchSuggestions.clear();
    productController.getProducts('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyNavigationDrawer(),
      appBar: AppBar(
        title: Text('Quản lý sản phẩm'),
        actions: [
          IconButton(
            icon: Obx(() => Badge(
              isLabelVisible: productController.selectedCategories.isNotEmpty,
              label: Text(productController.selectedCategories.length.toString()),
              child: const Icon(Icons.filter_list),
            )),
            onPressed: () {
              context.showCategoryFilterBottomSheet(
                availableCategories: productController.allCategories ?? [],
                selectedCategories: productController.selectedCategories ?? [],
                onApplyFilters: (categories) {
                  productController.selectedCategories.assignAll(categories);
                  productController.refreshProducts();
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar with clear button
          Container(
            margin: EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              children: [
                // Search icon and text area (clickable to open search screen)
                Expanded(
                  child: InkWell(
                    onTap: _openSearchScreen,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      child: Row(
                        children: [
                          Icon(Icons.search, color: Colors.grey.shade600),
                          SizedBox(width: 8),
                          Expanded(
                            child: Obx(() => Text(
                              productController.searchQuery.value.isNotEmpty
                                  ? productController.searchQuery.value
                                  : "Tìm kiếm sản phẩm...",
                              style: TextStyle(
                                color: productController.searchQuery.value.isNotEmpty
                                    ? Colors.black
                                    : Colors.grey.shade600,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Clear button - only visible when there's a search query
                Obx(() => productController.searchQuery.value.isNotEmpty
                    ? InkWell(
                  onTap: _clearSearch,
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Icon(Icons.clear, color: Colors.grey.shade600),
                  ),
                )
                    : SizedBox.shrink()
                ),
              ],
            ),
          ),

          // Product list
          Expanded(
            child: Obx(() {
              // Always show loading indicator when fetching, regardless of list state
              if (productController.isFetching.value) {
                return Center(child: CircularProgressIndicator());
              }

              List<Product> products = productController.allProducts;
              if (products.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/icons/not_found_icon.png', height: 80),
                      const SizedBox(height: 30),
                      Text('Không tìm thấy sản phẩm phù hợp', style: TextStyle(fontSize: 18)),
                    ],
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8.0),
                child: RefreshIndicator(
                  onRefresh: () async {
                    productController.refreshProducts();
                  },
                  child: ListView.builder(
                      controller: scrollController,
                      itemCount: products.length + (productController.hasMoreData.value ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index < products.length) {
                          final Product product = products[index];
                          return GestureDetector(
                              onTap: () {
                                productController.setSelectedProduct(product);
                                Get.to(() => ProductDetailScreen());
                              },
                              child: ItemCard(product: product)
                          );
                        } else if (productController.hasMoreData.value) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        return null;
                      }
                  ),
                ),
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed('/add-product');
        },
        backgroundColor: Color(0xff2F98F5),
        shape: CircleBorder(),
        child: Icon(
          Icons.add,
          size: 30,
          color: Colors.white,
        ),
      ),
    );
  }
}
// Dedicated search screen
class ProductSearchScreen extends StatefulWidget {
  final ProductController productController;

  const ProductSearchScreen({Key? key, required this.productController}) : super(key: key);

  @override
  _ProductSearchScreenState createState() => _ProductSearchScreenState();
}

class _ProductSearchScreenState extends State<ProductSearchScreen> {
  late TextEditingController searchQueryController;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Initialize with the current search query
    searchQueryController = TextEditingController(
        text: widget.productController.searchQuery.value
    );

    // Focus the search field automatically
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    searchQueryController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _clearSearch() {
    searchQueryController.clear();
    widget.productController.searchSuggestions.clear();
    widget.productController.searchQuery.value = '';
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(65),
        child: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0.5,
          flexibleSpace: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () => Get.back(),
                  ),
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: TextField(
                        controller: searchQueryController,
                        focusNode: _focusNode,
                        onChanged: (value) {
                          // Update the searchQuery when typing
                          widget.productController.searchQuery.value = value;
                          widget.productController.searchProducts(value);
                        },
                        style: TextStyle(fontSize: 16),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          hintText: "Tìm kiếm sản phẩm...",
                          hintStyle: TextStyle(color: Colors.grey.shade500),
                          prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
                          suffixIcon: IconButton(
                            onPressed: _clearSearch,
                            icon: Icon(Icons.clear, color: Colors.grey.shade600, size: 18),
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Search suggestions
          Expanded(
            child: Obx(() {
              // Show loading indicator when searching
              if (widget.productController.isFetching.value) {
                return Center(child: CircularProgressIndicator());
              }

              if (widget.productController.searchSuggestions.isEmpty) {
                // Show recent searches or categories here if you want
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search, size: 48, color: Colors.grey.shade400),
                      SizedBox(height: 16),
                      Text(
                        'Nhập từ khóa để tìm kiếm',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                );
              }

              return ListView.separated(
                itemCount: widget.productController.searchSuggestions.length,
                separatorBuilder: (context, index) => Divider(height: 1),
                itemBuilder: (context, index) {
                  final suggestion = widget.productController.searchSuggestions[index];
                  return ListTile(
                    leading: Icon(Icons.search),
                    title: Text(suggestion),
                    onTap: () {
                      // Update the controller's searchQuery value
                      // widget.productController.searchQuery.value = suggestion;
                      widget.productController.selectSuggestion(suggestion);
                      Get.back(); // Return to main screen after selecting
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}