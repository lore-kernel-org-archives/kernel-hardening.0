Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CA+xQMzy45NoLqy8XyArT4ZTN1q21zRnjj9VLHz5awmG61eU_9A@mail.gmail.com>
References: <CA+xQMzy45NoLqy8XyArT4ZTN1q21zRnjj9VLHz5awmG61eU_9A@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 7 Dec 2016 13:09:09 -0800
Message-ID: <CAGXu5jK3FqVi+kwD57k1eMYjFniYdFeh6_=D=2HfVx9TWnqSbw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Regarding PaX
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Dec 6, 2016 at 11:46 PM, manjunatha srinivasan
<manjunathan.n@gmail.com> wrote:
> Hi

Hi!

>
> I am new to PaX.
>
> I have plan to port only PaX (i.e mutual exclusive write/execute
> pages) for latest kernel (kernel.org) for x86_64 architectures. From
> other place I found patch from
> (https://git.m-privacy.de/linux-mprivacy-4.1.git) from branch
> 'paxonly' for  4.1  kernel. From the commit ID
> 9474667100c85c944a0d71ede82ef85e3ab502dc (123248 lines).
> In other place from https://grsecurity.net/download.php, I can see the
>  patch 'grsecurity-3.1-4.8.12-201612062306.patch' .
>
> I don't' know where to start from these places. Please let me know
> about information on internals i.e. about code implementation and
> related documents of PaX ( i.e. mutual exclusive write/execute
> pages.).

PaX collects a lot of features. It sounds like you're interested only
in the W^X mmap/mprotect/etc feature?

> Also if want to do of porting PaX (i.e mutual exclusive write/execute
> pages) from scratch where can I find internals of it. Is that
> information from https://pax.grsecurity.net/ is enough idea for kick
> start.
> Please let me know the prerequisite knowledge on Linux subsystem like
> memory management before starting.

I would generally recommend reading the code to understand what's
happening. Other folks on the list may have better pointers for where
to learn about Linux mm, but it's a pretty complex area of the kernel.

For the first step, I'd recommend writing tests that currently fail
against the upstream kernel, then extract the pieces from PaX that
cover the feature you're interested in, and make sure your tests then
pass. From there, cutting up the patches into logically distinct
pieces would be next, which would be followed by upstream review (and
likely a few rounds of adjustments to the patches), and hopefully
finally getting them accept.

> Please let me know any openwall  git repository is  available.

Openwall just hosts this mailing list.

> If you feel this not the correct place of asking, please advice where
> should I post.

This is the right place to discuss development and porting of security
features for the upstream Linux kernel.

Thanks for the interest!

-Kees

-- 
Kees Cook
Nexus Security
