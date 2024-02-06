import 'dart:math';

import 'package:oem_huining_anhui/model/list_node.dart';

class CalculateLogic {
  //中间变量L4（用于计算系数Kf）
  ///   插深U(mm)
  ///   num? insertDeep;
  ///   凸台H(mm)
  ///   num? boss;
  static double getL4(String connection, num insertDeep, num boss) {
    if (connection == '焊接') {
      return (insertDeep - boss) / 25.4;
    }
    return insertDeep / 25.4;
  }

  static CalculateResult? calculate(InitCalculate initCalculate) {
    CalculateResult calculateResult = CalculateResult();

    ///中间变量
    //D4
    num D4 = calculateD4(initCalculate.diameterA ?? 0);
    //F4
    num F4 = calculateF4(initCalculate.diameterB ?? 0);
    //H4
    num H4 = calculateH4(initCalculate.diameterHole ?? 0);
    //L4
    num L4 = calculateL4(initCalculate.connection ?? '法兰',
        initCalculate.insertDeep ?? 0, initCalculate.boss ?? 0);

    ///展示的变量
    //自振频率
    num naturalFre = calculateNaturalFre(initCalculate.densityOfMaterial ?? 0,
        D4, F4, H4, L4, initCalculate.elasticModulus ?? 0);
    //系数Kf
    num kf = getKf(naturalFre, L4, initCalculate.densityOfMaterial ?? 0,
        initCalculate.elasticModulus ?? 0);
    //激励频率
    num excFrequency = getExcFrequency(
        initCalculate.flowRate ?? 0, initCalculate.diameterB ?? 0);
    //频率比
    num freRatio =
        getFreRatio(initCalculate.flowRate ?? 0, excFrequency, naturalFre);
    num rE = getRe(
        initCalculate.flowRate ?? 0,
        initCalculate.diameterA ?? 0,
        initCalculate.diameterB ?? 0,
        initCalculate.densityOfFlow ?? 0,
        initCalculate.viscosity ?? 0);
    //截面
    num section = getSection(
        initCalculate.diameterB ?? 0,
        initCalculate.insertDeep ?? 0,
        initCalculate.boss ?? 0,
        initCalculate.diameterA ?? 0);
    //流体力
    num fluidForce = getFluidForce(initCalculate.resistanceE ?? 0,
        initCalculate.densityOfFlow ?? 0, initCalculate.flowRate ?? 0, section);
    //根部弯距
    num bendingDistance = getBendingDistance(
        fluidForce, initCalculate.insertDeep ?? 0, initCalculate.boss ?? 0);
    //根部弯应力
    num fatigue = getFatigue(initCalculate.flowRate ?? 0, bendingDistance,
        initCalculate.diameterA ?? 0, initCalculate.diameterHole ?? 0);
    //外压应力
    num stressOutside = getStressOutside(initCalculate.diameterB ?? 0,
        initCalculate.diameterHole ?? 0, initCalculate.pressure ?? 0);
    // 共振流速
    num speedResonance =
        getSpeedResonance(naturalFre, initCalculate.diameterB ?? 0);
    // 共振Re
    num resonanceRe = getResonanceRe(
        speedResonance,
        initCalculate.diameterA ?? 0,
        initCalculate.diameterB ?? 0,
        initCalculate.densityOfFlow ?? 0,
        initCalculate.viscosity ?? 0);
    // 共振Fl
    num resonanceFL = getResonanceFL(initCalculate.resonance ?? 0,
        initCalculate.densityOfFlow ?? 0, speedResonance, section);
    //共振弯距
    num resonanceML = getResonanceML(
        resonanceFL, initCalculate.insertDeep ?? 0, initCalculate.boss ?? 0);
    // 根部弯应力
    num resonanceFatigue = getResonanceFatigue(
        resonanceML,
        initCalculate.diameterA ?? 0,
        initCalculate.diameterHole ?? 0,
        initCalculate.flowRate ?? 0,
        freRatio);
    // 疲劳应力Mpa
    num stressFatigue =
        getStressFatigue(resonanceFatigue, initCalculate.stressAllowable ?? 0);
    bool isQualified = getIsQualified(freRatio, fatigue, stressOutside,
        initCalculate.stressAllowable ?? 0, resonanceFatigue, stressFatigue);
    calculateResult.freRatio = num.tryParse(freRatio.toStringAsFixed(2));
    calculateResult.naturalFre = num.tryParse(naturalFre.toStringAsFixed(2));
    calculateResult.bendingDistance =
        num.tryParse(bendingDistance.toStringAsFixed(2));
    calculateResult.excFrequency =
        num.tryParse(excFrequency.toStringAsFixed(2));
    calculateResult.fatigue = num.tryParse(fatigue.toStringAsFixed(2));
    calculateResult.fluidForce = num.tryParse(fluidForce.toStringAsFixed(2));
    calculateResult.kF = num.tryParse(kf.toStringAsFixed(2));
    calculateResult.rE = num.tryParse(rE.toStringAsFixed(2));
    calculateResult.resonanceFatigue =
        num.tryParse(resonanceFatigue.toStringAsFixed(2));
    calculateResult.resonanceFL = num.tryParse(resonanceFL.toStringAsFixed(2));
    calculateResult.resonanceML = num.tryParse(resonanceML.toStringAsFixed(2));
    calculateResult.resonanceRe = num.tryParse(resonanceRe.toStringAsFixed(2));
    calculateResult.section = num.tryParse(section.toStringAsFixed(5));
    calculateResult.speedResonance =
        num.tryParse(speedResonance.toStringAsFixed(2));
    calculateResult.stressFatigue =
        num.tryParse(stressFatigue.toStringAsFixed(2));
    calculateResult.stressOutside =
        num.tryParse(stressOutside.toStringAsFixed(2));
    calculateResult.isQualified = isQualified;
    print(calculateResult.toString());
    return calculateResult;
  }

