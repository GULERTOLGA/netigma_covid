import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File>  localFile(String name) async {
  final path = await _localPath;
  return File('$path/$name.json');
}

Future<String> readContent(String path) async {
  try {
    final file = await localFile(path);
    // Read the file.
    String contents = await file.readAsString();

    return contents;
  } catch (e) {
    // If encountering an error, return 0.
    return null;
  }
}

Future<List<String>> getFavorites() async
{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return  prefs.getStringList("favorites");
}

Future<void> removeCountry(String country) async
{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>  list = await getFavorites();
  list.remove(country);
  prefs.setStringList("favorites", list);

}

showToast(String message){
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0
  );
}

Future<List<String>> addFavorites(String country) async
{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var list =  prefs.getStringList("favorites");
  if(list == null)
    list = new List<String>();
    if(list.indexOf(country) == -1)
      list.add(country);
    await prefs.setStringList("favorites", list);
    showToast("The country you selected has been added to your favorites list.");
}

Future<File> writeFile(String path, String content) async {
  final file = await localFile(path);

  // Write the file.
  return file.writeAsString(content);
}

var flags = <String,Image>{
  "Afghanistan":Image.asset('assets/flags/af.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Åland Islands":Image.asset('assets/flags/ax.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Albania":Image.asset('assets/flags/al.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Algeria":Image.asset('assets/flags/dz.png', fit: BoxFit.contain, width: 40, height: 40,),
  "American Samoa":Image.asset('assets/flags/as.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Andorra":Image.asset('assets/flags/ad.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Angola":Image.asset('assets/flags/ao.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Anguilla":Image.asset('assets/flags/ai.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Antarctica":Image.asset('assets/flags/aq.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Antigua and Barbuda":Image.asset('assets/flags/ag.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Argentina":Image.asset('assets/flags/ar.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Armenia":Image.asset('assets/flags/am.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Aruba (Netherlands)":Image.asset('assets/flags/aw.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Australia":Image.asset('assets/flags/au.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Austria":Image.asset('assets/flags/at.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Azerbaijan":Image.asset('assets/flags/az.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Bahamas":Image.asset('assets/flags/bs.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Bahrain":Image.asset('assets/flags/bh.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Bangladesh":Image.asset('assets/flags/bd.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Barbados":Image.asset('assets/flags/bb.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Belarus":Image.asset('assets/flags/by.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Belgium":Image.asset('assets/flags/be.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Belize":Image.asset('assets/flags/bz.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Benin":Image.asset('assets/flags/bj.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Bermuda (UK)":Image.asset('assets/flags/bm.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Bhutan":Image.asset('assets/flags/bt.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Bolivia":Image.asset('assets/flags/bo.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Bonaire":Image.asset('assets/flags/bq.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Bosnia and Herzegovina":Image.asset('assets/flags/ba.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Botswana":Image.asset('assets/flags/bw.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Bouvet Island":Image.asset('assets/flags/bv.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Brazil":Image.asset('assets/flags/br.png', fit: BoxFit.contain, width: 40, height: 40,),
  "British Indian Ocean Territory":Image.asset('assets/flags/io.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Brunei":Image.asset('assets/flags/bn.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Bulgaria":Image.asset('assets/flags/bg.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Burkina Faso":Image.asset('assets/flags/bf.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Burundi":Image.asset('assets/flags/bi.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Cabo Verde":Image.asset('assets/flags/cv.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Cambodia":Image.asset('assets/flags/kh.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Cameroon":Image.asset('assets/flags/cm.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Canada":Image.asset('assets/flags/ca.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Cayman Islands (UK)":Image.asset('assets/flags/ky.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Central African Republic":Image.asset('assets/flags/cf.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Chad":Image.asset('assets/flags/td.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Chile":Image.asset('assets/flags/cl.png', fit: BoxFit.contain, width: 40, height: 40,),
  "China":Image.asset('assets/flags/cn.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Christmas Island":Image.asset('assets/flags/cx.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Cocos (Keeling) Islands":Image.asset('assets/flags/cc.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Colombia":Image.asset('assets/flags/co.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Comoros":Image.asset('assets/flags/km.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Congo":Image.asset('assets/flags/cg.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Democratic Republic of the Congo":Image.asset('assets/flags/cd.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Cook Islands":Image.asset('assets/flags/ck.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Costa Rica":Image.asset('assets/flags/cr.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Côte d'Ivoire":Image.asset('assets/flags/ci.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Croatia":Image.asset('assets/flags/hr.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Cuba":Image.asset('assets/flags/cu.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Curacao (Netherlands)":Image.asset('assets/flags/cw.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Cyprus":Image.asset('assets/flags/cy.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Czech Republic":Image.asset('assets/flags/cz.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Denmark":Image.asset('assets/flags/dk.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Djibouti":Image.asset('assets/flags/dj.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Dominica":Image.asset('assets/flags/dm.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Dominican Republic":Image.asset('assets/flags/do.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Ecuador":Image.asset('assets/flags/ec.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Egypt":Image.asset('assets/flags/eg.png', fit: BoxFit.contain, width: 40, height: 40,),
  "El Salvador":Image.asset('assets/flags/sv.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Equatorial Guinea":Image.asset('assets/flags/gq.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Eritrea":Image.asset('assets/flags/er.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Estonia":Image.asset('assets/flags/ee.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Swaziland":Image.asset('assets/flags/sz.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Ethiopia":Image.asset('assets/flags/et.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Falkland Islands":Image.asset('assets/flags/fk.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Faroe Islands (Denmark)":Image.asset('assets/flags/fo.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Fiji":Image.asset('assets/flags/fj.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Finland":Image.asset('assets/flags/fi.png', fit: BoxFit.contain, width: 40, height: 40,),
  "France":Image.asset('assets/flags/fr.png', fit: BoxFit.contain, width: 40, height: 40,),
  "French Guiana (France)":Image.asset('assets/flags/gf.png', fit: BoxFit.contain, width: 40, height: 40,),
  "French Polynesia (France)":Image.asset('assets/flags/pf.png', fit: BoxFit.contain, width: 40, height: 40,),
  "French Southern Territories":Image.asset('assets/flags/tf.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Gabon":Image.asset('assets/flags/ga.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Gambia":Image.asset('assets/flags/gm.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Georgia":Image.asset('assets/flags/ge.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Germany":Image.asset('assets/flags/de.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Ghana":Image.asset('assets/flags/gh.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Gibraltar (UK)":Image.asset('assets/flags/gi.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Greece":Image.asset('assets/flags/gr.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Greenland (Denmark)":Image.asset('assets/flags/gl.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Grenada":Image.asset('assets/flags/gd.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Guadeloupe (France)":Image.asset('assets/flags/gp.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Guam (US)":Image.asset('assets/flags/gu.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Guatemala":Image.asset('assets/flags/gt.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Guernsey (UK)":Image.asset('assets/flags/gg.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Guinea":Image.asset('assets/flags/gn.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Guinea-Bissau":Image.asset('assets/flags/gw.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Guyana":Image.asset('assets/flags/gy.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Haiti":Image.asset('assets/flags/ht.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Heard Island and McDonald Islands":Image.asset('assets/flags/hm.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Holy See":Image.asset('assets/flags/va.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Honduras":Image.asset('assets/flags/hn.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Hong Kong":Image.asset('assets/flags/hk.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Hungary":Image.asset('assets/flags/hu.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Iceland":Image.asset('assets/flags/is.png', fit: BoxFit.contain, width: 40, height: 40,),
  "India":Image.asset('assets/flags/in.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Indonesia":Image.asset('assets/flags/id.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Iran":Image.asset('assets/flags/ir.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Iraq":Image.asset('assets/flags/iq.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Ireland":Image.asset('assets/flags/ie.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Isle of Man":Image.asset('assets/flags/im.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Israel":Image.asset('assets/flags/il.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Italy":Image.asset('assets/flags/it.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Jamaica":Image.asset('assets/flags/jm.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Japan":Image.asset('assets/flags/jp.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Jersey":Image.asset('assets/flags/je.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Jordan":Image.asset('assets/flags/jo.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Kazakhstan":Image.asset('assets/flags/kz.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Kenya":Image.asset('assets/flags/ke.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Kiribati":Image.asset('assets/flags/ki.png', fit: BoxFit.contain, width: 40, height: 40,),
  "South Korea":Image.asset('assets/flags/kr.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Korea":Image.asset('assets/flags/kp.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Kuwait":Image.asset('assets/flags/kw.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Kyrgyzstan":Image.asset('assets/flags/kg.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Lao People's Democratic Republic":Image.asset('assets/flags/la.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Latvia":Image.asset('assets/flags/lv.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Lebanon":Image.asset('assets/flags/lb.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Lesotho":Image.asset('assets/flags/ls.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Liberia":Image.asset('assets/flags/lr.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Libya":Image.asset('assets/flags/ly.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Liechtenstein":Image.asset('assets/flags/li.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Lithuania":Image.asset('assets/flags/lt.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Luxembourg":Image.asset('assets/flags/lu.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Macao":Image.asset('assets/flags/mo.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Madagascar":Image.asset('assets/flags/mg.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Malawi":Image.asset('assets/flags/mw.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Malaysia":Image.asset('assets/flags/my.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Maldives":Image.asset('assets/flags/mv.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Mali":Image.asset('assets/flags/ml.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Malta":Image.asset('assets/flags/mt.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Marshall Islands":Image.asset('assets/flags/mh.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Martinique (France)":Image.asset('assets/flags/mq.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Mauritania":Image.asset('assets/flags/mr.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Mauritius":Image.asset('assets/flags/mu.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Mayotte (France)":Image.asset('assets/flags/yt.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Mexico":Image.asset('assets/flags/mx.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Micronesia":Image.asset('assets/flags/fm.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Moldova":Image.asset('assets/flags/md.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Monaco":Image.asset('assets/flags/mc.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Mongolia":Image.asset('assets/flags/mn.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Montenegro":Image.asset('assets/flags/me.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Montserrat (UK)":Image.asset('assets/flags/ms.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Morocco":Image.asset('assets/flags/ma.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Mozambique":Image.asset('assets/flags/mz.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Myanmar":Image.asset('assets/flags/mm.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Namibia":Image.asset('assets/flags/na.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Nauru":Image.asset('assets/flags/nr.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Nepal":Image.asset('assets/flags/np.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Netherlands":Image.asset('assets/flags/nl.png', fit: BoxFit.contain, width: 40, height: 40,),
  "New Caledonia (France)":Image.asset('assets/flags/nc.png', fit: BoxFit.contain, width: 40, height: 40,),
  "New Zealand":Image.asset('assets/flags/nz.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Nicaragua":Image.asset('assets/flags/ni.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Niger":Image.asset('assets/flags/ne.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Nigeria":Image.asset('assets/flags/ng.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Niue":Image.asset('assets/flags/nu.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Norfolk Island":Image.asset('assets/flags/nf.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Macedonia":Image.asset('assets/flags/mk.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Northern Mariana Islands":Image.asset('assets/flags/mp.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Norway":Image.asset('assets/flags/no.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Oman":Image.asset('assets/flags/om.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Pakistan":Image.asset('assets/flags/pk.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Palau":Image.asset('assets/flags/pw.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Palestine":Image.asset('assets/flags/ps.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Panama":Image.asset('assets/flags/pa.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Papua New Guinea":Image.asset('assets/flags/pg.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Paraguay":Image.asset('assets/flags/py.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Peru":Image.asset('assets/flags/pe.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Philippines":Image.asset('assets/flags/ph.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Pitcairn":Image.asset('assets/flags/pn.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Poland":Image.asset('assets/flags/pl.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Portugal":Image.asset('assets/flags/pt.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Puerto Rico (US)":Image.asset('assets/flags/pr.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Qatar":Image.asset('assets/flags/qa.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Reunion (France)":Image.asset('assets/flags/re.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Romania":Image.asset('assets/flags/ro.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Russia":Image.asset('assets/flags/ru.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Rwanda":Image.asset('assets/flags/rw.png', fit: BoxFit.contain, width: 40, height: 40,),
  "St. h":Image.asset('assets/flags/bl.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Saint Helena, Ascension and Tristan da Cunha":Image.asset('assets/flags/sh.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Saint Kitts and Nevis":Image.asset('assets/flags/kn.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Saint Lucia":Image.asset('assets/flags/lc.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Saint Martin":Image.asset('assets/flags/mf.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Saint Pierre and Miquelon":Image.asset('assets/flags/pm.png', fit: BoxFit.contain, width: 40, height: 40,),
  "St. Vincent and the Grenadines":Image.asset('assets/flags/vc.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Samoa":Image.asset('assets/flags/ws.png', fit: BoxFit.contain, width: 40, height: 40,),
  "San Marino":Image.asset('assets/flags/sm.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Sao Tome and Principe":Image.asset('assets/flags/st.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Saudi Arabia":Image.asset('assets/flags/sa.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Senegal":Image.asset('assets/flags/sn.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Serbia":Image.asset('assets/flags/rs.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Seychelles":Image.asset('assets/flags/sc.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Sierra Leone":Image.asset('assets/flags/sl.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Singapore":Image.asset('assets/flags/sg.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Sint Maarten (Dutch part)":Image.asset('assets/flags/sx.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Slovakia":Image.asset('assets/flags/sk.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Slovenia":Image.asset('assets/flags/si.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Solomon Islands":Image.asset('assets/flags/sb.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Somalia":Image.asset('assets/flags/so.png', fit: BoxFit.contain, width: 40, height: 40,),
  "South Africa":Image.asset('assets/flags/za.png', fit: BoxFit.contain, width: 40, height: 40,),
  "South Georgia and the South Sandwich Islands":Image.asset('assets/flags/gs.png', fit: BoxFit.contain, width: 40, height: 40,),
  "South Sudan":Image.asset('assets/flags/ss.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Spain":Image.asset('assets/flags/es.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Sri Lanka":Image.asset('assets/flags/lk.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Sudan":Image.asset('assets/flags/sd.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Suriname":Image.asset('assets/flags/sr.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Svalbard and Jan Mayen":Image.asset('assets/flags/sj.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Sweden":Image.asset('assets/flags/se.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Switzerland":Image.asset('assets/flags/ch.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Syrian Arab Republic":Image.asset('assets/flags/sy.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Taiwan":Image.asset('assets/flags/tw.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Tajikistan":Image.asset('assets/flags/tj.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Tanzania":Image.asset('assets/flags/tz.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Thailand":Image.asset('assets/flags/th.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Timor-Leste":Image.asset('assets/flags/tl.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Togo":Image.asset('assets/flags/tg.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Tokelau":Image.asset('assets/flags/tk.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Tonga":Image.asset('assets/flags/to.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Trinidad and Tobago":Image.asset('assets/flags/tt.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Tunisia":Image.asset('assets/flags/tn.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Turkey":Image.asset('assets/flags/tr.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Turkmenistan":Image.asset('assets/flags/tm.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Turks and Caicos Islands":Image.asset('assets/flags/tc.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Tuvalu":Image.asset('assets/flags/tv.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Uganda":Image.asset('assets/flags/ug.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Ukraine":Image.asset('assets/flags/ua.png', fit: BoxFit.contain, width: 40, height: 40,),
  "United Arab Emirates":Image.asset('assets/flags/ae.png', fit: BoxFit.contain, width: 40, height: 40,),
  "United Kingdom":Image.asset('assets/flags/gb.png', fit: BoxFit.contain, width: 40, height: 40,),
  "United States Minor Outlying Islands":Image.asset('assets/flags/um.png', fit: BoxFit.contain, width: 40, height: 40,),
  "United States":Image.asset('assets/flags/us.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Uruguay":Image.asset('assets/flags/uy.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Uzbekistan":Image.asset('assets/flags/uz.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Vanuatu":Image.asset('assets/flags/vu.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Venezuela":Image.asset('assets/flags/ve.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Vietnam":Image.asset('assets/flags/vn.png', fit: BoxFit.contain, width: 40, height: 40,),
  "U.S. Virgin Islands":Image.asset('assets/flags/vg.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Virgin Islands":Image.asset('assets/flags/vi.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Wallis and Futuna":Image.asset('assets/flags/wf.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Western Sahara":Image.asset('assets/flags/eh.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Yemen":Image.asset('assets/flags/ye.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Zambia":Image.asset('assets/flags/zm.png', fit: BoxFit.contain, width: 40, height: 40,),
  "Zimbabwe":Image.asset('assets/flags/zw.png', fit: BoxFit.contain, width: 40, height: 40,),


};
