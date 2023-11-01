Return-Path: <kernel-hardening-return-21718-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id CBFE1C4332F
	for <kernel-hardening@archiver.kernel.org>; Wed,  1 Nov 2023 10:57:06 +0000 (UTC)
Received: (qmail 13368 invoked by uid 550); 1 Nov 2023 10:56:55 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13315 invoked from network); 1 Nov 2023 10:56:54 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
	s=20191114; t=1698836202;
	bh=2Y/ez8hqZVouVrOdZsa/L2LhER6nF7a1GqN0vlqwRvw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ojxwebgjINekqTFqAH/wfkvsKtx9UdDKpPdlSBP4dPC5WXNDw+IEMn6UNa0bG6N+V
	 i6jEfp/mYd0yWwvGJ77234uSG8dY2LT6n5Gpch9rQEYVlqsbVB6q6LQYwsUweYlreC
	 1KFBiSTpG4o5sjqcuUdouDuMxNe8/erwfX5674Qc=
Date: Wed, 1 Nov 2023 11:56:38 +0100
From: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To: Stefan Bavendiek <stefan.bavendiek@mailbox.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, 
	kernel-hardening@lists.openwall.com, linux-hardening@vger.kernel.org
Subject: Re: Isolating abstract sockets
Message-ID: <20231101.eeshae5Ahpei@digikod.net>
References: <Y59qBh9rRDgsIHaj@mailbox.org>
 <20231024134608.GC320399@mail.hallyn.com>
 <CAHC9VhRCJfBRu8172=5jF_gFhv2znQXTnGs_c_ae1G3rk_Dc-g@mail.gmail.com>
 <20231024141807.GB321218@mail.hallyn.com>
 <CAHC9VhQaotVPGzWFFzRCgw9mDDc2tu6kmGHioMBghj-ybbYx1Q@mail.gmail.com>
 <20231024160714.GA323539@mail.hallyn.com>
 <ZUFmW8DrxrhOhuVs@mailbox.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZUFmW8DrxrhOhuVs@mailbox.org>
X-Infomaniak-Routing: alpha

On Tue, Oct 31, 2023 at 09:40:59PM +0100, Stefan Bavendiek wrote:
> On Tue, Oct 24, 2023 at 11:07:14AM -0500, Serge E. Hallyn wrote:
> > In 2005, before namespaces were upstreamed, I posted the 'bsdjail' LSM,
> > which briefly made it into the -mm kernel, but was eventually rejected as
> > being an abuse of the LSM interface for OS level virtualization :)
> > 
> > It's not 100% clear to me whether Stefan only wants isolation, or
> > wants something closer to virtualization.
> > 
> > Stefan, would an LSM allowing you to isolate certain processes from
> > some abstract unix socket paths (or by label, whatever0 suffice for you?
> >
> 
> My intention was to find a clean way to isolate abstract sockets in network
> applications without adding dependencies like LSMs. However the entire approach
> of using namespaces for this is something I have mostly abandoned. LSMs like
> Apparmor and SELinux would work fine for process isolation when you can control
> the target system, but for general deployment of sandboxed processes, I found it
> to be significantly easier (and more effective) to build this into the
> application itself by using a multi process approach with seccomp (Basically how
> OpenSSH did it)

I agree that for sandbox use cases embedding such security policy into
the application itself makes sense. Landlock works the same way as
seccomp but it sandboxes applications according to the kernel semantic
(e.g. process, socket). The LSM framework is just a kernel
implementation detail. ;)
