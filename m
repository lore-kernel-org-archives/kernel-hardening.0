Return-Path: <SRS0=tEhV=BU=lists.openwall.com=kernel-hardening-return-19585-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5F05C433DF
	for <kernel-hardening@archiver.kernel.org>; Mon, 10 Aug 2020 23:06:04 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 24C882073E
	for <kernel-hardening@archiver.kernel.org>; Mon, 10 Aug 2020 23:06:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 24C882073E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19585-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 15386 invoked by uid 550); 10 Aug 2020 23:05:57 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15366 invoked from network); 10 Aug 2020 23:05:56 -0000
Date: Tue, 11 Aug 2020 00:05:21 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc: Kees Cook <keescook@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Aleksa Sarai <cyphar@cyphar.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Andy Lutomirski <luto@kernel.org>,
	Christian Brauner <christian.brauner@ubuntu.com>,
	Christian Heimes <christian@python.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Deven Bowers <deven.desai@linux.microsoft.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Eric Chiang <ericchiang@google.com>,
	Florian Weimer <fweimer@redhat.com>,
	James Morris <jmorris@namei.org>, Jan Kara <jack@suse.cz>,
	Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>,
	Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
	Matthew Garrett <mjg59@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Michael Kerrisk <mtk.manpages@gmail.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Philippe =?iso-8859-1?Q?Tr=E9buchet?= <philippe.trebuchet@ssi.gouv.fr>,
	Scott Shell <scottsh@microsoft.com>,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	Shuah Khan <shuah@kernel.org>, Steve Dower <steve.dower@python.org>,
	Steve Grubb <sgrubb@redhat.com>,
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
	Thibaut Sautereau <thibaut.sautereau@clip-os.org>,
	Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
	kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v7 0/7] Add support for O_MAYEXEC
Message-ID: <20200810230521.GG1236603@ZenIV.linux.org.uk>
References: <20200723171227.446711-1-mic@digikod.net>
 <202007241205.751EBE7@keescook>
 <0733fbed-cc73-027b-13c7-c368c2d67fb3@digikod.net>
 <20200810202123.GC1236603@ZenIV.linux.org.uk>
 <917bb071-8b1a-3ba4-dc16-f8d7b4cc849f@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <917bb071-8b1a-3ba4-dc16-f8d7b4cc849f@digikod.net>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Tue, Aug 11, 2020 at 12:43:52AM +0200, Mickaël Salaün wrote:

> Hooking on open is a simple design that enables processes to check files
> they intend to open, before they open them.

Which is a good thing, because...?

> From an API point of view,
> this series extends openat2(2) with one simple flag: O_MAYEXEC. The
> enforcement is then subject to the system policy (e.g. mount points,
> file access rights, IMA, etc.).

That's what "unspecified" means - as far as the kernel concerned, it's
"something completely opaque, will let these hooks to play, semantics is
entirely up to them".
 
> Checking on open enables to not open a file if it does not meet some
> requirements, the same way as if the path doesn't exist or (for whatever
> reasons, including execution permission) if access is denied. It is a
> good practice to check as soon as possible such properties, and it may
> enables to avoid (user space) time-of-check to time-of-use (TOCTOU)
> attacks (i.e. misuse of already open resources).

?????  You explicitly assume a cooperating caller.  If it can't be trusted
to issue the check between open and use, or can be manipulated (ptraced,
etc.) into not doing so, how can you rely upon the flag having been passed
in the first place?  And TOCTOU window is definitely not wider that way.

If you want to have it done immediately after open(), bloody well do it
immediately after open.  If attacker has subverted your control flow to the
extent that allows them to hit descriptor table in the interval between
these two syscalls, you have already lost - they'll simply prevent that
flag from being passed.

What's the point of burying it inside openat2()?  A convenient multiplexor
to hook into?  We already have one - it's called do_syscall_...
