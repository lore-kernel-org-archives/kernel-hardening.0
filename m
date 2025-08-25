Return-Path: <kernel-hardening-return-21969-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 04CCCCA0FE1
	for <kernel-hardening@archiver.kernel.org>; Mon, 25 Aug 2025 09:39:50 +0000 (UTC)
Received: (qmail 9329 invoked by uid 550); 25 Aug 2025 09:39:44 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9306 invoked from network); 25 Aug 2025 09:39:43 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756114773;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SEwlDpD+C/EtRZv27QcaLtBUwUyBdktuJKWqODYJttI=;
	b=YGCrfsS0O+PYD+6vOZ5yL8Xrbv6hqCp/JmqIgfzmFJY27HRhs4mfEmNWzxoRJQylT5xJ2d
	f5Y1VJANlAXfJ/8uTMLY3SG2nuBMcOYy+bY4nayleyjIDE7anBOriyX7C064bnvRfrJcDx
	eAbdCdc2H8E2Aq9NmPW6w9HRKBKfsJk=
X-MC-Unique: mnd5_XyLMPSzPB5s5xNMDA-1
X-Mimecast-MFC-AGG-ID: mnd5_XyLMPSzPB5s5xNMDA_1756114767
From: Florian Weimer <fweimer@redhat.com>
To: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
Cc: Andy Lutomirski <luto@amacapital.net>,  Jann Horn <jannh@google.com>,
  Al Viro <viro@zeniv.linux.org.uk>,  Christian Brauner
 <brauner@kernel.org>,  Kees Cook <keescook@chromium.org>,  Paul Moore
 <paul@paul-moore.com>,  Serge Hallyn <serge@hallyn.com>,  Andy Lutomirski
 <luto@kernel.org>,  Arnd Bergmann <arnd@arndb.de>,  Christian Heimes
 <christian@python.org>,  Dmitry Vyukov <dvyukov@google.com>,  Elliott
 Hughes <enh@google.com>,  Fan Wu <wufan@linux.microsoft.com>,  Jeff Xu
 <jeffxu@google.com>,  Jonathan Corbet <corbet@lwn.net>,  Jordan R Abrahams
 <ajordanr@google.com>,  Lakshmi Ramasubramanian
 <nramas@linux.microsoft.com>,  Luca Boccassi <bluca@debian.org>,  Matt
 Bobrowski <mattbobrowski@google.com>,  Miklos Szeredi
 <mszeredi@redhat.com>,  Mimi Zohar <zohar@linux.ibm.com>,  Nicolas
 Bouchinet <nicolas.bouchinet@oss.cyber.gouv.fr>,  Robert Waite
 <rowait@microsoft.com>,  Roberto Sassu <roberto.sassu@huawei.com>,  Scott
 Shell <scottsh@microsoft.com>,  Steve Dower <steve.dower@python.org>,
  Steve Grubb <sgrubb@redhat.com>,  kernel-hardening@lists.openwall.com,
  linux-api@vger.kernel.org,  linux-fsdevel@vger.kernel.org,
  linux-integrity@vger.kernel.org,  linux-kernel@vger.kernel.org,
  linux-security-module@vger.kernel.org,  Jeff Xu <jeffxu@chromium.org>
Subject: Re: [RFC PATCH v1 1/2] fs: Add O_DENY_WRITE
In-Reply-To: <20250825.mahNeel0dohz@digikod.net> (=?utf-8?Q?=22Micka=C3=AB?=
 =?utf-8?Q?l_Sala=C3=BCn=22's?= message
	of "Mon, 25 Aug 2025 11:31:42 +0200")
References: <20250822170800.2116980-1-mic@digikod.net>
	<20250822170800.2116980-2-mic@digikod.net>
	<CAG48ez1XjUdcFztc_pF2qcoLi7xvfpJ224Ypc=FoGi-Px-qyZw@mail.gmail.com>
	<20250824.Ujoh8unahy5a@digikod.net>
	<CALCETrWwd90qQ3U2nZg9Fhye6CMQ6ZF20oQ4ME6BoyrFd0t88Q@mail.gmail.com>
	<20250825.mahNeel0dohz@digikod.net>
Date: Mon, 25 Aug 2025 11:39:11 +0200
Message-ID: <lhuikibbv0g.fsf@oldenburg.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

* Micka=C3=ABl Sala=C3=BCn:

> The order of checks would be:
> 1. open script with O_DENY_WRITE
> 2. check executability with AT_EXECVE_CHECK
> 3. read the content and interpret it
>
> The deny-write feature was to guarantee that there is no race condition
> between step 2 and 3.  All these checks are supposed to be done by a
> trusted interpreter (which is allowed to be executed).  The
> AT_EXECVE_CHECK call enables the caller to know if the kernel (and
> associated security policies) allowed the *current* content of the file
> to be executed.  Whatever happen before or after that (wrt.
> O_DENY_WRITE) should be covered by the security policy.

Why isn't it an improper system configuration if the script file is
writable?

In the past, the argument was that making a file (writable and)
executable was an auditable even, and that provided enough coverage for
those people who are interested in this.

Thanks,
Florian

