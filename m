Message-ID: <1494370967.7678.1.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Tue, 09 May 2017 19:02:47 -0400
In-Reply-To: <CAGXu5jKXAfOa_2kbWTN==Uibw94QM06Xw+0Bw9ZioSpiaxXsBA@mail.gmail.com>
References: <20170504142435.10175-1-danielmicay@gmail.com>
	 <20170504154850.GE20461@leverpostej> <1493920184.1596.4.camel@gmail.com>
	 <20170504180917.GB19929@leverpostej> <20170505103839.GB699@leverpostej>
	 <CAGXu5jKXAfOa_2kbWTN==Uibw94QM06Xw+0Bw9ZioSpiaxXsBA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] [PATCH] add the option of fortified string.h
 functions
To: Kees Cook <keescook@chromium.org>, Mark Rutland <mark.rutland@arm.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Fleming <matt@codeblueprint.co.uk>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 2017-05-09 at 13:39 -0700, Kees Cook wrote:
> On Fri, May 5, 2017 at 3:38 AM, Mark Rutland <mark.rutland@arm.com>
> wrote:
> > ---->8----
> > diff --git a/drivers/firmware/efi/libstub/Makefile
> > b/drivers/firmware/efi/libstub/Makefile
> > index f742596..b5327f5 100644
> > --- a/drivers/firmware/efi/libstub/Makefile
> > +++ b/drivers/firmware/efi/libstub/Makefile
> > @@ -18,7 +18,8 @@ cflags-$(CONFIG_EFI_ARMSTUB)  +=
> > -I$(srctree)/scripts/dtc/libfdt
> > 
> >  KBUILD_CFLAGS                  := $(cflags-y)
> > -DDISABLE_BRANCH_PROFILING \
> >                                    $(call cc-option,-ffreestanding)
> > \
> > -                                  $(call cc-option,-fno-stack-
> > protector)
> > +                                  $(call cc-option,-fno-stack-
> > protector) \
> > +                                  -D__NO_FORTIFY
> > 
> >  GCOV_PROFILE                   := n
> >  KASAN_SANITIZE                 := n
> > ---->8----
> 
> Can we split the compile time from runtime checks so the efi stub is
> still covered by the build-time checks? (Or was there a compile
> failure I missed?)
> 
> -Kees

It might just need fortify_panic defined somewhere. It seems like the
place I defined it on x86 covers this but I might be wrong about that.
