Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20160314211449.2075da4a5806112bebb7ab6d@gmail.com>
References: <20160307000208.1bec3e7dc874489d1b4fcbb4@gmail.com>
	<20160307000329.a51b2b8f4fdb0e60344f0b20@gmail.com>
	<CAK7LNAQ+t3z8R+VB7UvGQQqHZcDq+B_F3W0=zTLzmFs_fSybOw@mail.gmail.com>
	<20160314211449.2075da4a5806112bebb7ab6d@gmail.com>
Date: Wed, 16 Mar 2016 16:50:32 +0900
Message-ID: <CAK7LNART3s3dtsV3fApVmXbqpDe+QBsBOxW37hqCM-YXCzo-Pw@mail.gmail.com>
From: Masahiro Yamada <yamada.masahiro@socionext.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v5 1/5] Shared library support
To: Emese Revfy <re.emese@gmail.com>
Cc: Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, pageexec@freemail.hu, spender@grsecurity.net, kernel-hardening@lists.openwall.com, Michal Marek <mmarek@suse.com>, Kees Cook <keescook@chromium.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, fengguang.wu@intel.com, Dmitry Vyukov <dvyukov@google.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Emese,


2016-03-15 5:14 GMT+09:00 Emese Revfy <re.emese@gmail.com>:
> On Fri, 11 Mar 2016 15:19:33 +0900
> Masahiro Yamada <yamada.masahiro@socionext.com> wrote:
>
>> As an alternative, you can add needed build rules
>> into tools/gcc/Makefile, not scripts/Makefile.host
>>
>> I guess these rule won't be used in other places.
>
> I think it is better if the rules stay under scripts/ because I expect that there will also be clang and llvm plugins
> in the future (e.g., clang plugins can access the frontend that gcc plugins can't do). In this case these rules would
> either have to be duplicated or moved back under scripts/ (which makes it difficult to backport).
>
>> > +# hostcc-option
>> > +# Usage: cflags-y += $(call hostcc-option,-march=winchip-c6,-march=i586)
>> > +
>> > +hostcc-option = $(call try-run,\
>> > +       $(HOSTCC) $(HOSTCFLAGS) $(HOST_EXTRACFLAGS) $(1) -c -x c /dev/null -o "$$TMP",$(1),$(2))
>> > +
>> >  __hostprogs := $(sort $(hostprogs-y) $(hostprogs-m))
>> > +__hostlibs := $(sort $(hostlibs-y) $(hostlibs-m))
>> > +__hostcxxlibs := $(sort $(hostcxxlibs-y) $(hostcxxlibs-m))
>> >
>> >  # C code
>> >  # Executables compiled from a single .c file
>> > @@ -42,6 +60,19 @@ host-cxxmulti        := $(foreach m,$(__hostprogs),$(if $($(m)-cxxobjs),$(m)))
>> >  # C++ Object (.o) files compiled from .cc files
>> >  host-cxxobjs   := $(sort $(foreach m,$(host-cxxmulti),$($(m)-cxxobjs)))
>> >
>> > +# Shared libaries (only .c supported)
>> > +# Shared libraries (.so) - all .so files referenced in "xxx-objs"
>> > +host-cshlib    := $(sort $(filter %.so, $(host-cobjs)))
>>
>> useless.
>
> Which part do you think is useless and why?


The line

host-cshlib    := $(sort $(filter %.so, $(host-cobjs)))

is useless because there is no host program that consists of .so files.


Your intention is to generate shared objects as final targets,
not host tools that call shared objects.





-- 
Best Regards
Masahiro Yamada
