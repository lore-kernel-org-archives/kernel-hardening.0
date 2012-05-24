Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <b70813c0eac769820b35e8879180b13f.squirrel@webmail.greenhost.nl>
In-Reply-To: 
 <CABqD9hZCx88UzAeayn0cz=nTcT=fMiUZohTayHWq+Dcnnx-hQQ@mail.gmail.com>
References: <20120522173942.GJ11775@ZenIV.linux.org.uk>
    <1337875681-20717-1-git-send-email-wad@chromium.org>
    <1337875681-20717-2-git-send-email-wad@chromium.org>
    <acabbed13c4f02e653879844a9cbddef.squirrel@webmail.greenhost.nl>
    <CABqD9hZCx88UzAeayn0cz=nTcT=fMiUZohTayHWq+Dcnnx-hQQ@mail.gmail.com>
Date: Thu, 24 May 2012 22:17:05 +0200
From: "Indan Zupancic" <indan@nul.nu>
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: [kernel-hardening] Re: [RFC PATCH 1/3] seccomp: Don't allow tracers to abuse RET_TRACE
To: Will Drewry <wad@chromium.org>
Cc: linux-kernel@vger.kernel.org, mcgrathr@google.com, hpa@zytor.com, netdev@parisplace.org, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com, mingo@redhat.com, oleg@redhat.com, peterz@infradead.org, rdunlap@xenotime.net, tglx@linutronix.de, luto@mit.edu, serge.hallyn@canonical.com, pmoore@redhat.com, akpm@linux-foundation.org, corbet@lwn.net, markus@chromium.org, coreyb@linux.vnet.ibm.com, keescook@chromium.org, viro@zeniv.linux.org.uk, jmorris@namei.org
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, May 24, 2012 20:24, Will Drewry wrote:
> On Thu, May 24, 2012 at 12:54 PM, Indan Zupancic <indan@nul.nu> wrote:
>> This patch doesn't make any sense whatsoever. You can't know why a system
>> call was blocked by a seccomp filter, assuming it's always because of the
>> system call number is wrong.
>
> All this does is assert that the tracer can't change the syscall
> number without it skipping the call.

Why wouldn't it be allowed to change the system call number?

And try answering that question in a way that doesn't apply to syscall
argument values too.

> If seccomp returned
> SECCOMP_RET_TRACE because the argument to open was O_RDWR, then
> everything is fine.

No it's not fine, because it's inconsistent and arbitrary.

>
>> Also, you don't check if an allowed system call is changed into a denied
>> one, so this doesn't protect against ptracers bypassing seccomp filters.
>
> This enforces that the system call that is going to be executed is the
> one that triggered SECCOMP_RET_TRACE.  That means seccomp is
> delegating the go/no-go decision to the tracer.  I don't understand
> your assertion here.  This code doesn't affect the PTRACE_SYSCALL
> case.

It still gives normal ptracers the ability to bypass seccomp by changing
allowed system calls into system calls that would have been denied. So
considering ptrace can still be used to execute arbitrary system calls,
why add this special case restriction to SECCOMP_RET_TRACE?

>
>> And one of the main points of PTRACE_EVENT_SECCOMP events was that it's
>> useful for cases that can't be handled or decided by the seccomp filter.
>> Then taking away the ability to change the syscall number makes it a lot
>> less useful.
>
> Do you have a valid case where you want to remap one system call to
> another without the ability to also handle the syscall exit path and
> do any fixups?  I've mostly just seen skip, allow, update arguments -
> not swapping the entire syscall.  That said, it's possible.  you could
> do all sorts of weird things with ptrace if you want :)

One case is for system call injection where an arbitrary syscall is
hijacked for the jailer's purposes. But that needs the exit path too.
Another one is replacing fork() with clone(), but that's only necessary
on 2.4. Another one is to let the process call exit() to get rid of it.

But it's easy to get the exit notification by resuming with PTRACE_SYSCALL
after getting a PTRACE_EVENT_SECCOMP event, so I don't see how it matters
if we're interested in the exit path or not.

In the jailer the first system call after an execve is replaced with a
call to mmap2() to get a read-only shared mapping which is used to avoid
file path modifications and similar races. And when using seccomp all
events are PTRACE_EVENT_SECCOMP ones, and those are exactly the ones
where we need the shared read-only mapping. We could work around your
ad hoc restriction, but the main thing is if seccomp filters is just
about syscall numbers anyway, then why use BPF instead of a bitmask?

The whole point of PTRACE_EVENT_SECCOMP is to delegate to ptrace, it
means "we can't decide in the filter, ask the ptracer". This implies
that the ptracer is trusted, so doing any checks afterwards is a bit
pointless. But if you want to do it anyway, at least do it properly
and re-run the filter after ptrace. To avoid loops you need to allow
the syscall if you get another PTRACE_EVENT_SECCOMP.

>
>> Either do the seccomp test before or after ptrace, or both, but please
>> don't introduce ad hoc checks like this.
>
> I don't feel strongly about this RFC, but I don't believe that
> expectations are being changed dramatically.

As seccomp can generate ptrace events, the only thing that makes sense is
to either do seccomp first and ignore ptrace changes, or rerun filters after
any ptrace changes. But as I said in my other mail, if a process can call
ptrace(), it will pretty much avoid all secomp filters anyway, seccomp
filters which allow ptrace() are pretty much guaranteed to be insecure.
We're talking about a non-seccomped process ptracing a seccomped process,
both with the same UID. I don't think it matters in practice what you do
in this case, from a security point of view.

Greetings,

Indan
