Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 17 Oct 2016 12:02:30 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20161017110229.GC29095@leverpostej>
References: <1476311522-15381-1-git-send-email-labbott@redhat.com>
 <1476311522-15381-3-git-send-email-labbott@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1476311522-15381-3-git-send-email-labbott@redhat.com>
Subject: [kernel-hardening] Re: [PATCHv2 2/4] arm64: dump: Make the page table dumping seq_file
 optional
To: Laura Abbott <labbott@redhat.com>
Cc: AKASHI Takahiro <takahiro.akashi@linaro.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, David Brown <david.brown@linaro.org>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Oct 12, 2016 at 03:32:00PM -0700, Laura Abbott wrote:
> 
> The page table dumping code always assumes it will be dumping to a
> seq_file to userspace. Future code will be taking advantage of
> the page table dumping code but will not need the seq_file. Make
> the seq_file optional for these cases.
> 
> Acked-by: Mark Rutland <mark.rutland@arm.com>

Now that I'm back in the office with access to hardware, I've been able
to give this a spin. FWIW, feel free to upgrade the above to:

Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Tested-by: Mark Rutland <mark.rutland@arm.com>

Thanks,
Mark.
