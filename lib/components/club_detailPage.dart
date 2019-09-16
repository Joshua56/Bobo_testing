
import 'dart:io';

import 'package:bobo_ui/components/add_reservation_ui.dart';
import 'package:bobo_ui/modals/club_modal.dart';
import 'package:bobo_ui/modules/club_module.dart';
import 'package:bobo_ui/modules/reservation_module.dart';
import 'package:bobo_ui/modules/user_module.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClubDetailPage extends StatelessWidget {
  final String clubId;

  ClubDetailPage({
    this.clubId
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (context) => ClubModule()),
        ChangeNotifierProvider(builder: (context) => UserModule()),
        ChangeNotifierProvider(builder: (context) => ReservationModule()),
      ],  
      child: Scaffold(
        body: SingleChildScrollView(
                  child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              // club Name and Image
              clubLabel(context),
              ClubDetailBody(clubId:clubId),
            ],
          ),
        ),
      ),
    );
  }

  Widget clubLabel(BuildContext context) {
    return Consumer<ClubModule>(
      builder: (context, clubModule, _){
      ClubModal _club = clubModule.getClub(clubId);
      return Container(
        height: MediaQuery.of(context).size.height*.3,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          // fit: StackFit.expand,
          children: <Widget>[
            // Club image
            Container(width: double.infinity, child: Image.network(_club.image != null ? _club.image : '', fit: BoxFit.cover,)),

            // Club name
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(30))
                ),
                child: Text(
                  _club.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25
                  ),
                ),
              ),
            ),
          ],
        ),
      );
      }
    );
  }
}

class ClubDetailBody extends StatefulWidget {

  final String clubId;

  ClubDetailBody({
    this.clubId
  });


  @override
  _ClubDetailBodyState createState() => _ClubDetailBodyState();
}

class _ClubDetailBodyState extends State<ClubDetailBody> with SingleTickerProviderStateMixin {
  

  TabController _tabController;

  TextStyle tabTitleStyle(){
    return TextStyle(
      color: Colors.black
    );
  }

    @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height*.7,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          TabBar(
            controller: _tabController,
            tabs: <Widget>[
              Tab(child: Text("Reservation", style: tabTitleStyle(),),),
              Tab(child: Text("Info", style: tabTitleStyle(),),),
              Tab(child: Text("Gallery", style: tabTitleStyle(),),),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                // Add Reservation Tab
                AddReservationUI(clubId: widget.clubId),

                // Info Tab
                Container(child: Center(child: Text("info"),),),

                // Gallery
                ClubGallery(widget.clubId),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ClubGallery extends StatelessWidget {
  final String clubId;
  ClubGallery(this.clubId);

  List<String> _gallery;


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => ClubModule(),
      child: Consumer<ClubModule>(
        builder: (context, clubModule, _){
          ClubModal _club = clubModule.getClub(clubId);
          _club.gallery == null ? _gallery = <String>[] : _gallery = _club.gallery;
            
          return GridView.builder(
            gridDelegate:
            new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            itemCount: _gallery.length,
            itemBuilder: (BuildContext context, int index){
              return SizedBox(
                  height: 140,
                  width: 140,
                  child: Card(
                    child: _gallery[index] == null ? Container() : Image.network(_gallery[index],  fit: BoxFit.cover,),
                        
                    
                  ),
                );
            },
          );
       }
      ),
    );
  }
}
