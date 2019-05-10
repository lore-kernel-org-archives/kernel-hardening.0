Date: Fri, 10 May 2019 13:23:24 -0700
From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] gcc-plugins: arm_ssp_per_task_plugin: Fix for older GCC
 < 6
Message-ID: <201905101322.BEDE5CC@keescook>
References: <20190510090025.4680-1-chris.packham@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190510090025.4680-1-chris.packham@alliedtelesis.co.nz>
To: Chris Packham <chris.packham@alliedtelesis.co.nz>
Cc: re.emese@gmail.com, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, May 10, 2019 at 09:00:25PM +1200, Chris Packham wrote:
> Use gen_rtx_set instead of gen_rtx_SET. The former is a wrapper macro
> that handles the difference between GCC versions implementing
> the latter.
> 
> This fixes the following error on my system with g++ 5.4.0 as the host
> compiler
> 
>    HOSTCXX -fPIC scripts/gcc-plugins/arm_ssp_per_task_plugin.o
>  scripts/gcc-plugins/arm_ssp_per_task_plugin.c:42:14: error: macro "gen_rtx_SET" requires 3 arguments, but only 2 given
>           mask)),
>                ^
>  scripts/gcc-plugins/arm_ssp_per_task_plugin.c: In function ‘unsigned int arm_pertask_ssp_rtl_execute()’:
>  scripts/gcc-plugins/arm_ssp_per_task_plugin.c:39:20: error: ‘gen_rtx_SET’ was not declared in this scope
>     emit_insn_before(gen_rtx_SET
> 
> Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>

Thanks for this! It seems correct to me. Ard, any thoughts? I can send
it to Linus next week...

Fixes: 189af4657186 ("ARM: smp: add support for per-task stack canaries")
Cc: stable@vger.kernel.org

-Kees

> ---
>  scripts/gcc-plugins/arm_ssp_per_task_plugin.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/scripts/gcc-plugins/arm_ssp_per_task_plugin.c b/scripts/gcc-plugins/arm_ssp_per_task_plugin.c
> index 89c47f57d1ce..8c1af9bdcb1b 100644
> --- a/scripts/gcc-plugins/arm_ssp_per_task_plugin.c
> +++ b/scripts/gcc-plugins/arm_ssp_per_task_plugin.c
> @@ -36,7 +36,7 @@ static unsigned int arm_pertask_ssp_rtl_execute(void)
>  		mask = GEN_INT(sext_hwi(sp_mask, GET_MODE_PRECISION(Pmode)));
>  		masked_sp = gen_reg_rtx(Pmode);
>  
> -		emit_insn_before(gen_rtx_SET(masked_sp,
> +		emit_insn_before(gen_rtx_set(masked_sp,
>  					     gen_rtx_AND(Pmode,
>  							 stack_pointer_rtx,
>  							 mask)),
> -- 
> 2.21.0
> 

-- 
Kees Cook
