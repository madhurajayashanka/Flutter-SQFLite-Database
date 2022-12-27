import 'package:databases/product.dart';
import 'package:databases/product_db_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class ProductScreen extends StatefulWidget {

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  List<Product> productList = <Product>[];
  Product? _selectedProduct;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ProductDBHelper.instance.getProductsList().then((value){
      setState(() {
        productList=value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product Screen"),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(child: ListView.builder(
              itemCount: productList.length,
                itemBuilder: (BuildContext context,index){
              if(productList.isNotEmpty){
                return GestureDetector(
                  child: Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      boxShadow:[
                        BoxShadow(
                          blurRadius: 3,
                          spreadRadius: 3,
                          color: Colors.grey.withOpacity(0.2)
                        )
                      ]
                    ),
                    child: ListTile(
                      leading: Icon(Icons.newspaper),
                      title: Text("${productList[index].name}",
                          overflow: TextOverflow.ellipsis
                          ,style: TextStyle(fontSize:20,fontWeight: FontWeight.bold),),
                      subtitle: Text("LKR ${productList[index].price}",style: TextStyle(fontSize:15),),
                    trailing: Container(
                      width: 100,
                      child: Wrap(
                        direction: Axis.horizontal,
                        alignment: WrapAlignment.end,
                        children: [
                          IconButton(onPressed: (){
                            setState(() {
                              _selectedProduct=productList[index];
                              showProductDialogBox(context, InputType.UpdateProduct);
                            });
                          }, icon: Icon(Icons.edit),),
                          IconButton(onPressed: (){
                            setState(() {
                              _selectedProduct=productList[index];
                            });
                            ProductDBHelper.instance.deleteProduct(_selectedProduct!).then((value) {
                              ProductDBHelper.instance.getProductsList().then((value){
                                setState(() {
                                  productList=value;
                                });
                              });
                            });
                          }, icon: Icon(Icons.delete),color: Colors.red,),

                        ],
                      ),
                    ),
                    ),
                  ),
                );
              }else{
                return Container(
                  child: Center(
                    child: Text("List is empty"),
                  ),
                );
              }
            }))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        showProductDialogBox(context,InputType.AddProduct);
      },
      child: Icon(Icons.add),
        backgroundColor: Colors.blue,  ),

    );
  }

  showProductDialogBox(BuildContext context,InputType type){
    bool isUpdateProduct = false;
    isUpdateProduct=(type == InputType.UpdateProduct)? true:false;

    if(isUpdateProduct){
      _nameController.text="${_selectedProduct?.name}";
      _priceController.text="${_selectedProduct?.price}";
      _quantityController.text="${_selectedProduct?.quantity}";
    }

    Widget saveButton = ElevatedButton(onPressed: (){
      if(_nameController.text.isNotEmpty && _priceController.text.isNotEmpty && _quantityController.text.isNotEmpty){


        if(!isUpdateProduct){

          setState(() {
            Product product = Product();
            product.name = _nameController.text;
            product.price = (_priceController.text);
            product.quantity = (_quantityController.text);

            ProductDBHelper.instance.insertProduct(product).then((value) {
              ProductDBHelper.instance.getProductsList().then((value){
                this.setState(() {
                  productList=value;
                });
              });
              Navigator.pop(context);
              emptyTextFields();

            });
          });


        }else{

          _selectedProduct?.name = _nameController.text;
          _selectedProduct?.price = (_priceController.text);
          _selectedProduct?.quantity = (_quantityController.text);

          ProductDBHelper.instance.updateProduct(_selectedProduct!).then((value) {
            ProductDBHelper.instance.getProductsList().then((value){
              this.setState(() {
                productList=value;
              });
            });
            Navigator.pop(context);
            emptyTextFields();

          });
        }


      }
    }, child: Text("Save"));
    Widget cancelButton = ElevatedButton(onPressed: (){
      Navigator.of(context).pop();
    }, child: Text("Cancel"));
    AlertDialog productDetailsBox = AlertDialog(
      title: Text(!isUpdateProduct ? "Add new product": "Update product"),
      content: Container(
        child: Wrap(
          children: [
            Container(
              child: TextFormField(
                controller: _nameController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "Product Name",

                ),
              ),
            ),
            Container(
              child: TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Product Price",

                ),
              ),
            ),
            Container(
              child: TextFormField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Quantity",
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        saveButton,
        cancelButton
      ],
    );
    showDialog(context: context, builder: (BuildContext context){
      return productDetailsBox;
    });


  }
  void emptyTextFields(){
    _nameController.text='';
    _priceController.text='';
    _quantityController.text='';
  }
}
enum InputType{
  AddProduct,UpdateProduct
}
