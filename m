Return-Path: <SRS0=38MV=64=lists.openwall.com=kernel-hardening-return-18796-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4ABCC433E0
	for <kernel-hardening@archiver.kernel.org>; Thu, 14 May 2020 16:47:03 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 00E2A2065F
	for <kernel-hardening@archiver.kernel.org>; Thu, 14 May 2020 16:47:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="n73P5w0/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 00E2A2065F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18796-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 4088 invoked by uid 550); 14 May 2020 16:46:55 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17763 invoked from network); 14 May 2020 15:52:30 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ts3exPU5b4D6Eif+mpAKX6mXkCcZa+SnvdeaxQ9mZeM=;
        b=n73P5w0/ZNHj6r9xqk6zxWRaFGCxbL5c36nerRqhbZ5NOMMw/V3LHaS6GjNroeq11B
         hkLhReslaIkbpZbAmEJwH90HGvHSvkx5StDy556cfRaMyefW6OB07aO5MhmBrmm8vThA
         4JJ/S6xJSxyXUNLyTP60+uVZXT6qbnH2OnlRXyadY3R8dgUg7BeoW+9BjOZVroQby/pn
         ScWezo6502Bf69Wwn8oTIxxwvwWJwv33hZiiPV00+mteAt3qiPDxB+ZEIrcjT3VvOlRg
         /D0Qa8Pd9eVeK3/GHbPGEp1qFGbWcZ72unt4SIogHXcUPb+Kfgl4E8kmDFv+SLZVW6UY
         FV3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ts3exPU5b4D6Eif+mpAKX6mXkCcZa+SnvdeaxQ9mZeM=;
        b=jAqIHS3wQMWxlH8nbGuAYv4vGyPBypcVmfK5tuSw5/FIYxZt4LTpS4SKLGqHYU9J4M
         4tHConLnGyiGu9APXpIHA7YRL3+E6AgJ+imc6udg1hvsm4nJVyCIpgR8pTSW7jXNvwbg
         Fg8O1mHtJUFgytsBSOucX37/IiQhk/2j7Dz1WrPvDw4MldO4djxsY+z7gcd3PxhJ65A/
         otcfkzbU4pq/7HHhJU8K7Xqz9VxbZjdECx0Jb83T3FPHX3Qr/lXALHM+jZwGucsYj+9P
         auh04owMBvq4nP1YfJeY3vU+svRiQGUIYuO2z3DhLsULSYgmhPvb1SXG53NnAvZiSSz7
         fe5Q==
X-Gm-Message-State: AOAM531Np4LzV299u51rUJnvASnwodMXlj52EhJSuqyU4Ena3jbxc2wd
	jDHTjp1lVzTzcIqYiXHqVQggDDqn/rbnVFX1XMM=
X-Google-Smtp-Source: ABdhPJyTq5NgHHXOOIt7GEAvBuXGY23iCp2ui/mBClBnszl5WhyiAHvYPhzgbDeRnkGUD739ES1OpYBXdtop71nCBtY=
X-Received: by 2002:aca:210a:: with SMTP id 10mr6129577oiz.92.1589471539001;
 Thu, 14 May 2020 08:52:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200505153156.925111-1-mic@digikod.net> <20200505153156.925111-4-mic@digikod.net>
 <CAEjxPJ7y2G5hW0WTH0rSrDZrorzcJ7nrQBjfps2OWV5t1BUYHw@mail.gmail.com>
 <202005131525.D08BFB3@keescook> <202005132002.91B8B63@keescook>
 <CAEjxPJ7WjeQAz3XSCtgpYiRtH+Jx-UkSTaEcnVyz_jwXKE3dkw@mail.gmail.com> <202005140739.F3A4D8F3@keescook>
In-Reply-To: <202005140739.F3A4D8F3@keescook>
From: Stephen Smalley <stephen.smalley.work@gmail.com>
Date: Thu, 14 May 2020 11:52:07 -0400
Message-ID: <CAEjxPJ5dPmBo7cORWq9U-Ma9BcT2cnMR39RG9_7uAZXwsPxb9w@mail.gmail.com>
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

On Thu, May 14, 2020 at 10:41 AM Kees Cook <keescook@chromium.org> wrote:
>
> On Thu, May 14, 2020 at 08:22:01AM -0400, Stephen Smalley wrote:
> > On Wed, May 13, 2020 at 11:05 PM Kees Cook <keescook@chromium.org> wrote:
> > >
> > > On Wed, May 13, 2020 at 04:27:39PM -0700, Kees Cook wrote:
> > > > Like, couldn't just the entire thing just be:
> > > >
> > > > diff --git a/fs/namei.c b/fs/namei.c
> > > > index a320371899cf..0ab18e19f5da 100644
> > > > --- a/fs/namei.c
> > > > +++ b/fs/namei.c
> > > > @@ -2849,6 +2849,13 @@ static int may_open(const struct path *path, int acc_mode, int flag)
> > > >               break;
> > > >       }
> > > >
> > > > +     if (unlikely(mask & MAY_OPENEXEC)) {
> > > > +             if (sysctl_omayexec_enforce & OMAYEXEC_ENFORCE_MOUNT &&
> > > > +                 path_noexec(path))
> > > > +                     return -EACCES;
> > > > +             if (sysctl_omayexec_enforce & OMAYEXEC_ENFORCE_FILE)
> > > > +                     acc_mode |= MAY_EXEC;
> > > > +     }
> > > >       error = inode_permission(inode, MAY_OPEN | acc_mode);
> > > >       if (error)
> > > >               return error;
> > > >
> > >
> > > FYI, I've confirmed this now. Effectively with patch 2 dropped, patch 3
> > > reduced to this plus the Kconfig and sysctl changes, the self tests
> > > pass.
> > >
> > > I think this makes things much cleaner and correct.
> >
> > I think that covers inode-based security modules but not path-based
> > ones (they don't implement the inode_permission hook).  For those, I
> > would tentatively guess that we need to make sure FMODE_EXEC is set on
> > the open file and then they need to check for that in their file_open
> > hooks.
>
> Does there need to be an FMODE_OPENEXEC, or is the presence of
> FMODE_OPEN with FMODE_EXEC sufficient?

I don't think we need an extra flag/mode bit.  But note that 1)
FMODE_OPENED isn't set until after security_file_open() is called so
we can't rely on it there, 2) __FMODE_EXEC aka FMODE_EXEC is set in
f_flags not f_mode, 3) FMODE_EXEC was originally introduced for
distributed filesystems so that they could return ETXTBUSY if the file
was opened for write and execute on different nodes, 4) AppArmor and
TOMOYO have special handling of execve based on current->in_execve so
I guess the only overlap would be for uselib(2).
