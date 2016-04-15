Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 15 Apr 2016 09:58:55 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
Message-ID: <20160415085854.GJ15182@e104818-lin.cambridge.arm.com>
References: <CAGXu5jJ+++wTLk3zV8M6D-aPDnbejw9qOXcznqLRUySsYDiiaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jJ+++wTLk3zV8M6D-aPDnbejw9qOXcznqLRUySsYDiiaQ@mail.gmail.com>
Subject: [kernel-hardening] Re: ARMv8.0 PAN emulation
To: Kees Cook <keescook@google.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Kees,

On Wed, Apr 13, 2016 at 08:34:31AM -0700, Kees Cook wrote:
> I was curious about where PAN emulation for ARMv8.0 stood?

I guess the question is with regards to the arm64 kernel port.

> You'd mentioned[1] that it might be possible to rework the TTBR0 patch
> to do what's needed. Is there anyone that has cycles to work on it?

Unfortunately, not. I can put it on our to-do list but the backlog is
pretty large already, so I can't realistically state an ETA.

> Also, did you ever get an answer about the lowmem boundary?

No but I looked through the arm32 kernel and couldn't find any
guarantees. IIRC, we used to have such assumption in the past until we
got the TI Keystone platform with RAM being relocated above 4GB (after
the initial boot code).

-- 
Catalin
