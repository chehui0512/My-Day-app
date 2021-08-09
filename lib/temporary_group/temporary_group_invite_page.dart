import 'dart:convert';

import 'package:My_Day_app/models/get_temporary_group_invitet_model.dart';
import 'package:My_Day_app/schedule/create_schedule.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TemporaryGroupInvitePage extends StatefulWidget {
  int groupNum;
  TemporaryGroupInvitePage(this.groupNum);

  @override
  TemporaryGroupInviteWidget createState() =>
      new TemporaryGroupInviteWidget(groupNum);
}

class TemporaryGroupInviteWidget extends State<TemporaryGroupInvitePage> {
  int groupNum;
  TemporaryGroupInviteWidget(this.groupNum);

  String uid = 'lili123';
  String _startTime = "";
  String _endTime = "";

  GetTemporaryGroupInvitetModel _getTemporaryGroupInviteModel = null;

  List _memberList = [];
  List _inviteMemberList = [];

  @override
  void initState() {
    super.initState();
    _getTemporaryGroupInviteRequest();
  }

  String _dateFormat(dateTime) {
    String dateString =
        '${dateTime.month.toString().padLeft(2, '0')} 月 ${dateTime.day.toString().padLeft(2, '0')} 日 ${weekdayName[dateTime.weekday - 1]} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    return dateString;
  }

  Future _getTemporaryGroupInviteRequest() async {
    var jsonString = await rootBundle
        .loadString('assets/json/get_temporary_group_invite.json');

    // var httpClient = HttpClient();
    // var request = await httpClient.getUrl(
    //     Uri.http('myday.sytes.net', '/group/group_list/', {'uid': uid}));
    // var response = await request.close();
    // var jsonString = await response.transform(utf8.decoder).join();
    // httpClient.close();

    var jsonMap = json.decode(jsonString);

    var getTemporaryGroupInviteModel =
        GetTemporaryGroupInvitetModel.fromJson(jsonMap);
    setState(() {
      _memberList = new List();
      _inviteMemberList = new List();

      _getTemporaryGroupInviteModel = getTemporaryGroupInviteModel;
      _startTime = _dateFormat(_getTemporaryGroupInviteModel.startTime);
      _endTime = _dateFormat(_getTemporaryGroupInviteModel.endTime);

      for (int i = 0; i < _getTemporaryGroupInviteModel.member.length; i++) {
        if (_getTemporaryGroupInviteModel.member[i].statusId == 2) {
          _inviteMemberList.add(_getTemporaryGroupInviteModel.member[i]);
        }
        if (_getTemporaryGroupInviteModel.member[i].statusId == 1 &&
            _getTemporaryGroupInviteModel.member[i].memberName !=
                _getTemporaryGroupInviteModel.founderName) {
          _memberList.add(_getTemporaryGroupInviteModel.member[i]);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    if (_getTemporaryGroupInviteModel != null) {
      return Scaffold(
          appBar: AppBar(
              backgroundColor: Theme.of(context).primaryColor,
              leading: Container(
                margin: EdgeInsets.only(left: screenSize.height * 0.02),
                child: GestureDetector(
                  child: Icon(Icons.chevron_left),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              title: Text(_getTemporaryGroupInviteModel.title,
                  style: TextStyle(fontSize: screenSize.width * 0.052))),
          body: Container(color: Colors.white, child: _build(context)));
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

  Widget _build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return ListView(
      children: [
        SizedBox(
          height: screenSize.height * 0.02,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("開始", style: TextStyle(fontSize: screenSize.height * 0.025)),
            Text(_startTime,
                style: TextStyle(fontSize: screenSize.height * 0.025)),
          ],
        ),
        SizedBox(
          height: screenSize.height * 0.015,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("結束", style: TextStyle(fontSize: screenSize.height * 0.025)),
            Text(_endTime,
                style: TextStyle(fontSize: screenSize.height * 0.025)),
          ],
        ),
        SizedBox(
          height: screenSize.height * 0.02,
        ),
        Divider(),
        _buildList(context)
      ],
    );
  }

  Image getImage(String imageString) {
    var screenSize = MediaQuery.of(context).size;
    bool isGetImage;
    Image friendImage = Image.asset(
      'assets/images/friend_choose.png',
      width: screenSize.height * 0.04683,
    );
    const Base64Codec base64 = Base64Codec();
    Image image = Image.memory(base64.decode(imageString),
        width: screenSize.height * 0.04683,
        height: screenSize.height * 0.04683,
        fit: BoxFit.fill);
    var resolve = image.image.resolve(ImageConfiguration.empty);
    resolve.addListener(ImageStreamListener((_, __) {
      isGetImage = true;
    }, onError: (Object exception, StackTrace stackTrace) {
      isGetImage = false;
      print('error');
    }));

    if (isGetImage == null) {
      return image;
    } else {
      return friendImage;
    }
  }

  Widget _buildList(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        if (_inviteMemberList.length != 0) _buildInviteMemberList(context),
        _buildMemberList(context)
      ],
    );
  }

  Widget _buildInviteMemberList(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        Container(
          margin: EdgeInsets.only(
              left: screenSize.height * 0.03,
              bottom: screenSize.height * 0.02,
              top: screenSize.height * 0.02),
          child: Text('邀請中',
              style: TextStyle(
                  fontSize: screenSize.width * 0.041,
                  color: Color(0xff7AAAD8))),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _inviteMemberList.length,
          itemBuilder: (BuildContext context, int index) {
            var members = _inviteMemberList[index];
            return ListTile(
              contentPadding: EdgeInsets.symmetric(
                  horizontal: screenSize.width * 0.055, vertical: 0.0),
              leading: ClipOval(
                child: getImage(members.memberPhoto),
              ),
              title: Text(
                members.memberName,
                style: TextStyle(fontSize: screenSize.width * 0.041),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return Divider();
          },
        )
      ],
    );
  }

  Widget _buildMemberList(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        Container(
          margin: EdgeInsets.only(
              left: screenSize.height * 0.03,
              bottom: screenSize.height * 0.02,
              top: screenSize.height * 0.02),
          child: Text('成員',
              style: TextStyle(
                  fontSize: screenSize.width * 0.041,
                  color: Color(0xff7AAAD8))),
        ),
        ListTile(
          contentPadding: EdgeInsets.symmetric(
              horizontal: screenSize.width * 0.055, vertical: 0.0),
          leading: ClipOval(
            child: getImage(_getTemporaryGroupInviteModel.founderPhoto),
          ),
          title: Text(
            _getTemporaryGroupInviteModel.founderName,
            style: TextStyle(fontSize: screenSize.width * 0.041),
          ),
          trailing: Text("建立者", style: TextStyle(fontSize: screenSize.width * 0.041)),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _memberList.length,
          itemBuilder: (BuildContext context, int index) {
            var members = _memberList[index];
            return ListTile(
              contentPadding: EdgeInsets.symmetric(
                  horizontal: screenSize.width * 0.055, vertical: 0.0),
              leading: ClipOval(
                child: getImage(members.memberPhoto),
              ),
              title: Text(
                members.memberName,
                style: TextStyle(fontSize: screenSize.width * 0.041),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return Divider();
          },
        )
      ],
    );
  }
}
