Return-Path: <kernel-hardening-return-21977-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 9CB3CCA0EFA
	for <kernel-hardening@archiver.kernel.org>; Tue, 26 Aug 2025 12:33:48 +0000 (UTC)
Received: (qmail 9774 invoked by uid 550); 26 Aug 2025 12:33:36 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9651 invoked from network); 26 Aug 2025 12:33:36 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1756211450; bh=gfBKabosxEFtok1jhLkwvxbr40tlm8siH8D4p2Cx5vc=;
	h=Date:Subject:Message-ID:MIME-Version:Content-Type:From;
	b=b8GII4CJJPfrDPxvB9Xkdi0sqO33xqyhjhyC9qdBJqJW/dCH804qFrwyFAxn2OZBY
	 Hx/Gz6dSA7W9aVjxxpye9lOfRVq+7gssepbPckc+6tJjKM5KeOZQzwY+wTIqX10xlT
	 zPaBEdKd/kyFu0yacX3gXr8Gitguh87mEfx6yREqi0uWNtZGKzQMYh0JQvKO0hhDTi
	 vSyM573nYo5yqDMnBnY8yy6iD+vznX9EIEcSlWJZcS91rCIV6aSvMj0QmEAvxhPg7b
	 qtKT3t8q4RGh99UggPBiE028v3jpn+rrQCTJPH9tGBzx+zJqqJpXlHQg1DdLH2fI+D
	 IG3e2BChNa9AQ==
Date: Tue, 26 Aug 2025 08:30:41 -0400
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
Message-ID: <20250826123041.GB1603531@mit.edu>
References: <20250822170800.2116980-1-mic@digikod.net>
 <20250826-skorpion-magma-141496988fdc@brauner>
 <20250826.aig5aiShunga@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250826.aig5aiShunga@digikod.net>
bFrom: Theodore Ts'o <tytso@mit.edu>
From: "Theodore Ts'o" <tytso@mit.edu>

Is there a single, unified design and requirements document that
describes the threat model, and what you are trying to achieve with
AT_EXECVE_CHECK and O_DENY_WRITE?  I've been looking at the cover
letters for AT_EXECVE_CHECK and O_DENY_WRITE, and the documentation
that has landed for AT_EXECVE_CHECK and it really doesn't describe
what *are* the checks that AT_EXECVE_CHECK is trying to achieve:

   "The AT_EXECVE_CHECK execveat(2) flag, and the
   SECBIT_EXEC_RESTRICT_FILE and SECBIT_EXEC_DENY_INTERACTIVE
   securebits are intended for script interpreters and dynamic linkers
   to enforce a consistent execution security policy handled by the
   kernel."

Um, what security policy?  What checks?  What is a sample exploit
which is blocked by AT_EXECVE_CHECK?

And then on top of it, why can't you do these checks by modifying the
script interpreters?

Confused,

						- Ted
