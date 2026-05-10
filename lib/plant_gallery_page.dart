import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'monthly_plant_history.dart';

class PlantGalleryPage
    extends StatelessWidget {
  const PlantGalleryPage(
      {super.key});

  Box<MonthlyPlantHistory>
      get box =>
          Hive.box<MonthlyPlantHistory>(
              'monthly_plant_history');

  List<MonthlyPlantHistory>
      getHistories() {
    final histories =
        box.values.toList();
    histories.sort(
      (a, b) {
        int yearCmp =
            b.year.compareTo(a.year);
        if (yearCmp != 0)
          return yearCmp;
        return b.month.compareTo(a.month);
      },
    );
    return histories;
  }

  @override
  Widget build(
      BuildContext context) {
    final histories =
        getHistories();

    return Scaffold(
      backgroundColor:
          const Color(0xFF09090F),
      appBar: AppBar(
        backgroundColor:
            Colors.black,
        title: const Text(
          'PLANT GALLERY',
          style: TextStyle(
            color: Colors.cyan,
            fontWeight:
                FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ),
      body: SafeArea(
        child: histories.isEmpty
            ? const Center(
                child: Text(
                  'NO HISTORY',
                  style: TextStyle(
                    color: Colors
                        .white54,
                  ),
                ),
              )
            : Padding(
                padding:
                    const EdgeInsets
                        .all(16),
                child:
                    GridView.builder(
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing:
                        16,
                    crossAxisSpacing:
                        16,
                  ),
                  itemCount:
                      histories.length,
                  itemBuilder: (context,
                      index) {
                    final history =
                        histories[index];

                    return Container(
                      decoration:
                          BoxDecoration(
                        gradient:
                            const LinearGradient(
                          colors: [
                            Color(
                                0xFF111827),
                            Color(
                                0xFF1E1B4B),
                          ],
                        ),
                        borderRadius:
                            BorderRadius
                                .circular(
                                    16),
                        border: Border.all(
                          color: Colors
                              .cyan,
                          width: 1.5,
                        ),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsets
                                .all(12),
                        child: Column(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .center,
                          children: [
                            Text(
                              history
                                  .getEmoji(),
                              style:
                                  const TextStyle(
                                fontSize:
                                    48,
                              ),
                            ),
                            const SizedBox(
                                height:
                                    8),
                            Text(
                              '${history.year}年${history.month}月',
                              style:
                                  const TextStyle(
                                color: Colors
                                    .white70,
                                fontSize:
                                    12,
                              ),
                              textAlign:
                                  TextAlign
                                      .center,
                            ),
                            const SizedBox(
                                height:
                                    4),
                            Text(
                              history
                                  .getLevelName(),
                              style:
                                  const TextStyle(
                                color: Colors
                                    .cyan,
                                fontSize:
                                    14,
                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                              textAlign:
                                  TextAlign
                                      .center,
                            ),
                            const SizedBox(
                                height:
                                    4),
                            Text(
                              '${history.totalExp}分',
                              style:
                                  const TextStyle(
                                color: Colors
                                    .white,
                                fontSize:
                                    12,
                              ),
                              textAlign:
                                  TextAlign
                                      .center,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
