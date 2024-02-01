import 'package:flutter/material.dart';
import 'package:oem_huining_anhui/logic/calculate_logic/calculate_logic.dart';
import 'package:oem_huining_anhui/model/common_constant.dart';
import 'package:oem_huining_anhui/model/list_node.dart';
import 'package:oem_huining_anhui/widget/input_widget/tro_input_widget.dart';
import 'package:oem_huining_anhui/widget/input_widget/tro_select_widget.dart';

late CalculateBuildWidgetState calculateBuildWidgetState;

class CalculateBuildWidget extends StatefulWidget {
  final ListNode curListNode;
  final Function calculate;
  const CalculateBuildWidget(
      {Key? key, required this.curListNode, required this.calculate})
      : super(key: key);

  @override
  State<CalculateBuildWidget> createState() {
    calculateBuildWidgetState = CalculateBuildWidgetState();
    return calculateBuildWidgetState;
  }
}

class CalculateBuildWidgetState extends State<CalculateBuildWidget> {
  ListNode? curListNode;

  set(ListNode listNode) {
    setState(() {
      curListNode = listNode;
    });
  }

  @override
  void initState() {
    curListNode = widget.curListNode;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    InitCalculate initCalculate = curListNode?.data ?? InitCalculate();
    CalculateResult calculateResult = curListNode?.ans ?? CalculateResult();
    return Flexible(
      flex: 8,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //标题
            Align(
              alignment: Alignment.center,
              child: Text(
                '数据详情',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            //计算前置基础信息
            Row(
              children: [
                Text(
                  '当前位号:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  initCalculate.nom ?? '',
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 18,
                      fontStyle: FontStyle.italic),
                )
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.black)),
              child: Form(
                child: Wrap(
                  children: [
                    Container(
                      width: 250,
                      child: TroInput(
                        label: '位号',
                        width: 200,
                        labelWidth: 100,
                        value: initCalculate.nom,
                        labelStyle: TextStyle(
                          fontSize: 12,
                        ),
                        onChange: (data) {
                          curListNode?.nom = data;
                          initCalculate.nom = data;
                        },
                      ),
                    ),
                    Container(
                      width: 250,
                      child: TroInput(
                        label: '套管大径(mm)',
                        width: 200,
                        labelWidth: 100,
                        value: '${initCalculate.diameterA ?? '请输入'}',
                        labelStyle: TextStyle(
                          fontSize: 12,
                        ),
                        onChange: (data) {
                          initCalculate.diameterA = num.tryParse(data);
                        },
                      ),
                    ),
                    Container(
                      width: 250,
                      child: TroInput(
                        label: '套管小径(mm)',
                        width: 200,
                        labelWidth: 100,
                        value: '${initCalculate.diameterB ?? '请输入'}',
                        labelStyle: TextStyle(
                          fontSize: 12,
                        ),
                        onChange: (data) {
                          initCalculate.diameterB = num.tryParse(data);
                        },
                      ),
                    ),
                    Container(
                      width: 250,
                      child: TroInput(
                        label: '套管孔径(mm)',
                        width: 200,
                        labelWidth: 100,
                        value: '${initCalculate.diameterHole ?? '请输入'}',
                        labelStyle: TextStyle(
                          fontSize: 12,
                        ),
                        onChange: (data) {
                          initCalculate.diameterHole = num.tryParse(data);
                        },
                      ),
                    ),
                    Container(
                      width: 250,
                      child: TroInput(
                        label: '插深(mm)',
                        width: 200,
                        labelWidth: 100,
                        value: '${initCalculate.insertDeep ?? '请输入'}',
                        labelStyle: TextStyle(
                          fontSize: 12,
                        ),
                        onChange: (data) {
                          initCalculate.insertDeep = num.tryParse(data);
                        },
                      ),
                    ),
                    Container(
                      width: 250,
                      child: TroInput(
                        label: '凸台(mm)',
                        width: 200,
                        labelWidth: 100,
                        value: '${initCalculate.boss ?? '请输入'}',
                        labelStyle: TextStyle(
                          fontSize: 12,
                        ),
                        onChange: (data) {
                          initCalculate.boss = num.tryParse(data);
                        },
                      ),
                    ),

                    Container(
                      width: 250,
                      child: TroInput(
                        label: '使用温度(℃)',
                        width: 200,
                        labelWidth: 100,
                        value: '${initCalculate.tmp ?? '请输入'}',
                        labelStyle: TextStyle(
                          fontSize: 12,
                        ),
                        onChange: (data) {
                          initCalculate.tmp = num.tryParse(data);
                        },
                      ),
                    ),
                    Container(
                      width: 250,
                      child: TroInput(
                        label: '弹性模量(10^6psi)',
                        width: 200,
                        labelWidth: 100,
                        value: '${initCalculate.elasticModulus ?? '请输入'}',
                        labelStyle: TextStyle(
                          fontSize: 12,
                        ),
                        onChange: (data) {
                          initCalculate.elasticModulus = num.tryParse(data);
                        },
                      ),
                    ),
                    // Container(
                    //   width: 250,
                    //   child: TroInput(
                    //     label: '材质密度(kg/m3)',
                    //     width: 200,
                    //     labelWidth: 100,
                    //     value: '${initCalculate.densityOfMaterial ?? '请输入'}',
                    //     labelStyle: TextStyle(
                    //       fontSize: 12,
                    //     ),
                    //     onChange: (data) {
                    //       initCalculate.densityOfMaterial = num.tryParse(data);
                    //     },
                    //   ),
                    // ),
                    Container(
                      width: 250,
                      child: TroInput(
                        label: '介质流速(m/s)',
                        width: 200,
                        labelWidth: 100,
                        value: '${initCalculate.flowRate ?? '请输入'}',
                        labelStyle: TextStyle(
                          fontSize: 12,
                        ),
                        onChange: (data) {
                          initCalculate.flowRate = num.tryParse(data);
                        },
                      ),
                    ),
                    Container(
                      width: 250,
                      child: TroInput(
                        label: '黏度(Ns/m2)',
                        width: 200,
                        labelWidth: 100,
                        value: '${initCalculate.viscosity ?? '请输入'}',
                        labelStyle: TextStyle(
                          fontSize: 12,
                        ),
                        onChange: (data) {
                          initCalculate.viscosity = num.tryParse(data);
                        },
                      ),
                    ),
                    Container(
                      width: 250,
                      child: TroInput(
                        label: '阻力系数',
                        width: 200,
                        labelWidth: 100,
                        value: '${initCalculate.resistanceE ?? '请输入'}',
                        labelStyle: TextStyle(
                          fontSize: 12,
                        ),
                        onChange: (data) {
                          initCalculate.resistanceE = num.tryParse(data);
                        },
                      ),
                    ),
                    Container(
                      width: 250,
                      child: TroInput(
                        label: '流体密度(kg/m3)',
                        width: 200,
                        labelWidth: 100,
                        value: '${initCalculate.densityOfFlow ?? '请输入'}',
                        labelStyle: TextStyle(
                          fontSize: 12,
                        ),
                        onChange: (data) {
                          initCalculate.densityOfFlow = num.tryParse(data);
                        },
                      ),
                    ),

                    Container(
                      width: 250,
                      child: TroInput(
                        label: '许用应力(MPa)',
                        width: 200,
                        labelWidth: 100,
                        value: '${initCalculate.stressAllowable ?? '请输入'}',
                        labelStyle: TextStyle(
                          fontSize: 12,
                        ),
                        onChange: (data) {
                          initCalculate.stressAllowable = num.tryParse(data);
                        },
                      ),
                    ),
                    Container(
                      width: 250,
                      child: TroInput(
                        label: '共振Cl',
                        width: 200,
                        labelWidth: 100,
                        value: '${initCalculate.resonance ?? '请输入'}',
                        labelStyle: TextStyle(
                          fontSize: 12,
                        ),
                        onChange: (data) {
                          initCalculate.resonance = num.tryParse(data);
                        },
                      ),
                    ),
                    Container(
                      width: 250,
                      child: TroSelect(
                        value: initCalculate.connection,
                        dataList: [
                          SelectOptionVO(value: '法兰', label: '法兰'),
                          SelectOptionVO(value: '焊接', label: '焊接'),
                          SelectOptionVO(value: '螺纹', label: '螺纹'),
                        ],
                        label: '工艺连接',
                        width: 200,
                        labelWidth: 100,
                        labelStyle: TextStyle(
                          fontSize: 12,
                        ),
                        onChange: (data) {
                          initCalculate.connection = data;
                        },
                      ),
                    ),
                    Container(
                      width: 250,
                      child: TroSelect(
                        value: initCalculate.material,
                        dataList: [
                          SelectOptionVO(value: '304', label: '304'),
                          SelectOptionVO(value: 'GH3030', label: 'GH3030'),
                          SelectOptionVO(value: '310S', label: '310S'),
                          SelectOptionVO(value: 'Monel', label: 'Monel'),
                          SelectOptionVO(value: '钽Ta', label: '钽Ta'),
                          SelectOptionVO(value: '钛Ti', label: '钛Ti'),
                          SelectOptionVO(
                              value: 'Inconel600', label: 'Inconel600'),
                          SelectOptionVO(value: 'S31803', label: 'S31803'),
                          SelectOptionVO(
                              value: '双相不锈钢2205', label: '双相不锈钢2205'),
                          SelectOptionVO(
                              value: '超级双相不锈钢S32750', label: '超级双相不锈钢S32750'),
                        ],
                        label: '套管材质',
                        width: 200,
                        labelWidth: 100,
                        labelStyle: TextStyle(
                          fontSize: 12,
                        ),
                        onChange: (data) {
                          initCalculate.densityOfMaterial =
                              materialMap[data] ?? 0.29;
                          initCalculate.material = data;
                        },
                      ),
                    ),
                    Container(
                      width: 250,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TroSelect(
                            value: (initCalculate.curXX ?? 1).toString(),
                            dataList: [
                              SelectOptionVO(value: '2', label: '管线尺寸(mm)'),
                              SelectOptionVO(value: '1', label: '管线尺寸(in)'),
                            ],
                            label: '',
                            width: 95,
                            labelWidth: 0,
                            labelStyle: TextStyle(
                              fontSize: 10,
                            ),
                            onChange: (data) {
                              initCalculate.curXX = int.parse(data);
                              initCalculate.pipeSize = 0;
                              setState(() {});
                            },
                          ),
                          TroInput(
                            label: '',
                            width: 100,
                            labelWidth: 0,
                            value: '${initCalculate.pipeSize ?? '请输入'}',
                            labelStyle: TextStyle(
                              fontSize: 12,
                            ),
                            onChange: (data) {
                              if (initCalculate.curXX == '1') {
                                initCalculate.pipeSize = num.tryParse(data);
                              } else {
                                initCalculate.pipeSize =
                                    num.tryParse(data) ?? 0 / 25.4;
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 250,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TroSelect(
                            value: (initCalculate.curYY ?? 1).toString(),
                            dataList: [
                              SelectOptionVO(value: '1', label: '压力(MPa)'),
                              SelectOptionVO(value: '2', label: '压力(KPa)'),
                            ],
                            label: '',
                            width: 95,
                            labelWidth: 0,
                            labelStyle: TextStyle(
                              fontSize: 10,
                            ),
                            onChange: (data) {
                              initCalculate.curYY = int.parse(data);
                              initCalculate.pressure = 0;
                              setState(() {});
                              print(initCalculate);
                            },
                          ),
                          TroInput(
                            label: '',
                            width: 100,
                            labelWidth: 0,
                            value: '${initCalculate.pressure ?? '请输入'}',
                            labelStyle: TextStyle(
                              fontSize: 12,
                            ),
                            onChange: (data) {
                              if (initCalculate.curYY == '1') {
                                initCalculate.pressure = num.tryParse(data);
                              } else {
                                initCalculate.pressure =
                                    num.tryParse(data) ?? 0 / 1000;
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                            alignment: Alignment.centerRight,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(width: 1)),
                            width: 80,
                            height: 50,
                            child: Center(
                              child: TextButton(
                                onPressed: () {
                                  curListNode?.data = initCalculate;
                                  CalculateResult res =
                                      CalculateLogic.calculate(initCalculate) ??
                                          CalculateResult();
                                  widget.calculate.call(curListNode, res);
                                  setState(() {});
                                },
                                child: Text(
                                  '计算',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            //充当margin
            SizedBox(
              height: 50,
            ),
            //计算结果
            Text(
              '计算结果:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.black)),
              child: Form(
                child: Wrap(
                  children: [
                    Container(
                      width: 250,
                      child: TroInput(
                        enable: false,
                        label: '系数Kf',
                        width: 200,
                        labelWidth: 100,
                        value: '${calculateResult.kF ?? '等待计算'}',
                        labelStyle: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Container(
                      width: 250,
                      child: TroInput(
                        enable: false,
                        label: '自振频率fn(Hz)',
                        width: 200,
                        labelWidth: 100,
                        value: '${calculateResult.naturalFre ?? '等待计算'}',
                        labelStyle: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Container(
                      width: 250,
                      child: TroInput(
                        enable: false,
                        label: '激励频率fw(Hz)',
                        width: 200,
                        labelWidth: 100,
                        value: '${calculateResult.excFrequency ?? '等待计算'}',
                        labelStyle: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Container(
                      width: 250,
                      child: TroInput(
                        enable: false,
                        label: '频率比',
                        width: 200,
                        labelWidth: 100,
                        value: '${calculateResult.freRatio ?? '等待计算'}',
                        valueStyle: TextStyle(
                          color: (calculateResult.freRatio ?? 0) < 0.8
                              ? Colors.red
                              : Colors.green,
                        ),
                        labelStyle: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Container(
                      width: 250,
                      child: TroInput(
                        enable: false,
                        label: 'Re',
                        width: 200,
                        labelWidth: 100,
                        value: '${calculateResult.rE ?? '等待计算'}',
                        labelStyle: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Container(
                      width: 250,
                      child: TroInput(
                        enable: false,
                        label: '截面A(m2)',
                        width: 200,
                        labelWidth: 100,
                        value: '${calculateResult.section ?? '等待计算'}',
                        labelStyle: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Container(
                      width: 250,
                      child: TroInput(
                        enable: false,
                        label: '流体力F(N)',
                        width: 200,
                        labelWidth: 100,
                        value: '${calculateResult.fluidForce ?? '等待计算'}',
                        labelStyle: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Container(
                      width: 250,
                      child: TroInput(
                        enable: false,
                        label: '根部弯矩M(N*mm)',
                        width: 200,
                        labelWidth: 100,
                        value: '${calculateResult.bendingDistance ?? '等待计算'}',
                        labelStyle: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Container(
                      width: 250,
                      child: TroInput(
                        enable: false,
                        label: '根部弯应力σB(MPa)',
                        width: 200,
                        labelWidth: 100,
                        value: '${calculateResult.fatigue ?? '等待计算'}',
                        labelStyle: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Container(
                      width: 250,
                      child: TroInput(
                        enable: false,
                        label: '外压应力σP(MPa)',
                        width: 200,
                        labelWidth: 100,
                        value: '${calculateResult.stressOutside ?? '等待计算'}',
                        labelStyle: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Container(
                      width: 250,
                      child: TroInput(
                        enable: false,
                        label: '共振流速Vr(m/s)',
                        width: 200,
                        labelWidth: 100,
                        value: '${calculateResult.speedResonance ?? '等待计算'}',
                        labelStyle: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Container(
                      width: 250,
                      child: TroInput(
                        enable: false,
                        label: '共振Re',
                        width: 200,
                        labelWidth: 100,
                        value: '${calculateResult.resonanceRe ?? '等待计算'}',
                        labelStyle: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Container(
                      width: 250,
                      child: TroInput(
                        enable: false,
                        label: '共振FL(N)',
                        width: 200,
                        labelWidth: 100,
                        value: '${calculateResult.resonanceFL ?? '等待计算'}',
                        labelStyle: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Container(
                      width: 250,
                      child: TroInput(
                        enable: false,
                        label: '共振弯矩',
                        width: 200,
                        labelWidth: 100,
                        value: '${calculateResult.resonanceML ?? '等待计算'}',
                        labelStyle: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Container(
                      width: 250,
                      child: TroInput(
                        enable: false,
                        label: '共振根部弯应力σrB(MPa)',
                        width: 200,
                        labelWidth: 100,
                        value: '${calculateResult.resonanceFatigue ?? '等待计算'}',
                        labelStyle: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Container(
                      width: 250,
                      child: TroInput(
                        enable: false,
                        label: '疲劳许用应力σra(MPa)',
                        width: 200,
                        labelWidth: 100,
                        value: '${calculateResult.stressFatigue ?? '等待计算'}',
                        labelStyle: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //充当margin
            SizedBox(
              height: 50,
            ),
            //最终结果（是否合格）
            Row(
              children: [
                Text(
                  '是否合格:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  calculateResult.isQualified ?? false ? '合格' : '不合格',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: calculateResult.isQualified ?? false
                          ? Colors.green
                          : Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
