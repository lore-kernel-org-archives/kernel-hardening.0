Date: Thu, 22 Feb 2018 16:58:34 +0000
From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 1/2] stackleak: Update for arm64
Message-ID: <20180222165834.GC18421@arm.com>
References: <20180221011303.20392-1-labbott@redhat.com>
 <20180221011303.20392-2-labbott@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180221011303.20392-2-labbott@redhat.com>
To: Laura Abbott <labbott@redhat.com>
Cc: Alexander Popov <alex.popov@linux.com>, Kees Cook <keescook@chromium.org>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, richard.sandiford@arm.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi Laura,

On Tue, Feb 20, 2018 at 05:13:02PM -0800, Laura Abbott wrote:
> 
> arm64 has another layer of indirection in the RTL.
> Account for this in the plugin.
> 
> Signed-off-by: Laura Abbott <labbott@redhat.com>
> ---
>  scripts/gcc-plugins/stackleak_plugin.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/scripts/gcc-plugins/stackleak_plugin.c b/scripts/gcc-plugins/stackleak_plugin.c
> index 6fc991c98d8b..7dfaa027423f 100644
> --- a/scripts/gcc-plugins/stackleak_plugin.c
> +++ b/scripts/gcc-plugins/stackleak_plugin.c
> @@ -244,6 +244,11 @@ static unsigned int stackleak_final_execute(void)
>  		 * that insn.
>  		 */
>  		body = PATTERN(insn);
> +		/* arm64 is different */
> +		if (GET_CODE(body) == PARALLEL) {
> +			body = XEXP(body, 0);
> +			body = XEXP(body, 0);
> +		}

Like most kernel developers, I don't know the first thing about GCC internals
so I asked our GCC team and Richard (CC'd) reckons this should be:

	if (GET_CODE(body) == PARALLEL)
		body = XVECEXP(body, 0, 0);

instead of the hunk above. Can you give that a go instead, please?

Cheers,

Will
