Return-Path: <kernel-hardening-return-21980-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 9E9F8CA0FF2
	for <kernel-hardening@archiver.kernel.org>; Tue, 26 Aug 2025 17:47:55 +0000 (UTC)
Received: (qmail 13403 invoked by uid 550); 26 Aug 2025 17:47:44 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13363 invoked from network); 26 Aug 2025 17:47:44 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digikod.net;
	s=20191114; t=1756230454;
	bh=z/NUjKchTuxG8z+dgzPttXLaScBMzIR69Ax8SOVBUjA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JzF5NGctdlftcM1YJwG89Bu/YKhZpb2TC6flRXGDGvSAhwm7E9aTjbdy+MTPNR5Cf
	 wcuscZ0FG7I5fwGhBzF51K2dbWsjCtZ6LzO0l8iqWC0cfaoHkystxzh+QdA6e4M5Yo
	 5iaVkRVK9xXxIBIjDfYAAvTB0Ap23RVRVZB8hzag=
Date: Tue, 26 Aug 2025 19:47:30 +0200
From: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To: Theodore Ts'o <tytso@mit.edu>
Cc: Christian Brauner <brauner@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, Kees Cook <keescook@chromium.org>, 
	Paul Moore <paul@paul-moore.com>, Serge Hallyn <serge@hallyn.com>, 
	Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Christian Heimes <christian@python.org>, Dmitry Vyukov <dvyukov@google.com>, 
	Elliott Hughes <enh@google.com>, Fan Wu <wufan@linux.microsoft.com>, 
	Florian Weimer <fweimer@redhat.com>, Jann Horn <jannh@google.com>, Jeff Xu <jeffxu@google.com>, 
	Jonathan Corbet <corbet@lwn.net>, Jordan R Abrahams <ajordanr@google.com>, 
	Lakshmi Ramasubramanian <nramas@linux.microsoft.com>, Luca Boccassi <bluca@debian.org>, 
	Matt Bobrowski <mattbobrowski@google.com>, Miklos Szeredi <mszeredi@redhat.com>, 
	Mimi Zohar <zohar@linux.ibm.com>, Nicolas Bouchinet <nicolas.bouchinet@oss.cyber.gouv.fr>, 
	Robert Waite <rowait@microsoft.com>, Roberto Sassu <roberto.sassu@huawei.com>, 
	Scott Shell <scottsh@microsoft.com>, Steve Dower <steve.dower@python.org>, 
	Steve Grubb <sgrubb@redhat.com>, kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-security-module@vger.kernel.org
Subject: Re: [RFC PATCH v1 0/2] Add O_DENY_WRITE (complement AT_EXECVE_CHECK)
Message-ID: <20250826.iewie7Et5aiw@digikod.net>
References: <20250822170800.2116980-1-mic@digikod.net>
 <20250826-skorpion-magma-141496988fdc@brauner>
 <20250826.aig5aiShunga@digikod.net>
 <20250826123041.GB1603531@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250826123041.GB1603531@mit.edu>
X-Infomaniak-Routing: alpha

On Tue, Aug 26, 2025 at 08:30:41AM -0400, Theodore Ts'o wrote:
> Is there a single, unified design and requirements document that
> describes the threat model, and what you are trying to achieve with
> AT_EXECVE_CHECK and O_DENY_WRITE?  I've been looking at the cover
> letters for AT_EXECVE_CHECK and O_DENY_WRITE, and the documentation
> that has landed for AT_EXECVE_CHECK and it really doesn't describe
> what *are* the checks that AT_EXECVE_CHECK is trying to achieve:
> 
>    "The AT_EXECVE_CHECK execveat(2) flag, and the
>    SECBIT_EXEC_RESTRICT_FILE and SECBIT_EXEC_DENY_INTERACTIVE
>    securebits are intended for script interpreters and dynamic linkers
>    to enforce a consistent execution security policy handled by the
>    kernel."

From the documentation:

  Passing the AT_EXECVE_CHECK flag to execveat(2) only performs a check
  on a regular file and returns 0 if execution of this file would be
  allowed, ignoring the file format and then the related interpreter
  dependencies (e.g. ELF libraries, script’s shebang).

> 
> Um, what security policy?

Whether the file is allowed to be executed.  This includes file
permission, mount point option, ACL, LSM policies...

> What checks?

Executability checks?

> What is a sample exploit
> which is blocked by AT_EXECVE_CHECK?

Executing/interpreting any data: sh script.txt

> 
> And then on top of it, why can't you do these checks by modifying the
> script interpreters?

The script interpreter requires modification to use AT_EXECVE_CHECK.

There is no other way for user space to reliably check executability of
files (taking into account all enforced security
policies/configurations).
