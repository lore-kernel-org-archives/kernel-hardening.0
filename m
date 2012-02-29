Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CAB=4xhq1CPz74LchQ32oyhR1vUKjhMiTXENYbgeh=BoaYNP9JQ@mail.gmail.com>
References: <1330140111-17201-1-git-send-email-wad@chromium.org>
	<1330140111-17201-10-git-send-email-wad@chromium.org>
	<20120227175407.GD10608@redhat.com>
	<CABqD9hY1P7LfmBwQwSG7jDZmw6d_pZH4q2cZq_4ssjQUKRA32w@mail.gmail.com>
	<20120228164335.GC3664@redhat.com>
	<CABqD9hY7=DpxWzf3+WNsK=LuLrabf=oHxyy+CQgu0JLxZ80zPQ@mail.gmail.com>
	<CABqD9hZ3apFGi+BmX5UNgz=NJUbTigj6acDKG=wu9rrL0wN1Ww@mail.gmail.com>
	<20120229161437.GA3078@redhat.com>
	<CABqD9hZLi416irXMMPmysYohrOn1gQjhjDyKTggU80Kd7ywvcA@mail.gmail.com>
	<20120229170933.GA6149@redhat.com>
	<CAB=4xhq1CPz74LchQ32oyhR1vUKjhMiTXENYbgeh=BoaYNP9JQ@mail.gmail.com>
Date: Wed, 29 Feb 2012 11:51:49 -0600
Message-ID: <CABqD9haTSHdAcGBy4kLrhAs4UFSrMPFNsLC+X-Hf5_ud2_w19Q@mail.gmail.com>
From: Will Drewry <wad@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH v11 10/12] ptrace,seccomp: Add PTRACE_SECCOMP support
To: Roland McGrath <mcgrathr@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com, netdev@vger.kernel.org, x86@kernel.org, arnd@arndb.de, davem@davemloft.net, hpa@zytor.com, mingo@redhat.com, peterz@infradead.org, rdunlap@xenotime.net, tglx@linutronix.de, luto@mit.edu, eparis@redhat.com, serge.hallyn@canonical.com, djm@mindrot.org, scarybeasts@gmail.com, indan@nul.nu, pmoore@redhat.com, akpm@linux-foundation.org, corbet@lwn.net, eric.dumazet@gmail.com, markus@chromium.org, coreyb@linux.vnet.ibm.com, keescook@chromium.org, Denys Vlasenko <dvlasenk@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Feb 29, 2012 at 11:41 AM, Roland McGrath <mcgrathr@google.com> wrot=
e:
> I don't think TIF_NOTIFY_RESUME is apropos here. =A0That only triggers on
> returning to user mode, i.e. after syscall exit. =A0But regardless of the
> exact implementation details, I don't think it will be prohibitive to add
> some means by which the fast-path can back off before actual syscall entr=
y
> and go to the slow path for ptrace reporting.
>
> Since there is no strong reason to think it can't be reorganized that way
> later, I don't see any good rationale for constraining the seccomp-filter
> feature definition based on a plan to optimize the implementation in the
> future.

Sounds good to me.   I'll move to ptrace_event and save the problem of
code organization for the future.

Thanks!
