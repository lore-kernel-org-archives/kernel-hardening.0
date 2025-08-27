Return-Path: <kernel-hardening-return-21983-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 552D2CA0EFF
	for <kernel-hardening@archiver.kernel.org>; Wed, 27 Aug 2025 08:19:25 +0000 (UTC)
Received: (qmail 29762 invoked by uid 550); 27 Aug 2025 08:19:15 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 29739 invoked from network); 27 Aug 2025 08:19:15 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digikod.net;
	s=20191114; t=1756282745;
	bh=T4RPei0DtLnnZYB66tK2dsxFQ5Fek+OuCR7/tQ4qCMU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nIwesNdKHJfaQDzsU5qqtQNkWy5jqrsWIlIG7pLsa+xQyzF9Nn3bysidzhtBEq4s5
	 auix8D4X4Equ4OtaucY/q3K3HRCqT4s5FmKpQqbFkcZA8vYC9APYiHXG6rBWBRj6Lp
	 NFA+uIf2ecqGASyaInKvnjJQfy33/h63EhiHs8LI=
Date: Wed, 27 Aug 2025 10:19:02 +0200
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
Message-ID: <20250827.ShuD9thahkoh@digikod.net>
References: <20250822170800.2116980-1-mic@digikod.net>
 <20250826-skorpion-magma-141496988fdc@brauner>
 <20250826.aig5aiShunga@digikod.net>
 <20250826123041.GB1603531@mit.edu>
 <20250826.iewie7Et5aiw@digikod.net>
 <20250826205057.GC1603531@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250826205057.GC1603531@mit.edu>
X-Infomaniak-Routing: alpha

On Tue, Aug 26, 2025 at 04:50:57PM -0400, Theodore Ts'o wrote:
> On Tue, Aug 26, 2025 at 07:47:30PM +0200, Mickaël Salaün wrote:
> > 
> >   Passing the AT_EXECVE_CHECK flag to execveat(2) only performs a check
> >   on a regular file and returns 0 if execution of this file would be
> >   allowed, ignoring the file format and then the related interpreter
> >   dependencies (e.g. ELF libraries, script’s shebang).
> 
> But if that's it, why can't the script interpreter (python, bash,
> etc.) before executing the script, checks for executability via
> faccessat(2) or fstat(2)?

From commit a5874fde3c08 ("exec: Add a new AT_EXECVE_CHECK flag to
execveat(2)"):

    This is different from faccessat(2) + X_OK which only checks a subset of
    access rights (i.e. inode permission and mount options for regular
    files), but not the full context (e.g. all LSM access checks).  The main
    use case for access(2) is for SUID processes to (partially) check access
    on behalf of their caller.  The main use case for execveat(2) +
    AT_EXECVE_CHECK is to check if a script execution would be allowed,
    according to all the different restrictions in place.  Because the use
    of AT_EXECVE_CHECK follows the exact kernel semantic as for a real
    execution, user space gets the same error codes.


> 
> The whole O_DONY_WRITE dicsussion seemed to imply that AT_EXECVE_CHECK
> was doing more than just the executability check?

I would say that that AT_EXECVE_CHECK does a full executability check
(with the full caller's credentials checked against the currently
enforced security policy).

The rationale to add O_DENY_WRITE (which is now abandoned) was to avoid a race
condition between the check and the full read.  Indeed, with a full
execveat(2), the kernel write-lock the file to avoid such issue (which can lead
to other issues).

> 
> > There is no other way for user space to reliably check executability of
> > files (taking into account all enforced security
> > policies/configurations).
> 
> Why doesn't faccessat(2) or fstat(2) suffice?  This is why having a
> more substantive requirements and design doc might be helpful.  It
> appears you have some assumptions that perhaps other kernel developers
> are not aware.  I certainly seem to be missing something.....

My reasoning was to explain the rationale for a kernel feature in the commit
message, and the user doc (why and how to use it) in the user-facing
documentation.  Documentation improvements are welcome!
