// lib/presentation/screens/contacts_list_screen.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/contact.dart';
import '../blocs/contacts/contacts_bloc.dart';
import 'contact_form_screen.dart';
import 'change_history_screen.dart';

class ContactsListScreen extends StatefulWidget {
  const ContactsListScreen({super.key});

  @override
  State<ContactsListScreen> createState() => _ContactsListScreenState();
}

class _ContactsListScreenState extends State<ContactsListScreen> {
  final _controller = TextEditingController();

  // @override
  // void initState() {
  //   super.initState();
  //   context.read<ContactsBloc>().add(ContactsStarted());
  // }
  @override
  void initState() {
    super.initState();

    // initial load
    context.read<ContactsBloc>().add(ContactsStarted());

    // periodic background sync of pending offline ops (every 20s while screen is mounted)
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 20));
      try {
        final bloc = context.read<ContactsBloc>();
        // access the repository via the bloc and push the pending queue
        // (repo has trySyncPendingQueue())
        // ignore: avoid_dynamic_calls
        await (bloc.repo as dynamic).trySyncPendingQueue();
      } catch (_) {
        // swallow errors; next tick will retry
      }
      return mounted; // keep looping while this screen is alive
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const ContactFormScreen()),
        ),
        icon: const Icon(Icons.add),
        label: const Text('New Contact'),
      ),
      body: RefreshIndicator(
        onRefresh: () async => context.read<ContactsBloc>().add(ContactsRefresh()),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              expandedHeight: 120,
              backgroundColor: cs.primary,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsetsDirectional.only(start: 16, bottom: 6),
                title: const Text('Contacts',style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),),
                background: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        cs.primary.withOpacity(0.95),
                        cs.tertiary.withOpacity(0.85),
                      ],
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: _SearchBar(controller: _controller),
                  ),
                ),
              ),
            ),

            // Content
            SliverToBoxAdapter(child: const SizedBox(height: 8)),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              sliver: BlocBuilder<ContactsBloc, ContactsState>(
                builder: (context, state) {
                  if (state is ContactsLoading) {
                    return _ShimmerList();
                  } else if (state is ContactsError) {
                    return SliverToBoxAdapter(
                      child: _ErrorCard(
                        hasCache: state.hasCache,
                        onRetry: () => context.read<ContactsBloc>().add(ContactsStarted()),
                        onShowCached: state.hasCache
                            ? () => context.read<ContactsBloc>().add(ContactsSearch(''))
                            : null,
                      ),
                    );
                  } else if (state is ContactsEmpty) {
                    return SliverToBoxAdapter(child: _EmptyState(onCreate: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const ContactFormScreen()));
                    }));
                  } else if (state is ContactsContent) {
                    final list = state.list;
                    return SliverList.separated(
                      itemCount: list.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (_, i) => _ContactCard(contact: list[i]),
                    );
                  }
                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                },
              ),
            ),
            SliverToBoxAdapter(child: const SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  const _SearchBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8 + 44), // 44 to float above title
      child: Container(
        decoration: BoxDecoration(
          color: cs.surface.withOpacity(0.95),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 6),
            )
          ],
        ),
        child: TextField(
          controller: controller,
          onChanged: (v) => context.read<ContactsBloc>().add(ContactsSearch(v)),
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: 'Search by name or email',
            hintStyle: TextStyle(color: cs.onSurface.withOpacity(0.6)),
            prefixIcon: const Icon(Icons.search),
            suffixIcon: ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller,
              builder: (_, value, __) => value.text.isEmpty
                  ? const SizedBox.shrink()
                  : IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () {
                  controller.clear();
                  context.read<ContactsBloc>().add(ContactsSearch(''));
                },
              ),
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          ),
        ),
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final Contact contact;
  const _ContactCard({required this.contact});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final initials = _initials(contact.name);
    final avatarColor = _pastelColorFrom(contact.name, cs);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ContactFormScreen(existing: contact)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Avatar
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [avatarColor.withOpacity(0.95), avatarColor.withOpacity(0.65)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  initials,
                  style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.white),
                ),
              ),
              const SizedBox(width: 12),

              // Main info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            contact.name,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (contact.pendingSync) const SizedBox(width: 8),
                        if (contact.pendingSync)
                          _ChipIcon(
                            icon: Icons.hourglass_bottom_rounded,
                            label: 'Pending',
                            color: Colors.orange,
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        if ((contact.email ?? '').isNotEmpty)
                          _InfoPill(icon: Icons.mail_outline, text: contact.email!),
                        if ((contact.phone ?? '').isNotEmpty)
                          _InfoPill(icon: Icons.call_outlined, text: contact.phone!),
                        if ((contact.company ?? '').isNotEmpty)
                          _InfoPill(icon: Icons.apartment_outlined, text: contact.company!),
                      ],
                    ),
                  ],
                ),
              ),

              // Actions
              const SizedBox(width: 8),
              Column(
                children: [
                  IconButton(
                    tooltip: 'Edit',
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ContactFormScreen(existing: contact)),
                    ),
                  ),
                  IconButton(
                    tooltip: 'History',
                    icon: const Icon(Icons.history),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChangeHistoryScreen(
                          contactId: contact.id,
                          contactName: contact.name,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.characters.take(2).toString().toUpperCase();
    return (parts.first.characters.take(1).toString() + parts.last.characters.take(1).toString()).toUpperCase();
  }

  Color _pastelColorFrom(String seed, ColorScheme cs) {
    final h = seed.hashCode;
    final r = 150 + (h & 0x1F); // 150..181
    final g = 140 + ((h >> 5) & 0x1F); // 140..171
    final b = 160 + ((h >> 10) & 0x1F); // 160..191
    return Color.fromARGB(255, r, g, b);
  }
}

