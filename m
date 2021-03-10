Return-Path: <SRS0=zPsg=II=lists.openwall.com=kernel-hardening-return-20917-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26BC5C433DB
	for <kernel-hardening@archiver.kernel.org>; Wed, 10 Mar 2021 19:33:59 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C914B64FCC
	for <kernel-hardening@archiver.kernel.org>; Wed, 10 Mar 2021 19:33:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C914B64FCC
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20917-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1257 invoked by uid 550); 10 Mar 2021 19:33:51 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1234 invoked from network); 10 Mar 2021 19:33:50 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=C0lOxwjMEr6SWX1hFkOaQGtQdtdGB5FiXwich6XA348=;
        b=NM0J3hx50vHdC/p5h3lzfZtYNUEYEEEUohjNigiA0KbbFneszGz381/p3GLd6yhcWu
         1KuK6TsD+n34eVK+nnQVCLf7Ie1gBju2CVq9ZLZdvETqSzALoCaMBhnofjKv/3sNUuYN
         Q+U9UAUcm9S3x+gB24/4Dfqmv17Vzecl9QcOThzFQv18IpgBij82+yGRMQkEuNTIH62P
         CHqkLGTcxXMX4XVmnYWQNqi/lUVZXi/3hSoVBkV7dSo11C67xn4g9eGuGxYzntTDETq0
         gZmbcBXsEeXMzgX7wVy0G9U7fO0WveTk3yR14wSE1t3VhTeVYQHPwgmWcjKqCHW98c+d
         QxrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=C0lOxwjMEr6SWX1hFkOaQGtQdtdGB5FiXwich6XA348=;
        b=M3gulE2G2QdzISbEYodAJf/yszzJ+dkL2Ii2iQ7te43hAuQAL0YCLWN7e1PYl7fbBd
         b2XV0+jO0TCSPuWksIvhqfRKZm6atwSdJbptCYc5gpPjLYQY92N8/ZJOp2zg0vUsx6Ff
         khZGJkhGKwGEWr5AP1ngzgFjt2x9dofSET50E0ZlCs6G/WtIXfWpSiRd4NQQODOhDVsj
         VsJELdqOLUIk0Ner+ZXV7KBMXkRJg2qQBJ/dZA0IOQKBBNvGQv1D7HWG0zG6uA19RQV2
         rnsujMB8lUERM/jrAZm/wrjSnYb8BgeLDll5bPYJhlyiJatZ17fQbqEMLcgnOR8cwaDU
         srSQ==
X-Gm-Message-State: AOAM532EFsqHm48udvYUh8SXlspWSkuWgBSnJmFQIHLD2kMVzIjUaGMf
	3Tv81JWrDjPcH2CzjYxCj19em6lwMNZe4T3CEZpsZQ==
X-Google-Smtp-Source: ABdhPJywfvsHOIz0NkR2nMiYoKEhfTkPo9yaeevm6MgBPXJj4NmO1bY3FBXA9+0DF6QnwYxqUt/SZcMZ24QK6nH4d6g=
X-Received: by 2002:a2e:9bcd:: with SMTP id w13mr2643039ljj.43.1615404819005;
 Wed, 10 Mar 2021 11:33:39 -0800 (PST)
MIME-Version: 1.0
References: <20210310181857.401675-1-mic@digikod.net> <20210310181857.401675-2-mic@digikod.net>
 <m17dmeq0co.fsf@fess.ebiederm.org>
In-Reply-To: <m17dmeq0co.fsf@fess.ebiederm.org>
From: Jann Horn <jannh@google.com>
Date: Wed, 10 Mar 2021 20:33:12 +0100
Message-ID: <CAG48ez2gVdyFT3r_wVuqePWGQAi6YuYYXZcRJ7ENNdnpfpvkuw@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] fs: Allow no_new_privs tasks to call chroot(2)
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>, 
	Al Viro <viro@zeniv.linux.org.uk>, James Morris <jmorris@namei.org>, 
	Serge Hallyn <serge@hallyn.com>, Andy Lutomirski <luto@amacapital.net>, 
	Casey Schaufler <casey@schaufler-ca.com>, Christian Brauner <christian.brauner@ubuntu.com>, 
	Christoph Hellwig <hch@lst.de>, David Howells <dhowells@redhat.com>, 
	Dominik Brodowski <linux@dominikbrodowski.net>, John Johansen <john.johansen@canonical.com>, 
	Kees Cook <keescook@chromium.org>, Kentaro Takeda <takedakn@nttdata.co.jp>, 
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, kernel list <linux-kernel@vger.kernel.org>, 
	linux-security-module <linux-security-module@vger.kernel.org>, 
	=?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@linux.microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 10, 2021 at 8:23 PM Eric W. Biederman <ebiederm@xmission.com> w=
