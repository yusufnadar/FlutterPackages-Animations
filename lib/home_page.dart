import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

const String text =
    "Yinelenen bir sayfa içeriğinin okuyucunun dikkatini dağıttığı bilinen bir gerçektir. Lorem Ipsum kullanmanın amacı, sürekli 'buraya metin gelecek, buraya metin gelecek' yazmaya kıyasla daha dengeli bir harf dağılımı sağlayarak okunurluğu artırmasıdır. Şu anda birçok masaüstü yayıncılık paketi ve web sayfa düzenleyicisi, varsayılan mıgır metinler olarak Lorem Ipsum kullanmaktadır.";

const String image =
    "https://iso.500px.com/wp-content/uploads/2016/03/stock-photo-142984111.jpg";

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _showList = false;
  bool _slowAnimation = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animations Page'),
        actions: [
          IconButton(
              onPressed: () => setState(() => _showList = !_showList),
              icon: const Icon(Icons.code))
        ],
      ),
      body: PageTransitionSwitcher(
        transitionBuilder: (Widget child, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        },
        child: _showList ? const ListExample() : const GridExample(),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(12),
        child: Container(
          color: Colors.grey.shade300,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text('Slow Motion'),
              Switch(
                onChanged: (bool value) async {
                  setState(() {
                    _slowAnimation = value;
                  });
                  if (_slowAnimation) {
                    await Future.delayed(const Duration(milliseconds: 300));
                  }
                  timeDilation = _slowAnimation ? 4.0 : 1.0;
                },
                value: _slowAnimation,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ListExample extends StatefulWidget {
  const ListExample({Key? key}) : super(key: key);

  @override
  _ListExampleState createState() => _ListExampleState();
}

class _ListExampleState extends State<ListExample> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 16,
      itemBuilder: (context, index) => OpenContainer(
          transitionType: ContainerTransitionType.fade,
          closedBuilder: (_, VoidCallback openContainer) {
            return Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: ListTile(
                leading: Image.network(image),
                title: Text('Text $index'),
                onTap: openContainer,
              ),
            );
          },
          openBuilder: (_, __) {
            return const DetailPage();
          }),
    );
  }
}

class GridExample extends StatefulWidget {
  const GridExample({Key? key}) : super(key: key);

  @override
  _GridExampleState createState() => _GridExampleState();
}

class _GridExampleState extends State<GridExample> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.only(top: 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: 1.6),
      itemBuilder: (context, index) => OpenContainer(
          transitionType: ContainerTransitionType.fadeThrough,
          closedBuilder: (_, VoidCallback openContainer) {
            return Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: ListTile(
                leading: Image.network(image),
                title: Text('Text $index'),
                onTap: openContainer,
              ),
            );
          },
          openBuilder: (_, __) {
            return const DetailPage();
          }),
    );
  }
}

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool _largePhoto = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Screen'),
      ),
      body: PageTransitionSwitcher(
        reverse: _largePhoto,
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (Widget child, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return SharedAxisTransition(
            child: child,
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.scaled,
          );
        },
        child: _largePhoto
            ? GestureDetector(
                onTap: () => setState(() => _largePhoto = !_largePhoto),
                child: Image.network(
                  image,
                  height: double.infinity,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => _largePhoto = !_largePhoto),
                      child: Image.network(image),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      text,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
