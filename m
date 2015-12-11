Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 11 Dec 2015 17:21:40 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
Message-ID: <20151211172140.GQ26759@e104818-lin.cambridge.arm.com>
References: <1443018250-22893-1-git-send-email-catalin.marinas@arm.com>
 <CAGXu5jJYoCxATf8tWAhdosNH9jKovpcYQ=PqD85gHnT+oBF3CQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jJYoCxATf8tWAhdosNH9jKovpcYQ=PqD85gHnT+oBF3CQ@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH 0/4] arm: Privileged no-access for LPAE
To: Kees Cook <keescook@chromium.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Dec 10, 2015 at 11:40:44AM -0800, Kees Cook wrote:
> [thread necromancy]
> 
> This series looks good to me. I'd love to see it accepted. At the very
> least the cleanups look like no-brainers. :)
> 
> Please consider the series:
> 
> Reviewed-by: Kees Cook <keescook@chromium.org>
> 
> Thanks for working on it!

Thanks for the review. After some more (internal) discussions around
these patches, I need to get clarification on the architecture whether
changing the TTBCR.A1 bit is enough to guarantee an ASID change (I do
this trick to change to the reserved ASID and avoid TLB invalidation as
normally required by changes to translation control registers). If
that's not allowed by the architecture, I would have to change the
patches to switch to a reserved TTBR0 rather than disabling TTBR0 walks
at the TTBCR level.

-- 
Catalin
