const Gettext = imports.gettext
const Gtk = imports.gi.Gtk
const GObject = imports.gi.GObject
const Gio = imports.gi.Gio
const Config = imports.misc.config
const GTKTitleBar = imports.misc.extensionUtils.getCurrentExtension()
const Convenience = GTKTitleBar.imports.convenience

var PrefsWidget = GObject.registerClass(
  class GTKTBPrefsWidget extends Gtk.Box {
    _init(params) {
      this._settings = Convenience.getSettings()
      super._init(params)

      this._buildable = new Gtk.Builder()
      this._buildable.add_from_file(`${GTKTitleBar.path}/settings.ui`)

      this._container = this._getWidget('prefs_widget')
      this.add(this._container)

      this._bindStrings()
      this._bindSelects()
      this._bindBooleans()
      this._bindEnumerations()
    }

    _getWidget(name) {
      let widgetName = name.replace(/-/g, '_')
      return this._buildable.get_object(widgetName)
    }

    _bindInput(setting, prop) {
      let widget = this._getWidget(setting)
      this._settings.bind(setting, widget, prop, this._settings.DEFAULT_BINDING)
    }

    _bindEnum(setting) {
      let widget = this._getWidget(setting)
      widget.set_active(this._settings.get_enum(setting))

      widget.connect('changed', (combobox) => {
        this._settings.set_enum(setting, combobox.get_active())
      })
    }

    _bindStrings() {
      let settings = this._settings.getTypeSettings('string')
      settings.forEach(setting => { this._bindInput(setting, 'text') })
    }

    _bindSelects() {
      let settings = this._settings.getTypeSettings('select')
      settings.forEach(setting => { this._bindInput(setting, 'active-id') })
    }

    _bindBooleans() {
      let settings = this._settings.getTypeSettings('boolean')
      settings.forEach(setting => { this._bindInput(setting, 'active') })
    }

    _bindEnumerations() {
      let settings = this._settings.getTypeSettings('enum')
      settings.forEach(setting => { this._bindEnum(setting) })
    }
  }
)

function init() {
  Convenience.initTranslations()
}

function buildPrefsWidget() {
  let widget = new PrefsWidget()
  widget.show_all()

  return widget
}

