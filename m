Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 29 Sep 2016 15:44:52 -0700
From: Sami Tolvanen <samitolvanen@google.com>
Message-ID: <20160929224452.GA71670@samitolvanen.mtv.corp.google.com>
References: <1473788797-10879-1-git-send-email-catalin.marinas@arm.com>
 <20160915162044.GB19214@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160915162044.GB19214@leverpostej>
Subject: Re: [kernel-hardening] Re: [PATCH v3 0/7] arm64: Privileged Access
 Never using TTBR0_EL1 switching
To: kernel-hardening@lists.openwall.com
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-arm-kernel@lists.infradead.org, Kees Cook <keescook@chromium.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Will Deacon <will.deacon@arm.com>, AKASHI Takahiro <takahiro.akashi@linaro.org>, James Morse <james.morse@arm.com>, andre.przywara@arm.com, suzuki.poulose@arm.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Sep 15, 2016 at 05:20:45PM +0100, Mark Rutland wrote:
> Likewise, how do we handle __flush_cache_user_range and
> flush_icache_range? Some callers (e.g. __do_compat_cache_op) pass in
> __user addresses.

Also EXEC_USERSPACE in lkdtm passes a user space address to flush_icache_range
and causes the process to hang when I tested these patches on HiKey.

Adding uaccess_{enable,disable}_not_uao to __flush_cache_user_range appears to
fix the problem.

Sami
