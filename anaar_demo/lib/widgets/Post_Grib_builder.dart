import 'dart:math';
import 'package:anaar_demo/model/postcard_model.dart';
import 'package:anaar_demo/model/reseller_model.dart';
import 'package:anaar_demo/providers/postProvider.dart';
import 'package:anaar_demo/providers/userProvider.dart';
import 'package:anaar_demo/screens/TrendingPage.dart';
import 'package:anaar_demo/screens/reseller/ViewPost.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class Post_Grid extends StatefulWidget {
  String? userid;
  UserProvider? userProvider;
  Reseller? userprofile;

  Post_Grid({this.userid, this.userProvider,this.userprofile});

  @override
  State<Post_Grid> createState() => _Post_GridState();
}

class _Post_GridState extends State<Post_Grid> {
  @override
  void initState() {
    // TODO: implement initState
     WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PostcardProvider>(context, listen: false)
          .getPostByuserId(widget.userid);
    });
      
  }

  // final List<String> imageUrls;
  @override
  Widget build(BuildContext context) {
    // TODO: i 
    //mplement build
    return FutureBuilder<List<Postcard>>(
        future: Provider.of<PostcardProvider>(context, listen: false)
            .getPostByuserId(widget.userid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              
              child: Text("Failed to get posts"),
            );
          
          } 
          else if(snapshot.data!.isEmpty){
              return const Center(child: Text('No post found '),);
          }
          
          else {
            final postcardlist = snapshot.data!;
            final imageUrls = postcardlist
                .map((post) =>
                    post.images?.isNotEmpty == true ? post.images![0] : '')
                .toList();
            return GridView.builder(
              itemCount: postcardlist.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: (){Get.to(()=>Viewpost(
                  userprofile:widget.userprofile ,
                 userProvider: widget.userProvider,
                  postcard: postcardlist[index]));},
                child: Container(
                  height: 20,
                  width: 20,
                  
               //  color: Colors.amber,
                  child: Expanded(
                    child: Stack(children: [
                      Expanded(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          color: Colors.red,
                          child: Image(
                            image: NetworkImage(imageUrls[index] ?? ''),
                            fit: BoxFit.cover,
                          ),
                          //color: Colors.blue,
                        ),
                      ),
                        const Positioned(
                          bottom: 5,
                           right: 5,
                          child: Icon(Icons.photo,color: Color.fromARGB(255, 207, 207, 207),))
                    
                                    
                                    
                    ]),
                  ),
                ),
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 1,
              ),
            );
          }
        });
  }
}
