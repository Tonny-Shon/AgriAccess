class TPricingCalculator {
  //Calculate price based on tax and shipping
  static double calculateTotalPrice(double productPrice, String location) {
    double taxRate = getTaxRateForLocation(location);
    double taxAmount = productPrice * taxRate;

    double shippingCost = getShippingCost(location);

    double totalPrice = productPrice + taxAmount + shippingCost;
    return totalPrice;
  }

  //Calculate shipping cost
  static double calculateShippingCost(double productPrice, String location) {
    double shippingCost = getShippingCost(location);
    return shippingCost;
  }

  //Calculate tax
  static String calculateTax(double productionPrice, String location) {
    double taxRate = getTaxRateForLocation(location);
    double taxtAmount = productionPrice * taxRate;
    return taxtAmount.toStringAsFixed(2);
  }

  static double getTaxRateForLocation(String location) {
    //lokup the tax rate for a given location from the tax databse or location
    //Return the appropriate tax rate
    return 0.10;
  }

  static double getShippingCost(String location) {
    //lokup the shipping coat for a given location from the tax databse or location
    //RCalculate shipping cost basing on variousfactors like distance,weight,
    return 5.0; //Example of shipping cost of $5
  }

  //Sum all cart values and return total amount
  //Static double calculateCartTotal(CartModel cart){
  //return cart.items.map((e) => e.price).fold(0,(previousPrice,currentPrice) => previousPrice + (currentPrice ?? 0));
  // }
}
