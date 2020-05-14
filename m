Return-Path: <SRS0=DpWk=64=lists.openwall.com=kernel-hardening-return-18790-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77360C433DF
	for <kernel-hardening@archiver.kernel.org>; Thu, 14 May 2020 12:30:48 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C3D50206DA
	for <kernel-hardening@archiver.kernel.org>; Thu, 14 May 2020 12:30:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i5amiZT4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C3D50206DA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18790-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13377 invoked by uid 550); 14 May 2020 12:29:06 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5838 invoked from network); 14 May 2020 12:22:24 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nF6vAAaP1cfceYeXNm1y8xNSuJkqKIzjNDIfaM3hC6U=;
        b=i5amiZT4SYTxnRSl42OFApQUVQWMEMCzpzva6IzJpZUA8ComrOQCQAsHjrgthqm5Ti
         GtsNDdoRqE46Qt9PLanUT5TY2Bl0VFqUiHu5M0QIg6duIlNkLuQe8qJr+kir6XgqdVfD
         5/SOQWjTz2Km5dz+pfxkh7zPj9KPJ94r2/Ag3If3AMmreLm/vSOzM8UVd2wlUJy4XxrC
         Y3Y61W6yaKPCDHY9edStqeGLglJrTL68OjZ0vcd54XZi+j9Fq2kDYMrFFSRcy9rIFy7A
         nX7z+uQKUg5PTswBiYuT5Cmq5JDIibyvxwL2OfL1jJvso9rIPZInZKoazLpB6dSHSd6h
         W5UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nF6vAAaP1cfceYeXNm1y8xNSuJkqKIzjNDIfaM3hC6U=;
        b=LBWjJvrlE59VbyO9XvCuUXVzDgAzVUrEhKKcs1Uk+59u16L2zeQxL005RiSFHsr2kN
         oKWyXkq1Aqbo6lPafAycyWnC0S1v1x41d+80rlTtbvYBr5/nAHgowQaNvm+mqrvQFiR4
         Vy5oly8TuDNgiYd7cTK+6zIesj4f70LME5VPFC2hl0+aGa4b+elppWNONPtTFIzzzze9
         OGzy95xzhReuzMUdFfslUoaIQAIMrRuXr4tQa+qR4e2JzZB4pA7SWMeTeq9byEQLf17m
         mZI2h81eoXhCx/IPsTrvRI8QNZ3TyuO8y44aoC/tW/5JJf4wuJeVO+jIJb8MHotBhgIr
         l1JA==
X-Gm-Message-State: AGi0Pub7lSUs3CIxSiRrjOshsNcgSLyVp+6Uq0t0odoTBAAtyPNbjM6X
	+UeHDvwmxCS46azhqrc9o5GH0jMY30OaBVj6kZc=
X-Google-Smtp-Source: APiQypKvnbVkSBLslf8tuVKDqGZ9R3qBIciw1yU8Il1eGXOPA175sNtg+n/Z5A2Hq8fDCIabdLt9q9wcWPA/Ns3WUPQ=
X-Received: by 2002:aca:5e0b:: with SMTP id s11mr28839792oib.160.1589458931895;
 Thu, 14 May 2020 05:22:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200505153156.925111-1-mic@digikod.net> <20200505153156.925111-4-mic@digikod.net>
 <CAEjxPJ7y2G5hW0WTH0rSrDZrorzcJ7nrQBjfps2OWV5t1BUYHw@mail.gmail.com>
 <202005131525.D08BFB3@keescook> <202005132002.91B8B63@keescook>
In-Reply-To: <202005132002.91B8B63@keescook>
From: Stephen Smalley <stephen.smalley.work@gmail.com>
Date: Thu, 14 May 2020 08:22:01 -0400
Message-ID: <CAEjxPJ7WjeQAz3XSCtgpYiRtH+Jx-UkSTaEcnVyz_jwXKE3dkw@mail.gmail.com>
Subject: Re: [PATCH v5 3/6] fs: Enable to enforce noexec mounts or file exec
 through O_MAYEXEC
To: Kees Cook <keescook@chromium.org>
Cc: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>, 
	linux-kernel <linux-kernel@vger.kernel.org>, Aleksa Sarai <cyphar@cyphar.com>, 
	Alexei Starovoitov <ast@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Andy Lutomirski <luto@kernel.org>, Christian Heimes <christian@python.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Deven Bowers <deven.desai@linux.microsoft.com>, 
	Eric Chiang <ericchiang@google.com>, Florian Weimer <fweimer@redhat.com>, 
	James Morris <jmorris@namei.org>, Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>, 
	Jonathan Corbet <corbet@lwn.net>, Lakshmi Ramasubramanian <nramas@linux.microsoft.com>, 
	Matthew Garrett <mjg59@google.com>, Matthew Wilcox <willy@infradead.org>, 
	Michael Kerrisk <mtk.manpages@gmail.com>, =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mickael.salaun@ssi.gouv.fr>, 
	Mimi Zohar <zohar@linux.ibm.com>, 
	=?UTF-8?Q?Philippe_Tr=C3=A9buchet?= <philippe.trebuchet@ssi.gouv.fr>, 
	Scott Shell <scottsh@microsoft.com>, 
	Sean Christopherson <sean.j.christopherson@intel.com>, Shuah Khan <shuah@kernel.org>, 
	Steve Dower <steve.dower@python.org>, Steve Grubb <sgrubb@redhat.com>, 
	Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>, 
	Vincent Strubel <vincent.strubel@ssi.gouv.fr>, kernel-hardening@lists.openwall.com, 
	linux-api@vger.kernel.org, linux-integrity@vger.kernel.org, 
	LSM List <linux-security-module@vger.kernel.org>, 
	Linux FS Devel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, May 13, 2020 at 11:05 PM Kees Cook <keescook@chromium.org> wrote:
>
> On Wed, May 13, 2020 at 04:27:39PM -0700, Kees Cook wrote:
> > Like, couldn't just the entire thing just be:
> >
> > diff --git a/fs/namei.c b/fs/namei.c
> > index a320371899cf..0ab18e19f5da 100644
> > --- a/fs/namei.c
> > +++ b/fs/namei.c
> > @@ -2849,6 +2849,13 @@ static int may_open(const struct path *path, int acc_mode, int flag)
> >               break;
> >       }
> >
> > +     if (unlikely(mask & MAY_OPENEXEC)) {
> > +             if (sysctl_omayexec_enforce & OMAYEXEC_ENFORCE_MOUNT &&
> > +                 path_noexec(path))
> > +                     return -EACCES;
> > +             if (sysctl_omayexec_enforce & OMAYEXEC_ENFORCE_FILE)
> > +                     acc_mode |= MAY_EXEC;
> > +     }
> >       error = inode_permission(inode, MAY_OPEN | acc_mode);
> >       if (error)
> >               return error;
> >
>
> FYI, I've confirmed this now. Effectively with patch 2 dropped, patch 3
> reduced to this plus the Kconfig and sysctl changes, the self tests
> pass.
>
> I think this makes things much cleaner and correct.

I think that covers inode-based security modules but not path-based
ones (they don't implement the inode_permission hook).  For those, I
would tentatively guess that we need to make sure FMODE_EXEC is set on
the open file and then they need to check for that in their file_open
hooks.
