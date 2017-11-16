Date: Thu, 16 Nov 2017 15:28:19 +0000
From: Will Deacon <will.deacon@arm.com>
Message-ID: <20171116152818.GM9361@arm.com>
References: <20171026090942.7041-1-mark.rutland@arm.com>
 <20171026090942.7041-2-mark.rutland@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171026090942.7041-2-mark.rutland@arm.com>
Subject: [kernel-hardening] Re: [RFC PATCH 1/2] arm64: write __range_ok() in C
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Catalin Marinas <catalin.marinas@arm.com>, Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Oct 26, 2017 at 10:09:41AM +0100, Mark Rutland wrote:
> Currently arm64's __range_ok() is written in assembly for efficiency.
> 
> This hides the logic from the compiler, preventing the compiler from
> making some optimizations, such as re-ordering instructions or folding
> multiple calls to __range_ok().
> 
> This patch uses GCC's __builtin_uaddl_overflow() to provide an
> equivalent, efficient check, while giving the compiler the visibility it
> needs to optimize the check. In testing with v4.14-rc5 using the Linaro
> 17.05 GCC 6.3.1 toolchain, this has no impact on the kernel Image size,
> (but results in a smaller vmlinux).
> 
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Laura Abbott <labbott@redhat.com>
> Cc: Will Deacon <will.deacon@arm.com>
> ---
>  arch/arm64/include/asm/uaccess.h | 19 +++++++++++--------
>  1 file changed, 11 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/uaccess.h b/arch/arm64/include/asm/uaccess.h
> index fc0f9eb66039..36f84ec92b9d 100644
> --- a/arch/arm64/include/asm/uaccess.h
> +++ b/arch/arm64/include/asm/uaccess.h
> @@ -70,17 +70,20 @@ static inline void set_fs(mm_segment_t fs)
>   *
>   * This needs 65-bit arithmetic.
>   */
> +static bool __range_ok_c(unsigned long addr, unsigned long size)
> +{
> +	unsigned long result;
> +
> +	if (__builtin_uaddl_overflow(addr, size, &result))

I'm not sure if you're planning to revisit this series, but thought I'd
give you a heads up that apparently GCC 4.x doesn't have support for this
builtin, so we'll need to carry the asm at least for that toolchain.

Will
