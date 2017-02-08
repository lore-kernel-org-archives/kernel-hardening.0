From: valdis.kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1486590490_2896P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 08 Feb 2017 16:48:10 -0500
Message-ID: <43411.1486590490@turing-police.cc.vt.edu>
Subject: [kernel-hardening] next-20170207 initify_plugin kills gcc7.
To: Kees Cook <keescook@chromium.org>
Cc: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

--==_Exmh_1486590490_2896P
Content-Type: text/plain; charset=us-ascii

Seen in next-20170207:

[/usr/src/linux-next] gcc --version
gcc (GCC) 7.0.1 20170204 (Red Hat 7.0.1-0.6)
Copyright (C) 2017 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

[/usr/src/linux-next] make drivers/acpi/acpica/utdebug.o
  CHK     include/config/kernel.release
  CHK     include/generated/uapi/linux/version.h
  CHK     include/generated/utsrelease.h
  CHK     include/generated/timeconst.h
  CHK     include/generated/bounds.h
  CHK     include/generated/asm-offsets.h
  CALL    scripts/checksyscalls.sh
  DESCEND  objtool
  CC      drivers/acpi/acpica/utdebug.o
*** WARNING *** there are active plugins, do not report this as a bug unless you can reproduce it without enabling any plugins.
Event                            | Plugins
PLUGIN_FINISH_TYPE               | structleak_plugin
PLUGIN_ATTRIBUTES                | latent_entropy_plugin structleak_plugin initify_plugin
PLUGIN_START_UNIT                | latent_entropy_plugin initify_plugin
drivers/acpi/acpica/utdebug.c: In function ?acpi_debug_print?:
drivers/acpi/acpica/utdebug.c:158:1: internal compiler error: in is_call_arg_nocapture, at scripts/gcc-plugins/initify_plugin.c:792
 acpi_debug_print(u32 requested_debug_level,
 ^~~~~~~~~~~~~~~~
0x7f253a2b2127 is_call_arg_nocapture
	scripts/gcc-plugins/initify_plugin.c:792
0x7f253a2b2af8 search_capture_use
	scripts/gcc-plugins/initify_plugin.c:1054
0x7f253a2b2af8 has_capture_use_local_var
	scripts/gcc-plugins/initify_plugin.c:1140
0x7f253a2b349f verify_nocapture_functions
	scripts/gcc-plugins/initify_plugin.c:1477
0x7f253a2b349f initify_function_transform
	scripts/gcc-plugins/initify_plugin.c:1485
Please submit a full bug report,
with preprocessed source if appropriate.
Please include the complete backtrace with any bug report.
See <http://bugzilla.redhat.com/bugzilla> for instructions.
The bug is not reproducible, so it is likely a hardware or OS problem.
make[1]: *** [scripts/Makefile.build:295: drivers/acpi/acpica/utdebug.o] Error 1
make: *** [Makefile:1640: drivers/acpi/acpica/utdebug.o] Error 2
[/usr/src/linux-next]


--==_Exmh_1486590490_2896P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Comment: Exmh version 2.5 07/13/2001

iQEVAwUBWJuSGo0DS38y7CIcAQIzqQf/S6NqOBK1nHsAvujCAe7EuS5p5NGz7iyd
+jrE1LdpKXewUnash78Ew4NoRJ2jFBQWKVjIHlJx95py5HJCRabJSYD6GdPHv3oh
kpvg//gsnQyLNyej7Mw5GIpEUpdlIdxr3rhBEuip/agnclWd83kEwNsEe6AAJOUQ
GaJIrwE4Rvd78pFCjxQUEohlpMuMI9o7o5YEO+97xRo0SUcmvC8lm3UBGCRhxoTf
oZmX0HLGlvX30EJHcdWpXEo7SXQdmKyThFDoPh3KX9eLBVdCQAoG3r6M6S4zn5br
7qNlEgKXsDEv92q4Wyl33l/4oMN7dKGD8K2eXE/373PTsEVJF3/4tw==
=5QXM
-----END PGP SIGNATURE-----

--==_Exmh_1486590490_2896P--
