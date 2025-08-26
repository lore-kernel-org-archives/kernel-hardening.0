Return-Path: <kernel-hardening-return-21978-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 6DE00CA0FE9
	for <kernel-hardening@archiver.kernel.org>; Tue, 26 Aug 2025 12:35:29 +0000 (UTC)
Received: (qmail 3883 invoked by uid 550); 26 Aug 2025 12:35:21 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3842 invoked from network); 26 Aug 2025 12:35:21 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digikod.net;
	s=20191114; t=1756211711;
	bh=R8XQ+qnr9SZ/BmQ7yIcGbNm53gzbfSqxt8B1gBqiUxg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DVv3Cy/rQOpb1FageSeGpGJiQ0vQ9qK2YvEr44f/YXumQ0jgQLQbn01zyRrrPE6Fr
	 ztkIi3ltRzcLAUKGOSoRq/UYWQx6o+d/49io54LxzL/W9LzI8HgvK9kN3UmFUeBspK
	 JjbE8yzV9pYsgoKq3TcmYBkfEPA4TM5OCUV87IGQ=
Date: Tue, 26 Aug 2025 14:35:08 +0200
From: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To: Florian Weimer <fweimer@redhat.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Jann Horn <jannh@google.com>, 
	Al Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Paul Moore <paul@paul-moore.com>, 
	Serge Hallyn <serge@hallyn.com>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Christian Heimes <christian@python.org>, Dmitry Vyukov <dvyukov@google.com>, 
	Elliott Hughes <enh@google.com>, Fan Wu <wufan@linux.microsoft.com>, Jeff Xu <jeffxu@google.com>, 
	Jonathan Corbet <corbet@lwn.net>, Jordan R Abrahams <ajordanr@google.com>, 
	Lakshmi Ramasubramanian <nramas@linux.microsoft.com>, Luca Boccassi <bluca@debian.org>, 
	Matt Bobrowski <mattbobrowski@google.com>, Miklos Szeredi <mszeredi@redhat.com>, 
	Mimi Zohar <zohar@linux.ibm.com>, Nicolas Bouchinet <nicolas.bouchinet@oss.cyber.gouv.fr>, 
	Robert Waite <rowait@microsoft.com>, Roberto Sassu <roberto.sassu@huawei.com>, 
	Scott Shell <scottsh@microsoft.com>, Steve Dower <steve.dower@python.org>, 
	Steve Grubb <sgrubb@redhat.com>, kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, Jeff Xu <jeffxu@chromium.org>
Subject: Re: [RFC PATCH v1 1/2] fs: Add O_DENY_WRITE
Message-ID: <20250826.Lie3ye8to7yo@digikod.net>
References: <20250822170800.2116980-1-mic@digikod.net>
 <20250822170800.2116980-2-mic@digikod.net>
 <CAG48ez1XjUdcFztc_pF2qcoLi7xvfpJ224Ypc=FoGi-Px-qyZw@mail.gmail.com>
 <20250824.Ujoh8unahy5a@digikod.net>
 <CALCETrWwd90qQ3U2nZg9Fhye6CMQ6ZF20oQ4ME6BoyrFd0t88Q@mail.gmail.com>
 <20250825.mahNeel0dohz@digikod.net>
 <lhuikibbv0g.fsf@oldenburg.str.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <lhuikibbv0g.fsf@oldenburg.str.redhat.com>
X-Infomaniak-Routing: alpha

On Mon, Aug 25, 2025 at 11:39:11AM +0200, Florian Weimer wrote:
> * Mickaël Salaün:
> 
> > The order of checks would be:
> > 1. open script with O_DENY_WRITE
> > 2. check executability with AT_EXECVE_CHECK
> > 3. read the content and interpret it
> >
> > The deny-write feature was to guarantee that there is no race condition
> > between step 2 and 3.  All these checks are supposed to be done by a
> > trusted interpreter (which is allowed to be executed).  The
> > AT_EXECVE_CHECK call enables the caller to know if the kernel (and
> > associated security policies) allowed the *current* content of the file
> > to be executed.  Whatever happen before or after that (wrt.
> > O_DENY_WRITE) should be covered by the security policy.
> 
> Why isn't it an improper system configuration if the script file is
> writable?

It is, except if the system only wants to track executions (e.g. record
checksum of scripts) without restricting file modifications.

> 
> In the past, the argument was that making a file (writable and)
> executable was an auditable even, and that provided enough coverage for
> those people who are interested in this.

Yes, but in this case there is a race condition that this patch tried to
fix.
