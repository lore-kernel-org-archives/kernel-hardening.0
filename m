Return-Path: <SRS0=J5CM=6G=lists.openwall.com=kernel-hardening-return-18601-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E592EC54FCB
	for <kernel-hardening@archiver.kernel.org>; Wed, 22 Apr 2020 16:23:15 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1996A2076E
	for <kernel-hardening@archiver.kernel.org>; Wed, 22 Apr 2020 16:23:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="pCJQL5wp"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1996A2076E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18601-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7787 invoked by uid 550); 22 Apr 2020 16:23:06 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7761 invoked from network); 22 Apr 2020 16:23:05 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1587572573;
	bh=vL1OxLUkO57SX/mWyfifMZyxKgxNDdK+9KAUtaUgR8s=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=pCJQL5wpzqxkK6Z1paeS1DtxN2SJvrMoxmrfyZyHdHfqr8LGLs7PBgmXV8SsGSOB0
	 BtZ6QJs2Rosur+ARnwMa/rqiofUVL11N9SVyYgowuO/ZL2MypYCa/VeN0Btdmvx4vp
	 xYxvQFzwVemUkxToyEujLbnSyuVNdaOZ0eYbsosI=
X-Gm-Message-State: AGi0Pua9aPyrXngAusJmCel8AR2FVYhQsSqTSModUOnojZdtg8IZcbMy
	3IabohRj6mZ6QKYvD1QVvMR7pOhTXGWShKRcb+Y=
X-Google-Smtp-Source: APiQypLsFwNO0C4d0W+MXbDCwHM7UnxNHn6YKn2dD0B5OxwV+idu9mN487sOtBbBoHB6H0BA97JNc3b2G64fgqoZVxI=
X-Received: by 2002:a02:7785:: with SMTP id g127mr25575897jac.134.1587572573025;
 Wed, 22 Apr 2020 09:22:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200415210452.27436-1-kristen@linux.intel.com>
 <20200415210452.27436-10-kristen@linux.intel.com> <CAMj1kXGbh=0nC_6SGTWjKeDPdwBrEW0_vRbjDzWyqqjY_88S7Q@mail.gmail.com>
 <57fcb4a823003e955b63e81085b7d18a2ac0c139.camel@linux.intel.com> <00b0ea7c94e298e12bc3bfcc1c780dc78056c463.camel@linux.intel.com>
In-Reply-To: <00b0ea7c94e298e12bc3bfcc1c780dc78056c463.camel@linux.intel.com>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Wed, 22 Apr 2020 18:22:41 +0200
X-Gmail-Original-Message-ID: <CAMj1kXHHrH7CUTS854xNnWpqj8mFNdZ9gfW7fgNxmueno-ZegQ@mail.gmail.com>
Message-ID: <CAMj1kXHHrH7CUTS854xNnWpqj8mFNdZ9gfW7fgNxmueno-ZegQ@mail.gmail.com>
Subject: Re: [PATCH 9/9] module: Reorder functions
To: Kristen Carlson Accardi <kristen@linux.intel.com>
Cc: Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, hpa@zytor.com, 
	Jessica Yu <jeyu@kernel.org>, Arjan van de Ven <arjan@linux.intel.com>, X86 ML <x86@kernel.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, 
	rick.p.edgecombe@intel.com
Content-Type: text/plain; charset="UTF-8"

