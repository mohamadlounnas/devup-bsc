part of '../petra_data.dart';

// Search suggestions (70)
List<String> _searchSuggestions = const [
  'stamp',
  'figure',
  'cylinder',
  'membranophone',
  'seal',
  'copper',
  'molded',
  'brass',
  'dagger',
  'alloy',
  'silver',
  'slip',
  'animal',
  'stone',
  'opaque',
  'sculpture',
  'earthenware',
  'incised',
  'ink',
  'jambiya',
  'paper',
  'ceramics',
  'jasper',
  'metal',
  'unguentarium',
  'ceramic',
  'stonepaste',
  'leather',
  'green',
  'nude',
  'folio',
  'glazed',
  'sherd',
  'vessel',
  'white',
  'chordophone',
  'fragment',
  'book',
  'lute',
  'decoration',
  'headed',
  'female',
  'codices',
  'illustrated',
  'scaraboid',
  'drum',
  'shahnama',
  'jewelry',
  'bronze',
  'steatite',
  'porcelain',
  'plucked',
  'wood',
  'cultic',
  'kings',
  'painted',
  'gold',
  'watercolor',
  'quartz',
  'scarab',
  'steel',
  'lamp',
  'manuscript',
  'daggers',
  'splash',
  'head',
  'sheath',
  'jug',
  'bowl',
  'scene',
];

