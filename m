Return-Path: <SRS0=nlLt=5O=lists.openwall.com=kernel-hardening-return-18277-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 784C1C43331
	for <kernel-hardening@archiver.kernel.org>; Sun, 29 Mar 2020 03:17:27 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C5DE1206F2
	for <kernel-hardening@archiver.kernel.org>; Sun, 29 Mar 2020 03:17:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="m9oqaykc"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C5DE1206F2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18277-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 20084 invoked by uid 550); 29 Mar 2020 03:17:20 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20064 invoked from network); 29 Mar 2020 03:17:19 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4II2bc92WqcI1jJHIbHJBRCr9XHybTRKP72pOZ2vBn8=;
        b=m9oqaykcy7+GRfPUA0qekrpwJwNqG0S1mlKb9K3dSMoiUplMP4jDXKYYiUxNSn1n+v
         4oyL3E8RvMsSp58YQD7MyGe1pOXmUDh3zVX3F14wt1es3/kyO62xLP1vqLHROC2/iG5A
         NA5fTeT/j2lxo6j6d+AbeShqGk6CPpwln0Emo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4II2bc92WqcI1jJHIbHJBRCr9XHybTRKP72pOZ2vBn8=;
        b=BuafzDDE5gkRT5a+Hv5NR9vdYugHGQpFc60JvKg/E9orM1vM7rDuAKDWciHCMRdpqm
         YTGDjYtSrEPxHLAEZxzxZeyt97xHNX5a9o5I49dX1h28m3auF4BcnpQsdELSuoiGQV06
         WdS451xOzzw2EyGkDwP6qM0tZR/d3xbjb03O6731W4YqULKWr7ZZnAkNyhkvdItFArxr
         WuKY0Jz6xaIHSs+94HYKd9zptujWc9Opm3kSp7R2/he5MyNrrbH/HhlF1ZPqu1gWM18d
         1AFc3j5EM13lKlvyRCyV21gcXuLF47ykuSWvkygjc6Yj6+Qx5XcmcHlUwVMAJIQwZ+xI
         Xx7Q==
X-Gm-Message-State: ANhLgQ2GAdD8lQLIuNLlwiIj9n0QbhvaRp5fIWHRjhtojTlzxix1V026
	Sw3hFx1UqJ/faZzO9jdIdI4uNw==
X-Google-Smtp-Source: ADFU+vtseLSYN5So1Oobu2UiukVUxTzuZN3FTYmpLjJuga7kllNUrhEyIWnwcYJIyJMu6YW0JBI/4Q==
X-Received: by 2002:a17:90a:7105:: with SMTP id h5mr8294662pjk.54.1585451827508;
        Sat, 28 Mar 2020 20:17:07 -0700 (PDT)
Date: Sat, 28 Mar 2020 20:17:05 -0700
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
Message-ID: <202003282016.19E071712@keescook>
References: <20200327172331.418878-1-gladkov.alexey@gmail.com>
 <20200327172331.418878-8-gladkov.alexey@gmail.com>
 <202003281340.B73225DCC9@keescook>
 <20200328212547.xxiqxqhxzwp6w5n5@comp-core-i7-2640m-0182e6>
 <202003281453.CED94974@keescook>
 <20200328230046.v3qbffmbtl4sd7tg@comp-core-i7-2640m-0182e6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200328230046.v3qbffmbtl4sd7tg@comp-core-i7-2640m-0182e6>

On Sun, Mar 29, 2020 at 12:00:46AM +0100, Alexey Gladkov wrote:
> On Sat, Mar 28, 2020 at 02:53:49PM -0700, Kees Cook wrote:
> > > > > +/* definitions for hide_pid field */
> > > > > +enum {
> > > > > +	HIDEPID_OFF            = 0,
> > > > > +	HIDEPID_NO_ACCESS      = 1,
> > > > > +	HIDEPID_INVISIBLE      = 2,
> > > > > +	HIDEPID_NOT_PTRACEABLE = 4,
> > > > > +};
> > > > Should the numeric values still be UAPI if there is string parsing now?
> > > 
> > > I think yes, because these are still valid hidepid= values.
> > 
> > But if we don't expose the values, we can do whatever we like with
> > future numbers (e.g. the "is this a value or a bit field?" question).
> 
> Alexey Dobriyan suggested to put these parameters into the UAPI and it
> makes sense because these are user parameters.

Okidokey. :) Anyway, ignore my HIDEPID_MAX idea then, since this could
become a bitfield. Just checking for individual bits is the way to go
for now. Sorry for the noise.

-- 
Kees Cook
