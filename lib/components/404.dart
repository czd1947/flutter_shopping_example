import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

class AdvancedNotFoundPage extends StatefulWidget {
  final String? customTitle;
  final String? customDescription;
  final Widget? customAction;

  const AdvancedNotFoundPage({
    Key? key,
    this.customTitle,
    this.customDescription,
    this.customAction,
  }) : super(key: key);

  @override
  State<AdvancedNotFoundPage> createState() => _AdvancedNotFoundPageState();
}

class Particle {
  double x, y;
  double vx, vy;
  double size;
  double life;
  Color color;

  Particle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.size,
    required this.life,
    required this.color,
  });
}

class _AdvancedNotFoundPageState extends State<AdvancedNotFoundPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _floatAnimation;
  late Timer _particleTimer;

  final List<Particle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(
      begin: -10,
      end: 10,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // 创建初始粒子
    for (int i = 0; i < 15; i++) {
      _createParticle();
    }

    // 定时更新粒子
    _particleTimer = Timer.periodic(
      const Duration(milliseconds: 50),
      (_) => _updateParticles(),
    );
  }

  void _createParticle() {
    final colors = [
      Colors.red.withOpacity(0.6),
      Colors.orange.withOpacity(0.6),
      Colors.purple.withOpacity(0.6),
    ];

    _particles.add(
      Particle(
        x: _random.nextDouble() * 400 - 200,
        y: _random.nextDouble() * 400 - 200,
        vx: _random.nextDouble() * 2 - 1,
        vy: _random.nextDouble() * 2 - 1,
        size: _random.nextDouble() * 4 + 1,
        life: _random.nextDouble() * 100 + 50,
        color: colors[_random.nextInt(colors.length)],
      ),
    );
  }

  void _updateParticles() {
    for (int i = _particles.length - 1; i >= 0; i--) {
      final particle = _particles[i];
      particle.x += particle.vx;
      particle.y += particle.vy;
      particle.life -= 1;

      if (particle.life <= 0 ||
          particle.x.abs() > 250 ||
          particle.y.abs() > 250) {
        _particles.removeAt(i);
      }
    }

    // 补充新粒子
    while (_particles.length < 15) {
      _createParticle();
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _handleSearch() {
    showSearch(context: context, delegate: _CustomSearchDelegate());
  }

  @override
  void dispose() {
    _controller.dispose();
    _particleTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // 粒子背景
          CustomPaint(
            painter: _ParticlePainter(_particles),
            size: Size.infinite,
          ),

          // 主内容
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 404 数字和动画
                    AnimatedBuilder(
                      animation: _floatAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, _floatAnimation.value),
                          child: child,
                        );
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // 发光效果
                          Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  colorScheme.error.withOpacity(0.15),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),

                          // 3D 效果的数字
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _build3DNumber('4', colorScheme.error),
                              const SizedBox(width: 10),
                              _build3DNumber('0', colorScheme.secondary),
                              const SizedBox(width: 10),
                              _build3DNumber('4', colorScheme.primary),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // 标题
                    Text(
                      widget.customTitle ?? '页面丢失了',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: colorScheme.onBackground,
                        letterSpacing: 1.5,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 描述
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        widget.customDescription ??
                            '我们找遍了每个角落，但似乎这个页面已经消失了。\n可能是链接已更改，或者页面已被移除。',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.6,
                          color: colorScheme.onBackground.withOpacity(0.7),
                        ),
                      ),
                    ),

                    const SizedBox(height: 50),

                    // 操作区域
                    widget.customAction ?? _buildDefaultActions(context),

                    const SizedBox(height: 30),

                    // 额外选项
                    Wrap(
                      spacing: 16,
                      runSpacing: 12,
                      alignment: WrapAlignment.center,
                      children: [
                        ActionChip(
                          avatar: const Icon(Icons.search, size: 18),
                          label: const Text('搜索页面'),
                          onPressed: _handleSearch,
                        ),
                        ActionChip(
                          avatar: const Icon(Icons.home, size: 18),
                          label: const Text('返回首页'),
                          onPressed: () => Navigator.popUntil(
                            context,
                            (route) => route.isFirst,
                          ),
                        ),
                        ActionChip(
                          avatar: const Icon(Icons.report_problem, size: 18),
                          label: const Text('报告问题'),
                          onPressed: () {
                            // 报告问题逻辑
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _build3DNumber(String number, Color color) {
    return Stack(
      children: [
        // 阴影
        Transform.translate(
          offset: const Offset(3, 3),
          child: Text(
            number,
            style: TextStyle(
              fontSize: 70,
              fontWeight: FontWeight.w900,
              color: Colors.black.withOpacity(0.2),
            ),
          ),
        ),
        // 主文字
        Text(
          number,
          style: TextStyle(
            fontSize: 70,
            fontWeight: FontWeight.w900,
            color: color,
            shadows: [
              Shadow(
                color: color.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDefaultActions(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: WrapAlignment.center,
      children: [
        FilledButton(
          onPressed: () => Navigator.maybePop(context),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.arrow_back_rounded),
              SizedBox(width: 8),
              Text('返回', style: TextStyle(fontSize: 16)),
            ],
          ),
        ),

        FilledButton.tonal(
          onPressed: () {
            // 刷新当前路由逻辑
          },
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.refresh_rounded),
              SizedBox(width: 8),
              Text('刷新页面', style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ],
    );
  }
}

// 粒子绘制器
class _ParticlePainter extends CustomPainter {
  final List<Particle> particles;

  _ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    for (final particle in particles) {
      final paint = Paint()
        ..color = particle.color
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        center.translate(particle.x, particle.y),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// 自定义搜索委托
class _CustomSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(child: Text('搜索结果: $query'));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.home),
          title: const Text('首页'),
          onTap: () {
            close(context, 'home');
          },
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('设置'),
          onTap: () {
            close(context, 'settings');
          },
        ),
      ],
    );
  }
}
