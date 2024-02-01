import 'dart:io';

import 'package:excel/excel.dart' as excel;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:oem_huining_anhui/logic/calculate_logic/calculate_logic.dart';
import 'package:oem_huining_anhui/logic/excel_to_json%20/excel_to_json.dart';
import 'package:oem_huining_anhui/model/list_node.dart';
import 'package:oem_huining_anhui/screen/calculate_build_widget.dart';
import 'package:oem_huining_anhui/screen/main_screen/data_edit_screen.dart';
import 'package:oem_huining_anhui/widget/select_button/dialog/mult_select_dialog.dart';
import 'package:oem_huining_anhui/widget/select_button/util/multi_select_item.dart';
import 'package:oem_huining_anhui/widget/select_button/util/multi_select_list_type.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  ScrollController scrollController = ScrollController();
  DataGridController _dataGridController = DataGridController();
  List<ListNode> listNodes = [];
  List<ListNode> ans = [];
  ListNode curListNode = ListNode();

  @override
  void initState() {
    // TODO: implement initState
    scrollController.initialScrollOffset;
    super.initState();
  }

  ///导出excel文件
  Future<void> downLoad(List<ListNode> list) async {
    excel.Excel outPutExcel = excel.Excel.createExcel();
    excel.Sheet initCalculate = outPutExcel['输入表'];
    excel.Sheet calculateResult = outPutExcel['输出表'];
    initCalculate.appendRow([
      '位号',
      '套管大径A',
      '套管小径B',
      '套管孔径',
      '插深',
      '凸台',
      '管线尺寸',
      '使用温度',
      '弹性模量',
      '材质密度',
      '介质流速',
      '黏度',
      '阻力系数',
      '流体密度',
      '压力',
      '许用应力',
      '共振',
      '工艺连接',
      '备注'
    ]);
    for (int i = 0; i < list.length; i++) {
      ListNode date = list[i];
      InitCalculate tmp = date.data ?? InitCalculate();
      initCalculate.appendRow([
        tmp.nom,
        tmp.diameterA,
        tmp.diameterB,
        tmp.diameterHole,
        tmp.insertDeep,
        tmp.boss,
        tmp.pipeSize,
        tmp.tmp,
        tmp.elasticModulus,
        tmp.densityOfMaterial,
        tmp.flowRate,
        tmp.viscosity,
        tmp.resistanceE,
        tmp.densityOfFlow,
        tmp.pressure,
        tmp.stressAllowable,
        tmp.resonance,
        tmp.connection,
      ]);
    }
    calculateResult.appendRow([
      '系数Kf',
      '自振频率',
      '激励频率',
      '频率比',
      'Re',
      '截面',
      '流体力',
      '跟部弯矩',
      '根部弯应力',
      '外压应力',
      '共振流速',
      '共振Re',
      '共振Fl',
      '共振弯距',
      '共振根部弯应力',
      '疲劳许用应力',
      '合格',
    ]);
    for (int i = 0; i < list.length; i++) {
      ListNode date = list[i];
      CalculateResult tmp = date.ans ?? CalculateResult();
      bool? isQualified = tmp.isQualified;
      String ans = '';
      if (isQualified != null) {
        if (isQualified) {
          ans = '合格';
        } else {
          ans = '不合格';
        }
      } else {
        ans = '无法确定';
      }

      calculateResult.appendRow([
        tmp.kF,
        tmp.naturalFre,
        tmp.excFrequency,
        tmp.freRatio,
        tmp.rE,
        tmp.section,
        tmp.fluidForce,
        tmp.bendingDistance,
        tmp.fatigue,
        tmp.stressOutside,
        tmp.speedResonance,
        tmp.resonanceRe,
        tmp.resonanceFL,
        tmp.resonanceML,
        tmp.resonanceFatigue,
        tmp.stressFatigue,
        ans
      ]);
    }
    var fileBytes = outPutExcel.save();
    final picker = FilePicker.platform;
    var directory = await picker.saveFile(
      dialogTitle: '保存文件',
      fileName: '导出文件.xlsx',
      type: FileType.custom,
      allowedExtensions: [
        'xlsx',
      ],
    );

    File("$directory")
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes!);
  }

  void _showMultiSelect(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (ctx) {
        ans = listNodes;
        return MultiSelectDialog(
          height: 500,
          width: 500,
          cancelText: Text('取消保存'),
          confirmText: Text('下一步'),
          title: Text('选择要导出的数据'),
          items: listNodes
              .map((e) => MultiSelectItem<ListNode>(e, e.nom ?? ''))
              .toList(),
          initialValue: ans,
          listType: MultiSelectListType.LIST,
          onConfirm: (values) {
            downLoad(values);
          },
        );
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // downLoad();
          _showMultiSelect(context);
        },
        tooltip: '数据导出',
        child: const Icon(Icons.outbond),
      ),
      body: Flex(
        direction: Axis.horizontal,
        children: [
          //左侧数据列表
          buildDataList(),
          Container(
            width: 2,
            color: Colors.black,
            height: double.maxFinite,
          ),
          //右侧数据计算
          buildCalculate(),
        ],
      ),
    );
  }

  ///左侧数据列表
  Widget buildDataList() {
    CommonDataSource commonDataSource = CommonDataSource(
        commonData: [
          ...listNodes,
        ],
        editNom: (index, nom) {
          listNodes[index].nom = nom;
          listNodes[index].data?.nom = nom;
          setState(() {});
        },
        deleteNode: (index) {
          listNodes.removeWhere((element) => element.nom == index);
          setState(() {});
        });
    return Flexible(
      flex: 3,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              '数据列表',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              // height: 800,
              // width: 400,
              child: Scrollbar(
                controller: ScrollController(),
                child: CustomScrollView(
                  scrollDirection: Axis.vertical,
                  controller: ScrollController(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Container(
                        height: 800,
                        width: 400,
                        child: SfDataGridTheme(
                          data: SfDataGridThemeData(
                            gridLineColor: Colors.green,
                            selectionColor: Colors.blue,
                          ),
                          child: SfDataGrid(
                            // allowEditing: true,
                            controller: _dataGridController,
                            columnWidthCalculationRange:
                                ColumnWidthCalculationRange.visibleRows,
                            gridLinesVisibility: GridLinesVisibility.both,
                            headerGridLinesVisibility: GridLinesVisibility.both,
                            selectionMode: SelectionMode.single,
                            navigationMode: GridNavigationMode.cell,
                            source: commonDataSource,
                            columnWidthMode: ColumnWidthMode.fill,
                            // editingGestureType: EditingGestureType.doubleTap,
                            sortingGestureType: SortingGestureType.doubleTap,
                            onCellTap: (data) {
                              calculateBuildWidgetState.set(
                                  listNodes.singleWhere((element) =>
                                      element.nom ==
                                      commonDataSource.dataGridRows[
                                              data.rowColumnIndex.rowIndex - 1]
                                          .getCells()[0]
                                          .value));
                              // setState(() {
                              //   curListNode = listNodes.singleWhere((element) =>
                              //       element.nom ==
                              //       commonDataSource.dataGridRows[
                              //               data.rowColumnIndex.rowIndex - 1]
                              //           .getCells()[0]
                              //           .value);
                              // });
                            },
                            // onSelectionChanged: (cur, old) {
                            //   print(cur[0].getCells()[0].value);
                            //   setState(() {
                            //     curListNode = listNodes.singleWhere((element) =>
                            //         element.nom == cur[0].getCells()[0].value);
                            //   });
                            // },
                            columns: [
                              GridColumn(
                                visible: true,
                                allowEditing: true,
                                columnName: 'nom',
                                label: Container(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 16.0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    '位号',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              GridColumn(
                                visible: true,
                                columnName: 'delete',
                                label: Container(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 16.0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    '删除',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () {
                      ///todo:添加
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => Dialog(
                          child: DataEditScreen(
                            listNodes: listNodes,
                          ),
                        ),
                      ).then((v) {
                        if (v != null) {
                          setState(() {});
                        }
                      });
                    },
                    icon: Icon(Icons.add),
                    tooltip: '添加',
                  ),
                  IconButton(
                    onPressed: () async {
                      final bytes = await pickExcelCsv();
                      if (bytes != null) {
                        final result = extractDataFromExcel(bytes: bytes);
                        listNodes.addAll(
                          List.from(result).map((e) => ListNode(
                                nom: InitCalculate.fromJson(e).nom,
                                data: InitCalculate.fromJson(e),
                                ans: CalculateLogic.calculate(
                                    InitCalculate.fromJson(e)),
                              )),
                        );
                        setState(() {});
                      }
                    },
                    icon: Icon(Icons.add_box_outlined),
                    tooltip: '批量添加',
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  ///右侧数据计算
  Widget buildCalculate() {
    return CalculateBuildWidget(
      curListNode: curListNode,
      calculate: (cur, res) {
        print(cur.toString());
        print(listNodes.map((e) => e.nom).toList());
        if (!listNodes.map((e) => e.nom).toList().contains(cur.nom)) {
          cur as ListNode;
          cur.ans = res;
          listNodes.add(cur);
        }
        setState(() {});
      },
    );
    // InitCalculate initCalculate = curListNode.data ?? InitCalculate();
    // CalculateResult calculateResult = curListNode.ans ?? CalculateResult();
    // return Flexible(
    //   flex: 8,
    //   child: Container(
    //     padding: EdgeInsets.symmetric(horizontal: 20),
    //     child: ListView(
    //       // crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         //标题
    //         Align(
    //           alignment: Alignment.center,
    //           child: Text(
    //             '数据详情',
    //             style: TextStyle(
    //               fontWeight: FontWeight.bold,
    //               fontSize: 20,
    //             ),
    //           ),
    //         ),
    //         //计算前置基础信息
    //         Row(
    //           children: [
    //             Text(
    //               '当前位号:',
    //               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
    //             ),
    //             Text(
    //               initCalculate.nom ?? '',
    //               style: TextStyle(
    //                   fontWeight: FontWeight.normal,
    //                   fontSize: 18,
    //                   fontStyle: FontStyle.italic),
    //             )
    //           ],
    //         ),
    //         Container(
    //           padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
    //           decoration: BoxDecoration(
    //               borderRadius: BorderRadius.circular(30),
    //               border: Border.all(color: Colors.black)),
    //           child: Form(
    //             child: Wrap(
    //               children: [
    //                 Container(
    //                   width: 250,
    //                   child: TroInput(
    //                     label: '位号',
    //                     width: 200,
    //                     labelWidth: 100,
    //                     value: initCalculate.nom,
    //                     labelStyle: TextStyle(
    //                       fontSize: 12,
    //                     ),
    //                     onChange: (data) {
    //                       initCalculate.nom = data;
    //                     },
    //                   ),
    //                 ),
    //                 Container(
    //                   width: 250,
    //                   child: TroInput(
    //                     label: '套管大径',
    //                     width: 200,
    //                     labelWidth: 100,
    //                     value: '${initCalculate.diameterA ?? '请输入'}',
    //                     labelStyle: TextStyle(
    //                       fontSize: 12,
    //                     ),
    //                     onChange: (data) {
    //                       initCalculate.diameterA = num.tryParse(data);
    //                     },
    //                   ),
    //                 ),
    //                 Container(
    //                   width: 250,
    //                   child: TroInput(
    //                     label: '套管小径',
    //                     width: 200,
    //                     labelWidth: 100,
    //                     value: '${initCalculate.diameterB ?? '请输入'}',
    //                     labelStyle: TextStyle(
    //                       fontSize: 12,
    //                     ),
    //                     onChange: (data) {
    //                       initCalculate.diameterB = num.tryParse(data);
    //                     },
    //                   ),
    //                 ),
    //                 Container(
    //                   width: 250,
    //                   child: TroInput(
    //                     label: '套管孔径',
    //                     width: 200,
    //                     labelWidth: 100,
    //                     value: '${initCalculate.diameterHole ?? '请输入'}',
    //                     labelStyle: TextStyle(
    //                       fontSize: 12,
    //                     ),
    //                     onChange: (data) {
    //                       initCalculate.diameterHole = num.tryParse(data);
    //                     },
    //                   ),
    //                 ),
    //                 Container(
    //                   width: 250,
    //                   child: TroInput(
    //                     label: '插深(mm)',
    //                     width: 200,
    //                     labelWidth: 100,
    //                     value: '${initCalculate.insertDeep ?? '请输入'}',
    //                     labelStyle: TextStyle(
    //                       fontSize: 12,
    //                     ),
    //                     onChange: (data) {
    //                       initCalculate.insertDeep = num.tryParse(data);
    //                     },
    //                   ),
    //                 ),
    //                 Container(
    //                   width: 250,
    //                   child: TroInput(
    //                     label: '凸台(mm)',
    //                     width: 200,
    //                     labelWidth: 100,
    //                     value: '${initCalculate.boss ?? '请输入'}',
    //                     labelStyle: TextStyle(
    //                       fontSize: 12,
    //                     ),
    //                     onChange: (data) {
    //                       initCalculate.boss = num.tryParse(data);
    //                     },
    //                   ),
    //                 ),
    //                 Container(
    //                   width: 250,
    //                   child: TroInput(
    //                     label: '管线尺寸(in)',
    //                     width: 200,
    //                     labelWidth: 100,
    //                     value: '${initCalculate.pipeSize ?? '请输入'}',
    //                     labelStyle: TextStyle(
    //                       fontSize: 12,
    //                     ),
    //                     onChange: (data) {
    //                       initCalculate.pipeSize = num.tryParse(data);
    //                     },
    //                   ),
    //                 ),
    //                 Container(
    //                   width: 250,
    //                   child: TroInput(
    //                     label: '使用温度(℃)',
    //                     width: 200,
    //                     labelWidth: 100,
    //                     value: '${initCalculate.tmp ?? '请输入'}',
    //                     labelStyle: TextStyle(
    //                       fontSize: 12,
    //                     ),
    //                     onChange: (data) {
    //                       initCalculate.tmp = num.tryParse(data);
    //                     },
    //                   ),
    //                 ),
    //                 Container(
    //                   width: 250,
    //                   child: TroInput(
    //                     label: '弹性模量(106psi)',
    //                     width: 200,
    //                     labelWidth: 100,
    //                     value: '${initCalculate.elasticModulus ?? '请输入'}',
    //                     labelStyle: TextStyle(
    //                       fontSize: 12,
    //                     ),
    //                     onChange: (data) {
    //                       initCalculate.elasticModulus = num.tryParse(data);
    //                     },
    //                   ),
    //                 ),
    //                 Container(
    //                   width: 250,
    //                   child: TroInput(
    //                     label: '材质密度(kg/m3)',
    //                     width: 200,
    //                     labelWidth: 100,
    //                     value: '${initCalculate.densityOfMaterial ?? '请输入'}',
    //                     labelStyle: TextStyle(
    //                       fontSize: 12,
    //                     ),
    //                     onChange: (data) {
    //                       initCalculate.densityOfMaterial = num.tryParse(data);
    //                     },
    //                   ),
    //                 ),
    //                 Container(
    //                   width: 250,
    //                   child: TroInput(
    //                     label: '介质流速(m/s)',
    //                     width: 200,
    //                     labelWidth: 100,
    //                     value: '${initCalculate.flowRate ?? '请输入'}',
    //                     labelStyle: TextStyle(
    //                       fontSize: 12,
    //                     ),
    //                     onChange: (data) {
    //                       initCalculate.flowRate = num.tryParse(data);
    //                     },
    //                   ),
    //                 ),
    //                 Container(
    //                   width: 250,
    //                   child: TroInput(
    //                     label: '黏度(Ns/m2)',
    //                     width: 200,
    //                     labelWidth: 100,
    //                     value: '${initCalculate.viscosity ?? '请输入'}',
    //                     labelStyle: TextStyle(
    //                       fontSize: 12,
    //                     ),
    //                     onChange: (data) {
    //                       initCalculate.viscosity = num.tryParse(data);
    //                     },
    //                   ),
    //                 ),
    //                 Container(
    //                   width: 250,
    //                   child: TroInput(
    //                     label: '阻力系数',
    //                     width: 200,
    //                     labelWidth: 100,
    //                     value: '${initCalculate.resistanceE ?? '请输入'}',
    //                     labelStyle: TextStyle(
    //                       fontSize: 12,
    //                     ),
    //                     onChange: (data) {
    //                       initCalculate.resistanceE = num.tryParse(data);
    //                     },
    //                   ),
    //                 ),
    //                 Container(
    //                   width: 250,
    //                   child: TroInput(
    //                     label: '流体密度(kg/m3)',
    //                     width: 200,
    //                     labelWidth: 100,
    //                     value: '${initCalculate.densityOfFlow ?? '请输入'}',
    //                     labelStyle: TextStyle(
    //                       fontSize: 12,
    //                     ),
    //                     onChange: (data) {
    //                       initCalculate.densityOfFlow = num.tryParse(data);
    //                     },
    //                   ),
    //                 ),
    //                 Container(
    //                   width: 250,
    //                   child: TroInput(
    //                     label: '压力(MPa)',
    //                     width: 200,
    //                     labelWidth: 100,
    //                     value: '${initCalculate.pressure ?? '请输入'}',
    //                     labelStyle: TextStyle(
    //                       fontSize: 12,
    //                     ),
    //                     onChange: (data) {
    //                       initCalculate.pressure = num.tryParse(data);
    //                     },
    //                   ),
    //                 ),
    //                 Container(
    //                   width: 250,
    //                   child: TroInput(
    //                     label: '许用应力(MPa)',
    //                     width: 200,
    //                     labelWidth: 100,
    //                     value: '${initCalculate.stressAllowable ?? '请输入'}',
    //                     labelStyle: TextStyle(
    //                       fontSize: 12,
    //                     ),
    //                     onChange: (data) {
    //                       initCalculate.stressAllowable = num.tryParse(data);
    //                     },
    //                   ),
    //                 ),
    //                 Container(
    //                   width: 250,
    //                   child: TroInput(
    //                     label: '共振Cl',
    //                     width: 200,
    //                     labelWidth: 100,
    //                     value: '${initCalculate.resonance ?? '请输入'}',
    //                     labelStyle: TextStyle(
    //                       fontSize: 12,
    //                     ),
    //                     onChange: (data) {
    //                       initCalculate.resonance = num.tryParse(data);
    //                     },
    //                   ),
    //                 ),
    //                 Container(
    //                   width: 250,
    //                   child: TroSelect(
    //                     value: initCalculate.connection,
    //                     dataList: [
    //                       SelectOptionVO(value: '法兰', label: '法兰'),
    //                       SelectOptionVO(value: '焊接', label: '焊接'),
    //                       SelectOptionVO(value: '螺纹', label: '螺纹'),
    //                     ],
    //                     label: '工艺连接',
    //                     width: 200,
    //                     labelWidth: 100,
    //                     labelStyle: TextStyle(
    //                       fontSize: 12,
    //                     ),
    //                     onChange: (data) {
    //                       initCalculate.connection = data;
    //                     },
    //                   ),
    //                 ),
    //                 Row(
    //                   mainAxisAlignment: MainAxisAlignment.end,
    //                   children: [
    //                     Container(
    //                         alignment: Alignment.centerRight,
    //                         decoration: BoxDecoration(
    //                             borderRadius: BorderRadius.circular(12),
    //                             border: Border.all(width: 1)),
    //                         width: 80,
    //                         height: 50,
    //                         child: Center(
    //                           child: TextButton(
    //                             onPressed: () {
    //                               CalculateResult res =
    //                                   CalculateLogic.calculate(initCalculate) ??
    //                                       CalculateResult();
    //                               listNodes
    //                                   .singleWhere((element) =>
    //                                       element.nom == curListNode.nom)
    //                                   .ans = res;
    //                               setState(() {});
    //                             },
    //                             child: Text(
    //                               '计算',
    //                               style: TextStyle(fontSize: 18),
    //                             ),
    //                           ),
    //                         )),
    //                   ],
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ),
    //         //充当margin
    //         SizedBox(
    //           height: 50,
    //         ),
    //         //计算结果
    //         Text(
    //           '计算结果:',
    //           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
    //         ),
    //         Container(
    //           padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
    //           decoration: BoxDecoration(
    //               borderRadius: BorderRadius.circular(30),
    //               border: Border.all(color: Colors.black)),
    //           child: Form(
    //             child: Wrap(
    //               children: [
    //                 Container(
    //                   width: 250,
    //                   child: TroInput(
    //                     enable: false,
    //                     label: '系数Kf',
    //                     width: 200,
    //                     labelWidth: 100,
    //                     value: '${calculateResult.kF ?? '等待计算'}',
    //                     labelStyle: TextStyle(
    //                       fontSize: 12,
    //                     ),
    //                   ),
    //                 ),
    //                 Container(
    //                   width: 250,
    //                   child: TroInput(
    //                     enable: false,
    //                     label: '自振频率fn(Hz)',
    //                     width: 200,
    //                     labelWidth: 100,
    //                     value: '${calculateResult.naturalFre ?? '等待计算'}',
    //                     labelStyle: TextStyle(
    //                       fontSize: 12,
    //                     ),
    //                   ),
    //                 ),
    //                 Container(
    //                   width: 250,
    //                   child: TroInput(
    //                     enable: false,
    //                     label: '激励频率fw(Hz)',
    //                     width: 200,
    //                     labelWidth: 100,
    //                     value: '${calculateResult.excFrequency ?? '等待计算'}',
    //                     labelStyle: TextStyle(
    //                       fontSize: 12,
    //                     ),
    //                   ),
    //                 ),
    //                 Container(
    //                   width: 250,
    //                   child: TroInput(
    //                     enable: false,
    //                     label: '频率比',
    //                     width: 200,
    //                     labelWidth: 100,
    //                     value: '${calculateResult.freRatio ?? '等待计算'}',
    //                     valueStyle: TextStyle(
    //                       color: (calculateResult.freRatio ?? 0) < 0.8
    //                           ? Colors.red
    //                           : Colors.green,
    //                     ),
    //                     labelStyle: TextStyle(
    //                       fontSize: 12,
    //                     ),
    //                   ),
    //                 ),
    //                 Container(
    //                   width: 250,
    //                   child: TroInput(
    //                     enable: false,
    //                     label: 'Re',
    //                     width: 200,
    //                     labelWidth: 100,
    //                     value: '${calculateResult.rE ?? '等待计算'}',
    //                     labelStyle: TextStyle(
    //                       fontSize: 12,
    //                     ),
    //                   ),
    //                 ),
    //                 Container(
    //                   width: 250,
    //                   child: TroInput(
    //                     enable: false,
    //                     label: '截面A(m2)',
    //                     width: 200,
    //                     labelWidth: 100,
    //                     value: '${calculateResult.section ?? '等待计算'}',
    //                     labelStyle: TextStyle(
    //                       fontSize: 12,
    //                     ),
    //                   ),
    //                 ),
    //                 Container(
    //                   width: 250,
    //                   child: TroInput(
    //                     enable: false,
    //                     label: '流体力F(N)',
    //                     width: 200,
    //                     labelWidth: 100,
    //                     value: '${calculateResult.fluidForce ?? '等待计算'}',
    //                     labelStyle: TextStyle(
    //                       fontSize: 12,
    //                     ),
    //                   ),
    //                 ),
    //                 Container(
    //                   width: 250,
    //                   child: TroInput(
    //                     enable: false,
    //                     label: '根部弯矩M(N*mm)',
    //                     width: 200,
    //                     labelWidth: 100,
    //                     value: '${calculateResult.bendingDistance ?? '等待计算'}',
    //                     labelStyle: TextStyle(
    //                       fontSize: 12,
    //                     ),
    //                   ),
    //                 ),
    //                 Container(
    //                   width: 250,
    //                   child: TroInput(
    //                     enable: false,
    //                     label: '根部弯应力σB(MPa)',
    //                     width: 200,
    //                     labelWidth: 100,
    //                     value: '${calculateResult.fatigue ?? '等待计算'}',
    //                     labelStyle: TextStyle(
    //                       fontSize: 12,
    //                     ),
    //                   ),
    //                 ),
    //                 Container(
    //                   width: 250,
    //                   child: TroInput(
    //                     enable: false,
    //                     label: '外压应力σP(MPa)',
    //                     width: 200,
    //                     labelWidth: 100,
    //                     value: '${calculateResult.stressOutside ?? '等待计算'}',
    //                     labelStyle: TextStyle(
    //                       fontSize: 12,
    //                     ),
    //                   ),
    //                 ),
    //                 Container(
    //                   width: 250,
    //                   child: TroInput(
    //                     enable: false,
    //                     label: '共振流速Vr(m/s)',
    //                     width: 200,
    //                     labelWidth: 100,
    //                     value: '${calculateResult.speedResonance ?? '等待计算'}',
    //                     labelStyle: TextStyle(
    //                       fontSize: 12,
    //                     ),
    //                   ),
    //                 ),
    //                 Container(
    //                   width: 250,
    //                   child: TroInput(
    //                     enable: false,
    //                     label: '共振Re',
    //                     width: 200,
    //                     labelWidth: 100,
    //                     value: '${calculateResult.resonanceRe ?? '等待计算'}',
    //                     labelStyle: TextStyle(
    //                       fontSize: 12,
    //                     ),
    //                   ),
    //                 ),
    //                 Container(
    //                   width: 250,
    //                   child: TroInput(
    //                     enable: false,
    //                     label: '共振FL(N)',
    //                     width: 200,
    //                     labelWidth: 100,
    //                     value: '${calculateResult.resonanceFL ?? '等待计算'}',
    //                     labelStyle: TextStyle(
    //                       fontSize: 12,
    //                     ),
    //                   ),
    //                 ),
    //                 Container(
    //                   width: 250,
    //                   child: TroInput(
    //                     enable: false,
    //                     label: '共振弯矩',
    //                     width: 200,
    //                     labelWidth: 100,
    //                     value: '${calculateResult.resonanceML ?? '等待计算'}',
    //                     labelStyle: TextStyle(
    //                       fontSize: 12,
    //                     ),
    //                   ),
    //                 ),
    //                 Container(
    //                   width: 250,
    //                   child: TroInput(
    //                     enable: false,
    //                     label: '共振根部弯应力σrB(MPa)',
    //                     width: 200,
    //                     labelWidth: 100,
    //                     value: '${calculateResult.resonanceFatigue ?? '等待计算'}',
    //                     labelStyle: TextStyle(
    //                       fontSize: 12,
    //                     ),
    //                   ),
    //                 ),
    //                 Container(
    //                   width: 250,
    //                   child: TroInput(
    //                     enable: false,
    //                     label: '疲劳许用应力σra(MPa)',
    //                     width: 200,
    //                     labelWidth: 100,
    //                     value: '${calculateResult.stressFatigue ?? '等待计算'}',
    //                     labelStyle: TextStyle(
    //                       fontSize: 12,
    //                     ),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ),
    //         //充当margin
    //         SizedBox(
    //           height: 50,
    //         ),
    //         //最终结果（是否合格）
    //         Row(
    //           children: [
    //             Text(
    //               '是否合格:',
    //               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
    //             ),
    //             SizedBox(
    //               width: 20,
    //             ),
    //             Text(
    //               calculateResult.isQualified ?? false ? '合格' : '不合格',
    //               style: TextStyle(
    //                   fontWeight: FontWeight.bold,
    //                   fontSize: 30,
    //                   color: calculateResult.isQualified ?? false
    //                       ? Colors.green
    //                       : Colors.red),
    //             ),
    //           ],
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
