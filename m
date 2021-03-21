Return-Path: <SRS0=tOYd=IT=lists.openwall.com=kernel-hardening-return-21030-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA60FC433C1
	for <kernel-hardening@archiver.kernel.org>; Sun, 21 Mar 2021 18:51:08 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0C24A61582
	for <kernel-hardening@archiver.kernel.org>; Sun, 21 Mar 2021 18:51:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0C24A61582
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lwn.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21030-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 20122 invoked by uid 550); 21 Mar 2021 18:51:01 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20090 invoked from network); 21 Mar 2021 18:51:00 -0000
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 77F39380
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1616352648; bh=EqV1VgSlLFQyXnFket4LcyHA3UrIyqvAcEOTQ+atUY8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=asHjG9H2A9f/73eb9aVEk4zMFITebZ1RPJiQNEqhor9AwXdirS+m0PSRYNhw8p0cs
	 tvenoGiSFBTdT3SJL8JdfpY4qS+bhyf0EWdjVToRdpxM3kP9IolZF3Bh/xYLm/TWSh
	 HlN39f0Myrcs8rVf6eMLkhWDWwOJfsUDdE/eQnhIOCDkTXJGfFO6U6OjWh5a3nJ7lT
	 z4CH/onLmCQkq0TtTxxybp5oDQEFc2THQmoBdsd7f/NgDt1BxKjBkrk1Yc5kISTGCl
	 dL5RFzdQWSrjPX2NdSBeRE/aQeAXEyTYX7kk7jWhSRvdxDj7/5iG6FO9h6aeMCEcuq
	 Wa6vVAbgKrFSQ==
From: Jonathan Corbet <corbet@lwn.net>
To: John Wood <john.wood@gmx.com>, Kees Cook <keescook@chromium.org>, Jann
 Horn <jannh@google.com>, Randy Dunlap <rdunlap@infradead.org>, James
 Morris <jmorris@namei.org>, Shuah Khan <shuah@kernel.org>
Cc: John Wood <john.wood@gmx.com>, "Serge E. Hallyn" <serge@hallyn.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andi Kleen
 <ak@linux.intel.com>, kernel test robot <oliver.sang@intel.com>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, linux-kselftest@vger.kernel.org,
 kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v6 7/8] Documentation: Add documentation for the Brute LSM
In-Reply-To: <20210307113031.11671-8-john.wood@gmx.com>
References: <20210307113031.11671-1-john.wood@gmx.com>
 <20210307113031.11671-8-john.wood@gmx.com>
Date: Sun, 21 Mar 2021 12:50:47 -0600
Message-ID: <87k0q0l4s8.fsf@meer.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain

John Wood <john.wood@gmx.com> writes:

> Add some info detailing what is the Brute LSM, its motivation, weak
> points of existing implementations, proposed solutions, enabling,
> disabling and self-tests.
>
> Signed-off-by: John Wood <john.wood@gmx.com>
> ---
>  Documentation/admin-guide/LSM/Brute.rst | 278 ++++++++++++++++++++++++
>  Documentation/admin-guide/LSM/index.rst |   1 +
>  security/brute/Kconfig                  |   3 +-
>  3 files changed, 281 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/admin-guide/LSM/Brute.rst

Thanks for including documentation with the patch!

As you get closer to merging this, though, you'll want to take a minute
(OK, a few minutes) to build the docs and look at the result; there are
a number of places where you're not going to get what you expect.  Just
as an example:

[...]

> +Based on the above scenario it would be nice to have this detected and
> +mitigated, and this is the goal of this implementation. Specifically the
> +following attacks are expected to be detected:
> +
> +1.- Launching (fork()/exec()) a setuid/setgid process repeatedly until a
> +    desirable memory layout is got (e.g. Stack Clash).
> +2.- Connecting to an exec()ing network daemon (e.g. xinetd) repeatedly until a
> +    desirable memory layout is got (e.g. what CTFs do for simple network
> +    service).
> +3.- Launching processes without exec() (e.g. Android Zygote) and exposing state
> +    to attack a sibling.
> +4.- Connecting to a fork()ing network daemon (e.g. apache) repeatedly until the
> +    previously shared memory layout of all the other children is exposed (e.g.
> +    kind of related to HeartBleed).

Sphinx will try to recognize your enumerated list, but that may be a bit
more punctuation than it is prepared to deal with; I'd take the hyphens
out, if nothing else.

[...]

> +These statistics are hold by the brute_stats struct.
> +
> +struct brute_cred {
> +	kuid_t uid;
> +	kgid_t gid;
> +	kuid_t suid;
> +	kgid_t sgid;
> +	kuid_t euid;
> +	kgid_t egid;
> +	kuid_t fsuid;
> +	kgid_t fsgid;
> +};

That will certainly not render the way you want.  What you need here is
a literal block:

These statistics are hold by the brute_stats struct::

    struct brute_cred {
	kuid_t uid;
	kgid_t gid;
	kuid_t suid;
	kgid_t sgid;
	kuid_t euid;
	kgid_t egid;
	kuid_t fsuid;
	kgid_t fsgid;
    };

The "::" causes all of the indented text following to be formatted
literally. 

Thanks,

jon
