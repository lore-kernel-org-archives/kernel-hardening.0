Reply-To: kernel-hardening@lists.openwall.com
From: ebiederm@xmission.com (Eric W. Biederman)
References: <1331421919-15499-1-git-send-email-tixxdz@opendz.org>
Date: Mon, 12 Mar 2012 12:13:15 -0700
In-Reply-To: <1331421919-15499-1-git-send-email-tixxdz@opendz.org> (Djalal
	Harouni's message of "Sun, 11 Mar 2012 00:25:10 +0100")
Message-ID: <m1pqchocok.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Subject: [kernel-hardening] Re: [PATCH 0/9] proc: protect /proc/<pid>/* files across execve
To: Djalal Harouni <tixxdz@opendz.org>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, Vasiliy Kulikov <segoon@openwall.com>, Kees Cook <keescook@chromium.org>, Solar Designer <solar@openwall.com>, WANG Cong <xiyou.wangcong@gmail.com>, James Morris <james.l.morris@oracle.com>, Oleg Nesterov <oleg@redhat.com>, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@elte.hu>, Stephen Wilson <wilsons@start.ca>, "Jason A. Donenfeld" <Jason@zx2c4.com>
List-ID: <kernel-hardening.lists.openwall.com>

Djalal Harouni <tixxdz@opendz.org> writes:

> Procfs files and other important objects may contain sensitive information
> which must not be seen, inherited or processed across execve.

So I am dense.  /proc/<pid>/mem was special in that it uses a different
set of checks than other files, and to do those access checks
/proc/<pid>/mem needed to look at exec_id.

For all of the access checks that are not written in that silly way.
What is wrong with ptrace_may_access run at every read/write of a file?

We redo all of the permission checks every time so that should avoid
races.

I really think you are trying to solve something that is not broken.
Certainly I could not see your argument for why anything but
/proc/<pid>/mem needs attention.

Eric
