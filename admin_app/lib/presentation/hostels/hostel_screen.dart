import 'package:admin_app/services/reservation_service.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lib/widgets/flex_table.dart';

class ReservationScreen extends StatefulWidget {
  const ReservationScreen({super.key});

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Reservations",
            style: Theme.of(context).textTheme.titleLarge!,
          ),
          FilledButton.icon(
            icon: Icon(FeatherIcons.shoppingBag),
            onPressed: () async {},
            label: Text('Add Reservation'),
          )
        ],
      ),
      SizedBox(
        height: 3,
      ),
      SizedBox(
        height: 35,
        width: 400,
        child: TextField(
          onSubmitted: (value) {},
          controller: TextEditingController(),
          decoration: InputDecoration(
            filled: true,
            label: Text("Search"),
            prefixIcon: Icon(Iconsax.search_favorite_1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
      FlexTable(
        selectable: false,
        scrollable: true,
        configs: const [
          FlexTableItemConfig.square(48),
          FlexTableItemConfig.flex(1),
          FlexTableItemConfig.flex(1),
          FlexTableItemConfig.flex(1),
          FlexTableItemConfig.flex(1),
          FlexTableItemConfig.square(40),
        ],
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FlexTableItem(children: [
              SizedBox(),
              Text(
                'Product',
              ),
              Text(
                'price',
              ),
              Text("Supplier"),
              Text(
                'Updated At',
              ),
              Icon(Iconsax.arrow_bottom),
            ]),
            ListenableBuilder(
                listenable: ReservationService.instance,
                builder: (context, child) {
                  return Column(
                    children: [
                      for (int i = 0; i < 5; i++)
                        InkWell(
                          splashColor: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.3),
                          highlightColor: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.1),
                          focusColor: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.1),
                          hoverColor: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          onTap: () async {},
                          child: SizedBox(
                            child: Padding(
                              padding: const EdgeInsets.all(7.0),
                              child: FlexTableItem(children: [
                                Container(
                                  // when desibled show red circle
                                  width: 45,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        width: 0.5),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(2),
                                    child: CircleAvatar(
                                      radius: 50,
                                    ),
                                  ),
                                ),
                                Text(
                                  'titkto',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  '10000',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      // when desibled show red circle
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            width: 1),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(1),
                                        child: CircleAvatar(
                                          child: Text(
                                            'instagram',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface
                                                  .withOpacity(0.5),
                                            ),
                                          ),
                                          // child: profile?.photoUrl.nullIfEmpty == null ? null : Text((profile!.displayName.nullIfEmpty ?? "?")[0].toUpperCase()),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'safe',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(),
                                        ),
                                        const SizedBox(
                                          height: 3,
                                        ),
                                        Text(
                                          'beef',
                                          style: Theme.of(context) //
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(color: Colors.grey),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Text(
                                  'tt',
                                  maxLines: 1,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                PopupMenuButton(
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      onTap: () async {},
                                      child: ListTile(
                                        title: Text("Edit"),
                                        leading: Icon(
                                          Iconsax.edit,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surfaceContainerHigh,
                                        ),
                                      ),
                                    ),
                                    // PopupMenuItem(
                                    //   child: ListTile(
                                    //     title:
                                    //         Text("Delete".tr()),
                                    //     leading:
                                    //         Icon(Iconsax.trash),
                                    //   ),
                                    // )
                                  ],
                                )
                              ]),
                            ),
                          ),
                        ),
                      // Add Creating button
                    ],
                  );
                }),
          ],
        ),
      ),
    ]);
  }
}
