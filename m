Reply-To: kernel-hardening@lists.openwall.com
Date: Sun, 11 Mar 2012 19:20:07 +0100
From: Oleg Nesterov <oleg@redhat.com>
Message-ID: <20120311182007.GA5601@redhat.com>
References: <1331421919-15499-1-git-send-email-tixxdz@opendz.org> <CA+55aFwdOgt=C52APPyvnAitcWNbzu-uXRi43m4bLS85oDgtqA@mail.gmail.com> <20120311103532.GA26980@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120311103532.GA26980@openwall.com>
Subject: [kernel-hardening] Re: exec_id protection from bad child exit signals (was: Re:
	[PATCH 0/9] proc: protect /proc/<pid>/* files across execve)
To: Solar Designer <solar@openwall.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Djalal Harouni <tixxdz@opendz.org>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Vasiliy Kulikov <segoon@openwall.com>, Kees Cook <keescook@chromium.org>, WANG Cong <xiyou.wangcong@gmail.com>, James Morris <james.l.morris@oracle.com>, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@elte.hu>, Stephen Wilson <wilsons@start.ca>, "Jason A. Donenfeld" <Jason@zx2c4.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 03/11, Solar Designer wrote:
>
> Actually, the original/historical purpose of the exec_id stuff was to
> protect privileged parent processes (those having done a SUID/SGID exec)
> from non-standard child exit signals, which could be set with clone().
> I think we may want to audit the current implementation and see if it
> still fully achieves the goal or maybe not (and fix it if not).

Funny that, I noticed this message only after I sent the question about
the current exec_id stuff.

> I include below pieces of the prototype implementation from
> linux-2.2.12-ow6.tar.gz released in 1999.

Perhaps I missed something, but ignoring the "cap_raised" issues, this
all is very simple. de_thread() should simply do:

	current->exit_signal = SIGCHLD;

	read_lock(&tasklist_lock);
	list_for_each_entry(p, &current->children, sibling)
		p->exit_signal = SIGCHILD;
	read_unlock(&tasklist_lock);

The only problem is CLONE_PARENT.

Oleg.
