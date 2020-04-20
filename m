Return-Path: <SRS0=tXI9=6E=lists.openwall.com=kernel-hardening-return-18563-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD19CC3815B
	for <kernel-hardening@archiver.kernel.org>; Mon, 20 Apr 2020 12:01:38 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 29AD6206DD
	for <kernel-hardening@archiver.kernel.org>; Mon, 20 Apr 2020 12:01:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y13i5g47"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 29AD6206DD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18563-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26058 invoked by uid 550); 20 Apr 2020 12:01:31 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26029 invoked from network); 20 Apr 2020 12:01:30 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1587384078;
	bh=LE0hh02HGEfNqHWFJ0oLjv2Ppm84+xP/7ZLrcujrTG8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Y13i5g47xbUNGJNi5vTVFyDihSOt16suza+URvR5daM1z5eHSMAj9R1xnPAD1zyjt
	 TPtd/jzEVgkfEGKGqnJre94CCl/6aPZNrJaVkvPIogBqXE2SlslhP8VsaZPV5Cuj+Q
	 1BZ406gj3boWp9JBYXDWjqU9KM9Sr1UB/rriubC4=
X-Gm-Message-State: AGi0PubYHVETuXuUbvnKOb49U2Lo9fkKtEoK5DKeyumgECVTBHjfCdSg
	uVRnMAPCP4xRfdiTHqS5EYdB+R8tE+mb6mJopew=
X-Google-Smtp-Source: APiQypLo7VI0Gx3PbINM1K4iGJJh8+XZEBEP5FIy1rH93FIKcOA36tIEnlm+cprLdjkY4/CAHs7D4dW8Nypqz+QTXq8=
X-Received: by 2002:a5d:9b8a:: with SMTP id r10mr8391396iom.171.1587384077983;
 Mon, 20 Apr 2020 05:01:17 -0700 (PDT)
MIME-Version: 1.0
References: <20200415210452.27436-1-kristen@linux.intel.com> <20200415210452.27436-10-kristen@linux.intel.com>
In-Reply-To: <20200415210452.27436-10-kristen@linux.intel.com>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Mon, 20 Apr 2020 14:01:06 +0200
X-Gmail-Original-Message-ID: <CAMj1kXGbh=0nC_6SGTWjKeDPdwBrEW0_vRbjDzWyqqjY_88S7Q@mail.gmail.com>
Message-ID: <CAMj1kXGbh=0nC_6SGTWjKeDPdwBrEW0_vRbjDzWyqqjY_88S7Q@mail.gmail.com>
Subject: Re: [PATCH 9/9] module: Reorder functions
To: Kristen Carlson Accardi <kristen@linux.intel.com>
Cc: Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, hpa@zytor.com, 
	Jessica Yu <jeyu@kernel.org>, arjan@linux.intel.com, X86 ML <x86@kernel.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, 
	rick.p.edgecomb@intel.com
Content-Type: text/plain; charset="UTF-8"

On Wed, 15 Apr 2020 at 23:07, Kristen Carlson Accardi
<kristen@linux.intel.com> wrote:
>
> If a module has functions split out into separate text sections
> (i.e. compiled with the -ffunction-sections flag), reorder the
> functions to provide some code diversification to modules.
>

Is that the only prerequisite? I.e., is it sufficient for another
architecture to add -ffunction-sections to the module CFLAGS to get
this functionality? (assuming it defines CONFIG_FG_KASLR=y)

> Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> ---
>  kernel/module.c | 82 +++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 82 insertions(+)
>
> diff --git a/kernel/module.c b/kernel/module.c
> index 646f1e2330d2..e432ec5f6df4 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -53,6 +53,8 @@
>  #include <linux/bsearch.h>
>  #include <linux/dynamic_debug.h>
>  #include <linux/audit.h>
> +#include <linux/random.h>
> +#include <asm/setup.h>
>  #include <uapi/linux/module.h>
>  #include "module-internal.h"
>
> @@ -2370,6 +2372,83 @@ static long get_offset(struct module *mod, unsigned int *size,
>         return ret;
>  }
>
> +/*
> + * shuffle_text_list()
> + * Use a Fisher Yates algorithm to shuffle a list of text sections.
> + */
> +static void shuffle_text_list(Elf_Shdr **list, int size)
> +{
> +       int i;
> +       unsigned int j;
> +       Elf_Shdr *temp;
> +
> +       for (i = size - 1; i > 0; i--) {
> +               /*
> +                * pick a random index from 0 to i
> +                */
> +               get_random_bytes(&j, sizeof(j));
> +               j = j % (i + 1);
> +
> +               temp = list[i];
> +               list[i] = list[j];
> +               list[j] = temp;
> +       }
> +}
> +
> +/*
> + * randomize_text()
> + * Look through the core section looking for executable code sections.
> + * Store sections in an array and then shuffle the sections
> + * to reorder the functions.
> + */
> +static void randomize_text(struct module *mod, struct load_info *info)
> +{
> +       int i;
> +       int num_text_sections = 0;
> +       Elf_Shdr **text_list;
> +       int size = 0;
> +       int max_sections = info->hdr->e_shnum;
> +       unsigned int sec = find_sec(info, ".text");
> +
> +       if (sec == 0)
> +               return;
> +
> +       text_list = kmalloc_array(max_sections, sizeof(*text_list), GFP_KERNEL);
> +       if (text_list == NULL)
> +               return;
> +
> +       for (i = 0; i < max_sections; i++) {
> +               Elf_Shdr *shdr = &info->sechdrs[i];
> +               const char *sname = info->secstrings + shdr->sh_name;
> +
> +               if (!(shdr->sh_flags & SHF_ALLOC) ||
> +                   !(shdr->sh_flags & SHF_EXECINSTR) ||
> +                   strstarts(sname, ".init"))
> +                       continue;
> +
> +               text_list[num_text_sections] = shdr;
> +               num_text_sections++;
> +       }
> +
> +       shuffle_text_list(text_list, num_text_sections);
> +
> +       for (i = 0; i < num_text_sections; i++) {
> +               Elf_Shdr *shdr = text_list[i];
> +
> +               /*
> +                * get_offset has a section index for it's last
> +                * argument, that is only used by arch_mod_section_prepend(),
> +                * which is only defined by parisc. Since this this type
> +                * of randomization isn't supported on parisc, we can
> +                * safely pass in zero as the last argument, as it is
> +                * ignored.
> +                */
> +               shdr->sh_entsize = get_offset(mod, &size, shdr, 0);
> +       }
> +
> +       kfree(text_list);
> +}
> +
>  /* Lay out the SHF_ALLOC sections in a way not dissimilar to how ld
>     might -- code, read-only data, read-write data, small data.  Tally
>     sizes, and place the offsets into sh_entsize fields: high bit means it
> @@ -2460,6 +2539,9 @@ static void layout_sections(struct module *mod, struct load_info *info)
>                         break;
>                 }
>         }
> +
> +       if (IS_ENABLED(CONFIG_FG_KASLR) && kaslr_enabled())

kaslr_enabled() only exists [as a function] on x86


> +               randomize_text(mod, info);
>  }
>
>  static void set_license(struct module *mod, const char *license)
> --
> 2.20.1
>
