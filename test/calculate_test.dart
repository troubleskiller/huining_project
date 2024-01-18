import 'dart:math';

import 'package:oem_huining_anhui/logic/calculate_logic/calculate_logic.dart';
import 'package:oem_huining_anhui/model/list_node.dart';

void main() {
  InitCalculate initCalculate = InitCalculate(
    nom: 'Tp1233-sdff',
    diameterA: 12,
    diameterB: 13,
    densityOfFlow: 23,
    stressAllowable: 123,
    densityOfMaterial: 455,
    diameterHole: 12,
    flowRate: 20,
    tmp: 23,
    elasticModulus: 24,
    resistanceE: 23.5,
    resonance: 4,
    insertDeep: 11,
    pipeSize: 10,
    pressure: 12.6,
    viscosity: 12.0,
    boss: 6,
  );
  String connection = "法兰";
  num diameterA = 34;
  num diameterB = 28;
  num diameterHole = 0.9;
  num insertDeep = 250;
  num boss = 150;
  num pipeSize = 14;
  num tmp = 450;
  num elasticModulus = 23.2;
  num densityOfMaterial = 0.29;
  num flowRate = 30;
  num viscosity = 1;
  num resistanceE = 1.2;
  num densityOfFlow = 18;
  num pressure = 4.5;
  num stressAllowable = 127.8;
  num resonance = 0.6;
  CalculateLogic.calculate(InitCalculate(
      connection: '法兰',
      diameterA: 34,
      diameterB: 28,
      diameterHole: 9,
      insertDeep: 250,
      boss: 150,
      pipeSize: 14,
      tmp: 450,
      elasticModulus: 23.2,
      densityOfMaterial: 0.29,
      flowRate: 30,
      viscosity: 1,
      resistanceE: 1.2,
      densityOfFlow: 18,
      pressure: 4.5,
      stressAllowable: 127.8,
      resonance: 0.6));
  //计算中间变量
}

//正确版（根据excel表公式得出）
///D4\F4\H4\L4是中间变量
double calculateNaturalFre(double densityOfMaterial, double D4, double F4,
    double H4, double L4, double elasticModulus) {
  return 3.127 /
      pow(
          (4 *
              densityOfMaterial *
              (0.5 * pow((D4 - F4), 2) +
                      (0.25 *
                              (3 * pow(F4, 4) / pow(H4, 2) -
                                  5 * pow(H4, 2) -
                                  6 *
                                      pow(
                                          (F4 +
                                              0.5 * (F4 - H4) * (D4 - F4) / L4),
                                          2))) *
                          (F4 / H4 * log((F4 - H4) * (D4 + H4) / (F4 + H4) / (D4 - H4)) +
                              log((pow(D4, 2) - pow(H4, 2)) /
                                  (pow(F4, 2) - pow(H4, 2)))) +
                      ((0.5 *
                              (6 * pow((F4 + 0.5 * (F4 - H4) * (D4 - F4) / L4), 2) -
                                  7 * pow(H4, 2) -
                                  3 * pow(F4, 4) / pow(H4, 2))) *
                          (F4 / H4 * atan((H4 * (F4 - D4) / (pow(H4, 2) + D4 * F4))) +
                              0.5 *
                                  log(((pow(D4, 2) + pow(H4, 2)) /
                                      (pow(F4, 2) + pow(H4, 2)))))) +
                      ((2 * (pow(F4, 3) / pow(H4, 2) - 3 * (F4 + 0.5 * (F4 - H4) * (D4 - F4) / L4))) *
                          (0.5 *
                                  F4 *
                                  log(((pow(F4, 2) + pow(H4, 2)) *
                                      (pow(D4, 2) - pow(H4, 2)) /
                                      (pow(F4, 2) - pow(H4, 2)) /
                                      (pow(D4, 2) + pow(H4, 2)))) +
                              H4 *
                                  atan((H4 * (F4 - D4) / (pow(H4, 2) + D4 * F4))) +
                              0.5 * H4 * log(((F4 - H4) * (D4 + H4) / (F4 + H4) / (D4 - H4))))))
                  .abs() /
              (3 * elasticModulus * pow(10, 6) * pow(((D4 - F4) / L4), 4))),
          0.5);
}

double calculateD4(double C4) {
  return C4 / 25.4;
}

double calculateF4(double E4) {
  return E4 / 25.4;
}

double calculateH4(double G4) {
  return G4 / 25.4;
}

double calculateL4(String J4, double I4, double K4, double a) {
  return J4 == "焊接" ? (I4 - K4) / 25.4 : I4 / 25.4;
}

// 其他公式继续...
