MIME-Version: 1.0
References: <1547198328-26359-1-git-send-email-yamada.masahiro@socionext.com>
In-Reply-To: <1547198328-26359-1-git-send-email-yamada.masahiro@socionext.com>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 11 Jan 2019 09:20:25 -0800
Message-ID: <CAGXu5jJzkqvyhZbCiQFHDZ3v36j2bM3_y_RMCof97rA35Z6opw@mail.gmail.com>
Subject: Re: [PATCH 1/2] kbuild: clean up hostprogs rules with hostld_flags
 and hostld_libs
Content-Type: text/plain; charset="UTF-8"
To: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Emese Revfy <re.emese@gmail.com>, Michal Marek <michal.lkml@markovi.net>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jan 11, 2019 at 1:19 AM Masahiro Yamada
<yamada.masahiro@socionext.com> wrote:
>
> Add hostld_flags and hostld_libs shorthands. No function change.
>
> Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>
>  scripts/Makefile.host | 23 +++++++++++++----------
>  1 file changed, 13 insertions(+), 10 deletions(-)
>
> diff --git a/scripts/Makefile.host b/scripts/Makefile.host
> index 0393f75..f2e15de 100644
> --- a/scripts/Makefile.host
> +++ b/scripts/Makefile.host
> @@ -78,23 +78,26 @@ endif
>  hostc_flags    = -Wp,-MD,$(depfile) $(__hostc_flags)
>  hostcxx_flags  = -Wp,-MD,$(depfile) $(__hostcxx_flags)
>
> +hostld_flags   = $(KBUILD_HOSTLDFLAGS)
> +hostld_libs    = $(KBUILD_HOSTLDLIBS) $(HOSTLDLIBS_$(@F))
> +
>  #####
>  # Compile programs on the host
>
>  # Create executable from a single .c file
>  # host-csingle -> Executable
>  quiet_cmd_host-csingle         = HOSTCC  $@
> -      cmd_host-csingle = $(HOSTCC) $(hostc_flags) $(KBUILD_HOSTLDFLAGS) -o $@ $< \
> -               $(KBUILD_HOSTLDLIBS) $(HOSTLDLIBS_$(@F))
> +      cmd_host-csingle = $(HOSTCC) $(hostc_flags) $(hostld_flags) -o $@ $< \
> +               $(hostld_libs)
>  $(host-csingle): $(obj)/%: $(src)/%.c FORCE
>         $(call if_changed_dep,host-csingle)
>
>  # Link an executable based on list of .o files, all plain c
>  # host-cmulti -> executable
>  quiet_cmd_host-cmulti  = HOSTLD  $@
> -      cmd_host-cmulti  = $(HOSTCC) $(KBUILD_HOSTLDFLAGS) -o $@ \
> +      cmd_host-cmulti  = $(HOSTCC) $(hostld_flags) -o $@ \
>                           $(addprefix $(obj)/,$($(@F)-objs)) \
> -                         $(KBUILD_HOSTLDLIBS) $(HOSTLDLIBS_$(@F))
> +                         $(hostld_libs)
>  $(host-cmulti): FORCE
>         $(call if_changed,host-cmulti)
>  $(call multi_depend, $(host-cmulti), , -objs)
> @@ -109,10 +112,10 @@ $(host-cobjs): $(obj)/%.o: $(src)/%.c FORCE
>  # Link an executable based on list of .o files, a mixture of .c and .cc
>  # host-cxxmulti -> executable
>  quiet_cmd_host-cxxmulti        = HOSTLD  $@
> -      cmd_host-cxxmulti        = $(HOSTCXX) $(KBUILD_HOSTLDFLAGS) -o $@ \
> +      cmd_host-cxxmulti        = $(HOSTCXX) $(hostld_flags) -o $@ \
>                           $(foreach o,objs cxxobjs,\
>                           $(addprefix $(obj)/,$($(@F)-$(o)))) \
> -                         $(KBUILD_HOSTLDLIBS) $(HOSTLDLIBS_$(@F))
> +                         $(hostld_libs)
>  $(host-cxxmulti): FORCE
>         $(call if_changed,host-cxxmulti)
>  $(call multi_depend, $(host-cxxmulti), , -objs -cxxobjs)
> @@ -143,9 +146,9 @@ $(host-cxxshobjs): $(obj)/%.o: $(src)/%.c FORCE
>  # Link a shared library, based on position independent .o files
>  # *.o -> .so shared library (host-cshlib)
>  quiet_cmd_host-cshlib  = HOSTLLD -shared $@
> -      cmd_host-cshlib  = $(HOSTCC) $(KBUILD_HOSTLDFLAGS) -shared -o $@ \
> +      cmd_host-cshlib  = $(HOSTCC) $(hostld_flags) -shared -o $@ \
>                           $(addprefix $(obj)/,$($(@F:.so=-objs))) \
> -                         $(KBUILD_HOSTLDLIBS) $(HOSTLDLIBS_$(@F))
> +                         $(hostld_libs)
>  $(host-cshlib): FORCE
>         $(call if_changed,host-cshlib)
>  $(call multi_depend, $(host-cshlib), .so, -objs)
> @@ -153,9 +156,9 @@ $(call multi_depend, $(host-cshlib), .so, -objs)
>  # Link a shared library, based on position independent .o files
>  # *.o -> .so shared library (host-cxxshlib)
>  quiet_cmd_host-cxxshlib        = HOSTLLD -shared $@
> -      cmd_host-cxxshlib        = $(HOSTCXX) $(KBUILD_HOSTLDFLAGS) -shared -o $@ \
> +      cmd_host-cxxshlib        = $(HOSTCXX) $(hostld_flags) -shared -o $@ \
>                           $(addprefix $(obj)/,$($(@F:.so=-objs))) \
> -                         $(KBUILD_HOSTLDLIBS) $(HOSTLDLIBS_$(@F))
> +                         $(hostld_libs)
>  $(host-cxxshlib): FORCE
>         $(call if_changed,host-cxxshlib)
>  $(call multi_depend, $(host-cxxshlib), .so, -objs)
> --
> 2.7.4
>


-- 
Kees Cook
