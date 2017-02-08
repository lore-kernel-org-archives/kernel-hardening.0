MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <43411.1486590490@turing-police.cc.vt.edu>
References: <43411.1486590490@turing-police.cc.vt.edu>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 8 Feb 2017 15:03:00 -0800
Message-ID: <CAGXu5jLU1j2-Owv-J+723KnTvqvpX0PQkWugvoY4f_WBC6SWRg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: next-20170207 initify_plugin kills gcc7.
To: "Valdis.Kletnieks@vt.edu" <valdis.kletnieks@vt.edu>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, Emese Revfy <re.emese@gmail.com>, PaX Team <pageexec@freemail.hu>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Feb 8, 2017 at 1:48 PM,  <valdis.kletnieks@vt.edu> wrote:
> Seen in next-20170207:
>
> [/usr/src/linux-next] gcc --version
> gcc (GCC) 7.0.1 20170204 (Red Hat 7.0.1-0.6)
> Copyright (C) 2017 Free Software Foundation, Inc.
> This is free software; see the source for copying conditions.  There is NO
> warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
>
> [/usr/src/linux-next] make drivers/acpi/acpica/utdebug.o
>   CHK     include/config/kernel.release
>   CHK     include/generated/uapi/linux/version.h
>   CHK     include/generated/utsrelease.h
>   CHK     include/generated/timeconst.h
>   CHK     include/generated/bounds.h
>   CHK     include/generated/asm-offsets.h
>   CALL    scripts/checksyscalls.sh
>   DESCEND  objtool
>   CC      drivers/acpi/acpica/utdebug.o
> *** WARNING *** there are active plugins, do not report this as a bug unless you can reproduce it without enabling any plugins.
> Event                            | Plugins
> PLUGIN_FINISH_TYPE               | structleak_plugin
> PLUGIN_ATTRIBUTES                | latent_entropy_plugin structleak_plugin initify_plugin
> PLUGIN_START_UNIT                | latent_entropy_plugin initify_plugin
> drivers/acpi/acpica/utdebug.c: In function ?acpi_debug_print?:
> drivers/acpi/acpica/utdebug.c:158:1: internal compiler error: in is_call_arg_nocapture, at scripts/gcc-plugins/initify_plugin.c:792
>  acpi_debug_print(u32 requested_debug_level,
>  ^~~~~~~~~~~~~~~~
> 0x7f253a2b2127 is_call_arg_nocapture
>         scripts/gcc-plugins/initify_plugin.c:792
> 0x7f253a2b2af8 search_capture_use
>         scripts/gcc-plugins/initify_plugin.c:1054
> 0x7f253a2b2af8 has_capture_use_local_var
>         scripts/gcc-plugins/initify_plugin.c:1140
> 0x7f253a2b349f verify_nocapture_functions
>         scripts/gcc-plugins/initify_plugin.c:1477
> 0x7f253a2b349f initify_function_transform
>         scripts/gcc-plugins/initify_plugin.c:1485
> Please submit a full bug report,
> with preprocessed source if appropriate.
> Please include the complete backtrace with any bug report.
> See <http://bugzilla.redhat.com/bugzilla> for instructions.
> The bug is not reproducible, so it is likely a hardware or OS problem.
> make[1]: *** [scripts/Makefile.build:295: drivers/acpi/acpica/utdebug.o] Error 1
> make: *** [Makefile:1640: drivers/acpi/acpica/utdebug.o] Error 2
> [/usr/src/linux-next]
>

Ah, fun! I'll bet this isn't seen in grsecurity because acpica/ is
actually marked up correctly. Still, it shouldn't explode. I'll see if
I can get a gcc 7 installed ...

Thanks!

-Kees

-- 
Kees Cook
Pixel Security
