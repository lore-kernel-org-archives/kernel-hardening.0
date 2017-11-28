MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CA+55aFz0t7cCkePJQ1w44Kw_g5nns1tYJLUOL7f-c7vriqkFig@mail.gmail.com>
References: <1511803118-2552-1-git-send-email-tixxdz@gmail.com>
 <1511803118-2552-6-git-send-email-tixxdz@gmail.com> <CA+55aFxfO1i1LS9dPTTCf50ovWPXcq6BE9mKiq_FxWSm4iE8Mg@mail.gmail.com>
 <CAEiveUcvKbuJMB5801jdRosxYn+CZ4E=pfvXNrhuOrXXbw4ZBQ@mail.gmail.com>
 <CA+55aFzx2eM+wVrjQEfkE-G8E9OVLcdo6vk0fDMwZNu2sh1oCQ@mail.gmail.com>
 <1100603534.56586.1511871419952@ichabod.co-bxl> <20171128193243.4fymnjk7fplqw62x@thunk.org>
 <CAGXu5jLtBjLSe5mbe5sYSao1o67ezkkQq_u3md9646rRfi3cCQ@mail.gmail.com>
 <CA+55aFzvaFR1skBFKwT1QPnKqxaLqCuq33FCuYz8DP7MjKkgNg@mail.gmail.com>
 <CAGXu5j+OzbUAcqVBuC8QoY-ZiA9Xw6Uf9kzfzpx9MQHQ1LtxVQ@mail.gmail.com> <CA+55aFz0t7cCkePJQ1w44Kw_g5nns1tYJLUOL7f-c7vriqkFig@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 28 Nov 2017 13:33:40 -0800
Message-ID: <CAGXu5j+V8+h6kdbz5Det=wsRKjt6Cm0-_n8soLCU2PZ=AvqpJQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] Re: [PATCH v5 next 5/5] net: modules: use
 request_module_cap() to load 'netdev-%s' modules
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Theodore Ts'o <tytso@mit.edu>, Djalal Harouni <tixxdz@gmail.com>, Jonathan Corbet <corbet@lwn.net>, James Morris <james.l.morris@oracle.com>, LSM List <linux-security-module@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Geo Kozey <geokozey@mailfence.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Nov 28, 2017 at 12:33 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Tue, Nov 28, 2017 at 12:20 PM, Kees Cook <keescook@chromium.org> wrote:
>>
>> So what's the right path forward for allowing a way to block
>> autoloading? Separate existing request_module() calls into "must be
>> privileged" and "can be unpriv" first, then rework the series to deal
>> with the "unpriv okay" subset?
>
> So once we've taken care of the networking ones that check their own
> different capability bit, maybe we can then make the regular
> request_module() do a rate-limited warning for non-CAP_SYS_MODULE uses
> that prints which module it's loading.
>
> And then just see what people report.

I'm fine to try this experiment. I just think it'll be very noisy. :)

> Because maybe it's just a very small handful that matters, and we can
> say "those are ok".

See, that's the problem: it's not a matter of "those are ok". Those
modules will either have bugs discovered in them or will gain bugs
over time. The point is to provide a mechanism to block an entire
attack surface on systems that do not need auto-loading (which is a
lot of systems).

As I've said before, this isn't a theoretical attack surface. This
year alone there have been three known-exploitable flaws exposed by
autoloading:

The exploit for CVE-2017-2636 uses int n_hdlc = N_HDLC; ioctl(fd,
TIOCSETD, &n_hdlc) [1]. This is using the existing "tty-ldisc-"
prefix, and is intentionally unprivileged.

The exploit for CVE-2017-6074 uses socket(PF_INET6, SOCK_DCCP,
IPPROTO_IP) [2]. This is using the existing proto prefix, and is
intentionally unprivileged.

The exploit for CVE-2017-7184 uses socket(PF_NETLINK, SOCK_RAW,
NETLINK_XFRM) [3]. This is using existing proto prefix and became
unprivileged by way of user namespaces (CAP_NET_ADMIN in a
user-namespace).

Concerned admins have already disabled user namespaces, so they were
protected from the last one, but they couldn't stop the first two
without explicit blacklists ahead of time. (Though anyone paying
attention to vulnerability histories would have already blacklisted
DCCP.)

> And maybe that is too optimistic, and we have a lot of device driver
> ones because people still have a static /dev and don't have udev
> populating modules and device nodes, and then maybe we need to
> introduce a "request_module_dev()" where the rule is that you had to
> at least have privileges to open the device node.
>
> Because I really am *not* interested in these security flags that are
> off by default and then get turned on by special cases. I think it's
> completely unacceptable to say "we're insecure by default but then you
> can do X and be secure". It doesn't work. It doesn't fix anything.

I empathize with this stance, but the last many years of hardening has
been doing this just fine, and we've progressively moved defenses from
"off by default" to "on by default", by way of distros, etc, over
time. But sometimes we have things that must stay off by default to
avoid breaking rule #1, even though every distro has turned it on by
default (e.g. link restrictions). So, saying "it must be on by default
and not break userspace" puts us in a bit of a catch-22.

It sounds like the proposed path forward is:

1) convert existing privileged request_module() usage to use explicit
permission and/or capability checks
2) mark the remaining with WARN_RATELIMIT
3) wait
4) ???

It's steps 3 and 4 that worry me because we have a standing need for a
solution here, and "wait" isn't a very convincing solution and step 4
is unknown. We know we're going to have unprivileged module loading
(e.g. AF_ALG), even if we reduce the places where it's used. In the
end, we will still need a way for a process to say "I don't want to
auto-load modules from here on out". That's the part I want to figure
out, otherwise Djalal doesn't have a way to address the attack
surface.

-Kees

[1] https://github.com/snorez/exploits/blob/master/cve-2017-2636/cve-2017-2636.c
[2] https://github.com/xairy/kernel-exploits/blob/master/CVE-2017-6074/poc.c
[3] https://github.com/snorez/exploits/blob/master/cve-2017-7184/exp.c

-- 
Kees Cook
Pixel Security
