import 'dart:convert';

import 'package:chat_enc/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import'package:cloud_firestore/cloud_firestore.dart';

import '../Encryption/aes.dart';

final _firestore = FirebaseFirestore.instance;
late User signedInUser;

class ChatScreen extends StatefulWidget {
  static const String screenRoute = 'chat_screen';

  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String? messageText;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    messagesStream();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        signedInUser = user;
        print(signedInUser.displayName);
      }
    } catch (e) {
      print(e);
    }
  }

  void messagesStream() async {
    await for(var snapchat in _firestore.collection("messages").snapshots()){
      for(var message in snapchat.docs){

      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFECE5DD),
      appBar: AppBar(
        backgroundColor: Color(0xFF272F3A),
        title: //Center(child: Text('code  line')),
        Row(
          children: [
            //Image.asset('images/logo.png', height: 25),
            SizedBox(width: 10),
            Text('Code Line',
              style: TextStyle(
             // fontSize: 40,
              fontFamily: 'ElMessiri',
              fontWeight: FontWeight.w500,
              //color: Color(0xff2e386b),
            ),)
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              _auth.signOut();
            //  Navigator.pop(context);
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                 HomeScreen()), (Route<dynamic> route) => false);

            },
            icon: Icon(Icons.adjust_outlined),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MessageStreamBuilder(),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Color(0xFF272F3A),
                    width: 2,
                  ),
                ),
              ),
              child:
              Row(
                children: [
                  SizedBox(width: 10),
                  //send message button
                  MaterialButton(
                    onPressed: () {
                      String messageText2 = Aes.encAes(messageText!);
                      messageTextController.clear();
                      _firestore.collection("messages").add({
                        'text' : messageText2,
                        'sender' : signedInUser.email,
                        'username' : signedInUser.displayName,
                        'key32' : Aes.getkey32(),
                        'iv16' : Aes.getiv16(),
                        'time' : FieldValue.serverTimestamp(),
                      });

                    },
                    minWidth: 0,
                    padding:
                    const EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
                    shape: const CircleBorder(),
                    color: Color(0xFF1d2733),
                    child: const Icon(Icons.send, color: Colors.white, size: 28),
                  ),
                  //input field & buttons
                  Expanded(
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        children: [



                          Expanded(
                              child: TextField(
                                controller: messageTextController,
                                onChanged: (value) async {
                                  messageText = value;

                                  print(messageText);
                                },
                                textAlign: TextAlign.right,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                //onTap: () {
                                //},
                                decoration: const InputDecoration(
                                    hintText: '... Messaging ',
                                    hintStyle: TextStyle(color: Color(0xFF272F3A),fontFamily: 'ElMessiri',),
                                    border: InputBorder.none),
                              )),
                          SizedBox(width: 10),
                          //adding some space
                          //SizedBox(width: mq.width * .02),
                        ],
                      ),
                    ),
                  ),


                  SizedBox(width: 10),

                ],
              ),

            ),
          ],
        ),
      ),
    );
  }
}

class MessageStreamBuilder extends StatelessWidget {
  const MessageStreamBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return  StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection("messages").orderBy('time').snapshots(),
      builder: (conrext ,snapchot){
        List<MessageLine> messageWidgets =[];
        if(!snapchot.hasData){
          return Center(
            child: CircularProgressIndicator(backgroundColor: Color(0xFF272F3A),),
          );
        }

        final messages = snapchot.data!.docs.reversed;
        for(var message in messages){
          //final messageText = Aes.decryptWithAESKey(message.get('text'));
          final messageText = message.get('text');

          Aes.setkey32(message.get('key32'));
          Aes.setiv16(message.get('iv16'));

          String messageText3 = Aes.denAes(messageText!);

          //String textdec = Aes.decryptWithAESKey(messageText);

          var messageSender = message.get('sender');

          //final currentUser = signedInUser.displayName;
          final currentUser = signedInUser.email;

          if(currentUser == messageSender){
            messageSender = "Me";

          }else{
            messageSender = message.get('username');
          }

          final messageWidget = MessageLine(
            sender: messageSender,
            text: messageText3,
            isMe:messageSender == "Me",);
          // isMe:currentUser == messageSender,);

          messageWidgets.add(messageWidget);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
            children: messageWidgets,
          ),
        );
      },
    );
  }
}


class MessageLine extends StatelessWidget {
  MessageLine({this.sender,this.text,required this.isMe, super.key});

  final String? sender ;
  final String? text ;
  final bool isMe;


  @override
  Widget build(BuildContext context) {


    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe ?  CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text("$sender",style: TextStyle(fontSize: 12,fontFamily: 'ElMessiri',color: Color(0xFF272F3A),)),
          Material(
            elevation: 5,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            color: isMe ?  Color(0xFF949596) : Color(0xFF272F3A),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10 , horizontal: 20),
              child: Text("$text ",
                //style: TextStyle(fontSize: 15, color :  Colors.white  ) ,
                style: TextStyle(
                  // fontSize: 40,
                  fontFamily: 'ElMessiri',
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
