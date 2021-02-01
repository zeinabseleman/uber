import 'dart:convert';

import 'package:http/http.dart' as http;

class RequestApi{

  static Future<dynamic> getRequest(String url) async{
    http.Response response = await http.get(url);
    try{
      if(response.statusCode ==200){
        String jsonData = response.body;
        var parsedJson = json.decode(jsonData);
        return parsedJson;
      }else{
        return 'faild';
      }
    }
   catch(exp){
    return 'faild';
   }

  }
}