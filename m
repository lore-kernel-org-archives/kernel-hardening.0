Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20160122104837.GA14440@pc.thejh.net>
References: <1453444200-8604-1-git-send-email-daniel.sangorrin@toshiba.co.jp>
 <1453444200-8604-2-git-send-email-daniel.sangorrin@toshiba.co.jp> <20160122104837.GA14440@pc.thejh.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 22 Jan 2016 09:17:17 -0800
Message-ID: <CALCETrUKXtWhSkqrK+TAy4u421yift8P49SM-RbAtB=tFKpkTQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] [RFC PATCH 1/1] seccomp: provide information
 about the previous syscall
To: Jann Horn <jann@thejh.net>
Cc: Daniel Sangorrin <daniel.sangorrin@toshiba.co.jp>, Kees Cook <keescook@chromium.org>, Will Drewry <wad@chromium.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jan 22, 2016 at 2:48 AM, Jann Horn <jann@thejh.net> wrote:
> On Fri, Jan 22, 2016 at 03:30:00PM +0900, Daniel Sangorrin wrote:
>> This patch allows applications to restrict the order in which
>> its system calls may be requested. In order to do that, we
>> provide seccomp-BPF scripts with information about the
>> previous system call requested.
>>
>> An example use case consists of detecting (and stopping) return
>> oriented attacks that disturb the normal execution flow of
>> a user program.
>
>
> The intent here is to mitigate attacks in which an attacker has
> e.g. a function pointer overwrite without a high degree of stack
> control or the ability to perform a stack pivot, correct? So that
> e.g. a one-gadget system() call won't succeed?
>
> Do you have data on how effective this protection is using just
> the previous system call number?
>
> I think that for example, the "magic ROP gadget" in glibc that
> can be used given just a single pointer overwrite and stdin
> control (https://gist.github.com/zachriggle/ca24daf4e8be953a3f96),
> which (as far as I can tell) is in the middle of the system()
> implementation, could be used as long as a transition to one of
> the following syscalls is allowed:
>
>  - rt_sigaction
>  - rt_sigprocmask
>  - clone
>  - execve
>
> I'm not sure how many interesting syscalls typically transition
> to that, perhaps you can comment on that?

rt_sigaction is going to be a problem.  It can legitimately follow
*anything* because of async signals.

In general, I think I don't like this idea.  It seems like a hack that
we'll have to support forever that will allow semi-reliable IDS
signatures to break due to async signals and occasionally detect
intrusions that don't modify themselves slightly to evade detection.

--Andy
