import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import '../../../data/models/province_model.dart';
import '../../../data/models/city_model.dart';

// connect apinya disini pake dio tidak http sama saja si
class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ongkos kirim'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          DropdownSearch<Province>(
            popupProps: PopupProps.menu(
              showSearchBox: true,
              itemBuilder: (context, item, isSelected) => ListTile(
                title: Text("${item.province}"),
              ),
            ),
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                labelText: "Provinsi awal",
                contentPadding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 15,
                ),
                border: OutlineInputBorder(),
              ),
            ),
            // asyncItems: (text) async {
            //   var response = await Dio().get(
            //     "https://api.rajaongkir.com/starter/province",
            //     queryParameters: {
            //       "key": "246c67ed323172adaa69539171d286e8",
            //     },
            //   );
            //   return Province.fromJsonList(
            //       response.data["rajaongkir"]["results"]);
            // },
            asyncItems: (text) async {
              var url = Uri.parse(
                "https://api.rajaongkir.com/starter/province?key=246c67ed323172adaa69539171d286e8",
              );

              var response = await http.get(url);

              if (response.statusCode == 200) {
                var data = jsonDecode(response.body);
                return Province.fromJsonList(data["rajaongkir"]["results"]);
              } else {
                throw Exception('Failed to load provinces');
              }
            },
            onChanged: (value) =>
                controller.provAsalId.value = value?.provinceId ?? "0",
          ),
          SizedBox(
            height: 20,
          ),
          DropdownSearch<City>(
            popupProps: PopupProps.menu(
              showSearchBox: true,
              itemBuilder: (context, item, isSelected) => ListTile(
                title: Text("${item.type}${item.cityName}"),
                // type buat menampilkan type kota/kabupaten
              ),
            ),
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                labelText: "Kota/kabupaten asal",
                contentPadding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 15,
                ),
                border: OutlineInputBorder(),
              ),
            ),
            asyncItems: (text) async {
              var response = await Dio().get(
                "https://api.rajaongkir.com/starter/city?province=${controller.provAsalId}",
                queryParameters: {
                  "key": "246c67ed323172adaa69539171d286e8",
                },
              );
              return City.fromJsonList(response.data["rajaongkir"]["results"]);
            },
            onChanged: (value) =>
                controller.cityAsalId.value = value?.cityId ?? "0",
          ),
          SizedBox(
            height: 20,
          ),
          DropdownSearch<Province>(
            popupProps: PopupProps.menu(
              showSearchBox: true,
              itemBuilder: (context, item, isSelected) => ListTile(
                title: Text("${item.province}"),
              ),
            ),
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                labelText: "Provinsi tujuan",
                contentPadding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 15,
                ),
                border: OutlineInputBorder(),
              ),
            ),
            asyncItems: (text) async {
              var response = await Dio().get(
                "https://api.rajaongkir.com/starter/province",
                queryParameters: {
                  "key": "246c67ed323172adaa69539171d286e8",
                },
              );
              return Province.fromJsonList(
                  response.data["rajaongkir"]["results"]);
            },
            onChanged: (value) =>
                controller.provTujuanId.value = value?.provinceId ?? "0",
          ),
          SizedBox(
            height: 20,
          ),
          DropdownSearch<City>(
            popupProps: PopupProps.menu(
              showSearchBox: true,
              itemBuilder: (context, item, isSelected) => ListTile(
                title: Text("${item.type}${item.cityName}"),
                // type buat menampilkan type kota/kabupaten
              ),
            ),
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                labelText: "Kota/kabupaten tujuan",
                contentPadding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 15,
                ),
                border: OutlineInputBorder(),
              ),
            ),
            asyncItems: (text) async {
              var response = await Dio().get(
                "https://api.rajaongkir.com/starter/city?province=${controller.provTujuanId}",
                queryParameters: {
                  "key": "246c67ed323172adaa69539171d286e8",
                },
              );
              return City.fromJsonList(response.data["rajaongkir"]["results"]);
            },
            onChanged: (value) =>
                controller.cityTujuanId.value = value?.cityId ?? "0",
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: controller.weightC,
            autocorrect: false,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Berat (Gram/Kg)",
              contentPadding: EdgeInsets.symmetric(
                vertical: 25,
                horizontal: 15,
              ),
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          DropdownSearch<Map<String, dynamic>>(
            items: [
              {
                "code": "jne",
                "name": "JNE",
              },
              {
                "code": "pos",
                "name": "POS Indoneisa",
              },
              {
                "code": "tiki",
                "name": "TIKI",
              },
            ],
            popupProps: PopupProps.menu(
              showSearchBox: true,
              itemBuilder: (context, item, isSelected) => ListTile(
                title: Text("${item["name"]}"),
              ),
            ),
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                labelText: "Kurir",
                contentPadding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 15,
                ),
                border: OutlineInputBorder(),
              ),
            ),
            onChanged: (value) =>
                controller.codeKurir.value = value?["code"] ?? "0",
            dropdownBuilder: (context, selectedItem) =>
                Text("${selectedItem?["name"] ?? "Pilih Kurir"}"),
          ),
          SizedBox(
            height: 30,
          ),
          Obx(
            () => ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
              onPressed: () {
                if (controller.isLoading.isFalse) {
                  controller.cekOngkir();
                }
              },
              child:
                  Text(controller.isLoading.isFalse ? "Cek Orkir" : "Loading"),
            ),
          ),
        ],
      ),
    );
  }
}
