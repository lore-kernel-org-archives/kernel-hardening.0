Reply-To: kernel-hardening@lists.openwall.com
References: <20160626173451.c8406cd0c7a87cc3f94d9753@gmail.com>
From: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Date: Wed, 2 Nov 2016 16:06:26 +1100
MIME-Version: 1.0
In-Reply-To: <20160626173451.c8406cd0c7a87cc3f94d9753@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Message-Id: <70eb7a4c-be31-3fdd-a5b4-8075b29b3b38@au1.ibm.com>
Subject: Re: [kernel-hardening] [PATCH] powerpc/kernel: Disable the latent
 entropy plugin unconditionally
To: kernel-hardening@lists.openwall.com, keescook@chromium.org
Cc: mmarek@suse.com, linux-kbuild@vger.kernel.org, pageexec@freemail.hu, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, Michael Ellerman <mpe@ellerman.id.au>
List-ID: <kernel-hardening.lists.openwall.com>

On 27/06/16 01:34, Emese Revfy wrote:
>
> Reported-by: PaX Team <pageexec@freemail.hu>
> Signed-off-by: Emese Revfy <re.emese@gmail.com>
> ---
>  arch/powerpc/kernel/Makefile | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
> index 01935b8..e9ef44f 100644
> --- a/arch/powerpc/kernel/Makefile
> +++ b/arch/powerpc/kernel/Makefile
> @@ -14,11 +14,12 @@ CFLAGS_prom_init.o      += -fPIC
>  CFLAGS_btext.o         += -fPIC
>  endif
>
> -ifdef CONFIG_FUNCTION_TRACER
>  CFLAGS_cputable.o += $(DISABLE_LATENT_ENTROPY_PLUGIN)
>  CFLAGS_init.o += $(DISABLE_LATENT_ENTROPY_PLUGIN)

I think you meant prom_init.o...

Additionally, DISABLE_LATENT_ENTROPY_PLUGIN is conditioned on 
CONFIG_PAX_LATENT_ENTROPY rather than CONFIG_GCC_PLUGIN_LATENT_ENTROPY, 
so it doesn't get exported correctly.

Will submit fixes along with patches to enable plugins on powerpc once I 
get that sorted.

(In future please remember to cc linuxppc-dev.)

-- 
Andrew Donnellan              OzLabs, ADL Canberra
andrew.donnellan@au1.ibm.com  IBM Australia Limited
