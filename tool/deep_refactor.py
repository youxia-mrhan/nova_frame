#!/usr/bin/env python3
"""Deep refactor: file moves + symbol renames for nova_frame."""
from __future__ import annotations

import os
import re
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
LIB = ROOT / "lib"

# (old_rel, new_rel) under lib/
FILE_MOVES = [
    ("res/kit_colors.dart", "theme/color_palette.dart"),
    ("res/kit_strings.dart", "theme/app_strings.dart"),
    ("shared/action/kit_log.dart", "foundation/logger/nova_logger.dart"),
    ("shared/widget/kit_refresh_list.dart", "shared/refresh/refresh_list_view.dart"),
    ("navigation/annotation/app_route.dart", "navigation/annotation/nova_route.dart"),
    ("navigation/app_router.dart", "navigation/nova_router.dart"),
    ("navigation/app_router.gr.dart", "navigation/nova_router.gr.dart"),
    ("navigation/core/app_uri.dart", "navigation/uri/nova_uri.dart"),
    ("navigation/app_context.dart", "navigation/nova_navigator_context.dart"),
    ("navigation/app_route_observer.dart", "navigation/nova_route_observer.dart"),
    ("navigation/route_page_label_registry.dart", "navigation/nova_route_labels.dart"),
    ("navigation/core/route_path_context.dart", "navigation/protocol/route_navigation.dart"),
    ("navigation/core/route_tracker.dart", "navigation/tracking/route_tracker.dart"),
    ("navigation/core/route_center.dart", "navigation/navigation_exports.dart"),
    ("navigation/link/link_schemes.dart", "navigation/link/nova_link_scheme.dart"),
    ("navigation/link/kit_app_links.dart", "navigation/deep_link/nova_app_links.dart"),
    ("foundation/reactive/vns_obx.dart", "foundation/reactive/value_state.dart"),
    ("foundation/reactive/page_vns.dart", "foundation/reactive/page_state.dart"),
    ("foundation/reactive/sns_sbx.dart", "foundation/reactive/stream_state.dart"),
    ("foundation/reactive/vns_multi_listen.dart", "foundation/reactive/multi_listen.dart"),
    ("foundation/reactive/change_notifier_provided_consumer.dart", "foundation/reactive/provided_consumer.dart"),
    ("telemetry/page_session_constants.dart", "telemetry/models/session_constants.dart"),
    ("telemetry/page_route_nav_op.dart", "telemetry/models/nav_operation.dart"),
    ("telemetry/page_session_telemetry.dart", "telemetry/session/session_tracker.dart"),
    ("telemetry/page_session_uploader.dart", "telemetry/uploader/session_uploader.dart"),
    ("telemetry/page_session_scope.dart", "telemetry/session/session_scope.dart"),
    ("telemetry/page_session_route_observer_mixin.dart", "telemetry/session/session_route_observer.dart"),
    ("telemetry/page_app_lifecycle_telemetry.dart", "telemetry/lifecycle/app_lifecycle_tracker.dart"),
    ("telemetry/route_telemetry_labels.dart", "telemetry/navigation/nav_telemetry_labels.dart"),
    ("app/page/adaptive_page.dart", "shared/layouts/nova_page_shell.dart"),
    ("services/storage/drift/app_database.dart", "services/storage/drift/nova_database.dart"),
    ("services/storage/drift/app_database.g.dart", "services/storage/drift/nova_database.g.dart"),
]

