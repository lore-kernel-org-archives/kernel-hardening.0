Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CALCETrVpa1zxVXOJoYKZ0zLCdH07dBKbw0Yo-BSJRH0eP_RBvQ@mail.gmail.com>
References: <20160129010651.GA13228@www.outflux.net> <CALCETrVpa1zxVXOJoYKZ0zLCdH07dBKbw0Yo-BSJRH0eP_RBvQ@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sun, 31 Jan 2016 12:19:01 -0800
Message-ID: <CALCETrXBqM2SL4h69CV9y1cd9ybsb8ACaMVrGXryeVfYt_twjw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [RFC][PATCH] seccomp: add SECCOMP_RET_ACK for non-fatal SIGSYS
To: Kees Cook <keescook@chromium.org>
Cc: LSM List <linux-security-module@vger.kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>, Linux API <linux-api@vger.kernel.org>, Will Drewry <wad@chromium.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jeffrey Vander Stoep <jeffv@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Jan 28, 2016 6:33 PM, "Andy Lutomirski" <luto@amacapital.net> wrote:
>
> On Thu, Jan 28, 2016 at 5:06 PM, Kees Cook <keescook@chromium.org> wrote:
> > Tracing processes for syscall usage can be done one step at a time with
> > SECCOMP_RET_TRAP, but this will block the syscall. Alternatively, using
> > a ptrace manager to handle SECCOMP_RET_TRACE returns can be used but is
> > heavy weight and depends on the ptrace infrastructure. A light-weight
> > method to learn syscalls is needed, which can reuse the existing delivery
> > of SIGSYS but without skipping the syscall. This is implemented as
> > SECCOMP_RET_ACK which is as permissive as SECCOMP_RET_ALLOW but delivers
> > SIGSYS after syscall completion, as long as the SECCOMP_RET_DATA is
> > non-zero. A signal handler can install a new rule for each syscall as
> > they are signaled with SECCOMP_RET_DATA set to 0 to disable reporting
> > for that syscall in the future (which is required for restarting syscalls
> > that are signal-sensitive like nanosleep).
> >
> > Registers from the signal will reflect registers after the syscall returns
> > rather than before. Signal-sensitive syscalls will trigger EINTR, so they
> > must be whitelisted before they are resumed. Not allowing the sigreturn
> > syscall (and likely prctl to whitelist) will make using SECCOMP_RET_ACK
> > useless.
> >
> > Signed-off-by: Kees Cook <keescook@chromium.org>
>
> Could this use task_work to queue the signal on return to user mode
> instead?  Would that solve the EINTR issues?
>

As another option, use the existing TRAP option but add a way for a
process to set a flag such that it can delete and re-add a filter.
Then you get SIGSYS, delete the old filter, add a new one that allows
the current syscall, and resume.  No funny business with EINTR or
clobbered regs.

--Andy
