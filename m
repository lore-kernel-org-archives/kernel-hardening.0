Date: Wed, 10 May 2017 12:12:25 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20170510111224.GA28159@leverpostej>
References: <20170504142435.10175-1-danielmicay@gmail.com>
 <20170504154850.GE20461@leverpostej>
 <1493920184.1596.4.camel@gmail.com>
 <20170504180917.GB19929@leverpostej>
 <20170505103839.GB699@leverpostej>
 <CAGXu5jKXAfOa_2kbWTN==Uibw94QM06Xw+0Bw9ZioSpiaxXsBA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jKXAfOa_2kbWTN==Uibw94QM06Xw+0Bw9ZioSpiaxXsBA@mail.gmail.com>
Subject: Re: [kernel-hardening] [PATCH] add the option of fortified string.h
 functions
To: Kees Cook <keescook@chromium.org>
Cc: Daniel Micay <danielmicay@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Fleming <matt@codeblueprint.co.uk>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, May 09, 2017 at 01:39:01PM -0700, Kees Cook wrote:
> On Fri, May 5, 2017 at 3:38 AM, Mark Rutland <mark.rutland@arm.com> wrote:
> > ---->8----
> > diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
> > index f742596..b5327f5 100644
> > --- a/drivers/firmware/efi/libstub/Makefile
> > +++ b/drivers/firmware/efi/libstub/Makefile
> > @@ -18,7 +18,8 @@ cflags-$(CONFIG_EFI_ARMSTUB)  += -I$(srctree)/scripts/dtc/libfdt
> >
> >  KBUILD_CFLAGS                  := $(cflags-y) -DDISABLE_BRANCH_PROFILING \
> >                                    $(call cc-option,-ffreestanding) \
> > -                                  $(call cc-option,-fno-stack-protector)
> > +                                  $(call cc-option,-fno-stack-protector) \
> > +                                  -D__NO_FORTIFY
> >
> >  GCOV_PROFILE                   := n
> >  KASAN_SANITIZE                 := n
> > ---->8----
> 
> Can we split the compile time from runtime checks so the efi stub is
> still covered by the build-time checks? (Or was there a compile
> failure I missed?)

Without this, the EFI stub won't build for arm64, due to the lack of a
fortify_panic(). The arm64 __efistub_ symbol mangling prevents us using
the usual kernel version, which would be wrong to use anyway.

Thanks,
Mark.
