MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170329190008.GE7909@n2100.armlinux.org.uk>
References: <1490811363-93944-1-git-send-email-keescook@chromium.org> <20170329190008.GE7909@n2100.armlinux.org.uk>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 29 Mar 2017 12:14:45 -0700
Message-ID: <CAGXu5j+v2kc60x9q2nmeygrxmLCrqoCEh5Tx7U8NyZo7E2BeYA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [RFC v2] Introduce rare_write() infrastructure
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Mark Rutland <mark.rutland@arm.com>, Andy Lutomirski <luto@kernel.org>, Hoeun Ryu <hoeun.ryu@gmail.com>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, "x86@kernel.org" <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Mar 29, 2017 at 12:00 PM, Russell King - ARM Linux
<linux@armlinux.org.uk> wrote:
> On Wed, Mar 29, 2017 at 11:15:52AM -0700, Kees Cook wrote:
>> This is take 2 of an RFC series to demonstrate a possible infrastructure
>> for the "write rarely" memory storage type in the kernel (patch 1). The
>> intent is to further reduce the internal attack surface of the kernel
>> by making more variables read-only while "at rest". This is heavily
>> based on the "__read_only" portion of the KERNEXEC infrastructure from
>> PaX/grsecurity, though I tried to adjust it to be more in line with
>> the upstream discussions around the APIs.
>
> How much data are we talking about here?

The goal is to put as much sensitive stuff from .data as possible into
.rodata, which is mostly structures with function pointers, etc. I
haven't measured the "final" results, since there's still a lot of
work to do to get all the other annotations into upstream.

>> As part of the series I've included both x86 support (patch 4), exactly
>> as done in PaX, and ARM support (patches 5-7), similar to what is done in
>> grsecurity but without support for earlier ARM CPUs. Both are lightly
>> tested by me, though they need a bit more work, especially ARM as it is
>> missing the correct domain marking for kernel modules.
>
> The implementation as it stands on ARM is going to gobble up
> multiples of 1MB of RAM as you need it to be section aligned due to
> using domains, so if we're talking about a small amount of data,
> this is very inefficient.  That also only works for non-LPAE as LPAE
> is unable to use that method.

AIUI, we're just flipping toe domain from DOMAIN_KERNEL to
DOMAIN_WR_RARE on the .rodata section (which is already 1MB aligned),
and (in the future if I or someone else can figure out how) on the
kernel module vmap area (which also shouldn't be changing alignment at
all).

-Kees

-- 
Kees Cook
Pixel Security
