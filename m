Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20160129010651.GA13228@www.outflux.net>
References: <20160129010651.GA13228@www.outflux.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 28 Jan 2016 18:33:01 -0800
Message-ID: <CALCETrVpa1zxVXOJoYKZ0zLCdH07dBKbw0Yo-BSJRH0eP_RBvQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [RFC][PATCH] seccomp: add SECCOMP_RET_ACK for non-fatal SIGSYS
To: Kees Cook <keescook@chromium.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, jeffv@google.com, Oleg Nesterov <oleg@redhat.com>, Will Drewry <wad@chromium.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jan 28, 2016 at 5:06 PM, Kees Cook <keescook@chromium.org> wrote:
> Tracing processes for syscall usage can be done one step at a time with
> SECCOMP_RET_TRAP, but this will block the syscall. Alternatively, using
> a ptrace manager to handle SECCOMP_RET_TRACE returns can be used but is
> heavy weight and depends on the ptrace infrastructure. A light-weight
> method to learn syscalls is needed, which can reuse the existing delivery
> of SIGSYS but without skipping the syscall. This is implemented as
> SECCOMP_RET_ACK which is as permissive as SECCOMP_RET_ALLOW but delivers
> SIGSYS after syscall completion, as long as the SECCOMP_RET_DATA is
> non-zero. A signal handler can install a new rule for each syscall as
> they are signaled with SECCOMP_RET_DATA set to 0 to disable reporting
> for that syscall in the future (which is required for restarting syscalls
> that are signal-sensitive like nanosleep).
>
> Registers from the signal will reflect registers after the syscall returns
> rather than before. Signal-sensitive syscalls will trigger EINTR, so they
> must be whitelisted before they are resumed. Not allowing the sigreturn
> syscall (and likely prctl to whitelist) will make using SECCOMP_RET_ACK
> useless.
>
> Signed-off-by: Kees Cook <keescook@chromium.org>

Could this use task_work to queue the signal on return to user mode
instead?  Would that solve the EINTR issues?

--Andy
