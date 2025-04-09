import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Widget journalTypeImageWidget(
  String assetName, {
  Color containerColor = Colors.green,
  double containerSize = 40,
  double iconSize = 20,
  Color iconColor = Colors.white,
}) {
  return Container(
    width: containerSize,
    height: containerSize,
    decoration: BoxDecoration(color: containerColor, shape: BoxShape.circle),
    child: FittedBox(
      fit: BoxFit.scaleDown,
      child: SvgPicture.asset(
        assetName,
        width: iconSize,
        height: iconSize,
        colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
      ),
    ),
  );
}

enum ExpenseImages {
  catering(name: "餐饮", img: "images/expense/catering.svg"),
  bus(name: "交通", img: "images/expense/bus.svg"),
  costume(name: "服饰", img: "images/expense/costume.svg"),
  shopping(name: "购物", img: "images/expense/shopping.svg"),
  service(name: "服务", img: "images/expense/service.svg"),
  education(name: "教育", img: "images/expense/education.svg"),
  recreation(name: "娱乐", img: "images/expense/recreation.svg"),
  exercise(name: "运动", img: "images/expense/exercise.svg"),
  livingPayment(name: "生活缴费", img: "images/expense/living_payment.svg"),
  travel(name: "旅行", img: "images/expense/travel.svg"),
  pet(name: "宠物", img: "images/expense/pet.svg"),
  hospital(name: "医疗", img: "images/expense/hospital.svg"),
  insurance(name: "保险", img: "images/expense/insurance.svg"),
  publicBenefit(name: "公益", img: "images/expense/public_benefit.svg"),
  sendRedPacket(name: "发红包", img: "images/expense/send_red_packet.svg"),
  transfer(name: "转账", img: "images/expense/transfer.svg"),
  relativeCard(name: "亲属卡", img: "images/expense/relative_card.svg"),
  peopleDealings(name: "其他人情", img: "images/expense/people_dealings.svg"),
  refund(name: "退还", img: "images/expense/refund.svg"),
  other(name: "其他", img: "images/expense/other.svg");

  static ExpenseImages fromName(String name) {
    return ExpenseImages.values.firstWhere(
      (element) => element.name == name,
      orElse: () => ExpenseImages.other,
    );
  }

  const ExpenseImages({required this.name, required this.img});

  final String name;
  final String img;
}

enum IncomeImages {
  business(name: "生意", img: "images/income/business.svg"),
  salary(name: "工资", img: "images/income/salary.svg"),
  bonus(name: "奖金", img: "images/income/bonus.svg"),
  peopleDealings(name: "其他人情", img: "images/income/people_dealings.svg"),
  receiverRedPacket(name: "收红包", img: "images/income/receiver_red_packet.svg"),
  receiverTransfer(name: "收转账", img: "images/income/transfer.svg"),
  storeTransfer(name: "商家转账", img: "images/income/store_transfer.svg"),
  refund(name: "退款", img: "images/income/refund.svg"),
  other(name: "其他", img: "images/income/other.svg");

  static IncomeImages fromName(String name) {
    return IncomeImages.values.firstWhere(
      (element) => element.name == name,
      orElse: () => IncomeImages.other,
    );
  }

  const IncomeImages({required this.name, required this.img});

  final String name;
  final String img;
}
