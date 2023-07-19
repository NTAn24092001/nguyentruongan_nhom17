import 'package:nhom17/consts/consts.dart';

class FilestoreServices {
  static getUser(uid){
    return filestore.collection(usersCollection).where('id', isEqualTo: uid).snapshots();
  }
  static getProducts(category){
    return filestore.collection(productCollection).where('p_category', isEqualTo: category).snapshots();
  }
  static getCart(uid){
    return filestore.collection(cartCollection).where('added_by', isEqualTo: uid).snapshots();
  }
  static deleteDocument(docId){
    return filestore.collection(cartCollection).doc(docId).delete();
  }
  static getChatMessages(docId){
    return filestore.collection(chatsCollection).doc(docId).collection(messagesCollection).orderBy('created_on', descending: false).snapshots();
  }
  static getAllOrders() {
    return filestore.collection(ordersCollection).where('order_by', isEqualTo: currentUser!.uid).snapshots();
  }
  static getWishlist() {
    return filestore.collection(productCollection).where('p_wishlist', arrayContains: currentUser!.uid).snapshots();
  }
  static getAllMessages() {
    return filestore.collection(chatsCollection).where('fromId', isEqualTo: currentUser!.uid).snapshots();
  }
  static getCounts() async {
    var res = await Future.wait([
      filestore.collection(cartCollection).where('added_by', isEqualTo: currentUser!.uid).get().then((value) {
        return value.docs.length;
      }),
      filestore.collection(productCollection).where('p_wishlist', arrayContains: currentUser!.uid).get().then((value) {
        return value.docs.length;
      }),
      filestore.collection(ordersCollection).where('order_by', isEqualTo: currentUser!.uid).get().then((value) {
        return value.docs.length;
      }),
    ]);
    return res;
  }
  static allProducts() {
    return filestore.collection(productCollection).snapshots();
  }
  static getFeatureProducts() {
    return filestore.collection(productCollection).where('isFeatured', isEqualTo: true).get();
  }

  static searchProduct(title) {
    return filestore.collection(productCollection).get(); 
  }
}