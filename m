Reply-To: kernel-hardening@lists.openwall.com
From: ebiederm@xmission.com (Eric W. Biederman)
References: <1453502345-30416-1-git-send-email-keescook@chromium.org>
Date: Fri, 22 Jan 2016 21:02:40 -0600
In-Reply-To: <1453502345-30416-1-git-send-email-keescook@chromium.org> (Kees
	Cook's message of "Fri, 22 Jan 2016 14:39:03 -0800")
Message-ID: <8737tp0zhr.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain
Subject: [kernel-hardening] Re: [PATCH 0/2] sysctl: allow CLONE_NEWUSER to be disabled
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Richard Weinberger <richard@nod.at>, Andy Lutomirski <luto@amacapital.net>, Robert =?utf-8?B?xZp3acSZY2tp?= <robert@swiecki.net>, Dmitry Vyukov <dvyukov@google.com>, David Howells <dhowells@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>, Kostya Serebryany <kcc@google.com>, Alexander Potapenko <glider@google.com>, Eric Dumazet <edumazet@google.com>, Sasha Levin <sasha.levin@oracle.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Kees Cook <keescook@chromium.org> writes:

> There continues to be unexpected side-effects and security exposures
> via CLONE_NEWUSER. For many end-users running distro kernels with
> CONFIG_USER_NS enabled, there is no way to disable this feature when
> desired. As such, this creates a sysctl to restrict CLONE_NEWUSER so
> admins not running containers or Chrome can avoid the risks of this
> feature.

I don't actually think there do continue to be unexpected side-effects
and security exposures with CLONE_NEWUSER.  It takes a while for all of
the fixes to trickle out to distros.  At most what I have seen recently
are problems with other kernel interfaces being amplified with user
namespaces.  AKA the current mess with devpts, and the unexpected
issues with bind mounts in mount namespaces.

I have a couple of concerns with a sysctl.

1) As user namespaces settle out this sysctl has the potential to
   decrease the security of the system overall as sandboxing
   features of the kernel will not be available to unprivileged
   applications.

   Web browsing with chrome will be less safe for example.

2) I strongly suspect the granularity of a sysctl is wrong for access to
   user namespaces on a production system.

   In general I suspect what we want is something like seccomp.  I
   believe all of the relevant bits are in registers.  I actually
   thought that was enough for seccomp.  Does seccomp not work for
   some reason?

3) A sysctl breeds a false sense of security in thinking that if a
   security issue is discovered you can just flip a switch, disable
   all new user namespaces and you won't be vulnerable.

   In fact most of the issues in the past have only required being in
   a user namespace to trigger.  Which means any containers or user
   namespaces that already exist could be used to exploit any new
   found issue.  Which means that a I don't think a sysctl will give
   the desired level of protection.

   In my analysis of the issues to date I don't know of anything
   short of a reboot that would meaninfully remove the threat.

4) With applications like docker coming on-line I don't think a
   restriction to processes with capabilities is actually meaninful
   for restricting access to user namespaces.

So I have concerns about both efficacy and usability with the proposed
sysctl.

So to keep this productive.  Please tell me about the threat model
you envision, and how you envision knobs in the kernel being used to
counter those threats.

Eric