# Longest-first symbol replacements (content only)
SYMBOL_REPLACEMENTS = [
    ("PageSessionDriftTableNames", "SessionTableNames"),
    ("PageSessionActionsTable", "SessionActionTable"),
    ("PageSessionsTable", "SessionTable"),
    ("kPageSessionDriftSchemaVersion", "kSessionDriftSchemaVersion"),
    ("PageSessionSyncStatus", "SessionSyncStatus"),
    ("PageSessionRouteObserverMixin", "SessionRouteObserverMixin"),
    ("PageSessionBinding", "SessionBinding"),
    ("PageSessionTelemetry", "SessionTracker"),
    ("PageSessionUploader", "SessionUploader"),
    ("PageSessionScope", "SessionScope"),
    ("PageAppLifecycleTelemetry", "AppLifecycleTracker"),
    ("PageRouteNavOp", "NavOperation"),
    ("RouteTelemetryLabels", "NavTelemetryLabels"),
    ("kitRefreshEmptyScroll", "refreshEmptyPlaceholder"),
    ("kitRefreshLoadingScroll", "refreshLoadingPlaceholder"),
    ("KitRefreshScrollBuilder", "RefreshScrollBuilder"),
    ("KitRefreshList", "RefreshListView"),
    ("KitOnLoadMore", "OnLoadMoreCallback"),
    ("KitOnRefresh", "OnRefreshCallback"),
    ("kitAppLinkLinkOverride", "novaDeepLinkBuilder"),
    ("KitAppLinks", "NovaAppLinks"),
    ("AdaptiveStatefulPageState", "NovaStatefulPageShellState"),
    ("AdaptiveStatefulPage", "NovaStatefulPageShell"),
    ("AdaptivePage", "NovaPageShell"),
    ("ChangeNotifierProvidedConsumer", "NovaProvidedConsumer"),
    ("PageLoadState", "NovaPageLoadState"),
    ("PageLoadPhase", "NovaPageLoadPhase"),
    ("PageVns", "NovaPageState"),
    ("PageObx", "NovaPageView"),
    ("VnsAllDirtyGate", "NovaAllDirtyGate"),
    ("vnsAnyMerged", "novaAnyMerged"),
    ("RoutePathContextX", "NovaRouteContextX"),
    ("RoutePageLabelRegistry", "NovaRouteLabelRegistry"),
    ("RouteTracker", "NovaRouteTracker"),
    ("appRoute", "NovaRoute"),
    ("@appRoute", "@NovaRoute"),
    ("KitColor", "NovaColorPalette"),
    ("KitStr", "AppStrings"),
    ("KitLog", "NovaLogger"),
    ("AppRouter", "NovaRouter"),
    ("appRouter", "novaRouter"),
    ("AppUri", "NovaUri"),
    ("AppContext", "NovaNavigatorContext"),
    ("AppRouteObserver", "NovaRouteObserver"),
    ("LinkSchemes", "NovaLinkScheme"),
    ("AppDatabase", "NovaDatabase"),
    ("novaframedev", "novadev"),
    ("novaframe", "nova"),
    ("Obs<", "NovaObs<"),
    ("class Vns<", "class NovaNotifier<"),
    ("extends Vns<", "extends NovaNotifier<"),
    (" Vns<", " NovaNotifier<"),
    ("(Vns<", "(NovaNotifier<"),
    (" Vns(", " NovaNotifier("),
    ("final Vns", "final NovaNotifier"),
    ("late final Vns", "late final NovaNotifier"),
    ("class Obx<", "class NovaBuilder<"),
    (" Obx<", " NovaBuilder<"),
    ("class Sns<", "class NovaStreamNotifier<"),
    (" Sns<", " NovaStreamNotifier<"),
    ("class Sbx<", "class NovaStreamBox<"),
    (" Sbx<", " NovaStreamBox<"),
    ("typedef Obs", "typedef NovaObs"),
]

