Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 23 Jun 2016 19:03:52 +0200
From: Oleg Nesterov <oleg@redhat.com>
Message-ID: <20160623170352.GA17372@redhat.com>
References: <cover.1466466093.git.luto@kernel.org>
 <CA+55aFyahpuy94qqECj0ZA6oD3Vy0r=gY2cH8_dB1a-4XURV2Q@mail.gmail.com>
 <CALCETrUuG0-tGNQ5iAEO2_gaK1eUq7AoALoBeQKcOP8cvxr=eA@mail.gmail.com>
 <CA+55aFx480bxx7VAmFqdsVGHjoSav4eCvVpcx5ZSpBQuq+=1Mw@mail.gmail.com>
 <20160623143126.GA16664@redhat.com>
 <CA+55aFwBL5ArLXZ0+YggTbp6Qon+OM+Foihe0yrQOmRRvu96VQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwBL5ArLXZ0+YggTbp6Qon+OM+Foihe0yrQOmRRvu96VQ@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v3 00/13] Virtually mapped stacks with guard pages (x86,
 core)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Andy Lutomirski <luto@kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 06/23, Linus Torvalds wrote:
>
> But that does bring up another possibility: do it at wait() time, when
> we do release_thread(). That's when we *used* to synchronously free
> it, before we did the lockless RCU walks.

Let me quote my previous email ;)

	And we can't free/nullify it when the parent/debuger reaps a zombie,
	say, mark_oom_victim() expects that get_task_struct() protects
	thread_info as well.

probably we can fix all such users though...

> At that point, it has been removed from all the thread lists. So the
> only way to find it is through the RCU walks. Do any of *those* touch
> ti->flags? I'm not seeing it,

Neither me, although I didn't try to grep too much.

> and it sounds fixable if any do

probably yes, but this would mean that tasklist_lock protects task->stack,
doesn't look really nice...

Oleg.
