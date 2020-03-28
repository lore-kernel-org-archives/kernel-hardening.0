Return-Path: <SRS0=gVn/=5N=lists.openwall.com=kernel-hardening-return-18268-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1870AC43331
	for <kernel-hardening@archiver.kernel.org>; Sat, 28 Mar 2020 20:41:23 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 65868206F6
	for <kernel-hardening@archiver.kernel.org>; Sat, 28 Mar 2020 20:41:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="IV5SgG1z"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 65868206F6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18268-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11427 invoked by uid 550); 28 Mar 2020 20:41:16 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11407 invoked from network); 28 Mar 2020 20:41:16 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3af4XQiObUNSlXzIpOluwclJ5Se37O3IqIxw7xF6Wfg=;
        b=IV5SgG1z6PHJS4slCqg3DwNNnmqSzIJL6lLp1fwgyLEJHHaJ6fFezzh2xoXOGxJwLX
         u1uxgsPMEvfXPUcQsdZOXFVXGdVOzEb6PYiQY7d+mwL+SpkgBSbR2QlSCupn/XvORASl
         wudH09K3inIipQyjqcchSB9CuWVOfYplGOnIM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3af4XQiObUNSlXzIpOluwclJ5Se37O3IqIxw7xF6Wfg=;
        b=F0D2ac/l+u1+yHY22T1kxLq+xiPNSO6xS6RK54yQgtfXy9LslLMTk7b7tSDE6Adajy
         SiY35VY9xFOl1ChA+dsexwusk89kxvQmBfI1cpJzDZZKudCc6J4dVocf4MYU2Th5s6K8
         NbLc+MCAPDau+0yjKE5l4Qt0JW81kmiYB6h5fXdh1cekzmPLM88noEQZYOZqaqHQqPmr
         GB6dpGYCK7iF9qme5oAANbPU5i7c48T82NNdlW6q/gaq913I44xGzV/e7YMWccOe+/hK
         ms1HA6UjQhq8UGGW19esCMpyzMQDY108xu+az0M5Fdob1tQo6KwszuXeb0s/4ZfGUcGR
         KFgQ==
X-Gm-Message-State: ANhLgQ1heRIugN3+pR9RBcLEfIDve38Hw6XNbcqr/BE8Lh6q8bni2aoB
	z033ABRe/wW26hqA68X409VOFw==
X-Google-Smtp-Source: ADFU+vtOdbkebW3RaZlpqXPeyjJPDfKZqqHvYrxqlogFKpu84+eIxERui1kCOdYg26q2QUxE07C9+Q==
X-Received: by 2002:a17:90a:240a:: with SMTP id h10mr6679023pje.123.1585428064347;
        Sat, 28 Mar 2020 13:41:04 -0700 (PDT)
Date: Sat, 28 Mar 2020 13:41:02 -0700
From: Kees Cook <keescook@chromium.org>
To: Alexey Gladkov <gladkov.alexey@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Linux API <linux-api@vger.kernel.org>,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>,
	Linux Security Module <linux-security-module@vger.kernel.org>,
	Akinobu Mita <akinobu.mita@gmail.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Alexey Gladkov <legion@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>,
	Daniel Micay <danielmicay@gmail.com>,
	Djalal Harouni <tixxdz@gmail.com>,
	"Dmitry V . Levin" <ldv@altlinux.org>,
	"Eric W . Biederman" <ebiederm@xmission.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ingo Molnar <mingo@kernel.org>,
	"J . Bruce Fields" <bfields@fieldses.org>,
	Jeff Layton <jlayton@poochiereds.net>,
	Jonathan Corbet <corbet@lwn.net>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v10 7/9] proc: move hidepid values to uapi as they are
 user interface to mount
Message-ID: <202003281340.B73225DCC9@keescook>
References: <20200327172331.418878-1-gladkov.alexey@gmail.com>
 <20200327172331.418878-8-gladkov.alexey@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200327172331.418878-8-gladkov.alexey@gmail.com>

On Fri, Mar 27, 2020 at 06:23:29PM +0100, Alexey Gladkov wrote:
> Suggested-by: Alexey Dobriyan <adobriyan@gmail.com>
> Reviewed-by: Alexey Dobriyan <adobriyan@gmail.com>
> Signed-off-by: Alexey Gladkov <gladkov.alexey@gmail.com>
> ---
>  include/linux/proc_fs.h      |  9 +--------
>  include/uapi/linux/proc_fs.h | 13 +++++++++++++
>  2 files changed, 14 insertions(+), 8 deletions(-)
>  create mode 100644 include/uapi/linux/proc_fs.h
> 
> diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
> index afd38cae2339..d259817ec913 100644
> --- a/include/linux/proc_fs.h
> +++ b/include/linux/proc_fs.h
> @@ -7,6 +7,7 @@
>  
>  #include <linux/types.h>
>  #include <linux/fs.h>
> +#include <uapi/linux/proc_fs.h>
>  
>  struct proc_dir_entry;
>  struct seq_file;
> @@ -27,14 +28,6 @@ struct proc_ops {
>  	unsigned long (*proc_get_unmapped_area)(struct file *, unsigned long, unsigned long, unsigned long, unsigned long);
>  };
>  
> -/* definitions for hide_pid field */
> -enum {
> -	HIDEPID_OFF	  = 0,
> -	HIDEPID_NO_ACCESS = 1,
> -	HIDEPID_INVISIBLE = 2,
> -	HIDEPID_NOT_PTRACEABLE = 4, /* Limit pids to only ptraceable pids */
> -};
> -
>  /* definitions for proc mount option pidonly */
>  enum {
>  	PROC_PIDONLY_OFF = 0,
> diff --git a/include/uapi/linux/proc_fs.h b/include/uapi/linux/proc_fs.h
> new file mode 100644
> index 000000000000..dc6d717aa6ec
> --- /dev/null
> +++ b/include/uapi/linux/proc_fs.h
> @@ -0,0 +1,13 @@
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> +#ifndef _UAPI_PROC_FS_H
> +#define _UAPI_PROC_FS_H
> +
> +/* definitions for hide_pid field */
> +enum {
> +	HIDEPID_OFF            = 0,
> +	HIDEPID_NO_ACCESS      = 1,
> +	HIDEPID_INVISIBLE      = 2,
> +	HIDEPID_NOT_PTRACEABLE = 4,
> +};
> +
> +#endif
> -- 
> 2.25.2
> 

Should the numeric values still be UAPI if there is string parsing now?

-- 
Kees Cook
