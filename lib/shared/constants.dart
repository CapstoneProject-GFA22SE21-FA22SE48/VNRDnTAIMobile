import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const double kDefaultPaddingValue = 16;
const kDefaultPadding = EdgeInsets.all(16);
const quizTime = 60;

final ButtonStyle style = ElevatedButton.styleFrom(
    textStyle: const TextStyle(fontSize: 20),
    backgroundColor: Colors.white,
    shadowColor: Colors.grey,
    alignment: Alignment.center,
    minimumSize: Size(200, 100),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)));

enum TEST_TYPE { STUDY, TEST }

enum TABS { SEARCH, MOCK_TEST, ANALYSIS, MINIMAP }

const TIME_OUT = 60;

const userId = "7df14016-d391-4a5b-9151-dc810e98c9aa";

const url = "https://10.0.2.2:5001/api/";


// {
//         "id": "7df14016-d391-4a5b-9151-dc810e98c9aa",
//         "username": "user0",
//         "password": "123456789",
//         "role": 2,
//         "status": 5,
//         "createdDate": "2020-10-01T00:00:00",
//         "isDeleted": false,
//         "comments": [],
//         "paragraphModificationRequestAdmins": [],
//         "paragraphModificationRequestScribes": [],
//         "testResults": [],
//         "userModificationRequestArbitratingAdmins": [],
//         "userModificationRequestModifiedUsers": [],
//         "userModificationRequestModifyingUsers": [],
//         "userModificationRequestPromotingAdmins": []
//     }
