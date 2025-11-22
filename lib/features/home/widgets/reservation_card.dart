import 'package:flutter/material.dart';

class ReservationCard extends StatefulWidget {
  const ReservationCard({Key? key}) : super(key: key);

  @override
  State<ReservationCard> createState() => _ReservationCardState();
}

class _ReservationCardState extends State<ReservationCard> {
  String? depart;
  String? destination;
  DateTime? departDate;
  int passengers = 1;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text('Commencer une réservation!', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          const Text('Bienvenue chez nous', style: TextStyle(color: Colors.black54)),
          const SizedBox(height: 12),

          _FieldTile(icon: Icons.navigation, label: 'Ville de Départ', value: depart, onTap: () async {
            final res = await _showInputDialog(context, 'Ville de Départ');
            if (res != null) setState(() => depart = res);
          }),

          const SizedBox(height: 10),
          _FieldTile(icon: Icons.place, label: 'Ville de Destination', value: destination, onTap: () async {
            final res = await _showInputDialog(context, 'Ville de Destination');
            if (res != null) setState(() => destination = res);
          }),

          const SizedBox(height: 10),
          _FieldTile(icon: Icons.calendar_today, label: 'Date de départ', value: departDate == null ? null : '${departDate!.day}/${departDate!.month}/${departDate!.year}', onTap: () async {
            final now = DateTime.now();
            final picked = await showDatePicker(context: context, initialDate: now, firstDate: now, lastDate: DateTime(now.year + 2));
            if (picked != null) setState(() => departDate = picked);
          }),

          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: const Offset(0, 2))]),
            child: ListTile(
              leading: const Icon(Icons.group, color: Colors.orange),
              title: const Text('Nombre de Passagers'),
              trailing: DropdownButton<int>(value: passengers, items: List.generate(5, (i) => i + 1).map((e) => DropdownMenuItem(value: e, child: Text(e.toString()))).toList(), onChanged: (v) => setState(() => passengers = v ?? 1)),
            ),
          ),

          const SizedBox(height: 12),
          ElevatedButton(onPressed: () {}, child: const Text('Continuer'))
        ]),
      ),
    );
  }

  Future<String?> _showInputDialog(BuildContext context, String title) async {
    final controller = TextEditingController();
    return showDialog<String>(context: context, builder: (context) => AlertDialog(title: Text(title), content: TextField(controller: controller), actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Annuler')), TextButton(onPressed: () => Navigator.of(context).pop(controller.text.trim()), child: const Text('OK'))]));
  }
}

class _FieldTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final VoidCallback? onTap;
  const _FieldTile({required this.icon, required this.label, this.value, this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: const Offset(0, 2))]),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(label),
        subtitle: value == null ? null : Text(value!),
        trailing: IconButton(icon: const Icon(Icons.edit), onPressed: onTap),
      ),
    );
  }
}
