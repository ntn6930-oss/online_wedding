import 'dart:html' as html;

class Seo {
  static void setMeta({required String title, required String description}) {
    html.document.title = title;
    _set('meta[name="description"]', 'content', description);
    _set('meta[property="og:title"]', 'content', title);
    _set('meta[property="og:description"]', 'content', description);
  }

  static void _set(String selector, String attr, String value) {
    final el = html.document.querySelector(selector);
    if (el != null) {
      el.setAttribute(attr, value);
    } else {
      final m = html.MetaElement()
        ..setAttribute('name', selector)
        ..setAttribute(attr, value);
      html.document.head?.append(m);
    }
  }
}
