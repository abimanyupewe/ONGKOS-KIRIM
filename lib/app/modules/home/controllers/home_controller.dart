import 'dart:convert';
import '../../../data/models/ongkir_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  TextEditingController weightC = TextEditingController();

  List<Ongkir> ongkosKirim = [];

  RxBool isLoading = false.obs;

  RxString provAsalId = "0".obs;
  RxString cityAsalId = "0".obs;
  RxString provTujuanId = "0".obs;
  RxString cityTujuanId = "0".obs;

  RxString codeKurir = "0".obs;

  void cekOngkir() async {
    if (provAsalId != "0" &&
        provTujuanId != "0" &&
        cityAsalId != "0" &&
        cityTujuanId != "0" &&
        codeKurir != "0" &&
        weightC.text != "0") {
      // eksekusi

      try {
        // var response = await Dio().post(
        //   "https://api.rajaongkir.com/starter/cost",
        //   queryParameters: {
        //     "key": "246c67ed323172adaa69539171d286e8",
        //     'content-type': 'application/x-www-form-urlencoded',
        //   },
        //   data: {
        //     "origin": cityAsalId.value,
        //     "destination": cityTujuanId.value,
        //     "weight": weightC.text,
        //     "courier": codeKurir.value,
        //   },
        // );
        isLoading.value = true;

        var response = await http.post(
          Uri.parse("https://api.rajaongkir.com/starter/cost"),
          headers: {
            "key": "246c67ed323172adaa69539171d286e8",
            'content-type': 'application/x-www-form-urlencoded',
          },
          body: {
            "origin": cityAsalId.value,
            "destination": cityTujuanId.value,
            "weight": weightC.text,
            "courier": codeKurir.value,
          },
        );
        isLoading.value = false;
        List ongkir = json.decode(response.body)["rajaongkir"]["results"][0]
            ["costs"] as List;
        ongkosKirim = Ongkir.fromJsonList(ongkir);

        Get.defaultDialog(
          title: "Ongkos kirim",
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: ongkosKirim
                .map(
                  (e) => ListTile(
                    title: Text("${e.service!.toUpperCase()}"),
                    subtitle: Text("Rp. ${e.cost![0].value}"),
                  ),
                )
                .toList(),
          ),
        );
      } catch (e) {
        Get.defaultDialog(
          title: "Terjadi Kesalahan",
          middleText: "Gagal cek ongkir",
        );
      }
    } else {
      Get.defaultDialog(
        title: "Terjadi Kesalahan",
        middleText: "Data input tidak lengkap",
      );
    }
  }
}
