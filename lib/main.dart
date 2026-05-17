import 'package:flutter/material.dart';

void main() => runApp(const ServiceBookingApp());

class ServiceBookingApp extends StatelessWidget {
  const ServiceBookingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GK Service Booking',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD4A95A),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF090D16),
        fontFamily: 'Roboto',
      ),
      home: const BookingHomePage(),
    );
  }
}

class ServiceOption {
  const ServiceOption(this.name, this.description, this.price, this.duration);

  final String name;
  final String description;
  final int price;
  final String duration;
}

const services = <ServiceOption>[
  ServiceOption(
    'MVP Planning Session',
    'Scope, core flows, launch priorities, risks, and technical direction.',
    180,
    '90 min',
  ),
  ServiceOption(
    'Flutter App Prototype',
    'Clickable cross-platform UI prototype for validating a product idea.',
    750,
    '5 days',
  ),
  ServiceOption(
    'Android App Refactor',
    'Architecture review, UI cleanup, performance pass, and technical plan.',
    520,
    '3 days',
  ),
];

class BookingHomePage extends StatefulWidget {
  const BookingHomePage({super.key});

  @override
  State<BookingHomePage> createState() => _BookingHomePageState();
}

class _BookingHomePageState extends State<BookingHomePage> {
  int selectedService = 1;
  int selectedSlot = 0;
  final slots = const ['Today 16:30', 'Tomorrow 10:00', 'Friday 14:00'];

  @override
  Widget build(BuildContext context) {
    final service = services[selectedService];
    final width = MediaQuery.sizeOf(context).width;
    final isWide = width >= 820;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF090D16), Color(0xFF101827), Color(0xFF0B111D)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1080),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _Header(),
                    const SizedBox(height: 32),
                    isWide
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: _ServicePicker(selectedService, _selectService)),
                              const SizedBox(width: 20),
                              Expanded(child: _BookingSummary(service, slots[selectedSlot])),
                            ],
                          )
                        : Column(
                            children: [
                              _ServicePicker(selectedService, _selectService),
                              const SizedBox(height: 20),
                              _BookingSummary(service, slots[selectedSlot]),
                            ],
                          ),
                    const SizedBox(height: 20),
                    _SlotPicker(slots, selectedSlot, (index) => setState(() => selectedSlot = index)),
                    const SizedBox(height: 20),
                    const _TrustStrip(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _selectService(int index) => setState(() => selectedService = index);
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('GK Coding', style: TextStyle(color: Color(0xFFD4A95A), fontWeight: FontWeight.w800)),
          const SizedBox(height: 18),
          Text(
            'Service booking flow for modern software businesses.',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 12),
          Text(
            'A real Flutter demo showing responsive layout, selectable services, appointment slots, and conversion-focused summary UI.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: const Color(0xFFB7C1D6), height: 1.55),
          ),
        ],
      ),
    );
  }
}

class _ServicePicker extends StatelessWidget {
  const _ServicePicker(this.selectedIndex, this.onSelect);

  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Choose a service', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 14),
        for (var i = 0; i < services.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _SelectableCard(
              selected: selectedIndex == i,
              onTap: () => onSelect(i),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(services[i].name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17))),
                      Text('€${services[i].price}', style: const TextStyle(color: Color(0xFFD4A95A), fontWeight: FontWeight.w900)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(services[i].description, style: const TextStyle(color: Color(0xFFB7C1D6), height: 1.45)),
                  const SizedBox(height: 10),
                  Text(services[i].duration, style: const TextStyle(color: Color(0xFFD4A95A))),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _SlotPicker extends StatelessWidget {
  const _SlotPicker(this.slots, this.selectedIndex, this.onSelect);

  final List<String> slots;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Preferred slot', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 14),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (var i = 0; i < slots.length; i++)
              ChoiceChip(
                selected: selectedIndex == i,
                label: Text(slots[i]),
                onSelected: (_) => onSelect(i),
              ),
          ],
        ),
      ],
    );
  }
}

class _BookingSummary extends StatelessWidget {
  const _BookingSummary(this.service, this.slot);

  final ServiceOption service;
  final String slot;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(colors: [Color(0xFFD4A95A), Color(0xFFF1CE83)]),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Booking summary', style: TextStyle(color: Color(0xFF111827), fontWeight: FontWeight.w900, fontSize: 24)),
          const SizedBox(height: 16),
          _SummaryLine('Selected', service.name),
          _SummaryLine('Slot', slot),
          _SummaryLine('Estimate', '€${service.price} · ${service.duration}'),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () {},
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFF090D16)),
            child: const Text('Request project'),
          ),
        ],
      ),
    );
  }
}

class _SummaryLine extends StatelessWidget {
  const _SummaryLine(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF263244))),
          const SizedBox(width: 12),
          Expanded(child: Text(value, textAlign: TextAlign.right, style: const TextStyle(color: Color(0xFF111827), fontWeight: FontWeight.w800))),
        ],
      ),
    );
  }
}

class _SelectableCard extends StatelessWidget {
  const _SelectableCard({required this.selected, required this.onTap, required this.child});

  final bool selected;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: _cardDecoration(selected: selected),
        child: child,
      ),
    );
  }
}

class _TrustStrip extends StatelessWidget {
  const _TrustStrip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: const Wrap(
        spacing: 18,
        runSpacing: 10,
        children: [
          _TrustItem('Responsive UI'),
          _TrustItem('Local state'),
          _TrustItem('Premium theme'),
          _TrustItem('Conversion flow'),
        ],
      ),
    );
  }
}

class _TrustItem extends StatelessWidget {
  const _TrustItem(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text('• $text', style: const TextStyle(color: Color(0xFFB7C1D6), fontWeight: FontWeight.w700));
  }
}

BoxDecoration _cardDecoration({bool selected = false}) {
  return BoxDecoration(
    color: const Color(0xFF111827).withValues(alpha: 0.88),
    borderRadius: BorderRadius.circular(24),
    border: Border.all(color: selected ? const Color(0xFFD4A95A) : const Color(0xFF26344D)),
    boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 28, offset: Offset(0, 18))],
  );
}
