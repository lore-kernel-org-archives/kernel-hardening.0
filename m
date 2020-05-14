Return-Path: <SRS0=Sm6C=64=lists.openwall.com=kernel-hardening-return-18792-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14A36C433E0
	for <kernel-hardening@archiver.kernel.org>; Thu, 14 May 2020 15:45:37 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 66A0B20657
	for <kernel-hardening@archiver.kernel.org>; Thu, 14 May 2020 15:45:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="WeBSVMSY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 66A0B20657
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18792-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7829 invoked by uid 550); 14 May 2020 15:45:28 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7806 invoked from network); 14 May 2020 15:45:27 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=C14dFYivD8qv8BpAvB7kTDBgmObt0Bwj81tS0Zc4/E8=;
        b=WeBSVMSYQ4gtB5dULeEkKU/Ya0fz/EW/RpuUt7D8OeJEBKAKV2pF5kPidP02iOR39J
         G1MttEPeItqlTkRXkO6DaVmCrP7nH7+PO7my0CuD5d86lDI5xv46HrYCZiFQuNjdOnTz
         5lq27uwgV1aYUO8FPK6JNzqOwNdl1+mzKbYGk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=C14dFYivD8qv8BpAvB7kTDBgmObt0Bwj81tS0Zc4/E8=;
        b=P2YrqpUft8i6pwbMZiT2jyMoMFxYIIlrqiUtXZZ4yZUkSd+7eWw/5XeUuUU7ZqOHIO
         Y994XfDBodyUBMDvlEZOfp+EmKpzTYWe2ej2vRUp4y33WoIPRcMVT3xGhMs8nIzvVz9a
         4sUW6L+zyLoyRliAuNfUDs2LePVZZm4nccUpkOI/orX+hgN6S7k15n2uRdeCvWv7nTRD
         VbRG0BoUd8WmrpT/MHGi8hiq3nwwPWOrBj6qSmMDf0ArRGxYbUxGwps8J2V66WDWGlp8
         L6iCso7ongAugnD9KigOeOHfgfnulsAXEUefQfZpIkYbiK01xIorDEUW+7jccK5aS92y
         zvyg==
X-Gm-Message-State: AOAM530ZdVv/5UqfmnCkcnGkLwOfote9mOEvbJfzU843j5fcsg2C0YYB
	FbyC5bnMk9wOZvbbCHys2pam6g==
X-Google-Smtp-Source: ABdhPJyhzYoT7OtYhHCXKJ4eWD6sNRzKX5qxh8oQ2rT3RB19/hswKImd/xT2ezGyqupFNS8qGCcfOg==
X-Received: by 2002:a17:902:c113:: with SMTP id 19mr4514772pli.95.1589471115414;
        Thu, 14 May 2020 08:45:15 -0700 (PDT)
Date: Thu, 14 May 2020 08:45:13 -0700
From: Kees Cook <keescook@chromium.org>
To: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Aleksa Sarai <cyphar@cyphar.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@kernel.org>,
	Christian Heimes <christian@python.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Deven Bowers <deven.desai@linux.microsoft.com>,
	Eric Chiang <ericchiang@google.com>,
	Florian Weimer <fweimer@redhat.com>,
	James Morris <jmorris@namei.org>, Jan Kara <jack@suse.cz>,
	Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>,
	Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
	Matthew Garrett <mjg59@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Michael Kerrisk <mtk.manpages@gmail.com>,
	=?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mickael.salaun@ssi.gouv.fr>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Philippe =?iso-8859-1?Q?Tr=E9buchet?= <philippe.trebuchet@ssi.gouv.fr>,
	Scott Shell <scottsh@microsoft.com>,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	Shuah Khan <shuah@kernel.org>, Steve Dower <steve.dower@python.org>,
	Steve Grubb <sgrubb@redhat.com>,
	Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
	Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
	kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	LSM List <linux-security-module@vger.kernel.org>,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v5 3/6] fs: Enable to enforce noexec mounts or file exec
 through O_MAYEXEC
Message-ID: <202005140830.2475344F86@keescook>
References: <20200505153156.925111-1-mic@digikod.net>
 <20200505153156.925111-4-mic@digikod.net>
 <CAEjxPJ7y2G5hW0WTH0rSrDZrorzcJ7nrQBjfps2OWV5t1BUYHw@mail.gmail.com>
 <202005131525.D08BFB3@keescook>
 <202005132002.91B8B63@keescook>
 <CAEjxPJ7WjeQAz3XSCtgpYiRtH+Jx-UkSTaEcnVyz_jwXKE3dkw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEjxPJ7WjeQAz3XSCtgpYiRtH+Jx-UkSTaEcnVyz_jwXKE3dkw@mail.gmail.com>

On Thu, May 14, 2020 at 08:22:01AM -0400, Stephen Smalley wrote:
> On Wed, May 13, 2020 at 11:05 PM Kees Cook <keescook@chromium.org> wrote:
> >
> > On Wed, May 13, 2020 at 04:27:39PM -0700, Kees Cook wrote:
> > > Like, couldn't just the entire thing just be:
> > >
> > > diff --git a/fs/namei.c b/fs/namei.c
> > > index a320371899cf..0ab18e19f5da 100644
> > > --- a/fs/namei.c
> > > +++ b/fs/namei.c
> > > @@ -2849,6 +2849,13 @@ static int may_open(const struct path *path, int acc_mode, int flag)
> > >               break;
> > >       }
> > >
> > > +     if (unlikely(mask & MAY_OPENEXEC)) {
> > > +             if (sysctl_omayexec_enforce & OMAYEXEC_ENFORCE_MOUNT &&
> > > +                 path_noexec(path))
> > > +                     return -EACCES;
> > > +             if (sysctl_omayexec_enforce & OMAYEXEC_ENFORCE_FILE)
> > > +                     acc_mode |= MAY_EXEC;
> > > +     }
> > >       error = inode_permission(inode, MAY_OPEN | acc_mode);
> > >       if (error)
> > >               return error;
> > >
> >
> > FYI, I've confirmed this now. Effectively with patch 2 dropped, patch 3
> > reduced to this plus the Kconfig and sysctl changes, the self tests
> > pass.
> >
> > I think this makes things much cleaner and correct.
> 
> I think that covers inode-based security modules but not path-based
> ones (they don't implement the inode_permission hook).  For those, I
> would tentatively guess that we need to make sure FMODE_EXEC is set on
> the open file and then they need to check for that in their file_open
> hooks.

I kept confusing myself about what order things happened in, so I made
these handy notes about the call graph:

openat2(dfd, char * filename, open_how)
    do_filp_open(dfd, filename, open_flags)
        path_openat(nameidata, open_flags, flags)
            do_open(nameidata, file, open_flags) 
                may_open(path, acc_mode, open_flag)
                    inode_permission(inode, MAY_OPEN | acc_mode)
                        security_inode_permission(inode, acc_mode)
                vfs_open(path, file)
                    do_dentry_open(file, path->dentry->d_inode, open)
                        if (unlikely(f->f_flags & FMODE_EXEC && !S_ISREG(inode->i_mode))) ...
                        security_file_open(f)
                        open()

So, it looks like adding FMODE_EXEC into f_flags in do_open() is needed in
addition to injecting MAY_EXEC into acc_mode in do_open()? Hmmm

-- 
Kees Cook
