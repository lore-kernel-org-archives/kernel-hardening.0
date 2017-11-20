Date: Mon, 20 Nov 2017 12:22:35 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20171120122235.ku6whdnpgatib6in@lakrids.cambridge.arm.com>
References: <20171026090942.7041-1-mark.rutland@arm.com>
 <20171026090942.7041-2-mark.rutland@arm.com>
 <20171116152818.GM9361@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171116152818.GM9361@arm.com>
Subject: [kernel-hardening] Re: [RFC PATCH 1/2] arm64: write __range_ok() in C
To: Will Deacon <will.deacon@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Catalin Marinas <catalin.marinas@arm.com>, Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Nov 16, 2017 at 03:28:19PM +0000, Will Deacon wrote:
> On Thu, Oct 26, 2017 at 10:09:41AM +0100, Mark Rutland wrote:
> > +static bool __range_ok_c(unsigned long addr, unsigned long size)
> > +{
> > +	unsigned long result;
> > +
> > +	if (__builtin_uaddl_overflow(addr, size, &result))
> 
> I'm not sure if you're planning to revisit this series, but thought I'd
> give you a heads up that apparently GCC 4.x doesn't have support for this
> builtin, so we'll need to carry the asm at least for that toolchain.

Thanks for the heads-up. I see my Linaro 14.09 GCC 4.9 generates an
out-of-line call to a __builtin_uaddl_overflow helper.

We can avoid the builtin, and write the test in C instead, e.g.

static inline bool __range_ok_c(unsigned long addr, unsigned long size)
{
        unsigned long end = addr + size;

        if (end < addr)
                return false;

        return end <= current_thread_info()->addr_limit;
}

... in my standalone test-case, that generates code that's almost
identical to the builtin, except that the compiler chooses to look at a
different flag.

Thanks,
Mark.
