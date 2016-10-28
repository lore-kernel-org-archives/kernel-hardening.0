Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 28 Oct 2016 15:58:00 -0400
From: Brad Spengler <spender@grsecurity.net>
Message-ID: <20161028195800.GA6193@grsecurity.net>
References: <1477071466-19256-1-git-send-email-michael.leibowitz@intel.com>
 <CAGXu5jLN5NLH+ScR_i+C18EXqektP92vCrb2h8K_pvR0Yb1bYg@mail.gmail.com>
 <CAGXu5jLCCUK0AWBf4V-Djqydd3y3JxT5ccLmg8ATwn7_1-DTaQ@mail.gmail.com>
 <CAGXu5jKpjZ9KbUCsTSPxO7pGqKra+K28aECxvA4VRR9Tfrzh+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="dDRMvlgZJXvWKvBx"
Content-Disposition: inline
In-Reply-To: <CAGXu5jKpjZ9KbUCsTSPxO7pGqKra+K28aECxvA4VRR9Tfrzh+A@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH] Add the randstruct gcc plugin
To: Kees Cook <keescook@chromium.org>
Cc: Michael Leibowitz <michael.leibowitz@intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Emese Revfy <re.emese@gmail.com>, PaX Team <pageexec@freemail.hu>, "Schaufler, Casey" <casey.schaufler@intel.com>, "Reshetova, Elena" <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>


--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Just curious:

http://git.kernel.org/cgit/linux/kernel/git/kees/linux.git/commit/?h=3Dkspp=
/gcc-plugin/randstruct&id=3Dcd7686ee26b839ad5e0467ac2162b360bf1fa673

"These were found using allyesconfig on x86, arm, and arm64."

Who found them, and whose code is all that?

http://git.kernel.org/cgit/linux/kernel/git/kees/linux.git/commit/?h=3Dkspp=
/gcc-plugin/randstruct&id=3D6dd5fff4a626c8db8800d76f5096f6efcd2a675f

Who decided on these, whose code is it?

http://git.kernel.org/cgit/linux/kernel/git/kees/linux.git/commit/?h=3Dkspp=
/gcc-plugin/randstruct&id=3D7169767228cd6d117a0908997d9a3b38bfb6a1b9

Ditto -- did you spend the hours to figure the ARM hunk out?  I only see yo=
ur=20
name there.

Show the world you can do something more than plagiarize code.  This is the
third time I'm having to warn you guys collectively about this.  How hard
is it to not plagiarize?

-Brad

