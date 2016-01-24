Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <8737tp0zhr.fsf@x220.int.ebiederm.org>
References: <1453502345-30416-1-git-send-email-keescook@chromium.org>
	<8737tp0zhr.fsf@x220.int.ebiederm.org>
Date: Sun, 24 Jan 2016 12:57:50 -0800
Message-ID: <CAGXu5jLzjqzp0WFT=NNuSqOEFzu7u7z8p+x9nouwS9ptaca8qQ@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH 0/2] sysctl: allow CLONE_NEWUSER to be disabled
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Richard Weinberger <richard@nod.at>, Andy Lutomirski <luto@amacapital.net>, =?UTF-8?B?Um9iZXJ0IMWad2nEmWNraQ==?= <robert@swiecki.net>, Dmitry Vyukov <dvyukov@google.com>, David Howells <dhowells@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>, Kostya Serebryany <kcc@google.com>, Alexander Potapenko <glider@google.com>, Eric Dumazet <edumazet@google.com>, Sasha Levin <sasha.levin@oracle.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jan 22, 2016 at 7:02 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Kees Cook <keescook@chromium.org> writes:
>
>> There continues to be unexpected side-effects and security exposures
>> via CLONE_NEWUSER. For many end-users running distro kernels with
>> CONFIG_USER_NS enabled, there is no way to disable this feature when
>> desired. As such, this creates a sysctl to restrict CLONE_NEWUSER so
>> admins not running containers or Chrome can avoid the risks of this
>> feature.
>
> I don't actually think there do continue to be unexpected side-effects
> and security exposures with CLONE_NEWUSER.  It takes a while for all of
> the fixes to trickle out to distros.  At most what I have seen recently
> are problems with other kernel interfaces being amplified with user
> namespaces.  AKA the current mess with devpts, and the unexpected
> issues with bind mounts in mount namespaces.

Access to CLONE_NEWUSER has lead to a lot of security issues over the
last 3 years. There has to be a way to avoid this for people that have
no interest in containers.

For admins running servers where there are no containers (which is
still a giant number of systems -- containers are popular but not
ubiquitous), the sysctl makes perfect sense.

> I have a couple of concerns with a sysctl.
>
> 1) As user namespaces settle out this sysctl has the potential to
>    decrease the security of the system overall as sandboxing
>    features of the kernel will not be available to unprivileged
>    applications.
>
>    Web browsing with chrome will be less safe for example.

I don't propose this for Desktops.

> 2) I strongly suspect the granularity of a sysctl is wrong for access to
>    user namespaces on a production system.
>
>    In general I suspect what we want is something like seccomp.  I
>    believe all of the relevant bits are in registers.  I actually
>    thought that was enough for seccomp.  Does seccomp not work for
>    some reason?

Setting a global seccomp filter on init is not possible with any inits
yet, and for some architectures it would push all processes onto the
slow path. It's an extraordinarily big hammer for wanting to turn off
a single area of the kernel with a long history of problems.

Also, seccomp is arguably a program author's policy tool, not a system
policy tool. We could offer this sysctl as an LSM too, but that's even
messier. This is a trivial change to user namespaces and provides a
large protection to people that aren't interested in the risks of
running containers.

> 3) A sysctl breeds a false sense of security in thinking that if a
>    security issue is discovered you can just flip a switch, disable
>    all new user namespaces and you won't be vulnerable.
>
>    In fact most of the issues in the past have only required being in
>    a user namespace to trigger.  Which means any containers or user
>    namespaces that already exist could be used to exploit any new
>    found issue.  Which means that a I don't think a sysctl will give
>    the desired level of protection.
>
>    In my analysis of the issues to date I don't know of anything
>    short of a reboot that would meaninfully remove the threat.

Any admin that decides to just turn off CLONE_NEWUSER in the middle of
still using it is insane. I don't think this breeds any false sense of
security as most sysctls are set at boot time.

> 4) With applications like docker coming on-line I don't think a
>    restriction to processes with capabilities is actually meaninful
>    for restricting access to user namespaces.

Admins who are currently using containers are already exposed to so
much attack surface. This is not for them, it's for people that don't
use containers.

> So I have concerns about both efficacy and usability with the proposed
> sysctl.

Two distros already have this sysctl because it was so strongly
requested by their users. This needs to be upstream so we can manage
the effects correctly.

> So to keep this productive.  Please tell me about the threat model
> you envision, and how you envision knobs in the kernel being used to
> counter those threats.

The threat model I envision is post-intrusion escalation of privileges
on systems that run distro kernels and do not use containers. I
envision the sysctl being used at boot time to kill the entire class
of current and future vulnerabilities exposed by CLONE_NEWUSER. Just
like the sysctls used to turn off modules at boot or turn off kexec at
boot.

As Linux developers I feel we have an obligation to provide our end
users with run-time choices (not just compile-time choices), since
most of our users are using kernels built by someone else. Given the
repeated problems with module auto-loading, we provided a way to
disable module loading. Given the physical-memory-rewriting exposure
of kexec, we provides a way to disable kexec. Given the conflict
between hibernation and kASLR, we provided a way to choose one at
runtime. Here, we're looking back on three years of vulnerabilities
around CLONE_NEWUSER with no end in sight, and we have an obligation
to help the end users that don't want to be exposed to this any more.
Note I'm not suggesting we stop trying to fix the problems we find
with user namespaces, but we need to provide a way to disable them.

Having this sysctl is vastly superior to telling people how to rewrite
their kernel memory at boot time to disable syscalls:

https://outflux.net/blog/archives/2013/12/10/live-patching-the-kernel/

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
