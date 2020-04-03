Return-Path: <SRS0=ykAD=5T=lists.openwall.com=kernel-hardening-return-18422-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3DFDC43331
	for <kernel-hardening@archiver.kernel.org>; Fri,  3 Apr 2020 23:59:45 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 113852073B
	for <kernel-hardening@archiver.kernel.org>; Fri,  3 Apr 2020 23:59:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Bbhh3fmX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 113852073B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18422-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 10012 invoked by uid 550); 3 Apr 2020 23:59:38 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9992 invoked from network); 3 Apr 2020 23:59:37 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YCa/Qs0yPmh3XTwnN4PsbMB277OSr9D+GN0maXxjMHA=;
        b=Bbhh3fmXAiGdRNFedcwh3XwyQ26GhP6Z9oRxi/DD0ElrQbHJt8FP23Due9BPsALnlu
         cdsBGZMeu1Kd8/vgELs72HvtyNixfzg4EaDAo5O2ENQpAqF+HriRbxrU9MqmUByE9IP0
         IyiltCvmyvjnf3QdBrKiVqJ2X8ZPSJrLSlitI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YCa/Qs0yPmh3XTwnN4PsbMB277OSr9D+GN0maXxjMHA=;
        b=DA1g+MjyZuud5j398TuUMpsnfUxY9WdYYnuA1CtY9mxh06VxTZhMd0a2dDe/3aSfF7
         orlAAL2scT8e/K5URDTPw4AU+pg2Ofb3B2XZqA4y0RnGV8KvtIauTHWlzCeLn6ML7Lvl
         Z6x1rlG2o6X/3/L0sxwx5a0U7x2e0VMd9po3SNNadan2AjSY8xH+PJVD2bXq95TgYlqe
         TfB81+cxOimcIrk6HornR+AtomvprKYxO6fsSRfUvxqClE9xJZWAHr9FG2FiPr7s4S0u
         HgXSTwhAbWfG0jeJaB4ne8ajCbvYrQTCd42fjnifY0AkkdNtNdzDV2Lqht86kSgmrPj+
         qirQ==
X-Gm-Message-State: AGi0PuZLqtr+I/AXzC36iuN66S77UbqTIUbyN2XuVAnO3OnP95mMVPU9
	7GWgoG0L3QPc3yahEsVW5o2gQpK1/98=
X-Google-Smtp-Source: APiQypKaLpvqre5tI8MwDWqt73Tqg7m9h+IsHfp66R3KYbvS+0hTX2lg8k4AHfoG5/7A9eafgxz9Gw==
X-Received: by 2002:a17:90a:21ac:: with SMTP id q41mr12995017pjc.41.1585958365843;
        Fri, 03 Apr 2020 16:59:25 -0700 (PDT)
Date: Fri, 3 Apr 2020 16:59:23 -0700
From: Kees Cook <keescook@chromium.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alexey Gladkov <gladkov.alexey@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>,
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
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ingo Molnar <mingo@kernel.org>,
	"J . Bruce Fields" <bfields@fieldses.org>,
	Jeff Layton <jlayton@poochiereds.net>,
	Jonathan Corbet <corbet@lwn.net>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v10 7/9] proc: move hidepid values to uapi as they are
 user interface to mount
Message-ID: <202004031658.8D0C048E3@keescook>
References: <20200327172331.418878-1-gladkov.alexey@gmail.com>
 <20200327172331.418878-8-gladkov.alexey@gmail.com>
 <875zehkeob.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <875zehkeob.fsf@x220.int.ebiederm.org>

On Thu, Apr 02, 2020 at 11:58:28AM -0500, Eric W. Biederman wrote:
> 
> I will just say that I do not understand exporting this to the uapi
> headers.  Why do we want to export the enumeration names?
> 
> I understand that the values are uapi.  This looks like it will make it
> difficult to make changes that rename enumeration values to make
> the code more readable.
> 
> Given that this patchset goes immediately to using string enumerated
> values, I also don't understand the point of exporting
> HIDEPID_NOT_PTRACEABLE.  I don't think we need to ever let
> people use the numeric value.
> 
> My sense is that if we are switching to string values we should
> just leave the existing numeric values as backwards compatiblity
> and not do anything to make them easier to use.

Yeah, that's what I had suggested too. Let's not export this to UAPI.

-Kees

> 
> Eric
> 
> 
> Alexey Gladkov <gladkov.alexey@gmail.com> writes:
> 
> > Suggested-by: Alexey Dobriyan <adobriyan@gmail.com>
> > Reviewed-by: Alexey Dobriyan <adobriyan@gmail.com>
> > Signed-off-by: Alexey Gladkov <gladkov.alexey@gmail.com>
> > ---
> >  include/linux/proc_fs.h      |  9 +--------
> >  include/uapi/linux/proc_fs.h | 13 +++++++++++++
> >  2 files changed, 14 insertions(+), 8 deletions(-)
> >  create mode 100644 include/uapi/linux/proc_fs.h
> >
> > diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
> > index afd38cae2339..d259817ec913 100644
> > --- a/include/linux/proc_fs.h
> > +++ b/include/linux/proc_fs.h
> > @@ -7,6 +7,7 @@
> >  
> >  #include <linux/types.h>
> >  #include <linux/fs.h>
> > +#include <uapi/linux/proc_fs.h>
> >  
> >  struct proc_dir_entry;
> >  struct seq_file;
> > @@ -27,14 +28,6 @@ struct proc_ops {
> >  	unsigned long (*proc_get_unmapped_area)(struct file *, unsigned long, unsigned long, unsigned long, unsigned long);
> >  };
> >  
> > -/* definitions for hide_pid field */
> > -enum {
> > -	HIDEPID_OFF	  = 0,
> > -	HIDEPID_NO_ACCESS = 1,
> > -	HIDEPID_INVISIBLE = 2,
> > -	HIDEPID_NOT_PTRACEABLE = 4, /* Limit pids to only ptraceable pids */
> > -};
> > -
> >  /* definitions for proc mount option pidonly */
> >  enum {
> >  	PROC_PIDONLY_OFF = 0,
> > diff --git a/include/uapi/linux/proc_fs.h b/include/uapi/linux/proc_fs.h
> > new file mode 100644
> > index 000000000000..dc6d717aa6ec
> > --- /dev/null
> > +++ b/include/uapi/linux/proc_fs.h
> > @@ -0,0 +1,13 @@
> > +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> > +#ifndef _UAPI_PROC_FS_H
> > +#define _UAPI_PROC_FS_H
> > +
> > +/* definitions for hide_pid field */
> > +enum {
> > +	HIDEPID_OFF            = 0,
> > +	HIDEPID_NO_ACCESS      = 1,
> > +	HIDEPID_INVISIBLE      = 2,
> > +	HIDEPID_NOT_PTRACEABLE = 4,
> > +};
> > +
> > +#endif

-- 
Kees Cook
