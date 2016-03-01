Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20160301181514.dc3dadeb7e18b77a09dddb7f@gmail.com>
References: <20160301181400.9c623ee9230381da90b89b2a@gmail.com>
	<20160301181514.dc3dadeb7e18b77a09dddb7f@gmail.com>
Date: Tue, 1 Mar 2016 14:50:09 -0800
Message-ID: <CAGXu5j+_3g-DAucJz+CYLZPEUauqfy52FmFDquh4xPOGB3Ek1g@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v4 1/3] GCC plugin infrastructure
To: Emese Revfy <re.emese@gmail.com>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Michal Marek <mmarek@suse.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Fengguang Wu <fengguang.wu@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Mar 1, 2016 at 9:15 AM, Emese Revfy <re.emese@gmail.com> wrote:
> This patch allows to build the whole kernel with GCC plugins. It was ported from
> grsecurity/PaX. The infrastructure supports building out-of-tree modules and
> building in a separate directory. Cross-compilation is supported too but
> currently only the x86 architecture enables plugins.

Sorry for the piecemeal review. :) I keep finding little things...

> diff --git a/scripts/Makefile.host b/scripts/Makefile.host
> index 133edfa..4d180d9 100644
> --- a/scripts/Makefile.host
> +++ b/scripts/Makefile.host
> @@ -124,5 +159,37 @@ quiet_cmd_host-cxxobjs     = HOSTCXX $@
>  $(host-cxxobjs): $(obj)/%.o: $(src)/%.cc FORCE
>         $(call if_changed_dep,host-cxxobjs)
>
> +# Compile .c file, create position independent .o file
> +# host-cshobjs -> .o
> +quiet_cmd_host-cshobjs = HOSTCC  -fPIC $@

Is there a reason to include the -fPIC and -shared (below) in the
"quiet" output?

I think this makes it harder to scan output, and is less "quiet" than
I'd expect:

...
  SYSHDR  arch/x86/entry/syscalls/../../include/generated/uapi/asm/unistd_x32.h
  HOSTCXX -fPIC tools/gcc/format_template.o
  CHK     include/generated/uapi/linux/version.h
  CHK     include/generated/utsrelease.h
  HOSTLLD -shared tools/gcc/format_template.so
  HOSTCC  arch/x86/tools/relocs_32.o
...

> +      cmd_host-cshobjs = $(HOSTCC) $(hostc_flags) -fPIC -c -o $@ $<
> +$(host-cshobjs): $(obj)/%.o: $(src)/%.c FORCE
> +       $(call if_changed_dep,host-cshobjs)
> +
> +# Compile .c file, create position independent .o file
> +# host-cxxshobjs -> .o
> +quiet_cmd_host-cxxshobjs       = HOSTCXX -fPIC $@
> +      cmd_host-cxxshobjs       = $(HOSTCXX) $(hostcxx_flags) -fPIC -c -o $@ $<
> +$(host-cxxshobjs): $(obj)/%.o: $(src)/%.c FORCE
> +       $(call if_changed_dep,host-cxxshobjs)
> +
> +# Link a shared library, based on position independent .o files
> +# *.o -> .so shared library (host-cshlib)
> +quiet_cmd_host-cshlib  = HOSTLLD -shared $@
> +      cmd_host-cshlib  = $(HOSTCC) $(HOSTLDFLAGS) -shared -o $@ \
> +                         $(addprefix $(obj)/,$($(@F:.so=-objs))) \
> +                         $(HOST_LOADLIBES) $(HOSTLOADLIBES_$(@F))
> +$(host-cshlib): $(obj)/%: $(host-cshobjs) FORCE
> +       $(call if_changed,host-cshlib)
> +
> +# Link a shared library, based on position independent .o files
> +# *.o -> .so shared library (host-cxxshlib)
> +quiet_cmd_host-cxxshlib        = HOSTLLD -shared $@
> +      cmd_host-cxxshlib        = $(HOSTCXX) $(HOSTLDFLAGS) -shared -o $@ \
> +                         $(addprefix $(obj)/,$($(@F:.so=-objs))) \
> +                         $(HOST_LOADLIBES) $(HOSTLOADLIBES_$(@F))
> +$(host-cxxshlib): $(obj)/%: $(host-cxxshobjs) FORCE
> +       $(call if_changed,host-cxxshlib)
> +
>  targets += $(host-csingle)  $(host-cmulti) $(host-cobjs)\
> -          $(host-cxxmulti) $(host-cxxobjs)
> +          $(host-cxxmulti) $(host-cxxobjs) $(host-cshlib) $(host-cshobjs) $(host-cxxshlib) $(host-cxxshobjs)

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
