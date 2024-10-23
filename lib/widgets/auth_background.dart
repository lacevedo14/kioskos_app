import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;

  const AuthBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.red,3
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          _colorBox(),
          _HeaderIcon(),
          this.child,
        ],
      ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 70),
          child: ClipRRect(
            child: SvgPicture.asset('assets/logo-elite-footer.svg',
                colorFilter:
                    const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
          )
          // Container(
          //   decoration: const BoxDecoration(
          //     image: DecorationImage(image: AssetImage('assets/images/logo_planimedic.png'),fit: BoxFit.scaleDown)
          //   ),
          // ),
          ),
    );
  }
}

class _colorBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: size.height * 0.4,
      decoration: _background(),
      child: Stack(
        children: [
          Positioned(child: _Bubble(), top: 90, left: 30),
          Positioned(child: _Bubble(), top: -40, left: -30),
          Positioned(child: _Bubble(), top: -50, right: -20),
          Positioned(child: _Bubble(), bottom: -50, left: 10),
          Positioned(child: _Bubble(), bottom: 120, right: 20),
        ],
      ),
    );
  }

  BoxDecoration _background() => const BoxDecoration(
          gradient: LinearGradient(colors: [
        Color(0xFF3598dc),
        Color(0xff3d85c6),
      ]));
}

class _Bubble extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Color.fromRGBO(255, 255, 255, 0.05)),
    );
  }
}