// Petra (342)
List<SearchData> _searchData = const [
  SearchData(1199, 451550, 'Fragment', 'fragment|stonepaste; slip painted, glazed|ceramics'),
  SearchData(-450, 324255, 'Figure of ibex', 'sculpture|bronze|'),
  SearchData(50, 325897, 'Unguentarium', 'vessel|ceramic|'),
  SearchData(-750, 323750, 'Stamp seal (oval bezel) with cultic scene', 'stamp seal|carnelian (quartz)|'),
  SearchData(1315, 451412, '"Yazdegird I Kicked to Death by the Water Horse", Folio from a Shahnama (Book of Kings)',
      'folio from an illustrated manuscript|ink, opaque watercolor, silver, and gold on paper|codices'),
  SearchData(-500, 327499, 'Vessel with a lid', 'vessel and lid|calcite alabaster|'),
  SearchData(-500, 323925, 'Scarab seal with human head', 'stamp seal|stone, mottled red and white|'),
  SearchData(1849, 443096, 'Headband', 'headband|silk, metal thread; wrapped and braided|textiles-costumes'),
  SearchData(-1750, 322914, 'Nude female figure', 'sculpture|ceramic|'),
  SearchData(-662, 323164, 'Openwork rattle', 'rattle|ceramic|'),
  SearchData(1299, 451583, 'Fragment', 'fragment|porcelain|ceramics'),
  SearchData(849, 455174, 'Fragment', 'fragment|earthenware; glazed|ceramics'),
  SearchData(-650, 327043, 'Palette with a sculpted female head and incised decoration', 'palette|calcite|'),
  SearchData(1249, 451551, 'Fragment', 'fragment|stonepaste; slip painted, incised, and splash glazed|ceramics'),
  SearchData(50, 324246, 'Sherd', 'sherd|ceramic|'),
  SearchData(50, 325919, 'Lamp', 'lamp|ceramic|'),
  SearchData(50, 325894, 'Unguentarium', 'vessel|ceramic|'),
  SearchData(849, 451515, 'Fragment', 'fragment|earthenware; molded decoration, glazed|ceramics'),
  SearchData(50, 325911, 'Unguentarium', 'vessel|ceramic|'),
  SearchData(899, 451501, 'Fragment', 'fragment|earthenware; unglazed|ceramics'),
  SearchData(50, 325898, 'Vessel', 'vessel|ceramic|'),
  SearchData(1149, 450930, 'Jar', 'jar|earthenware; glazed|ceramics'),
  SearchData(1892, 32370, 'Dagger (Jambiya) with Scabbard and Fitted Storage Case',
      'dagger (jambiya) with scabbard and fitted storage case|steel, silver, wood, textile, gold|daggers'),
  SearchData(1049, 451597, 'Fragment', 'fragment|earthenware; glazed|ceramics'),
  SearchData(-1750, 322916, 'Nude female figure', 'sculpture|ceramic|'),
  SearchData(1149, 451069, 'Earring, One of a Pair', 'earring|gold wire with filigree|jewelry'),
  SearchData(1049, 451603, 'Fragment', 'fragment|earthenware; glazed|ceramics'),
  SearchData(50, 325889, 'Bowl', 'bowl|ceramic|'),
  SearchData(-1600, 556377, 'Canaanite Cowroid Seal Amulet with Falcon Headed Deity',
      'cowroid seal amulet, falcon headed deity|steatite|'),
  SearchData(899, 451540, 'Fragment', 'fragment|earthenware|ceramics'),
  SearchData(1299, 451585, 'Fragment', 'fragment|porcelain|ceramics'),
  SearchData(50, 324251, 'Fragment of painted ware', 'sherd|ceramic|'),
  SearchData(300, 326693, 'Head of a man', 'sculpture|alabaster (gypsum)|'),
  SearchData(1875, 501012, 'Daff', 'daff|wood and parchment.|membranophone-double-headed / frame drum'),
  SearchData(899, 451592, 'Fragment', 'fragment|earthenware; glazed|ceramics'),
  SearchData(50, 325913, 'Unguentarium', 'vessel|ceramic|'),
  SearchData(1299, 451582, 'Fragment', 'fragment|porcelain|ceramics'),
  SearchData(-1500, 325125, 'Adze head', 'adze|bronze|'),
  SearchData(-500, 326993, 'Stamp seal (scaraboid) with cartouche', 'stamp seal|limestone|'),
  SearchData(-1597, 544660, 'Scarab with a Crocodile Headed Figure Holding a Flower',
      'scarab, crocodile figure, flower|glazed steatite|'),
  SearchData(-750, 325519, 'Head of bull', 'sculpture|ceramic|'),
  SearchData(150, 324318, 'Vessel', 'vessel|glass|'),
  SearchData(50, 325906, 'Juglet', 'juglet|ceramic|'),
  SearchData(1799, 444633, 'Powder Horn', 'powder horn|brass and silver|arms and armor'),
  SearchData(-1680, 323115, 'Inlay', 'inlay|bone|'),
  SearchData(1800, 30761, 'Spear', 'spear|steel, brass|shafted weapons'),
  SearchData(-662, 323144, 'Bottle', 'bottle|ceramic|'),
  SearchData(1875, 500962, 'Darabukka', 'darabukka|clay, polychrome|membranophone-single-headed / goblet drum'),
  SearchData(849, 451523, 'Fragment', 'fragment|earthenware; molded decoration, glazed|ceramics'),
  SearchData(-1500, 325126, 'Staff (?)', 'staff|bronze|'),
  SearchData(50, 324288, 'Vessel', 'vessel|ceramic|'),
  SearchData(899, 451532, 'Fragment', 'fragment|earthenware; molded decoration, glazed|ceramics'),
  SearchData(50, 325909, 'Unguentarium', 'vessel|ceramic|'),
  SearchData(1875, 500984, 'Stringed Instrument (Qanbus)',
      'stringed instrument (qanbus)|wood, hide|chordophone-lute-plucked-fretted'),
  SearchData(937, 451504, 'Fragment of a Bowl', 'fragment of a bowl|earthenware; glazed|ceramics'),
  SearchData(-750, 322308, 'Stamp seal (scaraboid) with cultic scene', 'stamp seal|green-black serpentine|'),
  SearchData(-1500, 325124, 'Axe head', 'axe|bronze|'),
  SearchData(50, 325885, 'Ribbed juglet', 'juglet|ceramic|'),
  SearchData(0, 326243, 'Open bowl', 'bowl|ceramic, paint|'),
  SearchData(849, 451546, 'Fragment', 'fragment|earthenware; slip painted, glazed|ceramics'),
  SearchData(-450, 323936, 'Stamp seal', 'stamp seal|agate|'),
  SearchData(-1594, 556437, 'Scarab with a Crocodile Headed Deity', 'scarab, sebek|glazed steatite|'),
  SearchData(1355, 449537, 'Mihrab (Prayer Niche)',
      'mihrab|mosaic of polychrome-glazed cut tiles on stonepaste body; set into mortar|ceramics'),
  SearchData(1849, 503639, 'Ney-Anbān/Habbān', 'tulum|wood, cane, goat or kidskin|aerophone-reed vibrated-bagpipe'),
  SearchData(-750, 326992, 'Stamp seal (ovoid, in grooved mount with loop handle) with cartouches',
      'stamp seal|steatite, white; copper alloy mount|'),
  SearchData(-1680, 323122, 'Bowl', 'bowl|ceramic, paint|'),
  SearchData(1649, 646829, 'Filigree Casket with Sliding Top', 'box|silver filigree; parcel-gilt|metal'),
  SearchData(999, 455153, 'Fragment', 'fragment|earthenware; luster-painted|ceramics'),
  SearchData(-662, 323155, 'Jug', 'jug|ceramic|'),
  SearchData(-700, 326994, 'Stamp seal (scaraboid) with monster', 'stamp seal|calcite|'),
  SearchData(-1630, 323118, 'Scarab seal ring', 'stamp seal ring|jasper, green with gold mount and copper alloy ring|'),
  SearchData(50, 325892, 'Cup', 'cup|ceramic|'),
  SearchData(899, 451577, 'Fragment', 'fragment|earthenware; incised|ceramics'),
  SearchData(150, 324316, 'Head-shaped flask', 'flask|glass|'),
  SearchData(849, 451524, 'Fragment', 'fragment|earthenware; molded decoration, glazed|ceramics'),
  SearchData(
      -2323, 544034, 'Head of a monkey from an ointment vessel', 'ointment jar fragment, monkey head|serpentinite|'),
  SearchData(-750, 322302, 'Stamp seal (scaraboid) with geometric design', 'stamp seal|steatite, black|'),
  SearchData(-750, 326995, 'Stamp seal (scaraboid) with divine symbol', 'stamp seal|limestone (?)|'),
  SearchData(50, 324250, 'Sherd', 'sherd|ceramic|'),
  SearchData(-1648, 544664, 'Canaanite Scarab with Two Men and a Lion', 'scarab, men, lion|steatite (glazed)|'),
  SearchData(50, 324248, 'Fragment of painted ware', 'sherd|ceramic|'),
  SearchData(-125, 327483, 'Votive plaque inscribed with Sabaean dedication', 'relief|copper alloy|'),
  SearchData(849, 451530, 'Fragment', 'fragment|earthenware; molded decoration, glazed|ceramics'),
  SearchData(899, 451499, 'Fragment', 'fragment|earthenware; unglazed|ceramics'),
  SearchData(-500, 326422, 'Stamp seal (duck-shaped) with geometric design', 'stamp seal|stone|'),
  SearchData(899, 451591, 'Fragment', 'fragment|earthenware; glazed|ceramics'),
  SearchData(-662, 323166, 'Bowl', 'bowl|ceramic|'),
  SearchData(-650, 321648, 'Stamp seal (conoid) with cultic scene',
      'stamp seal|brown chalcedony (quartz), possibly etched to produce yellow mottling|'),
  SearchData(1399, 451553, 'Fragment', 'fragment|earthenware; slip painted and glazed|ceramics'),
  SearchData(1687, 453279, 'Calligraphic Plaque', 'plaque|steel; forged and pierced|metal'),
  SearchData(1649, 448587, 'Panel from a Tent Lining (Qanat)',
      'panel|cotton; plain weave, mordant dyed and painted, resist-dyed|textiles-painted and/or printed'),
  SearchData(1199, 451558, 'Fragment', 'fragment|earthenware; slip painted and glazed|ceramics'),
  SearchData(899, 451500, 'Fragment', 'fragment|earthenware; unglazed|ceramics'),
  SearchData(-1630, 324567, 'Scarab seal', 'stamp seal|jasper, green (?)|'),
  SearchData(849, 451568, 'Fragment', 'fragment|stonepaste; slip painted and glazed|ceramics'),
  SearchData(1199, 451512, 'Fragment', 'fragment|stonepaste; underglaze painted|ceramics'),
  SearchData(1299, 451584, 'Fragment', 'fragment|porcelain|ceramics'),
  SearchData(1875, 500981, 'Junuk', 'junuk|wood|chordophone-harp'),
  SearchData(50, 325908, 'Unguentarium', 'vessel|ceramic|'),
  SearchData(1850, 31572, 'Dagger (Jambiya) with Sheath and Belt',
      'dagger (jambiya) with sheath and belt|steel, wood, silver, silver wire, textile, silk, leather|daggers'),
  SearchData(50, 325904, 'Juglet', 'juglet|ceramic|'),
  SearchData(1875, 500998, 'Kamānja agūz (old fiddle)',
      'kamānja agūz (old fiddle)|wood,  coconut shell, skin|chordophone-lute-bowed-unfretted'),
  SearchData(899, 451580, 'Fragment', 'fragment|earthenware; incised|ceramics'),
  SearchData(1849, 817059, 'Tapis, ceremonial skirt with squid pattern (cumi-cumi) iconography',
      'ceremonial skirt (tapis)|cotton, silk, mica, dyes|textiles-costumes'),
  SearchData(-700, 324013, 'Stamp seal (scarab) with monster', 'stamp seal|hematite|'),
  SearchData(787, 327822, 'Stamp seal', 'stamp seal|sandstone or siltstone ?|'),
  SearchData(849, 451562, 'Fragment', 'fragment|earthenware; slip painted and glazed|ceramics'),
  SearchData(937, 451508, 'Fragment', 'fragment|earthenware; glazed|ceramics'),
  SearchData(
      -750, 322307, 'Stamp seal (scaraboid) with cultic banquet scene', 'stamp seal|mottled orange jasper (quartz)|'),
  SearchData(-600, 321452, 'Stamp seal (grooved oval base with ribbed handle) with cultic scene',
      'stamp seal|neutral chalcedony (quartz)|'),
  SearchData(50, 325918, 'Vessel', 'vessel|ceramic|'),
  SearchData(899, 451498, 'Fragment of a Cup', 'fragment of a cup|earthenware; unglazed|ceramics'),
  SearchData(899, 451588, 'Fragment', 'fragment|earthenware; glazed|ceramics'),
  SearchData(849, 451543, 'Fragment', 'fragment|earthenware; splash glazed|ceramics'),
  SearchData(899, 451533, 'Fragment', 'fragment|earthenware; molded decoration, glazed|ceramics'),
  SearchData(50, 324252, 'Sherd', 'sherd|ceramic|'),
  SearchData(937, 451505, 'Fragment of a Bowl', 'fragment of a bowl|earthenware; glazed|ceramics'),
  SearchData(
      4, 323749, 'Stamp seal (scaraboid) with animals', 'stamp seal|variegated red and neutral carnelian (quartz)|'),
  SearchData(1887, 500568, 'Guenbri',
      'guenbri|gourd, wood, parchment decorated with floral designs|chordophone-lute-plucked-unfretted'),
  SearchData(-1680, 323124, 'Dish', 'dish|ceramic|'),
  SearchData(1525, 446603, '"Laila and Majnun in School", Folio 129 from a Khamsa (Quintet) of Nizami of Ganja',
      'folio from an illustrated manuscript|ink, opaque watercolor, and gold on paper|codices'),
  SearchData(1540, 452413, 'Velvet Panel with Hunting Scene',
      'tent panel|silk, flat metal thread; cut and voided velvet|textiles'),
  SearchData(50, 325900, 'Unguentarium', 'vessel|ceramic|'),
  SearchData(1875, 500989, 'Naqqareh', 'naqqareh|wood|membranophone-single-headed / kettle drum'),
  SearchData(50, 325888, 'Unguentarium', 'vessel|ceramic|'),
  SearchData(1649, 446546, 'Shahnama (Book of Kings) of Firdausi',
      'illustrated manuscript|ink, opaque watercolor, and gold on paper|codices'),
  SearchData(1049, 451606, 'Fragment', 'fragment|earthenware; glazed|ceramics'),
  SearchData(-1500, 323559, 'Cylinder seal', 'cylinder seal|stone|'),
  SearchData(1049, 451601, 'Fragment', 'fragment|earthenware; incised|ceramics'),
  SearchData(-662, 323169, 'Bowl', 'bowl|ceramic|'),
  SearchData(1199, 451564, 'Fragment', 'fragment|stonepaste; slip painted and glazed|ceramics'),
  SearchData(-1300, 322889, 'Enthroned deity', 'sculpture|bronze, gold foil|'),
  SearchData(849, 451521, 'Fragment', 'fragment|earthenware; molded decoration, glazed|ceramics'),
  SearchData(11, 442859, 'Basket Earring', 'earring|gold, silver (?); decorated with filigree and granulation|jewelry'),
  SearchData(1850, 31573, 'Dagger (Jambiya) with Sheath',
      'dagger (jambiya) with sheath|steel, wood, silver, gold, copper foil, pigment, paper, glue|daggers'),
  SearchData(-750, 327771, 'Stamp seal (ovoid) with deity (?)', 'stamp seal|steatite|'),
  SearchData(-1900, 325342, 'Oil lamp', 'lamp|ceramic|'),
  SearchData(-1300, 321407, 'Cylinder seal', 'cylinder seal|steatite|'),
  SearchData(849, 451519, 'Fragment', 'fragment|earthenware; molded decoration, glazed|ceramics'),
  SearchData(1149, 451068, 'Earring, One of a Pair', 'earring|gold wire with filigree|jewelry'),
  SearchData(1849, 503640, 'Daraboukkeh', 'daraboukkeh|pottery|membranophone-single-headed / goblet drum'),
  SearchData(-1875, 325093, 'Fenestrated axe blade', 'axe|bronze|'),
  SearchData(
      -700, 327102, 'Stamp seal (scaraboid) with cultic scene', 'stamp seal|veined neutral chalcedony (quartz)|'),
  SearchData(-1680, 323126, 'Pin', 'pin|bronze|'),
  SearchData(899, 451537, 'Fragment', 'fragment|earthenware; splash glazed decoration|ceramics'),
  SearchData(1187, 446860, 'Luster Bowl with Winged Horse',
      'bowl|stonepaste; luster-painted on opaque monochrome glaze|ceramics'),
  SearchData(899, 451538, 'Fragment', 'fragment|earthenware; splash glazed decoration|ceramics'),
  SearchData(50, 325899, 'Unguentarium', 'vessel|ceramic|'),
  SearchData(1556, 444864, 'Hawk Coin of the Emperor Akbar', 'coin|gold|coins'),
  SearchData(50, 325887, 'Small lamp', 'lamp|ceramic|'),
  SearchData(-1630, 324556, 'Scarab seal', 'stamp seal|stone, white|'),
  SearchData(-1750, 322915, 'Nude female figure', 'sculpture|ceramic|'),
  SearchData(50, 325907, 'Bowl', 'bowl|ceramic|'),
  SearchData(-1630, 324562, 'Scarab seal', 'stamp seal|steatite, white|'),
  SearchData(50, 325901, 'Lamp', 'lamp|ceramic|'),
  SearchData(-750, 326997, 'Stamp seal (scaraboid) with animal', 'stamp seal|steatite, gray (?)|'),
  SearchData(-1300, 327319, 'Smiting weather god or warrior with horned headgear', 'sculpture|bronze|'),
  SearchData(50, 325895, 'Unguentarium', 'vessel|ceramic|'),
  SearchData(-550, 323747, 'Scarab seal', 'stamp seal|jasper, green|'),
  SearchData(1199, 449159, 'Roundel with a Mounted Falconer and Hare',
      'roundel|gypsum plaster; modeled, painted, and gilded|sculpture'),
  SearchData(1049, 451600, 'Fragment', 'fragment|earthenware; incised and glazed|ceramics'),
  SearchData(1675, 24298, 'Dagger with Sheath',
      'dagger with sheath|steel, nephrite, gold, rubies, emeralds, silver-gilt, leather|daggers'),
  SearchData(1399, 451554, 'Fragment', 'fragment|stonepaste; slip painted and glazed|ceramics'),
  SearchData(-550, 323933, 'Stamp seal', 'stamp seal|carnelian|'),
  SearchData(-1775, 327285, 'Cylinder seal and modern impression: nude goddess before seated deity',
      'cylinder seal|hematite|'),
  SearchData(50, 325893, 'Unguentarium', 'vessel|ceramic|'),
  SearchData(899, 451503, 'Fragment of a Bowl', 'bowl fragment|earthenware; glazed|ceramics'),
  SearchData(-750, 326011, 'Stamp seal (scarab) with monster', 'stamp seal|lapis lazuli|'),
  SearchData(1875, 500990, 'Naqqāra', 'naqqāra|metal|membranophone-single-headed / kettle drum'),
  SearchData(1850, 31539, 'Dagger (Jambiya) with Sheath',
      'dagger (jambiya) with sheath|steel, wood, brass, silver, gold, copper, brass wire|daggers'),
  SearchData(1399, 451555, 'Fragment', 'fragment|stonepaste; slip painted and glazed|ceramics'),
  SearchData(-550, 323941, 'Scarab seal', 'stamp seal|rock crystal|'),
  SearchData(-1750, 322913, 'Nude female figure', 'sculpture|ceramic|'),
  SearchData(
      1532,
      452170,
      '"Bahrum Gur Before His Father, Yazdigird I", Folio 551v from the Shahnama (Book of Kings) of Shah Tahmasp',
      'folio from an illustrated manuscript|opaque watercolor, ink, silver, and gold on paper|codices'),
  SearchData(-1630, 326991, 'Scarab seal', 'stamp seal|faience, white (?)|'),
  SearchData(-2500, 325836, 'Spouted vessel', 'vessel|ceramic|'),
  SearchData(849, 451518, 'Fragment', 'fragment|earthenware; molded decoration, glazed|ceramics'),
  SearchData(999, 451567, 'Fragment', 'fragment|celadon|ceramics'),
  SearchData(50, 325905, 'Vessel', 'vessel|ceramic|'),
  SearchData(849, 451547, 'Fragment', 'fragment|earthenware; slip painted, glazed|ceramics'),
  SearchData(899, 451574, 'Fragment', 'fragment|earthenware; incised|ceramics'),
  SearchData(849, 451560, 'Fragment', 'fragment|earthenware; slip painted and glazed|ceramics'),
  SearchData(-850, 326010, 'Cylinder seal with chariot hunting scene', 'cylinder seal|egyptian blue|'),
  SearchData(1602, 453336, 'A Stallion', 'illustrated  album leaf|ink, opaque watercolor, and gold on paper|codices'),
  SearchData(1600, 451725, '"The Concourse of the Birds", Folio 11r from a Mantiq al-Tayr (Language of the Birds)',
      'folio from an illustrated manuscript|ink, opaque watercolor, gold, and silver on paper|codices'),
  SearchData(-1680, 323114, 'Inlay', 'inlay|bone|'),
  SearchData(-662, 323161, 'Jug', 'jug|ceramic|'),
  SearchData(-1680, 323120, 'Jug', 'jug|ceramic|'),
  SearchData(-500, 324075, 'Incense burner', 'incense burner|bronze|'),
  SearchData(-1630, 324557, 'Scarab seal ring', 'stamp seal ring|stone, white, copper alloy mount|'),
  SearchData(849, 451544, 'Fragment', 'fragment|earthenware; glazed|ceramics'),
  SearchData(1800, 30999, 'Sword (Saif) with Scabbard', 'sword (saif) with scabbard|steel, silver, leather|swords'),
  SearchData(50, 324247, 'Sherd', 'sherd|ceramic|'),
  SearchData(1049, 452939, 'Pair of Earrings', 'earrings|gold; filigree and granulation|jewelry'),
  SearchData(1199, 451513, 'Fragment', 'fragment|stonepaste; underglaze painted|ceramics'),
  SearchData(50, 325896, 'Unguentarium', 'vessel|ceramic|'),
  SearchData(-1630, 324560, 'Scarab seal', 'stamp seal|steatite, white pink|'),
  SearchData(-750, 326998, 'Stamp seal (scarab) with animal', 'stamp seal|mottled greenstone|'),
  SearchData(849, 451522, 'Fragment', 'fragment|earthenware; molded decoration, glazed|ceramics'),
  SearchData(-1650, 325690, 'Seven-cup offering bowl', 'bowl|ceramic|'),
  SearchData(50, 325883, 'Small bowl', 'bowl|ceramic|'),
  SearchData(-250, 328941, 'Standing bull', 'sculpture|copper alloy, shell|'),
  SearchData(-50, 325075, 'Fragment of a grave stele', 'relief|alabaster (gypsum)|'),
  SearchData(-1400, 327231, 'Smiting god, wearing an Egyptian atef crown', 'sculpture|bronze|'),
  SearchData(899, 451534, 'Fragment', 'fragment|earthenware; molded decoration, glazed|ceramics'),
  SearchData(
      -600, 323924, 'Stamp seal (loaf-shaped hemispheroid) with animal', 'stamp seal|banded carnelian (quartz)|'),
  SearchData(50, 325886, 'Juglet', 'juglet|ceramic|'),
  SearchData(1738, 446556, 'Shahnama (Book of Kings) of Firdausi',
      'illustrated manuscript|ink, opaque watercolor, silver, and gold on paper|codices'),
  SearchData(899, 451595, 'Fragment', 'fragment|earthenware; glazed|ceramics'),
  SearchData(-1680, 323123, 'Bowl', 'bowl|ceramic|'),
  SearchData(-300, 329093, 'Figure of a lion', 'sculpture|copper alloy|'),
  SearchData(50, 325884, 'Bowl', 'bowl|ceramic|'),
  SearchData(849, 451529, 'Fragment', 'fragment|earthenware; molded decoration, glazed|ceramics'),
  SearchData(150, 324319, 'Pitcher', 'pitcher|glass|'),
  SearchData(-125, 326694, 'Votive or funerary stele', 'stele|alabaster (gypsum)|'),
  SearchData(1330, 448938, '"The Funeral of Isfandiyar," Folio from a Shahnama (Book of Kings)',
      'folio from an illustrated manuscript|ink, opaque watercolor, and gold on paper|codices'),
  SearchData(1849, 444669, 'Necklace', 'necklace|silver and cloth|jewelry'),
  SearchData(1882, 73632, 'Mirror of National Costumes of All Nations  (Bankoku ishō kagami)',
      'print|triptych of woodblock prints (nishiki-e); ink and color on paper|prints'),
  SearchData(849, 451516, 'Fragment', 'fragment|earthenware; molded decoration, glazed|ceramics'),
  SearchData(-750, 321638, 'Stamp seal (scaraboid) with animals', 'stamp seal|variegated brown jasper (quartz)|'),
  SearchData(1750, 31745, 'Dagger (Jambiya)', 'dagger (jambiya)|steel, wood, silver, copper, brass|daggers'),
  SearchData(1049, 451607, 'Fragment', 'fragment|earthenware; incised|ceramics'),
  SearchData(1887, 500570, 'Guenbri',
      'gunibri|tortoise shell and wood.  floral design in white, yellow, and pink.|chordophone-lute-plucked-unfretted'),
  SearchData(
      1527,
      452142,
      '"Kai Khusrau Rides Bihzad for the First Time", Folio 212r from the Shahnama (Book of Kings) of Shah Tahmasp',
      'folio from an illustrated manuscript|opaque watercolor, ink, silver, and gold on paper|codices'),
  SearchData(-662, 323154, 'Oil jug', 'jug|ceramic|'),
  SearchData(-1630, 324559, 'Scarab seal', 'stamp seal|stone, white|'),
  SearchData(1049, 451604, 'Fragment', 'fragment|earthenware; glazed|ceramics'),
  SearchData(150, 324317, 'Head-shaped flask', 'flask|glass|'),
  SearchData(1299, 451587, 'Fragment', 'fragment|porcelain|ceramics'),
  SearchData(
      -1966, 545105, 'Head of a sphinx, possibly of Amenemhat I', 'head, sphinx; 12th-dyn-king|dolomitic marble|'),
  SearchData(-750, 324012, 'Stamp seal (scarab) with animal', 'stamp seal|hematite|'),
  SearchData(849, 451563, 'Fragment', 'fragment|earthenware; slip painted and glazed|ceramics'),
  SearchData(-1630, 324555, 'Scarab seal', 'stamp seal|stone, white|'),
  SearchData(899, 451593, 'Fragment', 'fragment|earthenware; splash glazed|ceramics'),
  SearchData(1149, 453615, 'Basket Earring, One of a Pair', 'earring|gold|jewelry'),
  SearchData(-1673, 324558, 'Scarab seal', 'stamp seal|stone, white|'),
  SearchData(1049, 451598, 'Fragment', 'fragment|earthenware; glazed|ceramics'),
  SearchData(1199, 451570, 'Fragment', 'fragment|stonepaste; slip painted and glazed|ceramics'),
  SearchData(50, 324245, 'Fragment of painted ware', 'sherd|ceramic|'),
  SearchData(50, 325903, 'Lamp', 'lamp|ceramic|'),
  SearchData(849, 451517, 'Fragment', 'fragment|earthenware; molded decoration, glazed|ceramics'),
  SearchData(-1648, 556529, 'Canaanite Scarab of the "Anra" Type', 'scarab, "anra"|steatite|'),
  SearchData(-900, 327101, 'Stamp seal (grooved tabloid) with three-figure contest scene and geometric design',
      'stamp seal|glazed steatite|'),
  SearchData(-1350, 321405, 'Cylinder seal', 'cylinder seal|stone|'),
  SearchData(-662, 323172, 'Lamp', 'lamp|ceramic|'),
  SearchData(849, 451542, 'Fragment', 'fragment|earthenware; splash glazed|ceramics'),
  SearchData(1887, 500569, 'Gumuri', 'gumuri|wood, parchment, hide|chordophone-lute-plucked-unfretted'),
  SearchData(-550, 323746, 'Scarab seal', 'stamp seal|jasper, green|'),
  SearchData(937, 451506, 'Fragment', 'fragment|earthenware; glazed|ceramics'),
  SearchData(1099, 451566, 'Fragment', 'fragment|celadon|ceramics'),
  SearchData(1199, 451510, 'Fragment', 'fragment|stonepaste; underglaze painted|ceramics'),
  SearchData(849, 451526, 'Fragment', 'fragment|earthenware; molded decoration, glazed|ceramics'),
  SearchData(799, 451571, 'Fragment', 'fragment|earthenware; glazed|ceramics'),
  SearchData(899, 451539, 'Fragment', 'fragment|earthenware; painted splash glazed decoration|ceramics'),
  SearchData(899, 451565, 'Fragment', 'fragment|stoneware|ceramics'),
  SearchData(849, 451535, 'Fragment', 'fragment|earthenware; molded decoration, glazed|ceramics'),
  SearchData(50, 325915, 'Cup', 'cup|ceramic|'),
  SearchData(899, 451590, 'Fragment', 'fragment|earthenware; glazed|ceramics'),
  SearchData(50, 325902, 'Cooking pot', 'pot|ceramic|'),
  SearchData(-1680, 323112, 'Pin', 'pin|bronze|'),
  SearchData(849, 451545, 'Fragment', 'fragment|earthenware; slip painted, glazed|ceramics'),
  SearchData(-662, 323158, 'Jug', 'jug|ceramic, paint|'),
  SearchData(-1680, 323113, 'Pin', 'pin|bronze|'),
  SearchData(849, 451514, 'Fragment', 'fragment|earthenware; molded decoration, glazed|ceramics'),
  SearchData(899, 451536, 'Fragment', 'fragment|earthenware; painted decoration|ceramics'),
  SearchData(1049, 451602, 'Fragment', 'fragment|earthenware; incised and glazed|ceramics'),
  SearchData(849, 455152, 'Fragment', 'fragment|earthenware; glazed|ceramics'),
  SearchData(937, 451507, 'Fragment', 'fragment|earthenware; glazed|ceramics'),
  SearchData(1124, 446283, 'Ewer with Molded Inscriptions and Figures on Horseback',
      'ewer|stonepaste; molded, monochrome glazed|ceramics'),
  SearchData(50, 325916, 'Plate', 'plate|ceramic|'),
  SearchData(899, 451589, 'Fragment', 'fragment|earthenware; glazed|ceramics'),
  SearchData(-1680, 323121, 'Jug', 'jug|ceramic|'),
  SearchData(50, 325914, 'Vessel', 'vessel|ceramic|'),
  SearchData(1875, 500993, 'Stringed Instrument',
      'stringed instrument|turtle shell and wood, 4 strings.|chordophone-lute-plucked-fretted'),
  SearchData(-550, 323931, 'Scaraboid seal', 'stamp seal|serpentine, green|'),
  SearchData(50, 325882, 'Small bowl', 'bowl|ceramic|'),
  SearchData(899, 451596, 'Fragment', 'fragment|earthenware; glazed|ceramics'),
  SearchData(50, 325912, 'Unguentarium', 'vessel|ceramic|'),
  SearchData(1882, 500567, 'Rebab', 'rebab|wood, leather, shells|chordophone-lute-bowed-unfretted'),
  SearchData(-2500, 327496, 'Head of a bull', 'sculpture|ivory (hippopotamus)|'),
  SearchData(1049, 451599, 'Fragment', 'fragment|earthenware; glazed|ceramics'),
  SearchData(50, 325910, 'Unguentarium', 'vessel|ceramic|'),
  SearchData(1399, 451556, 'Fragment', 'fragment|stonepaste; slip painted and glazed|ceramics'),
  SearchData(-662, 323159, 'Jug', 'jug|ceramic|'),
  SearchData(50, 325890, 'Bowl', 'bowl|ceramic|'),
  SearchData(1550, 451092, 'Safavid Courtiers Leading Georgian Captives',
      'panel|silk, metal wrapped thread; lampas|textiles-woven'),
  SearchData(1875, 500988, 'Naqqāra', 'naqqāra|metal|membranophone-single-headed / kettle drum'),
  SearchData(899, 451578, 'Fragment', 'fragment|earthenware; glazed|ceramics'),
  SearchData(849, 451528, 'Fragment', 'fragment|earthenware; molded decoration, glazed|ceramics'),
  SearchData(1850, 31773, 'Dagger (Jambiya) with Sheath and Belt',
      'dagger (jambiya) with sheath and belt|steel, wood, gold, silver, textile, leather, brass|daggers'),
  SearchData(1199, 451569, 'Fragment', 'fragment|stonepaste; slip painted and glazed|ceramics'),
  SearchData(899, 451576, 'Fragment', 'fragment|earthenware; incised|ceramics'),
  SearchData(-1600, 544669, 'Canaanite Scarab with a Roaring Lion', 'scarab, lion|steatite|'),
  SearchData(
      -500, 323745, 'Scarab seal with Bes dominating two lions below a winged sun disc', 'stamp seal|jasper, green|'),
  SearchData(849, 451525, 'Fragment', 'fragment|earthenware; molded decoration, glazed|ceramics'),
  SearchData(-1630, 323129, 'Scarab seal', 'stamp seal|amethyst|'),
  SearchData(-1630, 327099, 'Scarab seal', 'stamp seal|faience, white|'),
  SearchData(-1630, 324564, 'Scarab seal', 'stamp seal|steatite, white|'),
  SearchData(1489, 30812, 'Axe (Berdiche)', 'axe (berdiche)|steel, wood, silver|shafted weapons'),
  SearchData(
      -1981,
      552927,
      'Middle Kingdom statuette, reinscribed for Harsiese High Priest of Memphis in the Third Intermediate Period',
      'statuette, man, reinscribed for harsiese|greywacke|'),
  SearchData(899, 451502, 'Fragment', 'fragment|earthenware; glazed|ceramics'),
  SearchData(1850, 31703, 'Dagger (Jambiya) with Sheath and Belt',
      'dagger (jambiya) with sheath and belt|steel, silver, wood, leather, iron|daggers'),
  SearchData(-750, 327024, 'Stamp seal (scaraboid) with animal', 'stamp seal|serpentine, black (?)|'),
  SearchData(899, 451531, 'Fragment', 'fragment|earthenware; incised decoration, glazed|ceramics'),
  SearchData(899, 451594, 'Fragment', 'fragment|earthenware; glazed|ceramics'),
  SearchData(899, 451541, 'Fragment', 'fragment|earthenware; slip painted, incised, and splash glazed|ceramics'),
  SearchData(-500, 324027, 'Standing bull', 'sculpture|bronze|'),
  SearchData(-1630, 324561, 'Scarab seal', 'stamp seal|steatite, bone colored|'),
  SearchData(-750, 323748, 'Stamp seal (scarab) with anthropomorphic figure', 'stamp seal|mottled green glass|'),
  SearchData(-1800, 330882, 'Standing figure', 'sculpture|copper alloy|'),
  SearchData(50, 325891, 'Male figurine', 'sculpture|ceramic|'),
  SearchData(899, 451575, 'Fragment', 'fragment|earthenware; incised|ceramics'),
  SearchData(-750, 322309, 'Stamp seal (scaraboid) with cultic scene', 'stamp seal|black limestone|'),
  SearchData(-600, 321633, 'Stamp seal (scaraboid) with animal', 'stamp seal|neutral chalcedony (quartz)|'),
  SearchData(1875, 500985, 'Stringed Instrument', 'stringed instrument|wood|chordophone-lute-plucked-fretted'),
  SearchData(-700, 323163, 'Nude female figure', 'sculpture|ceramic|'),
  SearchData(
      1341,
      451414,
      '"Siyavush Displays his Skill at Polo before Afrasiyab," Folio from a Shahnama (Book of Kings)',
      'folio from an illustrated manuscript|ink, opaque watercolor, and gold on paper|codices'),
  SearchData(1449, 451552, 'Fragment', 'fragment|stonepaste; slip and underglaze painted|ceramics'),
  SearchData(1399, 451557, 'Fragment', 'fragment|stonepaste; slip painted and glazed|ceramics'),
  SearchData(1049, 451605, 'Fragment', 'fragment|earthenware; glazed|ceramics'),
  SearchData(-1600, 544670, 'Canaanite Scarab with a Lion over a Crocodile', 'scarab, lion, crocodile|steatite|'),
  SearchData(1200, 451379, 'Bowl with Courtly and Astrological Motifs',
      'bowl|stonepaste; polychrome inglaze and overglaze painted and gilded on opaque monochrome glaze (mina\'i)|ceramics'),
  SearchData(-700, 323823, 'Stamp seal (duck-shaped) with cultic scene',
      'stamp seal|variegated pink and white chalcedony (quartz)|'),
  SearchData(849, 451527, 'Fragment', 'fragment|earthenware; molded decoration, glazed|ceramics'),
  SearchData(1249, 450578, 'Dish with Horse and Rider',
      'dish|stonepaste; incised decoration through a black slip ground under a turquoise glaze (silhouette ware)|ceramics'),
  SearchData(899, 451581, 'Fragment', 'fragment|earthenware; incised|ceramics'),
  SearchData(-1630, 324563, 'Scarab seal', 'stamp seal|stone, cream colored|'),
  SearchData(899, 451579, 'Fragment', 'fragment|earthenware; glazed|ceramics'),
  SearchData(849, 451520, 'Fragment', 'fragment|earthenware; molded decoration, glazed|ceramics'),
  SearchData(
      1800, 31772, 'Dagger (Jambiya) with Sheath', 'dagger (jambiya) with sheath|steel, brass, wood, textile|daggers'),
  SearchData(937, 451509, 'Fragment', 'fragment|earthenware; glazed|ceramics'),
  SearchData(-1500, 327792, 'Cylinder seal', 'cylinder seal|copper alloy (leaded bronze)|'),
  SearchData(1199, 451511, 'Fragment', 'fragment|stonepaste; underglaze painted|ceramics'),
  SearchData(50, 324244, 'Fragment of painted ware', 'sherd|ceramic, pigment|'),
  SearchData(849, 455173, 'Fragment', 'fragment|earthenware; painted and glazed|ceramics'),
  SearchData(-1, 322592, 'Camel and riders', 'sculpture|silver|'),
  SearchData(1299, 451586, 'Fragment', 'fragment|porcelain|ceramics'),
  SearchData(849, 451561, 'Fragment', 'fragment|earthenware; slip painted and glazed|ceramics'),
  SearchData(50, 324249, 'Sherd', 'sherd|ceramic|'),
  SearchData(50, 325917, 'Bowl', 'bowl|ceramic|'),
  SearchData(-125, 326695, 'Standing male figure', 'sculpture|alabaster (gypsum)|'),
];
