import 'package:flutter/material.dart';
import 'elena_colors.dart';
import 'package:flutter/cupertino.dart';

/// ------------------------------------------------------------
/// INPUTS DE TEXTO
/// ------------------------------------------------------------
class ElenaInput extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;

  final Widget? suffixIcon;

  const ElenaInput({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: ElenaColors.border),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}

/// Input numérico
class ElenaInputNumber extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final void Function(String?)? onChanged; // ← compatibilidad onboarding

  const ElenaInputNumber({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          onChanged: onChanged, // ← nuevo
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: ElenaColors.border),
              borderRadius: BorderRadius.circular(14),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: ElenaColors.border.withOpacity(0.6)),
              borderRadius: BorderRadius.circular(14),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: ElenaColors.primary, width: 2),
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ],
    );
  }
}

/// ------------------------------------------------------------
/// DATE PICKER
/// ------------------------------------------------------------
class ElenaDateInput extends StatelessWidget {
  final String label;
  final DateTime? value;
  final Function(DateTime) onChanged;

  const ElenaDateInput({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  void _showCupertinoDatePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      barrierColor: Colors.black26,
      builder: (_) {
        return SafeArea(
          child: Center(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 1.05, end: 1.0),
              duration: const Duration(milliseconds: 120),
              curve: Curves.easeOutCubic,
              builder: (context, scale, child) {
                return Transform.scale(
                  scale: scale,
                  child: child,
                );
              },
              child: Container(
                width: 420,
                height: 330,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    Expanded(
                      child: Listener(
                        onPointerSignal: (event) {
                          // Permite scroll con rueda del mouse en Web
                        },
                        child: CupertinoDatePicker(
                          mode: CupertinoDatePickerMode.date,
                          initialDateTime: value ?? DateTime(2000, 1, 1),
                          maximumDate: DateTime.now(),
                          onDateTimeChanged: onChanged,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: CupertinoButton(
                        color: ElenaColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: const Text(
                          "Listo",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showCupertinoDatePicker(context),
      child: AbsorbPointer(
        child: ElenaInput(
          label: label,
          hint: "Seleccionar fecha",
          controller: TextEditingController(
            text: value == null
                ? ""
                : "${value!.day}/${value!.month}/${value!.year}",
          ),
          suffixIcon: const Icon(Icons.calendar_today),
        ),
      ),
    );
  }
}

/// ------------------------------------------------------------
/// DROPDOWN (actualizado para onboarding)
/// ------------------------------------------------------------
class ElenaDropdown extends StatelessWidget {
  final String label;
  final List<String> options; // ← renombrado para coincidir con tu pantallas
  final String? value;
  final void Function(String?) onChanged;

  const ElenaDropdown({
    super.key,
    required this.label,
    required this.options,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        DropdownButtonFormField(
          value: value,
          items: options
              .map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  ))
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: ElenaColors.border),
              borderRadius: BorderRadius.circular(14),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: ElenaColors.border.withOpacity(0.6)),
              borderRadius: BorderRadius.circular(14),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: ElenaColors.primary, width: 2),
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ],
    );
  }
}

/// ------------------------------------------------------------
/// SELECTABLE CARD (actualizado para var "title")
/// ------------------------------------------------------------
class ElenaSelectableCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? emoji; // ← NUEVO
  final bool selected;
  final VoidCallback onTap;

  const ElenaSelectableCard({
    super.key,
    required this.title,
    this.subtitle,
    this.emoji,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        decoration: BoxDecoration(
          color:
              selected ? ElenaColors.primary.withOpacity(0.12) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? ElenaColors.primary
                : ElenaColors.border.withOpacity(0.4),
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // EMOJI IZQUIERDA
            if (emoji != null)
              Text(
                emoji!,
                style: const TextStyle(fontSize: 26),
              ),

            if (emoji != null) const SizedBox(width: 14),

            // TÍTULO + SUBTÍTULO
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color:
                          selected ? ElenaColors.primary : ElenaColors.textDark,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 13,
                        color: selected
                            ? ElenaColors.primary.withOpacity(0.9)
                            : ElenaColors.textSecondary,
                      ),
                    ),
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Grid reusando el selectable
class ElenaGridSelectable extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const ElenaGridSelectable({
    super.key,
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElenaSelectableCard(
      title: title,
      selected: selected,
      onTap: onTap,
    );
  }
}

/// ------------------------------------------------
/// Selectable_card Whit _emojis
/// ------------------------------------------------
class ElenaSelectableCardEmoji extends StatelessWidget {
  final String title;
  final String emoji;
  final bool selected;
  final VoidCallback onTap;

  const ElenaSelectableCardEmoji({
    super.key,
    required this.title,
    required this.emoji,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: selected ? ElenaColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? ElenaColors.primary.withOpacity(0.9)
                : ElenaColors.border.withOpacity(0.3),
            width: selected ? 2 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: ElenaColors.primary.withOpacity(0.18),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: Row(
          children: [
            Text(
              emoji,
              style: TextStyle(
                fontSize: 26,
                color: selected ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: selected ? Colors.white : Colors.black87,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

/// ------------------------------------------------
/// Selectable_card Whit _emojis_description
/// ------------------------------------------------
class ElenaSelectableCardEmojiDescription extends StatelessWidget {
  final String emoji;
  final String title;
  final String description;
  final bool selected;
  final VoidCallback onTap;

  const ElenaSelectableCardEmojiDescription({
    super.key,
    required this.emoji,
    required this.title,
    required this.description,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color:
              selected ? ElenaColors.primary.withOpacity(0.15) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? ElenaColors.primary : Colors.grey.shade300,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 28),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: selected ? ElenaColors.primary : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ------------------------------------------------------------
/// BOTÓN PRIMARIO (faltaba en tu UI System)
/// ------------------------------------------------------------
class ElenaPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const ElenaPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: ElenaColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        child: Text(label, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}

/// ------------------------------------------------------------
// LISTA DE PAÍSES CON BANDERA
// ------------------------------------------------------------
class Country {
  final String name;
  final String flag;

  const Country(this.name, this.flag);
}

const List<Country> countriesWithFlags = [
  Country("Afganistán", "🇦🇫"),
  Country("Albania", "🇦🇱"),
  Country("Alemania", "🇩🇪"),
  Country("Andorra", "🇦🇩"),
  Country("Angola", "🇦🇴"),
  Country("Antigua y Barbuda", "🇦🇬"),
  Country("Arabia Saudita", "🇸🇦"),
  Country("Argelia", "🇩🇿"),
  Country("Argentina", "🇦🇷"),
  Country("Armenia", "🇦🇲"),
  Country("Australia", "🇦🇺"),
  Country("Austria", "🇦🇹"),
  Country("Azerbaiyán", "🇦🇿"),
  Country("Bahamas", "🇧🇸"),
  Country("Bangladés", "🇧🇩"),
  Country("Baréin", "🇧🇭"),
  Country("Bélgica", "🇧🇪"),
  Country("Belice", "🇧🇿"),
  Country("Benín", "🇧🇯"),
  Country("Bielorrusia", "🇧🇾"),
  Country("Bolivia", "🇧🇴"),
  Country("Bosnia y Herzegovina", "🇧🇦"),
  Country("Botsuana", "🇧🇼"),
  Country("Brasil", "🇧🇷"),
  Country("Brunéi", "🇧🇳"),
  Country("Bulgaria", "🇧🇬"),
  Country("Burkina Faso", "🇧🇫"),
  Country("Burundi", "🇧🇮"),
  Country("Cabo Verde", "🇨🇻"),
  Country("Camboya", "🇰🇭"),
  Country("Camerún", "🇨🇲"),
  Country("Canadá", "🇨🇦"),
  Country("Catar", "🇶🇦"),
  Country("Chad", "🇹🇩"),
  Country("Chile", "🇨🇱"),
  Country("China", "🇨🇳"),
  Country("Chipre", "🇨🇾"),
  Country("Colombia", "🇨🇴"),
  Country("Comoras", "🇰🇲"),
  Country("Corea del Norte", "🇰🇵"),
  Country("Corea del Sur", "🇰🇷"),
  Country("Costa de Marfil", "🇨🇮"),
  Country("Costa Rica", "🇨🇷"),
  Country("Croacia", "🇭🇷"),
  Country("Cuba", "🇨🇺"),
  Country("Dinamarca", "🇩🇰"),
  Country("Dominica", "🇩🇲"),
  Country("Ecuador", "🇪🇨"),
  Country("Egipto", "🇪🇬"),
  Country("El Salvador", "🇸🇻"),
  Country("Emiratos Árabes Unidos", "🇦🇪"),
  Country("Eritrea", "🇪🇷"),
  Country("Eslovaquia", "🇸🇰"),
  Country("Eslovenia", "🇸🇮"),
  Country("España", "🇪🇸"),
  Country("Estados Unidos", "🇺🇸"),
  Country("Estonia", "🇪🇪"),
  Country("Esuatini", "🇸🇿"),
  Country("Etiopía", "🇪🇹"),
  Country("Filipinas", "🇵🇭"),
  Country("Finlandia", "🇫🇮"),
  Country("Francia", "🇫🇷"),
  Country("Gabón", "🇬🇦"),
  Country("Gambia", "🇬🇲"),
  Country("Georgia", "🇬🇪"),
  Country("Ghana", "🇬🇭"),
  Country("Granada", "🇬🇩"),
  Country("Grecia", "🇬🇷"),
  Country("Guatemala", "🇬🇹"),
  Country("Guyana", "🇬🇾"),
  Country("Guinea", "🇬🇳"),
  Country("Guinea-Bisáu", "🇬🇼"),
  Country("Guinea Ecuatorial", "🇬🇶"),
  Country("Haití", "🇭🇹"),
  Country("Honduras", "🇭🇳"),
  Country("Hungría", "🇭🇺"),
  Country("India", "🇮🇳"),
  Country("Indonesia", "🇮🇩"),
  Country("Irak", "🇮🇶"),
  Country("Irán", "🇮🇷"),
  Country("Irlanda", "🇮🇪"),
  Country("Islandia", "🇮🇸"),
  Country("Islas Marshall", "🇲🇭"),
  Country("Islas Salomón", "🇸🇧"),
  Country("Israel", "🇮🇱"),
  Country("Italia", "🇮🇹"),
  Country("Jamaica", "🇯🇲"),
  Country("Japón", "🇯🇵"),
  Country("Jordania", "🇯🇴"),
  Country("Kazajistán", "🇰🇿"),
  Country("Kenia", "🇰🇪"),
  Country("Kirguistán", "🇰🇬"),
  Country("Kiribati", "🇰🇮"),
  Country("Kuwait", "🇰🇼"),
  Country("Laos", "🇱🇦"),
  Country("Lesoto", "🇱🇸"),
  Country("Letonia", "🇱🇻"),
  Country("Líbano", "🇱🇧"),
  Country("Liberia", "🇱🇷"),
  Country("Libia", "🇱🇾"),
  Country("Liechtenstein", "🇱🇮"),
  Country("Lituania", "🇱🇹"),
  Country("Luxemburgo", "🇱🇺"),
  Country("Madagascar", "🇲🇬"),
  Country("Malasia", "🇲🇾"),
  Country("Malaui", "🇲🇼"),
  Country("Maldivas", "🇲🇻"),
  Country("Malí", "🇲🇱"),
  Country("Malta", "🇲🇹"),
  Country("Marruecos", "🇲🇦"),
  Country("Mauricio", "🇲🇺"),
  Country("Mauritania", "🇲🇷"),
  Country("México", "🇲🇽"),
  Country("Micronesia", "🇫🇲"),
  Country("Moldavia", "🇲🇩"),
  Country("Mónaco", "🇲🇨"),
  Country("Mongolia", "🇲🇳"),
  Country("Montenegro", "🇲🇪"),
  Country("Mozambique", "🇲🇿"),
  Country("Myanmar", "🇲🇲"),
  Country("Namibia", "🇳🇦"),
  Country("Nauru", "🇳🇷"),
  Country("Nepal", "🇳🇵"),
  Country("Nicaragua", "🇳🇮"),
  Country("Níger", "🇳🇪"),
  Country("Nigeria", "🇳🇬"),
  Country("Noruega", "🇳🇴"),
  Country("Nueva Zelanda", "🇳🇿"),
  Country("Omán", "🇴🇲"),
  Country("Países Bajos", "🇳🇱"),
  Country("Pakistán", "🇵🇰"),
  Country("Palaos", "🇵🇼"),
  Country("Panamá", "🇵🇦"),
  Country("Papúa Nueva Guinea", "🇵🇬"),
  Country("Paraguay", "🇵🇾"),
  Country("Perú", "🇵🇪"),
  Country("Polonia", "🇵🇱"),
  Country("Portugal", "🇵🇹"),
  Country("Reino Unido", "🇬🇧"),
  Country("República Centroafricana", "🇨🇫"),
  Country("República Checa", "🇨🇿"),
  Country("República del Congo", "🇨🇬"),
  Country("República Democrática del Congo", "🇨🇩"),
  Country("República Dominicana", "🇩🇴"),
  Country("Ruanda", "🇷🇼"),
  Country("Rumania", "🇷🇴"),
  Country("Rusia", "🇷🇺"),
  Country("Samoa", "🇼🇸"),
  Country("San Cristóbal y Nieves", "🇰🇳"),
  Country("San Marino", "🇸🇲"),
  Country("San Vicente y las Granadinas", "🇻🇨"),
  Country("Santa Lucía", "🇱🇨"),
  Country("Santo Tomé y Príncipe", "🇸🇹"),
  Country("Senegal", "🇸🇳"),
  Country("Serbia", "🇷🇸"),
  Country("Seychelles", "🇸🇨"),
  Country("Sierra Leona", "🇸🇱"),
  Country("Singapur", "🇸🇬"),
  Country("Siria", "🇸🇾"),
  Country("Somalia", "🇸🇴"),
  Country("Sri Lanka", "🇱🇰"),
  Country("Sudáfrica", "🇿🇦"),
  Country("Sudán", "🇸🇩"),
  Country("Sudán del Sur", "🇸🇸"),
  Country("Suecia", "🇸🇪"),
  Country("Suiza", "🇨🇭"),
  Country("Surinam", "🇸🇷"),
  Country("Tailandia", "🇹🇭"),
  Country("Tanzania", "🇹🇿"),
  Country("Tayikistán", "🇹🇯"),
  Country("Timor Oriental", "🇹🇱"),
  Country("Togo", "🇹🇬"),
  Country("Tonga", "🇹🇴"),
  Country("Trinidad y Tobago", "🇹🇹"),
  Country("Túnez", "🇹🇳"),
  Country("Turkmenistán", "🇹🇲"),
  Country("Turquía", "🇹🇷"),
  Country("Tuvalu", "🇹🇻"),
  Country("Ucrania", "🇺🇦"),
  Country("Uganda", "🇺🇬"),
  Country("Uruguay", "🇺🇾"),
  Country("Uzbekistán", "🇺🇿"),
  Country("Vanuatu", "🇻🇺"),
  Country("Vaticano", "🇻🇦"),
  Country("Venezuela", "🇻🇪"),
  Country("Vietnam", "🇻🇳"),
  Country("Yemen", "🇾🇪"),
  Country("Yibuti", "🇩🇯"),
  Country("Zambia", "🇿🇲"),
  Country("Zimbabue", "🇿🇼"),
];

// ------------------------------------------------------------
// DROPDOWN ESPECÍFICO PARA PAÍSES CON BANDERA
// ------------------------------------------------------------
class ElenaDropdownCountry extends StatelessWidget {
  final String label;
  final String? value;
  final ValueChanged<String?> onChanged;

  const ElenaDropdownCountry({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Aseguramos que el value está en la lista, si no, lo ponemos en null
    final String? safeValue =
        countriesWithFlags.any((c) => c.name == value) ? value : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: safeValue,
          items: countriesWithFlags
              .map(
                (c) => DropdownMenuItem<String>(
                  value: c.name, // ← antes c["name"]
                  child: Row(
                    children: [
                      Text(
                        c.flag, // ← antes c["flag"]
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(width: 8),
                      Text(c.name), // ← antes c["name"]
                    ],
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: "Selecciona tu país",
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: ElenaColors.border),
              borderRadius: BorderRadius.circular(14),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: ElenaColors.border.withOpacity(0.6)),
              borderRadius: BorderRadius.circular(14),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: ElenaColors.primary, width: 2),
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ],
    );
  }
}
