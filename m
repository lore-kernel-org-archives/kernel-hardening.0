Return-Path: <kernel-hardening-return-21982-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 435B1CA0FF0
	for <kernel-hardening@archiver.kernel.org>; Tue, 26 Aug 2025 20:52:08 +0000 (UTC)
Received: (qmail 3612 invoked by uid 550); 26 Aug 2025 20:51:59 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3550 invoked from network); 26 Aug 2025 20:51:58 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1756241464; bh=v5oDFv0dgAPRpziVWFPx6zdFfgff+kVk8oRL4Pe1b1Y=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=Q1ARfjwu71oSkJlLMRLzzm2JN69hQGM1WvgsY5EY3+q98/n6dom5NJc6+WimJFJ3T
	 B7TYI4dgHUOuoz0y4mgTXm3/8l821W0KPSA3SC/2uRmT1YRUk6nkig9dXTW98axLsl
	 PySNicn6h7sntg32HF03DpOtccWEbyJXZxm8NgpAvJa/QJuzX8W1EbKpc+3BsMBXJ6
	 AXVHDhhbOMvY8uZrpPPT7E8DJZGoldPeeEInngiX8ldxwfjnVFRseaKAv+06eINfSY
	 icCTfTS3d4PpDP9Zjj7u6ITUPMKycEVz8eAyA4edVAeKl8QwO3/7IILoJ9JQ3PxtPP
	 aPcAeiSs+hnxQ==
Date: Tue, 26 Aug 2025 16:50:57 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc: Christian Brauner <brauner@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Kees Cook <keescook@chromium.org>, Paul Moore <paul@paul-moore.com>,
        Serge Hallyn <serge@hallyn.com>, Andy Lutomirski <luto@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Christian Heimes <christian@python.org>,
        Dmitry Vyukov <dvyukov@google.com>, Elliott Hughes <enh@google.com>,
        Fan Wu <wufan@linux.microsoft.com>,
        Florian Weimer <fweimer@redhat.com>, Jann Horn <jannh@google.com>,
        Jeff Xu <jeffxu@google.com>, Jonathan Corbet <corbet@lwn.net>,
        Jordan R Abrahams <ajordanr@google.com>,
        Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
        Luca Boccassi <bluca@debian.org>,
        Matt Bobrowski <mattbobrowski@google.com>,
        Miklos Szeredi <mszeredi@redhat.com>, Mimi Zohar <zohar@linux.ibm.com>,
        Nicolas Bouchinet <nicolas.bouchinet@oss.cyber.gouv.fr>,
        Robert Waite <rowait@microsoft.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        Scott Shell <scottsh@microsoft.com>,
        Steve Dower <steve.dower@python.org>, Steve Grubb <sgrubb@redhat.com>,
        kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [RFC PATCH v1 0/2] Add O_DENY_WRITE (complement AT_EXECVE_CHECK)
Message-ID: <20250826205057.GC1603531@mit.edu>
References: <20250822170800.2116980-1-mic@digikod.net>
 <20250826-skorpion-magma-141496988fdc@brauner>
 <20250826.aig5aiShunga@digikod.net>
 <20250826123041.GB1603531@mit.edu>
 <20250826.iewie7Et5aiw@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250826.iewie7Et5aiw@digikod.net>

On Tue, Aug 26, 2025 at 07:47:30PM +0200, Mickaël Salaün wrote:
> 
>   Passing the AT_EXECVE_CHECK flag to execveat(2) only performs a check
>   on a regular file and returns 0 if execution of this file would be
>   allowed, ignoring the file format and then the related interpreter
>   dependencies (e.g. ELF libraries, script’s shebang).

But if that's it, why can't the script interpreter (python, bash,
etc.) before executing the script, checks for executability via
faccessat(2) or fstat(2)?

The whole O_DONY_WRITE dicsussion seemed to imply that AT_EXECVE_CHECK
was doing more than just the executability check?

> There is no other way for user space to reliably check executability of
> files (taking into account all enforced security
> policies/configurations).

Why doesn't faccessat(2) or fstat(2) suffice?  This is why having a
more substantive requirements and design doc might be helpful.  It
appears you have some assumptions that perhaps other kernel developers
are not aware.  I certainly seem to be missing something.....

    		  	    	    - Ted
