Return-Path: <SRS0=RqpU=HD=lists.openwall.com=kernel-hardening-return-20715-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A48CBC433DB
	for <kernel-hardening@archiver.kernel.org>; Mon,  1 Feb 2021 18:39:17 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A40EE64E9A
	for <kernel-hardening@archiver.kernel.org>; Mon,  1 Feb 2021 18:39:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A40EE64E9A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=canonical.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20715-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 15507 invoked by uid 550); 1 Feb 2021 18:39:10 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5820 invoked from network); 1 Feb 2021 18:20:42 -0000
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UPqXWgUKPGqSrvzsDJ1hLN4vFt5hlyhZiNhXcx6/KiI=;
        b=qGntnhY0x5o6VwgXF2wNnJK/wsrsGvFFlkfMP6oBXbOTSctmZQuhzOsp+VLjwK/DBn
         2Iaz9e5EOIHqbLkqWpo/q2qHYfC3FZgswdky71vTry5/9Hk99P7wrK7COQ2fIkaS2dS7
         9pkJz0BsPiNOXPdUHAW3/ygbaZNrXJXU5VDLSWVAosWGjbkWYWcup3UyU+eDIN1m3LVb
         2KpFe7ZuE++uAjE+m3Qjgsc9GQ2B9c3MwDUnMWPiW74yyoLUl+S1o1VOqAfHPbmr5Xb/
         XZ1/evVQgwzw7Aq5O6ClOZVcoMORG3tHHTovNDox4ZZL+FeRkcN0qYFX3UO7PhSIDD4B
         5Mdw==
X-Gm-Message-State: AOAM531I4OQP2HolfzzChHZflxJBhbTHERqeC/9Yv4/jrHHWDWeqPzrw
	gyrLONlarca3wUk8SsUyQZMkiL0iNxAmZ2SqMVdvYTnni6bzuMEexQ+AARYcIAVo98/jh4ozxId
	9E0pmSEit1j+6yZTyLw75l/adszOWMm8MJGWRX1uEqGwTRJTQ4Qk=
X-Received: by 2002:aa7:d045:: with SMTP id n5mr20143334edo.306.1612203630225;
        Mon, 01 Feb 2021 10:20:30 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz/VHsu1uZGrDB+4cT71OTN2hs/MFvOZ2PaJJ/stCN9vTwHOVunhpIC9VzytRJMlREMp6yOQw==
X-Received: by 2002:aa7:d045:: with SMTP id n5mr20143312edo.306.1612203629956;
        Mon, 01 Feb 2021 10:20:29 -0800 (PST)
Date: Mon, 1 Feb 2021 19:20:24 +0100
From: Christian Brauner <christian.brauner@canonical.com>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Andy Lutomirski <luto@amacapital.net>,
	LKML <linux-kernel@vger.kernel.org>, Jann Horn <jann@thejh.net>
Subject: Re: forkat(int pidfd), execveat(int pidfd), other awful things?
Message-ID: <20210201182024.p5rz47pjksxbxd5a@gmail.com>
References: <CAHmME9oHBtR4fBBUY8E_Oi7av-=OjOGkSNhQuMJMHhafCjazBw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHmME9oHBtR4fBBUY8E_Oi7av-=OjOGkSNhQuMJMHhafCjazBw@mail.gmail.com>

On Mon, Feb 01, 2021 at 06:47:17PM +0100, Jason A. Donenfeld wrote:
> Hi Andy & others,
> 
> I was reversing some NT stuff recently and marveling over how wild and
> crazy things are over in Windows-land. A few things related to process
> creation caught my interest:
> 
> - It's possible to create a new process with an *arbitrary parent
> process*, which means it'll then inherit various things like handles
> and security attributes and tokens from that new parent process.
> 
> - It's possible to create a new process with the memory space handle
> of a different process. Consider this on Linux, and you have some
> abomination like `forkat(int pidfd)`.
> 
> The big question is "why!?" At first I was just amused by its presence
> in NT. Everything is an object and you can usually freely mix and
> match things, and it's very flexible, which is cool. But this is NT,
> not Linux.
> 
> Jann and I were discussing, though, that maybe some variant of these
> features might be useful to get rid of setuid executables. Imagine
> something like `systemd-sudod`, forked off of PID 1 very early.
> Subsequently all new processes on the system run with
> PR_SET_NO_NEW_PRIVS or similar policies to prevent non-root->root
> transition. Then, if you want to transition, you ask systemd-sudod (or
> polkitd, or whatever else you have in mind) to make you a new process,
> and it then does the various policy checks, and executes a new process
> for you as the parent of the requesting process.
> 
> So how would that work? Well, executing processes with arbitrary
> parents would be part of it, as above. But we'd probably want to more
> carefully control that new process. Which chroot is it in? How do
> cgroups work? And so on. And ultimately this design leads to something
> like ZwCreateProcess, where you have several arguments, each to a
> handle to some part of the new process state, or null to be inherited
> from its parent.
> 
> int execve_parent(int parent_pidfd, int root_dirfd, int cgroup_fd, int
> namespace_fd, const char *pathname, char *const argv[], char *const
> envp[]);
> 
> One could imagine this growing pretty unwieldy. There's also this
> other design aspect of Linux that's worth considering. Namespaces and
> other process-inherited resources are generally hierarchical, with
> children getting the resource from their parent. This makes sense and
> is simple to conceptualize. Everytime we add a new thing_fd as a
> pointer to one of these resources, and allow it to be used outside of
> that hierarchy, it introduces a kind of "escape hatch". That might be
> considered "bad design" by some; it might not be by others. Seen this
> way, NT is one massive escape hatch, with pretty much everything being
> an object with a handle.
> 
> But! Maybe this is nonetheless an interesting design avenue to
> explore. The introduction of pidfd is sort of just the "beginning" of
> that kind of design.
> 
> Is any of this interesting to you as a future of privilege escalation
> and management on Linux?

A bunch of this was discussed in a breakout room during Linux Plumbers
last year and I also had discussions with Lennart about this a little
while ago.

One API I had proposed was to extend pidfd_open() to give you a
pidfd that does not yet refer to any process, i.e. instead of

int pidfd = pidfd_open(1234, 0);

you could do

int pidfd = pidfd_open(-1/-ESRCH, 0);

which would give you an empty process handle without any mentionable
properties.

A simple/dumb design would then be to let clone3() not just return
pidfds but also take pidfds as an argument. You could then hand-off the
pidfd to another process SCM_RIGHTS/pidfd_getfd() and have it create a
process for you with the privileges of the caller, you'd still be the
parent.

Or in addition to pidfd_open() we add new syscalls to configure a
process context pidfd_configure() or sm. This design I initially
proposed before we ended up with what we have now.

So yes, I would love to have at least the concept to create a process
for another process, delegated fork, essentially.

Christian
