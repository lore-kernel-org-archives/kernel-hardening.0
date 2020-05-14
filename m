Return-Path: <SRS0=fwkt=64=lists.openwall.com=kernel-hardening-return-18797-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D0F0C433DF
	for <kernel-hardening@archiver.kernel.org>; Thu, 14 May 2020 16:47:27 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 3D1B62065F
	for <kernel-hardening@archiver.kernel.org>; Thu, 14 May 2020 16:47:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ME8yQCgb"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3D1B62065F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18797-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5919 invoked by uid 550); 14 May 2020 16:47:19 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3979 invoked from network); 14 May 2020 16:10:54 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=D5CbZd976r0FX8cps+cJg5GK1CX9lUZ+rR6vnN8xQ1g=;
        b=ME8yQCgbH2SZIDcdab7oOsHlv314+eYedrIFbgnDiv53fMIMW6h9hp1VKmEFSyrYZI
         ZSs829U1wHjFRgb8Z16vo5mQfCn03DReReAjYmZtQ2fcNZlTCtKTUnI1QwBesLOPRl0W
         d6vcjzwONEDKS9hHqk07r5NGbdWF3yHtjy/r+Rr5V0YC3Dp2aEo4V12d2OectxjEIosS
         WdY7O9cXLsRXiweqFenSDiCPZmyIDpM4iTXd71EmDlwoyHHu3I7PSr8magZZobs/ZFZB
         fiIstOhiEvBiglPKnuaRHDddwv4WaI/VifjsX4Xw/CdRzk8xvmHD8S4XS0Uz/yRBSm0f
         gNeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=D5CbZd976r0FX8cps+cJg5GK1CX9lUZ+rR6vnN8xQ1g=;
        b=XyxddEP0ywiRHzE6g27sVO/ePlxfOe32TTJjifI7rgTCqNKQ6IkXSG4vHRztm/4Gf1
         GODMsKcUzP8/XrUjfY9g05Gra9KOSrHFYfKYytYdYKua9nooyTUG0bIRs+hXnpMbkldD
         jQdPR/ZjzS/d+y2KQoJuZBxOpyokZQn3X3NIwRF6hUiLEPMYek5P7XbnIDwhNwRXKyS2
         B1E01OvYe7HA7gqLtSxWEMqmydDfdiC7Rbuh+TNirddaHjIFX7XPqD4PVpsMBxSQ3xYW
         0ri0dAjL1sM+nHuYu4+oVhYgdESQrBls5Bth59WsdGG3MBsxP0zM/xKMSBZJuwXvh/mv
         xf6g==
X-Gm-Message-State: AGi0PuYVjioAvnTugUnSzmVchHU494b4BIWPGVjWalmPL/ldOVTjQQNO
	6unZL0AdfZ0LLX82rnnQxCmuMkY6M9YcLhGdm5M=
X-Google-Smtp-Source: APiQypKtIw3xzkHAtALvSyqt4k9eNzYlxJoUxyheJsa+r6YEEdui4LketFU7MqwuU2v/F0vGykL4KdxDlzE9Lo0hTmQ=
X-Received: by 2002:aca:5e0b:: with SMTP id s11mr29579870oib.160.1589472642862;
 Thu, 14 May 2020 09:10:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200505153156.925111-1-mic@digikod.net> <20200505153156.925111-4-mic@digikod.net>
 <CAEjxPJ7y2G5hW0WTH0rSrDZrorzcJ7nrQBjfps2OWV5t1BUYHw@mail.gmail.com>
 <202005131525.D08BFB3@keescook> <202005132002.91B8B63@keescook>
 <CAEjxPJ7WjeQAz3XSCtgpYiRtH+Jx-UkSTaEcnVyz_jwXKE3dkw@mail.gmail.com> <202005140830.2475344F86@keescook>
In-Reply-To: <202005140830.2475344F86@keescook>
From: Stephen Smalley <stephen.smalley.work@gmail.com>
Date: Thu, 14 May 2020 12:10:31 -0400
Message-ID: <CAEjxPJ4R_juwvRbKiCg5OGuhAi1ZuVytK4fKCDT_kT6VKc8iRg@mail.gmail.com>
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

On Thu, May 14, 2020 at 11:45 AM Kees Cook <keescook@chromium.org> wrote:
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
> I kept confusing myself about what order things happened in, so I made
> these handy notes about the call graph:
>
> openat2(dfd, char * filename, open_how)
>     do_filp_open(dfd, filename, open_flags)
>         path_openat(nameidata, open_flags, flags)
>             do_open(nameidata, file, open_flags)
>                 may_open(path, acc_mode, open_flag)
>                     inode_permission(inode, MAY_OPEN | acc_mode)
>                         security_inode_permission(inode, acc_mode)
>                 vfs_open(path, file)
>                     do_dentry_open(file, path->dentry->d_inode, open)
>                         if (unlikely(f->f_flags & FMODE_EXEC && !S_ISREG(inode->i_mode))) ...
>                         security_file_open(f)
>                         open()
>
> So, it looks like adding FMODE_EXEC into f_flags in do_open() is needed in
> addition to injecting MAY_EXEC into acc_mode in do_open()? Hmmm

Just do both in build_open_flags() and be done with it? Looks like he
was already setting FMODE_EXEC in patch 1 so we just need to teach
AppArmor/TOMOYO to check for it and perform file execute checking in
that case if !current->in_execve?
