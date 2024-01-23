import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

///这是数据展示列表那边的数据模型
class ListNode {
  String? nom;
  String? state;
  InitCalculate? data;
  CalculateResult? ans;

  ListNode({this.nom, this.state, this.data, this.ans});

  ListNode copyWith(
          {String? nom,
          String? state,
          InitCalculate? data,
          CalculateResult? ans}) =>
      ListNode(
          nom: this.nom, state: this.state, data: this.data, ans: this.ans);
}

///这是具体数据包含的内容（入参：计算之前的）
class InitCalculate {
  //位号
  String? nom;

  //套管大径A(mm)
  num? diameterA;

  //套管小径B(mm)
  num? diameterB;

  //套管孔径d(mm)
  num? diameterHole;

  //插深U(mm)
  num? insertDeep;

  //凸台H(mm)
  num? boss;

  //管线尺寸(cm)#{in =cm * 0.39370}[!]//计算是要用in来算的
  num? pipeSize;

  //使用温度(℃)
  num? tmp;

  //弹性模量E(106psi)
  num? elasticModulus;

  //材质密度[这里入参用kg/m3]γ(lb/in3)
  num? densityOfMaterial;

  //介质流速[m/s]
  num? flowRate;

  //黏度μ(Ns/m2)
  num? viscosity;

  //阻力系数Cd
  num? resistanceE;

  //流体密度ρ(kg/m3)
  num? densityOfFlow;

  //压力P(MPa)
  num? pressure;

  //许用应力σa(MPa)
  num? stressAllowable;

  //共振Cl
  num? resonance;

  //工艺连接
  String? connection;

  InitCalculate(
      {this.nom,
      this.diameterA,
      this.diameterB,
      this.diameterHole,
      this.insertDeep,
      this.boss,
      this.pipeSize,
      this.tmp,
      this.elasticModulus,
      this.densityOfMaterial,
      this.flowRate,
      this.viscosity,
      this.resistanceE,
      this.densityOfFlow,
      this.pressure,
      this.stressAllowable,
      this.resonance,
      this.connection});

  InitCalculate.fromJson(dynamic json) {
    nom = json['位号'].toString();
    diameterA = json['套管大径A'];
    diameterB = json['套管小径B'];
    diameterHole = json['套管孔径'];
    insertDeep = json['插深'];
    boss = json['凸台'];
    pipeSize = json['管线尺寸'];
    tmp = json['使用温度'];
    elasticModulus = json['弹性模量'];
    densityOfMaterial = json['材质密度'];
    flowRate = json['介质流速'];
    viscosity = json['黏度'];
    resistanceE = json['阻力系数'];
    densityOfFlow = json['流体密度'];
    pressure = json['压力'];
    stressAllowable = json['许用应力'];
    resonance = json['共振'];
    connection = json['工艺连接'].toString();
  }

  @override
  String toString() {
    return 'InitCalculate{nom: $nom, diameterA: $diameterA, diameterB: $diameterB, diameterHole: $diameterHole, insertDeep: $insertDeep, boss: $boss, pipeSize: $pipeSize, tmp: $tmp, elasticModulus: $elasticModulus, densityOfMaterial: $densityOfMaterial, flowRate: $flowRate, viscosity: $viscosity, resistanceE: $resistanceE, densityOfFlow: $densityOfFlow, pressure: $pressure, stressAllowable: $stressAllowable, resonance: $resonance, connection: $connection,}';
  }
}

///这是数据计算之后应该的展示的内容
class CalculateResult {
  //是否符合标准（最重要）
  bool? isQualified;

  //外压应力
  // σP(MPa)
  num? stressOutside;

  //根部弯距M(N*mm)
  num? bendingDistance;

  //流体力
  num? fluidForce;

  //截面
  // A(m2)
  num? section;

  num? rE;

  num? kF;

  //激励频率
  num? excFrequency;

  //共振流速
  // Vr(m/s)
  num? speedResonance;

  //自振频率Hz
  num? naturalFre;

  //频率比
  num? freRatio;

  //共振根部弯应力(MPa)
  num? resonanceFatigue;

  //根部弯应力(MPa)
  num? fatigue;

  //疲劳应力Mpa
  num? stressFatigue;

  //共振Re
  num? resonanceRe;

  //共振FL
  num? resonanceFL;

  //共振弯矩
  // ML(N*mm)
  num? resonanceML;

  num? x;
  num? y;
  num? z;
  num? a;

