Return-Path: <SRS0=FQxa=6L=lists.openwall.com=kernel-hardening-return-18656-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECD89C4CECD
	for <kernel-hardening@archiver.kernel.org>; Mon, 27 Apr 2020 19:42:07 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 50CBE205C9
	for <kernel-hardening@archiver.kernel.org>; Mon, 27 Apr 2020 19:42:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MF42SY0y"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 50CBE205C9
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18656-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21953 invoked by uid 550); 27 Apr 2020 19:41:59 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21918 invoked from network); 27 Apr 2020 19:41:58 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Xl34K+WyxLr+OBvYQN0aKmiQr358TgE2J+a3gDDkuqM=;
        b=MF42SY0yJDHJdeoyY2Bjwc+L+5Rr7RvBuYk1vaEDqwpzTy0Ar8l+AbQfdBq1oayuyv
         SJXbUSShjHhaEBMZLwdk+OxRBeDjhp1VRKMog083j5glNgfGCc+7I5FgZ6vPiIIHhGWh
         sF7V0Ruklt+nNaNQX+JILLGfdp6vZWflEQ6iV76Id0K1rDOJArWBcMfpAUBaBLoVsXVb
         ypw+plAYtlWVCBp2m7iOCt6tepzBEZbd2OKkM4g8zh2qfOKC//uFor3uGBjViUMwr4CN
         VzVmewGExwi+4HTaPdyE/SZ/V0ozK5wjvdksx5p7yrkQWK1+DILp1h1GhuPi1M7VJjv0
         YM8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Xl34K+WyxLr+OBvYQN0aKmiQr358TgE2J+a3gDDkuqM=;
        b=cb1EB5d/PLdBq52Zz8FD9roSu7ChvP64cGnAICzXK5PTx4IzoWcSXYy7SEr+73X2bZ
         4fsCS6Rwnv1vEdra6usIM6gIQyfP18USFUlj6Wa6ipJjboL70cAK+YJkB1vIb1oLLZhn
         rhsRhUGvSxwIYRzSI4Z1UJ16PnFEPnOxQ2yEK6l49VFTddRssAcmwkPVqxQorgvsWJwq
         XEGuozrZrB3quFazcwX1OjDkrQoZonVMD4ylH2IK6SQxmseVKMjryYwkOVTnd+/xGMt1
         kG1oY3CHt5wQcv39ugpGmN2h2R/NNTfWoZh/mygv6/LcvvJf7520LK8qAqUmef2pHczY
         9ufA==
X-Gm-Message-State: AGi0PuaYwmMhvMgUcBaaZt+7njHLt55Dh0zp7vfM2fqTGXWXWVzVl0e7
	rI8LQqeoVkDsVR4r4NzILRl5lWMiN/UdP2S1ljuTWQ==
X-Google-Smtp-Source: APiQypJB2kkCHuH47L8Yqrr/alg5ajajOgnK9X0cKKMKzoNexUMBYbSy7qjFlCoaorsBN9I9MYaWgib532GjcJ9d3i8=
X-Received: by 2002:a2e:760c:: with SMTP id r12mr14755084ljc.139.1588016506746;
 Mon, 27 Apr 2020 12:41:46 -0700 (PDT)
MIME-Version: 1.0
References: <20200427143646.619227-1-christian.brauner@ubuntu.com>
 <CAG48ez3eSJSODADpo=O-j9txJ=2R+EupunRvs5H9t5Wa8mvkRA@mail.gmail.com> <20200427181507.ry3hw7ufiifwhi5k@wittgenstein>
