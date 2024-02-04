import 'package:oem_huining_anhui/model/list_node.dart';

void main() {
  ListNode listNode = ListNode(
      nom: '1',
      data: InitCalculate(
          nom: '46',
          diameterA: 23,
          diameterB: 21,
          diameterHole: 7,
          insertDeep: 370,
          boss: 150,
          pipeSize: 14,
          tmp: 260,
          elasticModulus: 23.2,
          densityOfMaterial: 0.29,
          flowRate: 16.4,
          viscosity: 1,
          resistanceE: 8.2,
          densityOfFlow: 0.09,
          pressure: 8.3,
          stressAllowable: 134.8,
          resonance: 7.6,
          connection: '法兰',
          material: '316',
          curXX: 1,
          curYY: 1),
      ans: CalculateResult());
  ListNode node = listNode.copy();
  ListNode node1 = ListNode.copyWith(listNode);
  node.data?.material = '123';
  node.nom = '123';
  print(node.data);
  print(node1.data);
  print(listNode.data);
  print(node.nom);
  print(node1.nom);
  print(listNode.nom);
}
