#include <gtk/gtk.h>

#include <cstdlib>

#include "my_application.h"

// GTK 3's Wayland backend aborts at startup when the GNOME xsettings schema
// no longer has the "antialiasing" key (removed in recent GNOME releases,
// e.g. Ubuntu 26.04). In that case, prefer the X11 backend (XWayland).
// An explicit GDK_BACKEND set by the user always wins.
static void work_around_missing_xsettings_keys() {
  if (g_getenv("GDK_BACKEND") != nullptr) {
    return;
  }
  GSettingsSchemaSource* source = g_settings_schema_source_get_default();
  if (source == nullptr) {
    return;
  }
  g_autoptr(GSettingsSchema) schema = g_settings_schema_source_lookup(
      source, "org.gnome.settings-daemon.plugins.xsettings", TRUE);
  if (schema != nullptr && !g_settings_schema_has_key(schema, "antialiasing")) {
    gdk_set_allowed_backends("x11,*");
  }
}

int main(int argc, char** argv) {
  work_around_missing_xsettings_keys();
  g_autoptr(MyApplication) app = my_application_new();
  return g_application_run(G_APPLICATION(app), argc, argv);
}
