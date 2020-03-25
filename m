Return-Path: <SRS0=tYIM=5K=lists.openwall.com=kernel-hardening-return-18224-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C4D0C2D0E6
	for <kernel-hardening@archiver.kernel.org>; Wed, 25 Mar 2020 18:00:39 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D98C920774
	for <kernel-hardening@archiver.kernel.org>; Wed, 25 Mar 2020 18:00:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pcB8/P4N"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D98C920774
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18224-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 18417 invoked by uid 550); 25 Mar 2020 18:00:32 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 18397 invoked from network); 25 Mar 2020 18:00:31 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=H2vECe2orURQBDgSGUswq0Em3Lt1cG8LhmyDWMenie4=;
        b=pcB8/P4NNmGc9jdx2cKv4xLm0LYKUe/enar+zNO7y4vivuI8tC96COsdPMsSERrJYl
         8PVqD0Ryt1WAvO9bHnakhvnUfsIgChkC7qbdx86g7WKZuyOUA3mnnQ+he6x9gSy+4cpx
         c6Q6vhS8Mm4rJylbtRie9w3bHOiCVzrhIRvJEdtRumQ5g7sTuldciIcsSt+D//krTaVi
         VwHm1SINNqM+sRZows4xI9xhUJ9uh1lwV4NKyK/Ng5sr3WIS2jMszdmOFH+lEufdeQxy
         yKgiUcMYDK6gAYDYTJBA3p14X99t6sm/bK7aD6+jXW/YVjBnPSxkU4iCFIq5tDotccO5
         IGwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=H2vECe2orURQBDgSGUswq0Em3Lt1cG8LhmyDWMenie4=;
        b=Bue7Zl7aGqG8BWAm2LVC8cy+Guvufo3M83nOOKt5s7TA69DCH9hO3ZvRcCZgg+pAml
         vQ7y/fqKqvBISllEFFTxW4M11ZWqe2qxrJ8nNxRjCkUsvgQMN4UvbRShWTrWpj6PbW4w
         m3+Oe4E08yJfVxoETYVBqghVzZIHW+0bRHIItNAIJ9S/8VKSvisByU1JNoLCVru1cbQL
         hTaL1HHz1zfS8eEW6utBNXfbzw5jeJ5+7RL6izbGqgRHC/I7frotaGmI4h1tFLnC8fOK
         1gc7fM+ytFS5B6CG8jwknWqfq9BTtKETTSfkYV9BEeczudWZQkhi4aNLi9FMSiqr0tVD
         3Tzg==
X-Gm-Message-State: ANhLgQ31yhrcY+PXsh7Q0mU0u85/a2TBd8tw5soxKMQDV1vJMLV9aYfL
	S65khz3vYhQ0Kw9xfa8MIw==
X-Google-Smtp-Source: ADFU+vskQBpU1fwag571AUWx4l8lwesSLXv4/Nn4D9x3DELZa5yjkr7FUq1vp/cSRcIq8i0IZhnnuQ==
X-Received: by 2002:a7b:cb42:: with SMTP id v2mr4697972wmj.170.1585159219122;
        Wed, 25 Mar 2020 11:00:19 -0700 (PDT)
Date: Wed, 25 Mar 2020 21:00:15 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexey Gladkov <gladkov.alexey@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Linux API <linux-api@vger.kernel.org>,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>,
	Linux Security Module <linux-security-module@vger.kernel.org>,
	Akinobu Mita <akinobu.mita@gmail.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
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
	Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>,
	Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH RESEND v9 3/8] proc: move hide_pid, pid_gid from
 pid_namespace to proc_fs_info
Message-ID: <20200325180015.GA18706@avx2>
References: <20200324204449.7263-1-gladkov.alexey@gmail.com>
 <20200324204449.7263-4-gladkov.alexey@gmail.com>
 <CAHk-=whXbgW7-FYL4Rkaoh8qX+CkS5saVGP2hsJPV0c+EZ6K7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHk-=whXbgW7-FYL4Rkaoh8qX+CkS5saVGP2hsJPV0c+EZ6K7A@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Mar 24, 2020 at 02:21:59PM -0700, Linus Torvalds wrote:
> On Tue, Mar 24, 2020 at 1:46 PM Alexey Gladkov <gladkov.alexey@gmail.com> wrote:
> >
> > +/* definitions for hide_pid field */
> > +enum {
> > +       HIDEPID_OFF       = 0,
> > +       HIDEPID_NO_ACCESS = 1,
> > +       HIDEPID_INVISIBLE = 2,
> > +};
> 
> Should this enum be named...
> 
> >  struct proc_fs_info {
> >         struct pid_namespace *pid_ns;
> >         struct dentry *proc_self;        /* For /proc/self */
> >         struct dentry *proc_thread_self; /* For /proc/thread-self */
> > +       kgid_t pid_gid;
> > +       int hide_pid;
> >  };
> 
> .. and then used here instead of "int"?
> 
> Same goes for 'struct proc_fs_context' too, for that matter?
> 
> And maybe in the function declarations and definitions too? In things
> like 'has_pid_permissions()' (the series adds some other cases later,
> like hidepid2str() etc)
> 
> Yeah, enums and ints are kind of interchangeable in C, but even if it
> wouldn't give us any more typechecking (except perhaps with sparse if
> you mark it so), it would be documenting the use.
> 
> Or am I missing something?
> 
> Anyway, I continue to think the series looks fine, bnut would love to
> see it in -next and perhaps comments from Al and Alexey Dobriyan..

Patches are OK, except the part where "pid" is named "pidfs" and
the suffix doesn't convey any information.

	mount -t proc -o subset=pid,sysctl,misc

Reviewed-by: Alexey Dobriyan <adobriyan@gmail.com>
