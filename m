Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAEB-d-7X5mGo+vuF+PO24k795wPNNHES0c9QXcPntXpObUZ4TQ@mail.gmail.com>
References: <CAEB-d-7X5mGo+vuF+PO24k795wPNNHES0c9QXcPntXpObUZ4TQ@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 3 Jan 2017 14:38:00 -0800
Message-ID: <CAGXu5j+bY=xtX_1v=_vj-rGsed5OsaR-6B15w=tmsor0HS1o+A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Security issues on ARM processor
To: amitsagar gowda <amitsagargowda@gmail.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Dec 29, 2016 at 2:22 AM, amitsagar gowda
<amitsagargowda@gmail.com> wrote:
> Hi All,
>       I'm interested to contribute to Linux Kernel Self Protection Project i
> have 12+ year of ARM Linux Kernel development  and hence would like to help
> in fixing some security issues on ARM processors. Could you please me find
> some topics where i could help in this lines.

Hi! Welcome to the fun!

As a small starter project, how about implementing
arch_within_stack_frames() (and then selecting
HAVE_ARCH_WITHIN_STACK_FRAMES in the arm Kconfig). Testing the result
should be possible with lkdtm's
USERCOPY_STACK_FRAME_FROM target.

Let us know if you need more details!

-Kees

-- 
Kees Cook
Nexus Security
