Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 14 Mar 2016 21:14:49 +0100
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20160314211449.2075da4a5806112bebb7ab6d@gmail.com>
In-Reply-To: <CAK7LNAQ+t3z8R+VB7UvGQQqHZcDq+B_F3W0=zTLzmFs_fSybOw@mail.gmail.com>
References: <20160307000208.1bec3e7dc874489d1b4fcbb4@gmail.com>
	<20160307000329.a51b2b8f4fdb0e60344f0b20@gmail.com>
	<CAK7LNAQ+t3z8R+VB7UvGQQqHZcDq+B_F3W0=zTLzmFs_fSybOw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v5 1/5] Shared library support
To: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, pageexec@freemail.hu, spender@grsecurity.net, kernel-hardening@lists.openwall.com, Michal Marek <mmarek@suse.com>, Kees Cook <keescook@chromium.org>, linux@rasmusvillemoes.dk, fengguang.wu@intel.com, dvyukov@google.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, 11 Mar 2016 15:19:33 +0900
Masahiro Yamada <yamada.masahiro@socionext.com> wrote:

> As an alternative, you can add needed build rules
> into tools/gcc/Makefile, not scripts/Makefile.host
> 
> I guess these rule won't be used in other places.

I think it is better if the rules stay under scripts/ because I expect that there will also be clang and llvm plugins
in the future (e.g., clang plugins can access the frontend that gcc plugins can't do). In this case these rules would
either have to be duplicated or moved back under scripts/ (which makes it difficult to backport).
 
> > +# hostcc-option
> > +# Usage: cflags-y += $(call hostcc-option,-march=winchip-c6,-march=i586)
> > +
> > +hostcc-option = $(call try-run,\
> > +       $(HOSTCC) $(HOSTCFLAGS) $(HOST_EXTRACFLAGS) $(1) -c -x c /dev/null -o "$$TMP",$(1),$(2))
> > +
> >  __hostprogs := $(sort $(hostprogs-y) $(hostprogs-m))
> > +__hostlibs := $(sort $(hostlibs-y) $(hostlibs-m))
> > +__hostcxxlibs := $(sort $(hostcxxlibs-y) $(hostcxxlibs-m))
> >
> >  # C code
> >  # Executables compiled from a single .c file
> > @@ -42,6 +60,19 @@ host-cxxmulti        := $(foreach m,$(__hostprogs),$(if $($(m)-cxxobjs),$(m)))
> >  # C++ Object (.o) files compiled from .cc files
> >  host-cxxobjs   := $(sort $(foreach m,$(host-cxxmulti),$($(m)-cxxobjs)))
> >
> > +# Shared libaries (only .c supported)
> > +# Shared libraries (.so) - all .so files referenced in "xxx-objs"
> > +host-cshlib    := $(sort $(filter %.so, $(host-cobjs)))
> 
> useless.

Which part do you think is useless and why?
 
> > +host-cshlib    += $(sort $(filter %.so, $(__hostlibs)))
> > +host-cxxshlib  := $(sort $(filter %.so, $(__hostcxxlibs)))
> > +# Remove .so files from "xxx-objs"
> > +host-cobjs     := $(filter-out %.so,$(host-cobjs))
> > +host-cxxobjs   := $(filter-out %.so,$(host-cxxobjs))
> > +
> > +# Object (.o) files used by the shared libaries
> > +host-cshobjs   := $(sort $(foreach m,$(host-cshlib),$($(m:.so=-objs))))
> > +host-cxxshobjs := $(sort $(foreach m,$(host-cxxshlib),$($(m:.so=-objs))))
> > +
> >  # output directory for programs/.o files
> >  # hostprogs-y := tools/build may have been specified.
> >  # Retrieve also directory of .o files from prog-objs or prog-cxxobjs notation
> > @@ -56,6 +87,10 @@ host-cmulti  := $(addprefix $(obj)/,$(host-cmulti))
> >  host-cobjs     := $(addprefix $(obj)/,$(host-cobjs))
> >  host-cxxmulti  := $(addprefix $(obj)/,$(host-cxxmulti))
> >  host-cxxobjs   := $(addprefix $(obj)/,$(host-cxxobjs))
> > +host-cshlib    := $(addprefix $(obj)/,$(host-cshlib))
> > +host-cxxshlib  := $(addprefix $(obj)/,$(host-cxxshlib))
> > +host-cshobjs   := $(addprefix $(obj)/,$(host-cshobjs))
> > +host-cxxshobjs := $(addprefix $(obj)/,$(host-cxxshobjs))
> >  host-objdirs    := $(addprefix $(obj)/,$(host-objdirs))
> >
> >  obj-dirs += $(host-objdirs)
> > @@ -124,5 +159,37 @@ quiet_cmd_host-cxxobjs     = HOSTCXX $@
> >  $(host-cxxobjs): $(obj)/%.o: $(src)/%.cc FORCE
> >         $(call if_changed_dep,host-cxxobjs)
> >
> > +# Compile .c file, create position independent .o file
> > +# host-cshobjs -> .o
> > +quiet_cmd_host-cshobjs = HOSTCC  -fPIC $@
> > +      cmd_host-cshobjs = $(HOSTCC) $(hostc_flags) -fPIC -c -o $@ $<
> > +$(host-cshobjs): $(obj)/%.o: $(src)/%.c FORCE
> > +       $(call if_changed_dep,host-cshobjs)
> > +
> > +# Compile .c file, create position independent .o file
> > +# host-cxxshobjs -> .o
> > +quiet_cmd_host-cxxshobjs       = HOSTCXX -fPIC $@
> > +      cmd_host-cxxshobjs       = $(HOSTCXX) $(hostcxx_flags) -fPIC -c -o $@ $<
> > +$(host-cxxshobjs): $(obj)/%.o: $(src)/%.c FORCE
> > +       $(call if_changed_dep,host-cxxshobjs)
> > +
> > +# Link a shared library, based on position independent .o files
> > +# *.o -> .so shared library (host-cshlib)
> > +quiet_cmd_host-cshlib  = HOSTLLD -shared $@
> > +      cmd_host-cshlib  = $(HOSTCC) $(HOSTLDFLAGS) -shared -o $@ \
> > +                         $(addprefix $(obj)/,$($(@F:.so=-objs))) \
> > +                         $(HOST_LOADLIBES) $(HOSTLOADLIBES_$(@F))
> > +$(host-cshlib): $(obj)/%: $(host-cshobjs) FORCE
> > +       $(call if_changed,host-cshlib)
> 
> 
> Could you use $(call multi-depend, ...)
> if you need to handle multi-object please?
> 
> Please refer to commit c8589d1e9e01 and commit 97e3226e6e984c8.

Ok, I will check it out.

> But, I still do not see any gcc-plugin that is large enough
> to be linked from multiple objects.

There will be large plugins later (typically if the plugin has more passes e.g., my size_overflow plugin).

-- 
Emese
