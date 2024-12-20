
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

/// [HelpPart] is the help part of the app.
/// shows help information to the user.
/// contcts
class HelpPart extends StatelessWidget {
  const HelpPart({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center ,
      children: [
        Image.asset( 'assets/logo/icon.png',
          height: 200,
        ),
        Padding(
          padding: const EdgeInsets.all(40),
          child: Center(
              child: Column(
            children: [
              Text(
                "Poulet Vert, La plateforme de vente en ligne de poulets de chair de qualité supérieure.\n Nous vous proposons des poulets de chair de qualité supérieure, élevés en plein air, nourris avec des aliments naturels et sans antibiotiques.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 10,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "developée par SADEEM INFORMATIQUE 2023",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 10,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                ),
              ),
            ],
          )),
        ),const SizedBox(height: 10),
      ],
    );
  }
}

/// contact options
class ContactOption extends StatelessWidget {
  const ContactOption({
    Key? key,
    required this.icon,
    required this.title,
    required this.value,
    required this.onTap,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).primaryColor,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.labelMedium!.copyWith(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.normal,
            ),
      ),
      subtitle: Text(value),
      onTap: onTap,
      // copy to clipboard
      trailing: IconButton(
        icon: const Icon(FluentIcons.copy_24_regular),
        onPressed: () {
          // copy to clipboard
          Clipboard.setData(ClipboardData(text: value));
          // show snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Copié dans le presse-papiers"),
            ),
          );
        },
      ),
    );
  }
}
