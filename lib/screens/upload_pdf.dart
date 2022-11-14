import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduk/screens/pdf_grid_view.dart';
import 'package:eduk/screens/view_pdf.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class UploadPdfsToFirestore extends StatefulWidget {
  const UploadPdfsToFirestore({Key? key}) : super(key: key);

  @override
  State<UploadPdfsToFirestore> createState() => _UploadPdfsToFirestoreState();
}

class _UploadPdfsToFirestoreState extends State<UploadPdfsToFirestore> {
  PlatformFile? pickedFile;
  String pdfUrl = "no url";
  String? imageUrl;
  int? number;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    print(result!.files.first.path);
    // if (result == null) return;
    setState(() {
      pickedFile = result.files.first;
    });
  }

  Future<String> uploadFile() async {
    String result = " Some error Occured";
    number = Random().nextInt(10);

    final pathInFirestore = 'files/${pickedFile!.name}';
    final file = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(pathInFirestore);
    UploadTask uploadTask = ref.putFile(file);
    TaskSnapshot task = await uploadTask;
    String link = await task.ref.getDownloadURL();
    print("link 1");

    // print(temp);
    link = link.replaceAll("%20", " ");
    await FirebaseFirestore.instance.collection("file").doc().set({
      'pdfUrl': pdfUrl,
      "fileUrl": link,
      "number": "pdf#" + number.toString(),
      "fileName": pickedFile!.name
    });
    print("link 2");

    return task.ref.getDownloadURL();
  }

  Future<void> listExample() async {
    ListResult result = await firebaseStorage.ref().child('files').listAll();
    result.items.forEach((Reference ref) {
      print("Found file : $ref");
      setState(() {
        pdfUrl = ref.fullPath;
        print(pdfUrl);
      });
    });
    result.prefixes.forEach((Reference ref) {
      print("Found directory : $ref");
    });
    // Future<void> downlloadUrl() async {
    //   String downloadUrl = await firebaseStorage.ref('files/').getDownloadURL();
    //   print(downloadUrl);
    //   setState(() {
    //     pdfUrl= downloadUrl;
    //    //print(pdfUrl);
    //   });
    //   print(pdfUrl);
    //   await FirebaseFirestore.instance.collection("file").doc().set({
    //     'pdfUrl':pdfUrl,
    //     "fileUrl":downloadUrl,
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pdf Screen"),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          if (pickedFile != null) Text(pickedFile!.name),
          if (pickedFile != null)
            Expanded(
                child: Container(
              child: Image.file(
                File(pickedFile!.path!),
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            )),
          ElevatedButton(
              onPressed: () async {
                await selectFile();
              },
              child: const Text("Select File")),
          ElevatedButton(
              onPressed: () async {
                uploadFile;
                String result = await uploadFile();
                print(result);
                // await gridViewShower
              },
              child: const Text("Upload File")),
          // ElevatedButton(
          //     onPressed: () {
          //       listExample();
          //       _pdfViewerKey.currentState?.openBookmarkView();
          //     },
          //     child: const Text("Launch pdf")),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection("file").snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 200,
                                childAspectRatio: 3 / 2,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 20),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (BuildContext ctx, i) {
                          QueryDocumentSnapshot x = snapshot.data!.docs[i];
                          return Stack(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(bottom: 80),
                                child: Center(
                                  child: Icon(Icons.insert_drive_file_outlined,
                                      size: 40),
                                ),
                              ),
                              // Image.network(
                              //     'https://www.kindacode.com/wp-content/uploads/2020/10/sample.jpg',
                              //     width: double.infinity,
                              //     height: 250,
                              //     fit: BoxFit.cover
                              // ),
                              Positioned(
                                // The Positioned widget is used to position the text inside the Stack widget
                                bottom: 0,
                                right: 0,
                                left: 0,
                                child: Container(
                                  // We use this Container to create a black box that wraps the white text so that the user can read the text even when the image is white
                                  width: 300,
                                  color: Colors.black38,
                                  padding: const EdgeInsets.all(10),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ViewPdf(
                                                    pdfUrl: x['fileUrl'],
                                                  )));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 2),
                                      child: Text(
                                        x["fileName"],
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 15,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 5,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              // Container(
                              //   alignment: Alignment.center,
                              //   decoration: BoxDecoration(
                              //       color: Colors.white38,
                              //       borderRadius: BorderRadius.circular(35)),
                              //   child: InkWell(
                              //       onTap: () {
                              //         Navigator.push(
                              //             context,
                              //             MaterialPageRoute(
                              //                 builder: (context) => ViewPdf(
                              //                   pdfUrl: x['fileUrl'],
                              //                 )));
                              //       },
                              //       child: Positioned(
                              //         bottom: 10,
                              //         right: 60,
                              //         top: 40,
                              //         child: Text(
                              //           x["fileName"],
                              //           style: const TextStyle(
                              //             color: Colors.white70,
                              //             fontSize: 18,
                              //
                              //           ),
                              //         ),
                              //       )
                              //   ),
                              // ),
                            ],
                          );
                        });
                    //  ListView.builder(
                    //    itemCount: snapshot.data!.docs.length,
                    //    itemBuilder: (context,i){
                    //
                    // QueryDocumentSnapshot x = snapshot.data!.docs[i];
                    // return InkWell(
                    //   onTap: (){
                    //     Navigator.push(context,
                    //         MaterialPageRoute(
                    //             builder: (context)=>ViewPdf(
                    //               pdfUrl: x['fileUrl'],
                    //             )
                    //         )
                    //     );
                    //   },
                    //   child: Container(
                    //     margin: EdgeInsets.symmetric(vertical: 10),
                    //     child: Text(x['fileName']),
                    //                ),
                    //             );
                    //           }
                    //         );
                  }
                  return ElevatedButton(onPressed: () {}, child: Text("data"));
                }),
          )
        ],
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       icon: InkWell(
      //           onTap: () async {
      //             await selectFile();
      //           },
      //           child: Icon(Icons.select_all)),
      //       label: 'Select Pdf',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: InkWell(
      //           onTap: () async {
      //             uploadFile;
      //             String result = await uploadFile();
      //             print(result);
      //             // await gridViewShower
      //           },
      //           child: Icon(Icons.upload_file_outlined)),
      //       label: 'Upload',
      //     ),
      //   ],
      // ),
    );
  }
  // Widget buildProgress() =>
  //     StreamBuilder<TaskSnapshot>(
  //         stream: uploadTask?.snapshotEvents,
  //         builder: (context, snapshot) {
  //           if (snapshot.hasData) {
  //           final data = snapshot.data!;
  //           double progress = data.bytesTransferred / data.totalBytes ;
  //           return SizedBox(
  //             height: 10,
  //             child: Stack(
  //               fit: StackFit.expand,
  //               children: [
  //                 LinearProgressIndicator(
  //                   value: progress,
  //                   backgroundColor: Colors.grey,
  //                   color: Colors.greenAccent,
  //                 ),
  //                 Center(
  //                   child: Text(
  //                     '${ ( 100 * progress ).roundToDouble() } %',
  //                     style: const TextStyle(color: Colors.white),
  //                   ),
  //                 )
  //               ],
  //             ),
  //           );
  //           } else
  //             return const SizedBox(height: 50,);
  //         });
}
