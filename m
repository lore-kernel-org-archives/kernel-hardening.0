MIME-Version: 1.0
In-Reply-To: <CALS6=qXZh5Oaav3ahvP9Sfg9eGyBFLGOisPve8mR5vDNz8JwWA@mail.gmail.com>
References: <CALS6=qXZh5Oaav3ahvP9Sfg9eGyBFLGOisPve8mR5vDNz8JwWA@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 31 Oct 2018 15:26:11 -0700
Message-ID: <CAGXu5jJjyVrXqsU9svsujG8t-DDccqp8vRTThnp8Nf37ztGG_w@mail.gmail.com>
Subject: Re: Empirically testing the effectiveness of kernel hardening patches
Content-Type: text/plain; charset="UTF-8"
To: Carter Cheng <cartercheng@gmail.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Oct 31, 2018 at 10:15 AM, Carter Cheng <cartercheng@gmail.com> wrote:
> Is there some sort of standard testbed for testing the effectivenss of a
> kernel hardening patch to see how effective it is against current malware?
> How does one go about this?

I haven't seen a specific framework like that, but there are fuzzers
(as mentioned in the other reply), and there is the lkdtm set of tests
(which try to exercise bug classes or elements of exploit techniques).

I'd note that testing old malware against new kernels isn't always
going to be very real-world meaningful, though. Most exploits are
designed to do the least amount of work to accomplish something, so
any break in the exploit chain will stop _that_ exploit, but it
doesn't mean there aren't other paths.

> I assume when it comes to hardening the kernel the main target is certain
> forms of privilege escalation. Is it possible to use Kali linux for this
> purpose?

The goal has been to kill classes of bugs (e.g. %n in format strings),
or exploit techniques (e.g. overwriting timer function arguments).
There's a bit of an overview about them here:
https://kernsec.org/wiki/index.php/Kernel_Self_Protection_Project/Work

-- 
Kees Cook