  static bool getIsQualified(num ratio, num fatigue, num stressOutside,
      num stressAllowable, num resonanceFatigue, num stressFatigue) {
    if (ratio <= 0.805) {
      if (fatigue + stressOutside <= stressAllowable) return true;
    } else {
      if (fatigue + stressOutside <= stressAllowable &&
          resonanceFatigue + stressOutside <= stressFatigue) return true;
    }
    return false;
  }

  static num calculateD4(num diameterA) {
    return diameterA / 25.4;
  }

  static num calculateF4(num diameterB) {
    return diameterB / 25.4;
  }

  static num calculateH4(num G4) {
    return G4 / 25.4;
  }

  static num calculateL4(
    String connection,
    num I4,
    num K4,
  ) {
    return connection == "焊接" ? (I4 - K4) / 25.4 : I4 / 25.4;
  }

  //  自振频率（需要计算）
  //  正确版（根据excel表公式得出）
  ///D4\F4\H4\L4是中间变量
  static num calculateNaturalFre(num densityOfMaterial, num D4, num F4, num H4,
      num L4, num elasticModulus) {
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
                                                0.5 *
                                                    (F4 - H4) *
                                                    (D4 - F4) /
                                                    L4),
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

  //系数kf
  ///   自振频率（需要计算）
  ///   num? naturalFre;
  ///   材质密度[这里入参用kg/m3]γ(lb/in3)
  ///   num? densityOfMaterial;
  ///   材质密度[这里入参用kg/m3]γ(lb/in3)
  ///   num? densityOfMaterial;
  ///   弹性模量E(106psi)
  ///   num? elasticModulus;
  static num getKf(
      num naturalFre, num L4, num densityOfMaterial, num elasticModulus) {
    //中间变量(L4)^2
    num tmp1 = pow(L4, 2);
    //(材质密度/弹性模量*10^6)^0.5
    num tmp2 = pow(densityOfMaterial / (elasticModulus * pow(10, 6)), 0.5);
    return naturalFre * tmp1 * tmp2;
  }

  //激励频率
  static num getExcFrequency(num S4, num diameterB) {
    if (S4 == 0) return 0;
    return 2.64 * S4 * 1000 / (25.4 * 12) / (diameterB / 25.4);
  }

  //频率比
  static num getFreRatio(num S4, num U4, num T4) {
    if (S4 == 0) return 0;
    return U4 / T4;
  }

  static num getRe(num S4, num diameterA, num diameterB, num Z4, num W4) {
    return S4 * (diameterA + diameterB) / 2 * Z4 / W4 * pow(10, -3);
  }

  //截面
  static num getSection(num diameterB, num I4, num K4, num diameterA) {
    return (diameterB + (I4 - K4) / I4 * (diameterA - diameterB) + diameterB) *
        (I4 - K4) /
        2 *
        pow(10, -6);
  }

  //流体力
  static num getFluidForce(num Y4, num Z4, num S4, num AA4) {
    return Y4 * Z4 / 2 * pow(S4, 2) * AA4;
  }

  //根部弯距
  static num getBendingDistance(num AB4, num I4, num K4) {
    return AB4 * (I4 - (I4 - K4) / 2);
  }

  //根部弯应力
  static num getFatigue(num S4, num AC4, num diameterA, num G4) {
    if (S4 == 0) return 0;
    return AC4 / (pi / 32 * (pow(diameterA, 4) - pow(G4, 4)) / diameterA);
  }

  //外压应力
  static num getStressOutside(num diameterB, num G4, num AE4) {
    if (0.5 * (diameterB - G4) / diameterB >= 0.25)
      return AE4 * 2 * pow(diameterB, 2) / (pow(diameterB, 2) - pow(G4, 2));
    return AE4 *
        (2 *
            pow(diameterB, 2) *
            (3.704691 -
                30.40096 * (0.5 * (diameterB - G4) / diameterB) +
                147.5387 * pow((0.5 * (diameterB - G4) / diameterB), 2) -
                273.0475 * pow((0.5 * (diameterB - G4) / diameterB), 3))) /
        (pow(diameterB, 2) - pow(G4, 2));
  }

  //共振流速
  static num getSpeedResonance(num T4, num diameterB) {
    return T4 * diameterB / 220;
  }

  //共振Re
  static num getResonanceRe(
      num AH4, num diameterA, num diameterB, num Z4, num W4) {
    return AH4 * (diameterA + diameterB) / 2 * Z4 / W4 * pow(10, -3);
  }

  //共振Fl
  static num getResonanceFL(num AJ4, num Z4, num AH4, num AA4) {
    return 100 * AJ4 * Z4 / 2 * pow(AH4, 2) * AA4;
  }

  //共振弯距
  static num getResonanceML(num AK4, num I4, num K4) {
    return AK4 * (I4 - (I4 - K4) / 2);
  }

  //根部弯应力
  static num getResonanceFatigue(
      num AL4, num diameterA, num G4, num S4, num V4) {
    if (S4 == 0 || V4 < 0.805) {
      return 0;
    } else {
      return AL4 /
          (3.14159 / 32 * (pow(diameterA, 4) - pow(G4, 4)) / diameterA);
    }
  }

  //疲劳应力Mpa
  static num getStressFatigue(num AM4, num AG4) {
    if (AM4 == 0) {
      return 0;
    } else {
      return AG4 / 2;
    }
  }
}
