Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20160929224452.GA71670@samitolvanen.mtv.corp.google.com>
References: <1473788797-10879-1-git-send-email-catalin.marinas@arm.com>
 <20160915162044.GB19214@leverpostej> <20160929224452.GA71670@samitolvanen.mtv.corp.google.com>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 30 Sep 2016 11:42:02 -0700
Message-ID: <CAGXu5jKEpZgc9zqmX=QKs_NH70fX_4CRNEtFKXEETK6UwykNMw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Re: [PATCH v3 0/7] arm64: Privileged Access
 Never using TTBR0_EL1 switching
To: Sami Tolvanen <samitolvanen@google.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Catalin Marinas <catalin.marinas@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Will Deacon <will.deacon@arm.com>, AKASHI Takahiro <takahiro.akashi@linaro.org>, James Morse <james.morse@arm.com>, andre.przywara@arm.com, "Suzuki K. Poulose" <suzuki.poulose@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Sep 29, 2016 at 3:44 PM, Sami Tolvanen <samitolvanen@google.com> wrote:
> On Thu, Sep 15, 2016 at 05:20:45PM +0100, Mark Rutland wrote:
>> Likewise, how do we handle __flush_cache_user_range and
>> flush_icache_range? Some callers (e.g. __do_compat_cache_op) pass in
>> __user addresses.
>
> Also EXEC_USERSPACE in lkdtm passes a user space address to flush_icache_range
> and causes the process to hang when I tested these patches on HiKey.
>
> Adding uaccess_{enable,disable}_not_uao to __flush_cache_user_range appears to
> fix the problem.

I had a thought just now on this: is lkdtm maybe doing the wrong thing
here? i.e. should lkdtm be the one do to the uaccess_en/disable
instead of flush_icache_range() itself, since it's the one abusing the
API?

-Kees

-- 
Kees Cook
Nexus Security