In-Reply-To: <20200427181507.ry3hw7ufiifwhi5k@wittgenstein>
From: Jann Horn <jannh@google.com>
Date: Mon, 27 Apr 2020 21:41:20 +0200
Message-ID: <CAG48ez2D36QZU0djiXGbirCgcFeAWA02s8PCk6SWEY5MoKg_kg@mail.gmail.com>
Subject: Re: [PATCH] nsproxy: attach to namespaces via pidfds
To: Christian Brauner <christian.brauner@ubuntu.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	=?UTF-8?Q?St=C3=A9phane_Graber?= <stgraber@ubuntu.com>, 
	Linux Containers <containers@lists.linux-foundation.org>, 
	"Eric W . Biederman" <ebiederm@xmission.com>, Serge Hallyn <serge@hallyn.com>, 
	Aleksa Sarai <cyphar@cyphar.com>, 
	linux-security-module <linux-security-module@vger.kernel.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, Apr 27, 2020 at 8:15 PM Christian Brauner
<christian.brauner@ubuntu.com> wrote:
> On Mon, Apr 27, 2020 at 07:28:56PM +0200, Jann Horn wrote:
> > On Mon, Apr 27, 2020 at 4:47 PM Christian Brauner
> > <christian.brauner@ubuntu.com> wrote:
[...]
> > > That means
> > > setns(nsfd, CLONE_NEWNET) equals setns(pidfd, CLONE_NEWNET). However,
> > > when a pidfd is passed, multiple namespace flags can be specified in the
> > > second setns() argument and setns() will attach the caller to all the
> > > specified namespaces all at once or to none of them. If 0 is specified
> > > together with a pidfd then setns() will interpret it the same way 0 is
> > > interpreted together with a nsfd argument, i.e. attach to any/all
> > > namespaces.
> > [...]
> > > Apart from significiantly reducing the number of syscalls from double
> > > digit to single digit which is a decent reason post-spectre/meltdown
> > > this also allows to switch to a set of namespaces atomically, i.e.
> > > either attaching to all the specified namespaces succeeds or we fail.
> >
> > Apart from the issues I've pointed out below, I think it's worth
> > calling out explicitly that with the current design, the switch will
> > not, in fact, be fully atomic - the process will temporarily be in
> > intermediate stages where the switches to some namespaces have
> > completed while the switches to other namespaces are still pending;
> > and while there will be less of these intermediate stages than before,
> > it also means that they will be less explicit to userspace.
>
> Right, that can be fixed by switching to the unshare model of getting a
> new set of credentials and committing it after the nsproxy has been
> installed? Then there shouldn't be an intermediate state anymore or
> rather an intermediate stage where we can still fail somehow.

It still wouldn't be atomic (in the sense of parallelism, not in the
sense of intermediate error handling) though; for example, if task B
does setns(<pidfd_of_task_a>, 0) and task C concurrently does
setns(<pidfd_of_task_b>, 0), then task C may end up with the new mount
namespace of task B but the old user namespace, or something like
that. If C is more privileged than B, that may cause C to have more
privileges through its configuration of namespaces than B does (e.g.
by running in the &init_user_ns but with a mount namespace owned by an
unprivileged user), which C may not expect. Same thing for racing
between unshare() and setns().

[...]
> > > +               put_user_ns(user_ns);
> > > +       }
> > > +#else
> > > +       if (flags & CLONE_NEWUSER)
> > > +               ret = -EINVAL;
> > > +#endif
> > > +
> > > +       if (!ret && wants_ns(flags, CLONE_NEWNS))
> > > +               ret = __ns_install(nsproxy, mnt_ns_to_common(nsp->mnt_ns));
> >
> > And this one might be even worse, because the mount namespace change
> > itself is only stored in the nsproxy at this point, but the cwd and
> > root paths have already been overwritten on the task's fs_struct.
> >
> > To actually make sys_set_ns() atomic, I think you'd need some
> > moderately complicated prep work, splitting the ->install handlers up
> > into prep work and a commit phase that can't fail.
>
> Wouldn't it be sufficient to move to an unshare like model, i.e.
> creating a new set of creds, and passing the new user_ns to
> create_new_namespaces() as well as having a temporary new_fs struct?
> That should get rid of all intermediate stages.

Ah, good point, I didn't realize that that already exists for unshare().