rote:
>
> Micka=C3=ABl Sala=C3=BCn <mic@digikod.net> writes:
>
> > From: Micka=C3=ABl Sala=C3=BCn <mic@linux.microsoft.com>
> >
> > Being able to easily change root directories enable to ease some
> > development workflow and can be used as a tool to strengthen
> > unprivileged security sandboxes.  chroot(2) is not an access-control
> > mechanism per se, but it can be used to limit the absolute view of the
> > filesystem, and then limit ways to access data and kernel interfaces
> > (e.g. /proc, /sys, /dev, etc.).
> >
> > Users may not wish to expose namespace complexity to potentially
> > malicious processes, or limit their use because of limited resources.
> > The chroot feature is much more simple (and limited) than the mount
> > namespace, but can still be useful.  As for containers, users of
> > chroot(2) should take care of file descriptors or data accessible by
> > other means (e.g. current working directory, leaked FDs, passed FDs,
> > devices, mount points, etc.).  There is a lot of literature that discus=
s
> > the limitations of chroot, and users of this feature should be aware of
> > the multiple ways to bypass it.  Using chroot(2) for security purposes
> > can make sense if it is combined with other features (e.g. dedicated
> > user, seccomp, LSM access-controls, etc.).
> >
> > One could argue that chroot(2) is useless without a properly populated
> > root hierarchy (i.e. without /dev and /proc).  However, there are
> > multiple use cases that don't require the chrooting process to create
> > file hierarchies with special files nor mount points, e.g.:
> > * A process sandboxing itself, once all its libraries are loaded, may
> >   not need files other than regular files, or even no file at all.
> > * Some pre-populated root hierarchies could be used to chroot into,
> >   provided for instance by development environments or tailored
> >   distributions.
> > * Processes executed in a chroot may not require access to these specia=
l
> >   files (e.g. with minimal runtimes, or by emulating some special files
> >   with a LD_PRELOADed library or seccomp).
> >
> > Allowing a task to change its own root directory is not a threat to the
> > system if we can prevent confused deputy attacks, which could be
> > performed through execution of SUID-like binaries.  This can be
> > prevented if the calling task sets PR_SET_NO_NEW_PRIVS on itself with
> > prctl(2).  To only affect this task, its filesystem information must no=
t
> > be shared with other tasks, which can be achieved by not passing
> > CLONE_FS to clone(2).  A similar no_new_privs check is already used by
> > seccomp to avoid the same kind of security issues.  Furthermore, becaus=
e
> > of its security use and to avoid giving a new way for attackers to get
> > out of a chroot (e.g. using /proc/<pid>/root), an unprivileged chroot i=
s
> > only allowed if the new root directory is the same or beneath the
> > current one.  This still allows a process to use a subset of its
> > legitimate filesystem to chroot into and then further reduce its view o=
f
> > the filesystem.
> >
> > This change may not impact systems relying on other permission models
> > than POSIX capabilities (e.g. Tomoyo).  Being able to use chroot(2) on
> > such systems may require to update their security policies.
> >
> > Only the chroot system call is relaxed with this no_new_privs check; th=
e
> > init_chroot() helper doesn't require such change.
> >
> > Allowing unprivileged users to use chroot(2) is one of the initial
> > objectives of no_new_privs:
> > https://www.kernel.org/doc/html/latest/userspace-api/no_new_privs.html
> > This patch is a follow-up of a previous one sent by Andy Lutomirski, bu=
t
> > with less limitations:
> > https://lore.kernel.org/lkml/0e2f0f54e19bff53a3739ecfddb4ffa9a6dbde4d.1=
327858005.git.luto@amacapital.net/
[...]
> Neither is_path_beneath nor path_is_under really help prevent escapes,
> as except for open files and files accessible from proc chroot already
> disallows going up.  The reason is the path is resolved with the current
> root before switching to it.

Yeah, this probably should use the same check as the CLONE_NEWUSER
logic, current_chrooted() from CLONE_NEWUSER; that check is already
used for guarding against the following syscall sequence, which has
similar security properties:
unshare(CLONE_NEWUSER); // gives the current process namespaced CAP_SYS_ADM=
IN
chroot("<...>"); // succeeds because of namespaced CAP_SYS_ADMIN

The current_chrooted() check in create_user_ns() is for the same
purpose as the check you're introducing here, so they should use the
same logic.
