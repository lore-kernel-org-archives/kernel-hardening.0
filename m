Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20120229161437.GA3078@redhat.com>
References: <1330140111-17201-1-git-send-email-wad@chromium.org>
	<1330140111-17201-10-git-send-email-wad@chromium.org>
	<20120227175407.GD10608@redhat.com>
	<CABqD9hY1P7LfmBwQwSG7jDZmw6d_pZH4q2cZq_4ssjQUKRA32w@mail.gmail.com>
	<20120228164335.GC3664@redhat.com>
	<CABqD9hY7=DpxWzf3+WNsK=LuLrabf=oHxyy+CQgu0JLxZ80zPQ@mail.gmail.com>
	<CABqD9hZ3apFGi+BmX5UNgz=NJUbTigj6acDKG=wu9rrL0wN1Ww@mail.gmail.com>
	<20120229161437.GA3078@redhat.com>
Date: Wed, 29 Feb 2012 10:33:35 -0600
Message-ID: <CABqD9hZLi416irXMMPmysYohrOn1gQjhjDyKTggU80Kd7ywvcA@mail.gmail.com>
From: Will Drewry <wad@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH v11 10/12] ptrace,seccomp: Add PTRACE_SECCOMP support
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com, netdev@vger.kernel.org, x86@kernel.org, arnd@arndb.de, davem@davemloft.net, hpa@zytor.com, mingo@redhat.com, peterz@infradead.org, rdunlap@xenotime.net, mcgrathr@chromium.org, tglx@linutronix.de, luto@mit.edu, eparis@redhat.com, serge.hallyn@canonical.com, djm@mindrot.org, scarybeasts@gmail.com, indan@nul.nu, pmoore@redhat.com, akpm@linux-foundation.org, corbet@lwn.net, eric.dumazet@gmail.com, markus@chromium.org, coreyb@linux.vnet.ibm.com, keescook@chromium.org, Denys Vlasenko <dvlasenk@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Feb 29, 2012 at 10:14 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 02/28, Will Drewry wrote:
>>
>> On Tue, Feb 28, 2012 at 11:04 AM, Will Drewry <wad@chromium.org> wrote:
>> > On Tue, Feb 28, 2012 at 10:43 AM, Oleg Nesterov <oleg@redhat.com> wrot=
e:
>> >>
>> >> Great. In this case this patch becomes really trivial. Just 2 defines
>> >> in ptrace.h and the unconditional ptrace_event() under SECCOMP_RET_TR=
ACE.
>>
>> hrm the only snag is that I can't then rely on TIF_SYSCALL_TRACE to
>> ensure seccomp is in the slow-path. =A0Right now, on x86, seccomp is
>> slow-path, but it doesn't have to be to have the syscall and args.
>> However, for ptrace to behavior properly, I believed it did need to be
>> in the slow path. =A0If SECCOMP_RET_TRACE doesn't rely on
>> PTRACE_SYSCALL, then it introduces a need for seccomp to always be in
>> the slow path or to flag (somehow) when it needs slow path.
>
> My understanding of this magic is very limited, and I'm afraid
> I misunderstood... So please correct me.
>
> But what is the problem? system_call checks _TIF_WORK_SYSCALL_ENTRY
> which includes _TIF_SECCOMP | _TIF_SYSCALL_TRACE, and jumps to
> tracesys which does SAVE_REST.
>
> Anyway. secure_computing() is called by syscall_trace_enter() which
> also calls tracehook_report_syscall_entry(). If SECCOMP_RET_TRACE
> can't do ptrace_event() then why tracehook_report_syscall_entry() is
> fine?

Early on in this patch series, I was urged away from regviews (for
many reasons), one of them was so that seccomp could, at some point,
be fast-path'd like audit is for x86.  (It may be on arm already, I'd
need to check.)  So I was hoping that I could avoid adding a slow-path
dependency to the seccomp code.

Right now, on x86, you are exactly right: Both seccomp and ptrace take
the slow path as part of _TIF_WORK_SYSCALL_ENTRY, and seccomp is only
called in syscall_trace_enter.  By adding a requirement for the
slow-path in the form of ptrace_event(), the difficulty for making
seccomp fast-path friendly is increased.  (It could be possible to add
a return code, e.g., return NEEDS_SLOW_PATH, which tells the fast path
code to restart the handling at syscall_trace_enter, so maybe I am
making a big deal out of nothing.)

I was hoping to avoid having TIF_SECCOMP imply the slow-path, but if
that is the only sane way to integrate, then I can leave making it
fast-path friendly as a future exercise.

If I'm over-optimizing, just say so, and I'll post the v12 with the
docs updated to indicate that, at present, seccomp filters requires
the slow path.  However, if you see a nice way to avoid the
dependency, I'd love to know!

Thanks!
will
