package dev.dupe.dupe

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.net.Uri
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

/**
 * Home-screen widget (PLAN_V3 phase 19): a "Scanner" button that opens the store-mode
 * scan (dupe://scan, same route as the app shortcut) and counters written by the app
 * (home_widget, key "counts": text already formatted in French).
 */
class DupeWidgetProvider : HomeWidgetProvider() {
  override fun onUpdate(
      context: Context,
      appWidgetManager: AppWidgetManager,
      appWidgetIds: IntArray,
      widgetData: SharedPreferences,
  ) {
    val counts = widgetData.getString("counts", null)
    for (widgetId in appWidgetIds) {
      val views =
          RemoteViews(context.packageName, R.layout.dupe_widget).apply {
            setOnClickPendingIntent(
                R.id.widget_scan,
                HomeWidgetLaunchIntent.getActivity(
                    context, MainActivity::class.java, Uri.parse("dupe://scan")),
            )
            setOnClickPendingIntent(
                R.id.widget_counts,
                HomeWidgetLaunchIntent.getActivity(
                    context, MainActivity::class.java, Uri.parse("dupe://home")),
            )
            setTextViewText(R.id.widget_counts, counts ?: "")
            setViewVisibility(
                R.id.widget_counts, if (counts.isNullOrEmpty()) View.GONE else View.VISIBLE)
          }
      appWidgetManager.updateAppWidget(widgetId, views)
    }
  }
}
