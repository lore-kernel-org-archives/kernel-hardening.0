Return-Path: <SRS0=W/mD=IO=lists.openwall.com=kernel-hardening-return-20952-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B150BC433DB
	for <kernel-hardening@archiver.kernel.org>; Tue, 16 Mar 2021 19:24:29 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id DF9DA64DCE
	for <kernel-hardening@archiver.kernel.org>; Tue, 16 Mar 2021 19:24:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DF9DA64DCE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20952-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26000 invoked by uid 550); 16 Mar 2021 19:24:22 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 25977 invoked from network); 16 Mar 2021 19:24:21 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=a1ue4t11OJbVivGpc6C3VCzhlUkhH8Mj6uX3JQk/WHc=;
        b=Nj8yYDluxqiAG+ej6jhoWTmPa96bXO9MvDia/puQbLS7/lpPxALfueZIRNjkZiCYCy
         Ljgk8A2MGIt5sqxHhcmGFj9bwRx66ATTPVkIOCfXJarh9XeLaTErjE/lVX2YPbMfkUTR
         weLoWOS0x3zLp07rZcrp0BhN98BIhcxt1Cq+U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=a1ue4t11OJbVivGpc6C3VCzhlUkhH8Mj6uX3JQk/WHc=;
        b=MM5ro4nf7J8pRAN2JVffurB6yKdWNuS+TiNpfdeLY8VIi32tVFc1i0MBX7dLp0gMeN
         buK+QgQniCQv2iXMdZ7Y/wR/JRi4aLvJRvvCkTBUkgUGHKG6xhJhvv+L28oHNlzkxBvL
         yydLXr77UX9zpPD+xdSH2rVlgc8A1envA8bzhcs8DpbwgQXR6pc6oPOKkR9AHwscQhbi
         0y2ogawUOlI9wJHsPZ04qUlst7Y4BqUCtbwiSVThfXSFI4wr4APtdfYxdKpCJcdk+sOp
         9GorPSGBeLgMOoQ55ueSqgBoCpyRvFqu+3JssYBNQQwFVy0hkHBQI86ebSCsTzZpeuHR
         0eSg==
X-Gm-Message-State: AOAM5325Mta6lNEoCzb8Zvuk+AnVa0pV3Qm37EegDPL+qhevbR7Fn3t5
	63SQzNiet3JRXTvaqA8ZKKS5wA==
X-Google-Smtp-Source: ABdhPJxdA7UfbYsvEPf38xgnGsO41RyHj+iYp3b8oYOJD+h6SmdhD+HE5h/MgGyUxrpMOZysl7Shew==
X-Received: by 2002:a17:90a:b115:: with SMTP id z21mr594754pjq.162.1615922649291;
        Tue, 16 Mar 2021 12:24:09 -0700 (PDT)
Date: Tue, 16 Mar 2021 12:24:07 -0700
From: Kees Cook <keescook@chromium.org>
To: Jann Horn <jannh@google.com>
Cc: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>,
	Al Viro <viro@zeniv.linux.org.uk>, James Morris <jmorris@namei.org>,
	Serge Hallyn <serge@hallyn.com>,
	Andy Lutomirski <luto@amacapital.net>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Christian Brauner <christian.brauner@ubuntu.com>,
	Christoph Hellwig <hch@lst.de>, David Howells <dhowells@redhat.com>,
	Dominik Brodowski <linux@dominikbrodowski.net>,
	"Eric W . Biederman" <ebiederm@xmission.com>,
	John Johansen <john.johansen@canonical.com>,
	Kentaro Takeda <takedakn@nttdata.co.jp>,
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	kernel list <linux-kernel@vger.kernel.org>,
	linux-security-module <linux-security-module@vger.kernel.org>,
	=?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@linux.microsoft.com>
Subject: Re: [PATCH v4 1/1] fs: Allow no_new_privs tasks to call chroot(2)
Message-ID: <202103161221.8291CC3E6@keescook>
References: <20210316170135.226381-1-mic@digikod.net>
 <20210316170135.226381-2-mic@digikod.net>
 <CAG48ez3=M-5WT73HqmFJr6UHwO0+2FJXxcAgRzp6wcd0P3TN=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG48ez3=M-5WT73HqmFJr6UHwO0+2FJXxcAgRzp6wcd0P3TN=Q@mail.gmail.com>

On Tue, Mar 16, 2021 at 08:04:09PM +0100, Jann Horn wrote:
> On Tue, Mar 16, 2021 at 6:02 PM Mickaël Salaün <mic@digikod.net> wrote:
> > One could argue that chroot(2) is useless without a properly populated
> > root hierarchy (i.e. without /dev and /proc).  However, there are
> > multiple use cases that don't require the chrooting process to create
> > file hierarchies with special files nor mount points, e.g.:
> > * A process sandboxing itself, once all its libraries are loaded, may
> >   not need files other than regular files, or even no file at all.
> > * Some pre-populated root hierarchies could be used to chroot into,
> >   provided for instance by development environments or tailored
> >   distributions.
> > * Processes executed in a chroot may not require access to these special
> >   files (e.g. with minimal runtimes, or by emulating some special files
> >   with a LD_PRELOADed library or seccomp).
> >
> > Unprivileged chroot is especially interesting for userspace developers
> > wishing to harden their applications.  For instance, chroot(2) and Yama
> > enable to build a capability-based security (i.e. remove filesystem
> > ambient accesses) by calling chroot/chdir with an empty directory and
> > accessing data through dedicated file descriptors obtained with
> > openat2(2) and RESOLVE_BENEATH/RESOLVE_IN_ROOT/RESOLVE_NO_MAGICLINKS.
> 
> I don't entirely understand. Are you writing this with the assumption
> that a future change will make it possible to set these RESOLVE flags
> process-wide, or something like that?

I thought it meant "open all out-of-chroot dirs as fds using RESOLVE_...
flags then chroot". As in, there's no way to then escape "up" for the
old opens, and the new opens stay in the chroot.

> [...]
> > diff --git a/fs/open.c b/fs/open.c
> [...]
> > +static inline int current_chroot_allowed(void)
> > +{
> > +       /*
> > +        * Changing the root directory for the calling task (and its future
> > +        * children) requires that this task has CAP_SYS_CHROOT in its
> > +        * namespace, or be running with no_new_privs and not sharing its
> > +        * fs_struct and not escaping its current root (cf. create_user_ns()).
> > +        * As for seccomp, checking no_new_privs avoids scenarios where
> > +        * unprivileged tasks can affect the behavior of privileged children.
> > +        */
> > +       if (task_no_new_privs(current) && current->fs->users == 1 &&
> 
> this read of current->fs->users should be using READ_ONCE()

Ah yeah, good call. I should remember this when I think "can this race?"
:P

-- 
Kees Cook
