Return-Path: <kernel-hardening-return-21975-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 3C818CA0EFA
	for <kernel-hardening@archiver.kernel.org>; Tue, 26 Aug 2025 09:07:34 +0000 (UTC)
Received: (qmail 3356 invoked by uid 550); 26 Aug 2025 09:07:25 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3324 invoked from network); 26 Aug 2025 09:07:25 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756199234;
	bh=v1CSBcWHPbCnidtHdXODW6dfbip1NV8JwzZFOpqYkck=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=s6iE5Y5FkD/yXMMiE/ghxcC3Oi9Yjk1XRIAqRYCNYsanV38XhW0i9eYf/To0VJW2o
	 WYQ/ZuC/nsgerBNGvoSmbNWxd920UR2TtKpnCWfGJ0ya5JFfJedNtTwBQQPmb8U4h4
	 BseIkK0ylDIqzI7SCwbyNOd9sNya7tC+6HO9HPjMmmQbOnK+zruIPEca3JrwtTdrNe
	 oRTWtlPucmsV8c2at+UAsG81IyPSE2bfpHKs4HQe1qvcsLoiG+/mf1P9GeBoVj6YSx
	 uaWFXu4OYAr72+8s0T/DoofNbBohK7R7cRZZj7Z1UVMUlyI61q+NGofFGEoEaZ13OJ
	 F3tqSNVCLSKcg==
Date: Tue, 26 Aug 2025 11:07:03 +0200
From: Christian Brauner <brauner@kernel.org>
To: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Kees Cook <keescook@chromium.org>, 
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
Message-ID: <20250826-skorpion-magma-141496988fdc@brauner>
References: <20250822170800.2116980-1-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250822170800.2116980-1-mic@digikod.net>

On Fri, Aug 22, 2025 at 07:07:58PM +0200, Mickaël Salaün wrote:
> Hi,
> 
> Script interpreters can check if a file would be allowed to be executed
> by the kernel using the new AT_EXECVE_CHECK flag. This approach works
> well on systems with write-xor-execute policies, where scripts cannot
> be modified by malicious processes. However, this protection may not be
> available on more generic distributions.
> 
> The key difference between `./script.sh` and `sh script.sh` (when using
> AT_EXECVE_CHECK) is that execve(2) prevents the script from being opened
> for writing while it's being executed. To achieve parity, the kernel
> should provide a mechanism for script interpreters to deny write access
> during script interpretation. While interpreters can copy script content
> into a buffer, a race condition remains possible after AT_EXECVE_CHECK.
> 
> This patch series introduces a new O_DENY_WRITE flag for use with
> open*(2) and fcntl(2). Both interfaces are necessary since script
> interpreters may receive either a file path or file descriptor. For
> backward compatibility, open(2) with O_DENY_WRITE will not fail on
> unsupported systems, while users requiring explicit support guarantees
> can use openat2(2).

We've said no to abusing the O_* flag space for that AT_EXECVE_* stuff
before and you've been told by Linus as well that this is a nogo.

Nothing has changed in that regard and I'm not interested in stuffing
the VFS APIs full of special-purpose behavior to work around the fact
that this is work that needs to be done in userspace. Change the apps,
stop pushing more and more cruft into the VFS that has no business
there.

That's before we get into all the issues that are introduced by this
mechanism that magically makes arbitrary files unwritable. It's not just
a DoS it's likely to cause breakage in userspace as well. I removed the
deny-write from execve because it already breaks various use-cases or
leads to spurious failures in e.g., go. We're not spreading this disease
as a first-class VFS API.
