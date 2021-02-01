Return-Path: <SRS0=5H3U=HD=lists.openwall.com=kernel-hardening-return-20712-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B146C433E0
	for <kernel-hardening@archiver.kernel.org>; Mon,  1 Feb 2021 17:52:16 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 22DEA64E92
	for <kernel-hardening@archiver.kernel.org>; Mon,  1 Feb 2021 17:52:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 22DEA64E92
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=zx2c4.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20712-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 23600 invoked by uid 550); 1 Feb 2021 17:52:08 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 23568 invoked from network); 1 Feb 2021 17:52:08 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1612201916;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8H4PmtHOZLPbqbAwMx0YvCGu/m87MtMsLJaMPY0DO38=;
	b=JVFb3K3FYo4WqseEMJ7K1AkrpJO6ERZ+yyavwrF0x91dFvQtw4xFEfud1DO4OzPEs7rPe0
	Bk3hKSh0phvR9yJJ+R3sndETQu0oVbNHwX/m0PeFiB2/5r8WGnRH7DGExjvHcSHprVXvJ0
	cjWKF5KUEn0apEobo9NtP87MnfOce4A=
X-Gm-Message-State: AOAM530MVYZ3L6A9bkN+SIlI7Aabn5+rQvtrqcp+ALuEEsrVhl5VUe2x
	8bJhLaguWumjljKXvxjI4MdqJ/6hxKGaei+e+dE=
X-Google-Smtp-Source: ABdhPJwvsXUL4HnViA7KFLcP8aHPlok8xuysB2NjPKamdocjxG61iK2GYtj5Kb7ZRT1mq1qRKM+ddJbo2CnAcmKyeco=
X-Received: by 2002:a25:4981:: with SMTP id w123mr25686628yba.123.1612201915772;
 Mon, 01 Feb 2021 09:51:55 -0800 (PST)
MIME-Version: 1.0
References: <CAHmME9oHBtR4fBBUY8E_Oi7av-=OjOGkSNhQuMJMHhafCjazBw@mail.gmail.com>
In-Reply-To: <CAHmME9oHBtR4fBBUY8E_Oi7av-=OjOGkSNhQuMJMHhafCjazBw@mail.gmail.com>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Mon, 1 Feb 2021 18:51:45 +0100
X-Gmail-Original-Message-ID: <CAHmME9rDC9ObAT=6CJ3h0KQ9ogHsrnDNMnocm5882A2j6OPF6g@mail.gmail.com>
Message-ID: <CAHmME9rDC9ObAT=6CJ3h0KQ9ogHsrnDNMnocm5882A2j6OPF6g@mail.gmail.com>
Subject: Re: forkat(int pidfd), execveat(int pidfd), other awful things?
To: Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Andy Lutomirski <luto@amacapital.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Jann Horn <jann@thejh.net>, 
	Christian Brauner <christian.brauner@canonical.com>
Content-Type: text/plain; charset="UTF-8"

> int execve_parent(int parent_pidfd, int root_dirfd, int cgroup_fd, int
> namespace_fd, const char *pathname, char *const argv[], char *const
> envp[]);

A variant on the same scheme would be:

int execve_remote(int pidfd, int root_dirfd, int cgroup_fd, int
namespace_fd, const char *pathname, char *const argv[], char *const
envp[]);

Unpriv'd process calls fork(), and from that fork sends its pidfd
through a unix socket to systemd-sudod, which then calls execve_remote
on that pidfd.

There are a lot of (potentially very bad) ways to skin this cat.