IMPORT_PATH_REPLACEMENTS = [
    ("package:nova_frame/res/kit_colors.dart", "package:nova_frame/theme/color_palette.dart"),
    ("package:nova_frame/res/kit_strings.dart", "package:nova_frame/theme/app_strings.dart"),
    ("package:nova_frame/shared/action/kit_log.dart", "package:nova_frame/foundation/logger/nova_logger.dart"),
    ("package:nova_frame/shared/widget/kit_refresh_list.dart", "package:nova_frame/shared/refresh/refresh_list_view.dart"),
    ("package:nova_frame/navigation/annotation/app_route.dart", "package:nova_frame/navigation/annotation/nova_route.dart"),
    ("package:nova_frame/navigation/app_router.dart", "package:nova_frame/navigation/nova_router.dart"),
    ("package:nova_frame/navigation/core/app_uri.dart", "package:nova_frame/navigation/uri/nova_uri.dart"),
    ("package:nova_frame/navigation/app_context.dart", "package:nova_frame/navigation/nova_navigator_context.dart"),
    ("package:nova_frame/navigation/app_route_observer.dart", "package:nova_frame/navigation/nova_route_observer.dart"),
    ("package:nova_frame/navigation/route_page_label_registry.dart", "package:nova_frame/navigation/nova_route_labels.dart"),
    ("package:nova_frame/navigation/core/route_path_context.dart", "package:nova_frame/navigation/protocol/route_navigation.dart"),
    ("package:nova_frame/navigation/core/route_tracker.dart", "package:nova_frame/navigation/tracking/route_tracker.dart"),
    ("package:nova_frame/navigation/core/route_center.dart", "package:nova_frame/navigation/navigation_exports.dart"),
    ("package:nova_frame/navigation/link/link_schemes.dart", "package:nova_frame/navigation/link/nova_link_scheme.dart"),
    ("package:nova_frame/navigation/link/kit_app_links.dart", "package:nova_frame/navigation/deep_link/nova_app_links.dart"),
    ("package:nova_frame/foundation/reactive/vns_obx.dart", "package:nova_frame/foundation/reactive/value_state.dart"),
    ("package:nova_frame/foundation/reactive/page_vns.dart", "package:nova_frame/foundation/reactive/page_state.dart"),
    ("package:nova_frame/foundation/reactive/sns_sbx.dart", "package:nova_frame/foundation/reactive/stream_state.dart"),
    ("package:nova_frame/foundation/reactive/vns_multi_listen.dart", "package:nova_frame/foundation/reactive/multi_listen.dart"),
    ("package:nova_frame/foundation/reactive/change_notifier_provided_consumer.dart", "package:nova_frame/foundation/reactive/provided_consumer.dart"),
    ("package:nova_frame/telemetry/page_session_constants.dart", "package:nova_frame/telemetry/models/session_constants.dart"),
    ("package:nova_frame/telemetry/page_route_nav_op.dart", "package:nova_frame/telemetry/models/nav_operation.dart"),
    ("package:nova_frame/telemetry/page_session_telemetry.dart", "package:nova_frame/telemetry/session/session_tracker.dart"),
    ("package:nova_frame/telemetry/page_session_uploader.dart", "package:nova_frame/telemetry/uploader/session_uploader.dart"),
    ("package:nova_frame/telemetry/page_session_scope.dart", "package:nova_frame/telemetry/session/session_scope.dart"),
    ("package:nova_frame/telemetry/page_session_route_observer_mixin.dart", "package:nova_frame/telemetry/session/session_route_observer.dart"),
    ("package:nova_frame/telemetry/page_app_lifecycle_telemetry.dart", "package:nova_frame/telemetry/lifecycle/app_lifecycle_tracker.dart"),
    ("package:nova_frame/telemetry/route_telemetry_labels.dart", "package:nova_frame/telemetry/navigation/nav_telemetry_labels.dart"),
    ("package:nova_frame/app/page/adaptive_page.dart", "package:nova_frame/shared/layouts/nova_page_shell.dart"),
    ("package:nova_frame/services/storage/drift/app_database.dart", "package:nova_frame/services/storage/drift/nova_database.dart"),
    ("/res/kit_colors.dart", "/theme/color_palette.dart"),
    ("/res/kit_strings.dart", "/theme/app_strings.dart"),
    ("/shared/action/kit_log.dart", "/foundation/logger/nova_logger.dart"),
    ("/shared/widget/kit_refresh_list.dart", "/shared/refresh/refresh_list_view.dart"),
    ("/navigation/annotation/app_route.dart", "/navigation/annotation/nova_route.dart"),
    ("/navigation/app_router.dart", "/navigation/nova_router.dart"),
    ("/navigation/core/app_uri.dart", "/navigation/uri/nova_uri.dart"),
    ("/navigation/app_context.dart", "/navigation/nova_navigator_context.dart"),
    ("/navigation/app_route_observer.dart", "/navigation/nova_route_observer.dart"),
    ("/navigation/route_page_label_registry.dart", "/navigation/nova_route_labels.dart"),
    ("/navigation/core/route_path_context.dart", "/navigation/protocol/route_navigation.dart"),
    ("/navigation/core/route_tracker.dart", "/navigation/tracking/route_tracker.dart"),
    ("/navigation/core/route_center.dart", "/navigation/navigation_exports.dart"),
    ("/navigation/link/link_schemes.dart", "/navigation/link/nova_link_scheme.dart"),
    ("/navigation/link/kit_app_links.dart", "/navigation/deep_link/nova_app_links.dart"),
    ("/foundation/reactive/vns_obx.dart", "/foundation/reactive/value_state.dart"),
    ("/foundation/reactive/page_vns.dart", "/foundation/reactive/page_state.dart"),
    ("/foundation/reactive/sns_sbx.dart", "/foundation/reactive/stream_state.dart"),
    ("/foundation/reactive/vns_multi_listen.dart", "/foundation/reactive/multi_listen.dart"),
    ("/foundation/reactive/change_notifier_provided_consumer.dart", "/foundation/reactive/provided_consumer.dart"),
    ("/telemetry/page_session_constants.dart", "/telemetry/models/session_constants.dart"),
    ("/telemetry/page_route_nav_op.dart", "/telemetry/models/nav_operation.dart"),
    ("/telemetry/page_session_telemetry.dart", "/telemetry/session/session_tracker.dart"),
    ("/telemetry/page_session_uploader.dart", "/telemetry/uploader/session_uploader.dart"),
    ("/telemetry/page_session_scope.dart", "/telemetry/session/session_scope.dart"),
    ("/telemetry/page_session_route_observer_mixin.dart", "/telemetry/session/session_route_observer.dart"),
    ("/telemetry/page_app_lifecycle_telemetry.dart", "/telemetry/lifecycle/app_lifecycle_tracker.dart"),
    ("/telemetry/route_telemetry_labels.dart", "/telemetry/navigation/nav_telemetry_labels.dart"),
    ("/app/page/adaptive_page.dart", "/shared/layouts/nova_page_shell.dart"),
    ("/services/storage/drift/app_database.dart", "/services/storage/drift/nova_database.dart"),
    ("part 'app_router.gr.dart'", "part 'nova_router.gr.dart'"),
    ("part 'app_database.g.dart'", "part 'nova_database.g.dart'"),
    ("_$AppDatabase", "_$NovaDatabase"),
    ("_$PageSessionsTable", "_$SessionTable"),
    ("_$PageSessionActionsTable", "_$SessionActionTable"),
]


