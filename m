Return-Path: <SRS0=9e1i=HD=lists.openwall.com=kernel-hardening-return-20711-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F2F8C433DB
	for <kernel-hardening@archiver.kernel.org>; Mon,  1 Feb 2021 17:47:51 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 6551E64E2A
	for <kernel-hardening@archiver.kernel.org>; Mon,  1 Feb 2021 17:47:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6551E64E2A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=zx2c4.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20711-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 20292 invoked by uid 550); 1 Feb 2021 17:47:42 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20260 invoked from network); 1 Feb 2021 17:47:42 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1612201649;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=KsSWLRNvHtqLZ/lu/iHPVGBawnROqG20zNGdQaCD7HA=;
	b=LSy9GJGCzYrRoSMuVVM/GJi6MpdSJ1QNNhr9PsJrFW/ef/fU1dWkZZVHz+x1zOX9mWjImO
	7fa4UoekmQH48i/JMwtiCTSUo8QCLOoCZ0twAhOkv99hSitWmLrm4RbHJRKnxvDYYSZaj1
	x5gNcOF3By4OgUc9HktJln1B/TUhnqE=
X-Gm-Message-State: AOAM530kLjR96z14jktb0gV+XBqN1t550x/TnIRkhe3YTYEdv3eHpHMx
	7+Eo0O7JVojpurup/qNiot0KWfzH5VXnQyZuLkc=
X-Google-Smtp-Source: ABdhPJzjKgTkuZkwBCx6W8tj6h7g7/av3LQr5hFaREKuh9kX5C89k0fD079sPfHEeqZVP8Za9VEEhpkh0G/am9b5mjI=
X-Received: by 2002:a25:cc3:: with SMTP id 186mr25452179ybm.306.1612201648057;
 Mon, 01 Feb 2021 09:47:28 -0800 (PST)
MIME-Version: 1.0
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Mon, 1 Feb 2021 18:47:17 +0100
X-Gmail-Original-Message-ID: <CAHmME9oHBtR4fBBUY8E_Oi7av-=OjOGkSNhQuMJMHhafCjazBw@mail.gmail.com>
Message-ID: <CAHmME9oHBtR4fBBUY8E_Oi7av-=OjOGkSNhQuMJMHhafCjazBw@mail.gmail.com>
Subject: forkat(int pidfd), execveat(int pidfd), other awful things?
To: Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Andy Lutomirski <luto@amacapital.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Jann Horn <jann@thejh.net>, 
	Christian Brauner <christian.brauner@canonical.com>
Content-Type: text/plain; charset="UTF-8"

Hi Andy & others,

I was reversing some NT stuff recently and marveling over how wild and
crazy things are over in Windows-land. A few things related to process
creation caught my interest:

- It's possible to create a new process with an *arbitrary parent
process*, which means it'll then inherit various things like handles
and security attributes and tokens from that new parent process.

- It's possible to create a new process with the memory space handle
of a different process. Consider this on Linux, and you have some
abomination like `forkat(int pidfd)`.

The big question is "why!?" At first I was just amused by its presence
in NT. Everything is an object and you can usually freely mix and
match things, and it's very flexible, which is cool. But this is NT,
not Linux.

Jann and I were discussing, though, that maybe some variant of these
features might be useful to get rid of setuid executables. Imagine
something like `systemd-sudod`, forked off of PID 1 very early.
Subsequently all new processes on the system run with
PR_SET_NO_NEW_PRIVS or similar policies to prevent non-root->root
transition. Then, if you want to transition, you ask systemd-sudod (or
polkitd, or whatever else you have in mind) to make you a new process,
and it then does the various policy checks, and executes a new process
for you as the parent of the requesting process.

So how would that work? Well, executing processes with arbitrary
parents would be part of it, as above. But we'd probably want to more
carefully control that new process. Which chroot is it in? How do
cgroups work? And so on. And ultimately this design leads to something
like ZwCreateProcess, where you have several arguments, each to a
handle to some part of the new process state, or null to be inherited
from its parent.

int execve_parent(int parent_pidfd, int root_dirfd, int cgroup_fd, int
namespace_fd, const char *pathname, char *const argv[], char *const
envp[]);

One could imagine this growing pretty unwieldy. There's also this
other design aspect of Linux that's worth considering. Namespaces and
other process-inherited resources are generally hierarchical, with
children getting the resource from their parent. This makes sense and
is simple to conceptualize. Everytime we add a new thing_fd as a
pointer to one of these resources, and allow it to be used outside of
that hierarchy, it introduces a kind of "escape hatch". That might be
considered "bad design" by some; it might not be by others. Seen this
way, NT is one massive escape hatch, with pretty much everything being
an object with a handle.

But! Maybe this is nonetheless an interesting design avenue to
explore. The introduction of pidfd is sort of just the "beginning" of
that kind of design.

Is any of this interesting to you as a future of privilege escalation
and management on Linux?

Jason
