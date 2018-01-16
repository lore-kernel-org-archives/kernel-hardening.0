MIME-Version: 1.0
In-Reply-To: <20180115075231.0d435fec@gandalf.local.home>
References: <20180113213441.52047-1-dan@kernelim.com> <20180113213441.52047-6-dan@kernelim.com>
 <20180114014801.GC1701@tigerII.localdomain> <20180114080108.GA69022@gmail.com>
 <20180115075231.0d435fec@gandalf.local.home>
From: Daniel Micay <danielmicay@gmail.com>
Date: Tue, 16 Jan 2018 18:44:45 -0500
Message-ID: <CA+DvKQJM8N30PXUTVJQTWfkhGu7-3F+sy9bwK-gJhc8anmwG9g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] Re: [PATCHv2 5/7] printk: allow kmsg to be
 encrypted using public key encryption
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Dan Aloni <dan@kernelim.com>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, linux-kernel@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>, Petr Mladek <pmladek@suse.com>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

> Do you have any backing from makers of such devices? I'd like to hear
> from Google's Android team or whoever that would turn this feature on.

(I'm not a Google employee, but I work on Android security and
contribute some of that to AOSP.)

Android restricts access to dmesg with SELinux, so it's not really an
issue there. They previously used dmesg_restrict but switched to
SELinux for fine-grained control without using the capability. In
general, the access control features / toggles proposed on
kernel-hardening don't do much for Android because there's nothing
unconfined and there's no system administrator reconfiguring the
system and disabling SELinux to make it work. The toggles like
dmesg_restrict tend to be too coarse without a good way to make
exceptions.

Unprivileged processes including apps can't access dmesg, debugfs,
sysfs (other than a tiny set of exceptions), procfs outside of
/proc/net and /proc/PID (but it uses hidepid=2) and a few whitelisted
files, etc. That's mostly done with SELinux along with using it for
ioctl command whitelisting to have per-device per-domain whitelists of
commands instead of using their global seccomp-bpf policy for it. The
hidepid=2 usage is an example of a feature where SELinux doesn't quite
fit the task as an alternative since apps are all in the untrusted_app
/ isolated_app domains but each have a unique uid/gid. It works
because hidepid has a gid option to set fine-grained exceptions,
rather than only being able to bypass it with a capability.

They do have some out-of-tree access control features and finding ways
to upstream those might be useful:

There's the added perf_event_paranoid=3 level which is set by default.
It's toggled off when a developer using profiling tools via Android
Debug Bridge (USB) after enabling ADB support in the OS and
whitelisting their key. That was submitted upstream again for Android
but it didn't end up landing. An LSM hook for perf events might help
but Android uses a fully static SELinux policy and would need a way to
toggle it off / on.

They also have group-based control over sockets used to implement the
INTERNET permission but technically they could double the number of
app domains and use SELinux for that if they absolutely had to avoid
an out-of-tree patch. They might not design it the same way today
since it predates using SELinux.
