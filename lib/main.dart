import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

void main() => runApp(PruebaTecnicaApp());


class PruebaTecnicaApp extends StatelessWidget{

  @override

  Widget build(BuildContext context){
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.red),
          home:FirstScreen(),
    );
  }
}



class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prueba Técnica'),
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
        children:<Widget>[
          Align(
            child: ElevatedButton(
              child: Text('Lista de elementos'),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SecondScreen()
                ));
              },),
          ),
          Align(
            child:ElevatedButton(
              child: Text('Google Maps'),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MapSample()
                ));
              },),
          ),
          Align(
            child:ElevatedButton(
              child: Text('Imágenes'),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => FourthScreen()
                ));
              },),
          ),

        ])
      ),);
  }
}

class SecondScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:AppBar(
            backgroundColor: Colors.purple,
        title:Text('Lista de elementos'),
    ),
    body:ListView(
      children: [
        ListTile(title:Text('Primer elemento')),
        ListTile(title:Text('Segundo elemento')),
        ListTile(title:Text('Tercer elemento')),
        Align(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Colors.purple),
            child:Text('Volver'),
            onPressed: () {
              Navigator.pop(context);


            },),
        ),


      ],
    ),
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(39.477593979107105, -0.3236434166054559),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(39.477593979107105, -0.3236434166054559),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
      title: Text('Google Maps'),),
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: Text('¡A la playa!'),
        icon: Icon(Icons.beach_access),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}

class FourthScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          appBar:AppBar(
            backgroundColor: Colors.orange,
            automaticallyImplyLeading: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => FirstScreen(),
                      ),);
              },
            ),
            title:Text('Ventana de imágenes'),
          ),
          body: Gallery(),

        ),
        );
  }
}

class Gallery extends StatefulWidget{
  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery>{

  late List <String> ids;



  @override
  void initState() {
    
    ids = [];

    _loadImageIds();

    super.initState();
  }
  void _loadImageIds() async {
    final response = await http.get('https://picsum.photos/v2/list');
    final json = jsonDecode(response.body);
    List <String> _ids = [];
    for (var image in json){
    _ids.add(image['id']);
    }
    setState(() {
      ids = _ids;
    });
  }
  @override
  Widget build(BuildContext context) {
    return GridView.builder(

      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemBuilder: (context, index) => GestureDetector(
        onTap:(){
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ImagePage(ids[index]),
          ),
          );
        },
        child: Image.network(
          'https://picsum.photos/id/${ids[index]}/300/300'),
      ),
      itemCount: ids.length,

    );
  }
}
class ImagePage extends StatelessWidget{
  final String id;
  ImagePage(this.id);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Text('Imagen'),
      ),
      backgroundColor: Colors.black,
    body: Center(
      child: Image.network('https://picsum.photos/id/${id}/600/600'),
    ),
    );
  }
}