On Fri, Oct 28, 2016 at 12:00:14PM -0700, Kees Cook wrote:
> On Thu, Oct 27, 2016 at 11:01 PM, Kees Cook <keescook@chromium.org> wrote:
> > On Thu, Oct 27, 2016 at 9:09 PM, Kees Cook <keescook@chromium.org> wrot=
e:
> >> On Fri, Oct 21, 2016 at 10:37 AM, Michael Leibowitz
> >> <michael.leibowitz@intel.com> wrote:
> >>> This plugin randomizes the layout of certain structures at compile
> >>> time.  This introduces two defines __randomize_layout and
> >>> __no_randomize_layout.  Which, in turn, tell the compiler to either
> >>> try to randomize or not to randomize the struct in question.
> >>>
> >>> This feature is ported over from grsecurity.  The implementation is
> >>> nearly identical to the original code written by the PaX Team and
> >>> Spender.  To make integration simpler, this version only supports
> >>> explicit marking of structures.  However, it retains the
> >>> __no_randomize_layout support for the future.  The UAPI checks are
> >>> retained as well.  Structures that are to be randomized are required
> >>> to use the C99 designated initializer form.
> >>>
> >>> Signed-off-by: Michael Leibowitz <michael.leibowitz@intel.com>
> >>> [...]
> >>> diff --git a/scripts/Makefile.gcc-plugins b/scripts/Makefile.gcc-plug=
ins
> >>> index 61f0e6d..94bfffe 100644
> >>> --- a/scripts/Makefile.gcc-plugins
> >>> +++ b/scripts/Makefile.gcc-plugins
> >>> @@ -19,9 +19,19 @@ ifdef CONFIG_GCC_PLUGINS
> >>>      endif
> >>>    endif
> >>>
> >>> -  GCC_PLUGINS_CFLAGS :=3D $(strip $(addprefix -fplugin=3D$(objtree)/=
scripts/gcc-plugins/, $(gcc-plugin-y)) $(gcc-plugin-cflags-y))
> >>> +  RANDSTRUCT_PLUGIN :=3D -fplugin=3D$(objtree)/scripts/gcc-plugins/r=
andomize_layout_plugin.so
> >>> +  ifdef CONFIG_GCC_PLUGIN_RANDSTRUCT
> >>> +    gcc-plugin-$(CONFIG_GCC_PLUGIN_RANDSTRUCT)         +=3D randomiz=
e_layout_plugin.so
> >>>
> >>> -  export PLUGINCC GCC_PLUGINS_CFLAGS GCC_PLUGIN GCC_PLUGIN_SUBDIR SA=
NCOV_PLUGIN
> >>> +    GCC_PLUGIN_RANDSTRUCT_CFLAGS :=3D -fplugin=3D$(objtree)/scripts/=
gcc-plugins/randomize_layout_plugin.so -DRANDSTRUCT_PLUGIN
> >>> +    ifdef CONFIG_GCC_PLUGIN_RANDSTRUCT_PERFORMANCE
> >>> +      GCC_PLUGIN_RANDSTRUCT_CFLAGS =3D -fplugin-arg-randomize_layout=
_plugin-performance-mode
> >>
> >> Found it: this "=3D" should be "+=3D", though really the whole section
> >> should just be updated to the new style of plugin handling:
> >>
> >>   gcc-plugin-$(CONFIG_GCC_PLUGIN_RANDSTRUCT)    +=3D randomize_layout_=
plugin.so
> >>   gcc-plugin-cflags-$(CONFIG_GCC_PLUGIN_RANDSTRUCT)     +=3D -DRANDSTR=
UCT_PLUGIN
> >>   gcc-plugin-cflags-$(CONFIG_GCC_PLUGIN_RANDSTRUCT_PERFORMANCE) +=3D
> >> -fplugin-arg-randomize_layout_plugin-performance-mode
> >>
> >> and the export of RANDSTRUCT_PLUGIN
> >
> > Also, it looks like "pahole" (or the DWARF record) is lying. :P
> > Printing out offsetof()s shows things clearly randomized.
> >
> > For the next version: can you update to the latest version of this
> > plugin? What you sent seems out of date compared to current
> > grsecurity. Disabling is_pure_ops_struct() with a "return 0" looks to
> > be sufficient to stop the automatic randomization.
>=20
> I've built out a more complete series here:
> http://git.kernel.org/cgit/linux/kernel/git/kees/linux.git/log/?h=3Dkspp/=
gcc-plugin/randstruct
>=20
> This includes all the initializer fixes and opt-in/opt-out markings,
> an updated plugin, etc.
>=20
> It still needs improved comments, changelogs, and some better
> understanding as to why the DWARF information appears broken. If you
> can work from this tree, that'd be great!
>=20
> -Kees
>=20
> --=20
> Kees Cook
> Nexus Security

--dDRMvlgZJXvWKvBx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCgAGBQJYE63BAAoJEETRwPglJf5JQ9oP/0V9OGQQhpn8G7ZrH+gIzR72
KsNpAIIK57B8JgbYtzLZaNtDw4f2AviujQZgIhafk16ctZl6A6PFTgdavKpD2D64
aoeO5mWqoNMJkOLsi/xJHjSkCwuK1AYy9+ejhYkEhAyjH5KiqXs/dDVyLQd0Dxgo
+0OmXTY7+rGnJrgDBC4vDV6LKJbJRlmdknmCyyw7KdPK2+NhYRg6Ddby+Rxq1eKQ
wp3yl0wlRwZFGMBxl5nQpcgD4njar3Yu+yzHNp6njl+alBwKvx52BatvCopMJVzo
HchWLGztYrEsPudiOP5GI21wpGvKVWNcvaMOkHs5gdJBP2HFL29wt9teb7z7ZP1Y
Fxym7Yp7gCssghI4UzoDgJJ4SL/0BPmttcy9Jc3Y5xwGMQbUioCqgemPwAEmNrXl
drYZUjg0uw4whcNKRzwgeCWDZRDizGFXzd0TKZ+M67e1XsoGFXp04+zqXp+pURSY
K6ykNMU3sL2RSLeZXLPlsEoQNOi+t7UKzQsxE+Ih1KW49zOCVHfscLmtIKDsw72i
e/jqSMKzYUC20GeVGwXOhQ9hf63tie/9YW5RT9Trqpk1Wj9HmiIaib9/ry4adn2V
4O5oWFUVpvZB4cXdVvz07lnsPnp7qoPXXnjkPMzEMzR9uTEeAiqF0eZAwrJrFQ7+
VQ5EDNWzQsJqwTqNXTx5
=HBrz
-----END PGP SIGNATURE-----

--dDRMvlgZJXvWKvBx--