On Mon, 20 Apr 2020 at 19:59, Kristen Carlson Accardi
<kristen@linux.intel.com> wrote:
>
> On Mon, 2020-04-20 at 10:56 -0700, Kristen Carlson Accardi wrote:
> > On Mon, 2020-04-20 at 14:01 +0200, Ard Biesheuvel wrote:
> > > On Wed, 15 Apr 2020 at 23:07, Kristen Carlson Accardi
> > > <kristen@linux.intel.com> wrote:
> > > > If a module has functions split out into separate text sections
> > > > (i.e. compiled with the -ffunction-sections flag), reorder the
> > > > functions to provide some code diversification to modules.
> > > >
> > >
> > > Is that the only prerequisite? I.e., is it sufficient for another
> > > architecture to add -ffunction-sections to the module CFLAGS to get
> > > this functionality? (assuming it defines CONFIG_FG_KASLR=y)
> >
> > I think it would work for modules. I've not tested this of course. It
> > might not make sense for some architectures (like 32 bit), but it
> > would
> > probably work.
> >
> > > > Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
> > > > Reviewed-by: Kees Cook <keescook@chromium.org>
> > > > ---
> > > >  kernel/module.c | 82
> > > > +++++++++++++++++++++++++++++++++++++++++++++++++
> > > >  1 file changed, 82 insertions(+)
> > > >
> > > > diff --git a/kernel/module.c b/kernel/module.c
> > > > index 646f1e2330d2..e432ec5f6df4 100644
> > > > --- a/kernel/module.c
> > > > +++ b/kernel/module.c
> > > > @@ -53,6 +53,8 @@
> > > >  #include <linux/bsearch.h>
> > > >  #include <linux/dynamic_debug.h>
> > > >  #include <linux/audit.h>
> > > > +#include <linux/random.h>
> > > > +#include <asm/setup.h>
> > > >  #include <uapi/linux/module.h>
> > > >  #include "module-internal.h"
> > > >
> > > > @@ -2370,6 +2372,83 @@ static long get_offset(struct module *mod,
> > > > unsigned int *size,
> > > >         return ret;
> > > >  }
> > > >
> > > > +/*
> > > > + * shuffle_text_list()
> > > > + * Use a Fisher Yates algorithm to shuffle a list of text
> > > > sections.
> > > > + */
> > > > +static void shuffle_text_list(Elf_Shdr **list, int size)
> > > > +{
> > > > +       int i;
> > > > +       unsigned int j;
> > > > +       Elf_Shdr *temp;
> > > > +
> > > > +       for (i = size - 1; i > 0; i--) {
> > > > +               /*
> > > > +                * pick a random index from 0 to i
> > > > +                */
> > > > +               get_random_bytes(&j, sizeof(j));
> > > > +               j = j % (i + 1);
> > > > +
> > > > +               temp = list[i];
> > > > +               list[i] = list[j];
> > > > +               list[j] = temp;
> > > > +       }
> > > > +}
> > > > +
> > > > +/*
> > > > + * randomize_text()
> > > > + * Look through the core section looking for executable code
> > > > sections.
> > > > + * Store sections in an array and then shuffle the sections
> > > > + * to reorder the functions.
> > > > + */
> > > > +static void randomize_text(struct module *mod, struct load_info
> > > > *info)
> > > > +{
> > > > +       int i;
> > > > +       int num_text_sections = 0;
> > > > +       Elf_Shdr **text_list;
> > > > +       int size = 0;
> > > > +       int max_sections = info->hdr->e_shnum;
> > > > +       unsigned int sec = find_sec(info, ".text");
> > > > +
> > > > +       if (sec == 0)
> > > > +               return;
> > > > +
> > > > +       text_list = kmalloc_array(max_sections,
> > > > sizeof(*text_list),
> > > > GFP_KERNEL);
> > > > +       if (text_list == NULL)
> > > > +               return;
> > > > +
> > > > +       for (i = 0; i < max_sections; i++) {
> > > > +               Elf_Shdr *shdr = &info->sechdrs[i];
> > > > +               const char *sname = info->secstrings + shdr-
> > > > > sh_name;
> > > > +
> > > > +               if (!(shdr->sh_flags & SHF_ALLOC) ||
> > > > +                   !(shdr->sh_flags & SHF_EXECINSTR) ||
> > > > +                   strstarts(sname, ".init"))
> > > > +                       continue;
> > > > +
> > > > +               text_list[num_text_sections] = shdr;
> > > > +               num_text_sections++;
> > > > +       }
> > > > +
> > > > +       shuffle_text_list(text_list, num_text_sections);
> > > > +
> > > > +       for (i = 0; i < num_text_sections; i++) {
> > > > +               Elf_Shdr *shdr = text_list[i];
> > > > +
> > > > +               /*
> > > > +                * get_offset has a section index for it's last
> > > > +                * argument, that is only used by
> > > > arch_mod_section_prepend(),
> > > > +                * which is only defined by parisc. Since this
> > > > this
> > > > type
> > > > +                * of randomization isn't supported on parisc, we
> > > > can
> > > > +                * safely pass in zero as the last argument, as
> > > > it
> > > > is
> > > > +                * ignored.
> > > > +                */
> > > > +               shdr->sh_entsize = get_offset(mod, &size, shdr,
> > > > 0);
> > > > +       }
> > > > +
> > > > +       kfree(text_list);
> > > > +}
> > > > +
> > > >  /* Lay out the SHF_ALLOC sections in a way not dissimilar to how
> > > > ld
> > > >     might -- code, read-only data, read-write data, small
> > > > data.  Tally
> > > >     sizes, and place the offsets into sh_entsize fields: high bit
> > > > means it
> > > > @@ -2460,6 +2539,9 @@ static void layout_sections(struct module
> > > > *mod, struct load_info *info)
> > > >                         break;
> > > >                 }
> > > >         }
> > > > +
> > > > +       if (IS_ENABLED(CONFIG_FG_KASLR) && kaslr_enabled())
> > >
> > > kaslr_enabled() only exists [as a function] on x86
> >
> > CONFIG_FG_KASLR is dependant on x86_64. If people really think there
> > is
> > value in having the module randomization not dependent on the kernel
> > randomization it can be changed to a different config option - but I
> > am
> > not sure that there is a ton of value in the module randomization on
> > it's own.
>

I think there is. The modules are a sizable attack surface, and made
up of drivers for a large part, many of which are not as carefully
reviewed as core code. Also, as I pointed out, the ELF loading trick
from the decompressor is simply infeasible on arm64, given that there
is no decompressor in the first place.

> I should have added - thank you for pointing this out, I will fix it in
> the next version. I was on a tangent about whether you should even use
> this without the main kernel randomization :).
>

Yeah. I was just pointing out that this breaks the build for all other
architectures :-)