def git_mv(src: Path, dst: Path) -> None:
    dst.parent.mkdir(parents=True, exist_ok=True)
    if src.exists():
        subprocess.run(["git", "mv", str(src), str(dst)], cwd=ROOT, check=True)


def apply_file_moves() -> None:
    for old, new in FILE_MOVES:
        src = LIB / old
        dst = LIB / new
        if src.exists():
            git_mv(src, dst)
    # remove empty dirs
    for p in [LIB / "res", LIB / "core"]:
        if p.exists() and not any(p.rglob("*")):
            p.rmdir()


def transform_file(path: Path) -> bool:
    text = path.read_text(encoding="utf-8")
    orig = text
    for a, b in IMPORT_PATH_REPLACEMENTS:
        text = text.replace(a, b)
    for a, b in SYMBOL_REPLACEMENTS:
        text = text.replace(a, b)
    if text != orig:
        path.write_text(text, encoding="utf-8")
        return True
    return False


def transform_all() -> int:
    count = 0
    for path in ROOT.rglob("*.dart"):
        if ".dart_tool" in path.parts or "build" in path.parts:
            continue
        if transform_file(path):
            count += 1
    return count


def main() -> None:
    os.chdir(ROOT)
    apply_file_moves()
    n = transform_all()
    print(f"Updated {n} dart files")


if __name__ == "__main__":
    main()
