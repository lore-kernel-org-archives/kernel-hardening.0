Date: Wed, 21 Jun 2017 10:24:56 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20170621092456.GA11903@leverpostej>
References: <1497018608-22168-1-git-send-email-alex.popov@linux.com>
 <CAGXu5jLcF_EHMtp+vb-zdjqKe+Z33ZKKVrx1FEVSXPyEEBa_qQ@mail.gmail.com>
 <995f7cdd-9894-5daf-2910-c2aba980302c@redhat.com>
 <20170620112040.GE28157@leverpostej>
 <CAGXu5j+Vpp60YSoPZUEGA-nFBLVUZSi-+itM7U9auSaWc0cBog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5j+Vpp60YSoPZUEGA-nFBLVUZSi-+itM7U9auSaWc0cBog@mail.gmail.com>
Subject: Re: [kernel-hardening] Re: [PATCH RFC v2 1/1] gcc-plugins: Add
 stackleak feature erasing the kernel stack at the end of syscalls
To: Kees Cook <keescook@chromium.org>
Cc: Laura Abbott <labbott@redhat.com>, Alexander Popov <alex.popov@linux.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Tycho Andersen <tycho@docker.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 20, 2017 at 12:11:56PM -0700, Kees Cook wrote:
> On Tue, Jun 20, 2017 at 4:20 AM, Mark Rutland <mark.rutland@arm.com> wrote:
> > On Tue, Jun 13, 2017 at 02:51:59PM -0700, Laura Abbott wrote:
> >> On 06/09/2017 10:28 AM, Kees Cook wrote:
> >> > It seems like it shouldn't be too hard to add on-user-return erasure
> >> > code to other architectures too.
> >>
> >> I played around getting this to compile for arm64 with a dummy
> >> stack clearing function. arm64 is doing something special with the
> >> efistub so it fails to link with
> >>
> >> drivers/firmware/efi/libstub/arm-stub.c:45:(.init.text+0x54): relocation
> >>       truncated to fit: R_AARCH64_CALL26 against undefined symbol `__efistub_track_stack'
> >>
> >> The relocation to the .init.text section and appending __efistub happens after
> >> compilation so the checks in the plugin itself don't work. I haven't come up
> >> with a solution to not have the plugin run on the stub yet.
> >
> > Can we do something like what we do for KCOV, and (only) place the
> > plugin-invoking flags to into CFLAGS_STACKLEAK, which we can filter out
> > in scripts/Makefile.lib?
> 
> That seems fine to me, though plugins have tended to provide a
> DISABLE_foo_bar_PLUGIN export (like used in ppc for turning off the
> latent entropy plugin):
> 
> scripts/Makefile.gcc-plugins:    DISABLE_LATENT_ENTROPY_PLUGIN +=
> -fplugin-arg-latent_entropy_plugin-disable
> 
> arch/powerpc/kernel/Makefile:CFLAGS_cputable.o +=
> $(DISABLE_LATENT_ENTROPY_PLUGIN)
> arch/powerpc/kernel/Makefile:CFLAGS_prom_init.o +=
> $(DISABLE_LATENT_ENTROPY_PLUGIN)
> ...

Interesting. I hadn't encountered that style before.

I'd seen the per-makefile config disables:

drivers/firmware/efi/libstub/Makefile:GCOV_PROFILE                      := n
drivers/firmware/efi/libstub/Makefile:KASAN_SANITIZE                    := n
drivers/firmware/efi/libstub/Makefile:UBSAN_SANITIZE                    := n
drivers/firmware/efi/libstub/Makefile:KCOV_INSTRUMENT                   := n

... and per-object config disables:

arch/arm64/mm/Makefile:KASAN_SANITIZE_physaddr.o        += n
arch/arm64/mm/Makefile:KASAN_SANITIZE_kasan_init.o      := n

... which AFAICT are both handled by the standard scripts/Makefile.lib idiom:

ifeq ($(CONFIG_KASAN),y)
_c_flags += $(if $(patsubst n%,, \
                $(KASAN_SANITIZE_$(basetarget).o)$(KASAN_SANITIZE)y), \
                $(CFLAGS_KASAN))
endif

... it seems a shame for plugins to follow a different pattern.

Thanks,
Mark.