class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoPill({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withOpacity(0.55),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: cs.onSurfaceVariant),
          const SizedBox(width: 6),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 180),
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12.5, color: cs.onSurface),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChipIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _ChipIcon({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: color)),
      ]),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onCreate;
  const _EmptyState({required this.onCreate});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Column(
          children: [
            Icon(Icons.contact_page_outlined, size: 64, color: cs.primary),
            const SizedBox(height: 12),
            Text('No contacts yet', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              'Create your first contact to get started.',
              style: TextStyle(color: cs.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onCreate,
              icon: const Icon(Icons.add),
              label: const Text('Add contact'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final bool hasCache;
  final VoidCallback onRetry;
  final VoidCallback? onShowCached;
  const _ErrorCard({required this.hasCache, required this.onRetry, this.onShowCached});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: cs.errorContainer,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.error.withOpacity(0.35)),
        ),
        child: Column(
          children: [
            Icon(Icons.wifi_off_rounded, color: cs.error, size: 40),
            const SizedBox(height: 10),
            Text('Network error', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: cs.error)),
            const SizedBox(height: 8),
            Text(
              hasCache
                  ? 'You can retry, or show your cached contacts.'
                  : 'Please check your connection and retry.',
              textAlign: TextAlign.center,
              style: TextStyle(color: cs.onErrorContainer.withOpacity(0.85)),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton(onPressed: onRetry, child: const Text('Retry')),
                const SizedBox(width: 10),
                if (hasCache)
                  OutlinedButton(onPressed: onShowCached, child: const Text('Show cached')),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _ShimmerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SliverList.builder(
      itemCount: 6,
      itemBuilder: (_, __) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: _ShimmerItem(color: cs.surfaceContainerHighest.withOpacity(0.6)),
      ),
    );
  }
}

class _ShimmerItem extends StatefulWidget {
  final Color color;
  const _ShimmerItem({required this.color});
  @override
  State<_ShimmerItem> createState() => _ShimmerItemState();
}

class _ShimmerItemState extends State<_ShimmerItem> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat();
  @override
  void dispose() { _c.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final base = widget.color;
    return AnimatedBuilder(
      animation: _c,
      builder: (_, __) {
        final t = (math.sin((_c.value * 2 * math.pi)) + 1) / 2; // 0..1
        final glow = Color.lerp(base, Colors.white.withOpacity(0.35), t)!;
        return Container(
          height: 82,
          decoration: BoxDecoration(
            color: glow,
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 4),
        );
      },
    );
  }
}