  CalculateResult(
      {this.isQualified,
      this.stressOutside,
      this.bendingDistance,
      this.fluidForce,
      this.section,
      this.fatigue,
      this.rE,
      this.excFrequency,
      this.speedResonance,
      this.naturalFre,
      this.freRatio,
      this.resonanceFatigue,
      this.stressFatigue,
      this.resonanceRe,
      this.resonanceFL});

  @override
  String toString() {
    return 'CalculateResult{isQualified: $isQualified, stressOutside: $stressOutside, bendingDistance: $bendingDistance, fluidForce: $fluidForce, section: $section, rE: $rE, kF: $kF, excFrequency: $excFrequency, speedResonance: $speedResonance, naturalFre: $naturalFre, freRatio: $freRatio, resonanceFatigue: $resonanceFatigue, fatigue: $fatigue, stressFatigue: $stressFatigue, resonanceRe: $resonanceRe, resonanceFL: $resonanceFL, resonanceML: $resonanceML, x: $x, y: $y, z: $z, a: $a}';
  }
}

class CommonDataSource extends DataGridSource {
  CommonDataSource({
    required List<ListNode> commonData,
    required Function editNom,
    required Function editState,
    required Function deleteNode,
  }) {
    dataGridRows = commonData.map<DataGridRow>((dataGridRow) {
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'nom', value: dataGridRow.nom),
        DataGridCell<String>(columnName: 'state', value: dataGridRow.state),
        DataGridCell<Widget>(
            columnName: 'delete',
            value: IconButton(
              onPressed: () {
                deleteNode.call(dataGridRow.nom);
              },
              icon: Icon(Icons.delete_outlined),
            )),
      ]);
    }).toList();
    editNomFun = editNom;
    editStateFun = editState;
  }

  List<DataGridRow> dataGridRows = [];

  //编辑位号
  Function? editNomFun;

  //编辑状态
  Function? editStateFun;

  //删除按钮
  Function? deleteNodeFun;

  @override
  List<DataGridRow> get rows => dataGridRows;

  /// Helps to hold the new value of all editable widgets.
  /// Based on the new value we will commit the new value into the corresponding
  /// DataGridCell on the onCellSubmit method.
  dynamic newCellValue;

  /// Helps to control the editable text in the [TextField] widget.
  TextEditingController editingController = TextEditingController();

  @override
  Future<void> onCellSubmit(DataGridRow dataGridRow,
      RowColumnIndex rowColumnIndex, GridColumn column) async {
    final dynamic oldValue = dataGridRow
            .getCells()
            .firstWhere((DataGridCell dataGridCell) =>
                dataGridCell.columnName == column.columnName)
            .value ??
        '';

    final int dataRowIndex = dataGridRows.indexOf(dataGridRow);

    if (newCellValue == null || oldValue == newCellValue) {
      return;
    }

    if (column.columnName == 'nom') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'nom', value: newCellValue);
      editNomFun?.call(dataRowIndex, newCellValue);
    } else if (column.columnName == 'state') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'state', value: newCellValue);
      editStateFun?.call(dataRowIndex, newCellValue);
      // _employees[dataRowIndex].name = newCellValue.toString();
    }
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      if (dataGridCell.columnName == 'delete') {
        return Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: dataGridCell.value);
      } else {
        return Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              dataGridCell.value.toString(),
              overflow: TextOverflow.ellipsis,
            ));
      }
    }).toList());
  }

  @override
  Widget? buildEditWidget(DataGridRow dataGridRow,
      RowColumnIndex rowColumnIndex, GridColumn column, CellSubmit submitCell) {
    // Text going to display on editable widget
    final String displayText = dataGridRow
            .getCells()
            .firstWhere((DataGridCell dataGridCell) =>
                dataGridCell.columnName == column.columnName)
            .value
            ?.toString() ??
        '';

    // The new cell value must be reset.
    // To avoid committing the [DataGridCell] value that was previously edited
    // into the current non-modified [DataGridCell].
    newCellValue = null;
    if (column.columnName == 'delete') {
      return null;
    }

    return Container(
      padding: const EdgeInsets.all(8.0),
      alignment: Alignment.centerLeft,
      child: TextField(
        autofocus: true,
        controller: editingController..text = displayText,
        textAlign: TextAlign.left,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
        ),
        keyboardType: TextInputType.multiline,
        onChanged: (String value) {
          if (value.isNotEmpty) {
            newCellValue = value;
          } else {
            newCellValue = null;
          }
        },
        onSubmitted: (String value) {
          // In Mobile Platform.
          // Call [CellSubmit] callback to fire the canSubmitCell and
          // onCellSubmit to commit the new value in single place.

          submitCell();
        },
      ),
    );
  }
}
