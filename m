Reply-To: kernel-hardening@lists.openwall.com
From: ebiederm@xmission.com (Eric W. Biederman)
References: <1377534240-13227-1-git-send-email-tixxdz@opendz.org>
	<871u5gqtw3.fsf@xmission.com>
	<20130826172054.GE27005@ZenIV.linux.org.uk>
	<20130827172406.GA2664@dztty> <20130828201141.GA21455@dztty>
	<CAGXu5jJ2yop1JrJT1nzKWoT_Q83s9fGK_2BuBcCotHCR9YecDQ@mail.gmail.com>
	<20130828211116.GA22184@dztty>
Date: Wed, 28 Aug 2013 17:26:56 -0700
In-Reply-To: <20130828211116.GA22184@dztty> (Djalal Harouni's message of "Wed,
	28 Aug 2013 22:11:17 +0100")
Message-ID: <87sixt735b.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain
Subject: [kernel-hardening] Re: [PATCH 1/2] procfs: restore 0400 permissions on /proc/*/{syscall,stack,personality}
To: Djalal Harouni <tixxdz@opendz.org>
Cc: Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Solar Designer <solar@openwall.com>, Vasiliy Kulikov <segoon@openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>


I have take a moment and read this thread, and have been completely
unenlightend.  People are upset but it is totally unclear why.

There is no explanation why it is ok to ignore the suid-exec case, as
the posted patches do.  Which ultimately means the patches provide
little to no security benefit, and that the posted patches as written
are broken.

There is no clear explanation of what people are worried about.
References to other threads and other commits do not help.

Can someome please state what they are worried about in simple language
step by step?

I see absolutely nothing to overturn Al's analysis that these files
simply don't need protection.



The closest I saw in the thread was people were worried about ASLR being
defeated.  All I see are kernel addresses and we don't have much if any
runtime or even load time randomization of where code is located in the
kernel address map on x86_64.  So I don't understand the concern.

Certainly all of the clever applications and use of suid apps appear to
be jumping around crazy hoops and to achieve what I can achieve with a
simple cat of a file.

Eric
