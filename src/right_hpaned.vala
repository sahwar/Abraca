/*
 * vim:noexpandtab:sw=4:sts=0:ts=4:syn=cs
 */
using GLib;

namespace Abraca {
	public class RightHPaned : Gtk.HPaned {
		private Gtk.Entry _filter_entry;
		private FilterTree _filter_tree;
		private PlaylistTree _playlist_tree;

		public FilterTree filter_tree {
			get {
				return _filter_tree;
			}
		}

		public PlaylistTree playlist_tree {
			get {
				return _playlist_tree;
			}
		}

		construct {
			position = 433;
			position_set = false;

			create_widgets();

			_filter_entry.activate += on_filter_entry_activate;
		}

		public void eval_config() {
			int pos = Abraca.instance().config.panes_pos1;

			position = pos.clamp(433, 800);
		}

		private void on_filter_entry_activate(Gtk.Entry entry) {
			Xmms.Collection coll;
			weak string pattern;

			pattern = _filter_entry.get_text();

			Xmms.Collection.parse(pattern, out coll);

			if (coll != null)
				_filter_tree.query_collection(coll);
		}

		private void create_widgets() {
			pack1(create_left_box(), false, true);
			pack2(create_right_box(), true, true);
		}

		private Gtk.Box create_left_box() {
			Gtk.VBox box = new Gtk.VBox(false, 0);

			Gtk.HBox hbox = new Gtk.HBox(false, 6);

			Gtk.Label label = new Gtk.Label("Filter:");
			hbox.pack_start(label, false, false, 0);

			_filter_entry = new Gtk.Entry();
			hbox.pack_start(_filter_entry, true, true, 0);

			box.pack_start(hbox, false, false, 2);

			Gtk.ScrolledWindow scrolled = new Gtk.ScrolledWindow(
				null, null
			);

			scrolled.set_policy(Gtk.PolicyType.AUTOMATIC,
			                    Gtk.PolicyType.AUTOMATIC);

			_filter_tree = new FilterTree();
			scrolled.add_with_viewport(_filter_tree);
			box.pack_start(scrolled, true, true, 0);

			return box;
		}

		private Gtk.Box create_right_box() {
			Gtk.VBox box = new Gtk.VBox(false, 0);

			Gtk.Expander exp = new Gtk.Expander("Playlist");
			box.pack_start(exp, false, false, 2);

			Gtk.ScrolledWindow scrolled = new Gtk.ScrolledWindow(
				null, null
			);

			scrolled.set_policy(Gtk.PolicyType.AUTOMATIC,
			                    Gtk.PolicyType.AUTOMATIC);

			_playlist_tree = new PlaylistTree();
			scrolled.add_with_viewport(_playlist_tree);
			box.pack_start(scrolled, true, true, 0);

			return box;
		}
	}
}