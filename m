Return-Path: <SRS0=UWrv=32=lists.openwall.com=kernel-hardening-return-17706-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FFDCC2D0B1
	for <kernel-hardening@archiver.kernel.org>; Thu,  6 Feb 2020 12:42:07 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id AEBE120661
	for <kernel-hardening@archiver.kernel.org>; Thu,  6 Feb 2020 12:42:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="gqic0Va6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AEBE120661
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17706-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5250 invoked by uid 550); 6 Feb 2020 12:42:01 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5230 invoked from network); 6 Feb 2020 12:42:00 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=R/G+XnWKaWnsAGyAhnss7hjHPbcbIWyeMj56v/dBiw0=;
        b=gqic0Va6FFKhVWe+HoLEbDIOLX9fEBKJIGhNNTuJohRE1KWTHzScoZSh5QZns/Kn5b
         hBttK0s+AxHa4qxZpeGwOp2hnd64Kn9Qccdt5cPeKT6TueBKOUw7Vph0IjYTTpvC8Jhk
         Y4/xNY2FQH3hPvZCiYOUSgf8lU6mukHJaE3SU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=R/G+XnWKaWnsAGyAhnss7hjHPbcbIWyeMj56v/dBiw0=;
        b=XRrTP3tLyNR1u34YzPKxo1XXWRRlXtLMiWxRCPnUhlqPH6nxOlPTa50Sg0on0dpr9m
         6OBUTgda8+0bXeV6VVusZQGfZebJch0eN0fIo3lBF7W/Pnu/AIgaX3r2I6RVc5rtWk0M
         j8KB5QqbETxBplKwqS5Q83aXawlZDmXUKkLPQ0xbmc+taHKptSwdTW0zT9gHVzM43JBF
         NLIIBx7dUcsHX/ysj4GMXwbA6o3ZORXtpZ1sT/1jYI80bfQyEye1axJ68mzrnuycT8Jv
         YAj/Y/GfMezxFMaYcqUwIoBc3qsAh42O/0sAOnv2YvDDbTlC7hj8VROJbVEYMdPI6Ere
         ln1Q==
X-Gm-Message-State: APjAAAW/9E4IInBKqGi1Nb+Hnel4uLp9YKgOxuxCt4I+CT35RvLBYHr9
	O+p6HnPPkdK3FSdbkRO89fTWVA==
X-Google-Smtp-Source: APXvYqzs3PSh1ujSf22dbd43fPKu0mlRTU+Ugms/ZlDsQaRqF7aFIOl1+GVNwH5FnEboLgfvMDiWsw==
X-Received: by 2002:a9d:6457:: with SMTP id m23mr8928122otl.162.1580992908944;
        Thu, 06 Feb 2020 04:41:48 -0800 (PST)
Date: Thu, 6 Feb 2020 04:41:46 -0800
From: Kees Cook <keescook@chromium.org>
To: Kristen Carlson Accardi <kristen@linux.intel.com>
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
	arjan@linux.intel.com, rick.p.edgecombe@intel.com, x86@kernel.org,
	linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
	Jessica Yu <jeyu@kernel.org>
Subject: Re: [RFC PATCH 10/11] module: Reorder functions
Message-ID: <202002060440.E7ED91B@keescook>
References: <20200205223950.1212394-1-kristen@linux.intel.com>
 <20200205223950.1212394-11-kristen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200205223950.1212394-11-kristen@linux.intel.com>

On Wed, Feb 05, 2020 at 02:39:49PM -0800, Kristen Carlson Accardi wrote:
> If a module has functions split out into separate text sections
> (i.e. compiled with the -ffunction-sections flag), reorder the
> functions to provide some code diversification to modules.
> 
> Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>

Probably a good idea to add Jessica to CC in next version:
	Jessica Yu <jeyu@kernel.org>

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  kernel/module.c | 85 +++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 85 insertions(+)
> 
> diff --git a/kernel/module.c b/kernel/module.c
> index b56f3224b161..231563e95e61 100644
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
> @@ -3245,6 +3247,87 @@ static int find_module_sections(struct module *mod, struct load_info *info)
>  	return 0;
>  }
>  
> +/*
> + * shuffle_text_list()
> + * Use a Fisher Yates algorithm to shuffle a list of text sections.
> + */
> +static void shuffle_text_list(Elf_Shdr **list, int size)
> +{
> +	int i;
> +	unsigned int j;
> +	Elf_Shdr *temp;
> +
> +	for (i = size - 1; i > 0; i--) {
> +		/*
> +		 * TBD - seed. We need to be able to use a known
> +		 * seed so that we can non-randomly randomize for
> +		 * debugging.
> +		 */
> +
> +		// pick a random index from 0 to i
> +		get_random_bytes(&j, sizeof(j));
> +		j = j % (i + 1);
> +
> +		temp = list[i];
> +		list[i] = list[j];
> +		list[j] = temp;
> +	}
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
> +	int i;
> +	int num_text_sections = 0;
> +	Elf_Shdr **text_list;
> +	int size = 0;
> +	int max_sections = info->hdr->e_shnum;
> +	unsigned int sec = find_sec(info, ".text");
> +
> +	if (!IS_ENABLED(CONFIG_FG_KASLR) || !kaslr_enabled())
> +		return;
> +
> +	if (sec == 0)
> +		return;
> +
> +	text_list = kmalloc_array(max_sections, sizeof(*text_list), GFP_KERNEL);
> +	if (text_list == NULL)
> +		return;
> +
> +	for (i = 0; i < max_sections; i++) {
> +		Elf_Shdr *shdr = &info->sechdrs[i];
> +		const char *sname = info->secstrings + shdr->sh_name;
> +
> +		if (!(shdr->sh_flags & SHF_ALLOC) ||
> +		    !(shdr->sh_flags & SHF_EXECINSTR) ||
> +		    strstarts(sname, ".init"))
> +			continue;
> +
> +		text_list[num_text_sections] = shdr;
> +		num_text_sections++;
> +	}
> +
> +	shuffle_text_list(text_list, num_text_sections);
> +
> +	for (i = 0; i < num_text_sections; i++) {
> +		Elf_Shdr *shdr = text_list[i];
> +		unsigned int infosec;
> +		const char *sname;
> +
> +		sname = info->secstrings + shdr->sh_name;
> +		infosec	= shdr->sh_info;
> +
> +		shdr->sh_entsize = get_offset(mod, &size, shdr, infosec);
> +	}
> +
> +	kfree(text_list);
> +}
> +
>  static int move_module(struct module *mod, struct load_info *info)
>  {
>  	int i;
> @@ -3282,6 +3365,8 @@ static int move_module(struct module *mod, struct load_info *info)
>  	} else
>  		mod->init_layout.base = NULL;
>  
> +	randomize_text(mod, info);
> +
>  	/* Transfer each section which specifies SHF_ALLOC */
>  	pr_debug("final section addresses:\n");
>  	for (i = 0; i < info->hdr->e_shnum; i++) {
> -- 
> 2.24.1
> 

-- 
Kees Cook
