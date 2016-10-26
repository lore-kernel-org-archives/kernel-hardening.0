Reply-To: kernel-hardening@lists.openwall.com
From: Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <20161021011210.GT19531@linaro.org>
References: <20161020062458.14014-1-takahiro.akashi@linaro.org> <CAGXu5jJ9jWxsjcPwc9v87ecPYPzoSLTq5bzA0h3t5nSobGdWVQ@mail.gmail.com> <20161021011210.GT19531@linaro.org>
Date: Wed, 26 Oct 2016 10:43:32 +1030
Message-ID: <87wpgw3r2r.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Subject: Re: [kernel-hardening] [PATCH] module: extend 'rodata=off' boot cmdline parameter to module mappings
To: AKASHI Takahiro <takahiro.akashi@linaro.org>, Kees Cook <keescook@chromium.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, Jessica Yu <jeyu@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

AKASHI Takahiro <takahiro.akashi@linaro.org> writes:
> On Thu, Oct 20, 2016 at 01:48:15PM -0700, Kees Cook wrote:
>> On Wed, Oct 19, 2016 at 11:24 PM, AKASHI Takahiro
>> <takahiro.akashi@linaro.org> wrote:
>> > The current "rodata=off" parameter disables read-only kernel mappings
>> > under CONFIG_DEBUG_RODATA:
>> >     commit d2aa1acad22f ("mm/init: Add 'rodata=off' boot cmdline parameter
>> >     to disable read-only kernel mappings")
>> >
>> > This patch is a logical extension to module mappings ie. read-only mappings
>> > at module loading can be disabled even if CONFIG_DEBUG_SET_MODULE_RONX
>> > (mainly for debug use). Please note, however, that it only affects RO/RW
>> > permissions, keeping NX set.

This patch looks good (except the minor issues noted by Kees); please CC
the followup version to Jessica as new module maintainer.

Thanks!
Rusty.

>> >
>> > This is the first step to make CONFIG_DEBUG_SET_MODULE_RONX mandatory
>> > (always-on) in the future as CONFIG_DEBUG_RODATA on x86 and arm64.
>> >
>> > Suggested-by: Mark Rutland <mark.rutland@arm.com>
>> > Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
>> > Cc: Rusty Russell <rusty@rustcorp.com.au>
>> > ---
>> > v1:
>> >   * remove RFC's "module_ronx=" and merge it with "rodata="
>> >   * always keep NX set if CONFIG_SET_MODULE_RONX
>> >
>> >  include/linux/init.h |  3 ++-
>> >  init/main.c          |  2 +-
>> >  kernel/module.c      | 21 ++++++++++++++++++---
>> >  3 files changed, 21 insertions(+), 5 deletions(-)
>> >
>> > diff --git a/include/linux/init.h b/include/linux/init.h
>> > index e30104c..20aa2eb 100644
>> > --- a/include/linux/init.h
>> > +++ b/include/linux/init.h
>> > @@ -126,7 +126,8 @@ void prepare_namespace(void);
>> >  void __init load_default_modules(void);
>> >  int __init init_rootfs(void);
>> >
>> > -#ifdef CONFIG_DEBUG_RODATA
>> > +#if defined(CONFIG_DEBUG_RODATA) || defined(CONFIG_DEBUG_SET_MODULE_RONX)
>> > +extern bool rodata_enabled;
>> >  void mark_rodata_ro(void);
>> >  #endif
>> >
>> > diff --git a/init/main.c b/init/main.c
>> > index 2858be7..92db2f3 100644
>> > --- a/init/main.c
>> > +++ b/init/main.c
>> > @@ -915,7 +915,7 @@ static int try_to_run_init_process(const char *init_filename)
>> >  static noinline void __init kernel_init_freeable(void);
>> >
>> >  #ifdef CONFIG_DEBUG_RODATA
>> > -static bool rodata_enabled = true;
>> > +bool rodata_enabled = true;
>> 
>> Is there a mismatch here between the extern ifdef and the bool ifdef?
>> I.e. shouldn't the ifdef here be || DEBUG_SET_MODULE_RONX too?
>
> Yes.
>
>> Also, can you mark this as __ro_after_init, since nothing changes it
>> after the kernel command line is parsed?
>
> Yes, yes.
>
> Thanks,
> -Takahiro AKASHI
>
>> Otherwise, this looks fine to me.
>> 
>> -Kees
>> 
>> 
>> -- 
>> Kees Cook
>> Nexus Security
