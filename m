Subject: Re: [PATCH 1/4] powerpc: Track KUAP state in the PACA
References: <20181122140416.3447-1-ruscur@russell.cc>
 <20181122140416.3447-2-ruscur@russell.cc>
From: Christophe Leroy <christophe.leroy@c-s.fr>
Message-ID: <48c49b69-0cef-d3dd-a883-c07fe5ef7be0@c-s.fr>
Date: Wed, 28 Nov 2018 09:38:08 +0000
MIME-Version: 1.0
In-Reply-To: <20181122140416.3447-2-ruscur@russell.cc>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
To: Russell Currey <ruscur@russell.cc>, linuxppc-dev@lists.ozlabs.org
Cc: mpe@ellerman.id.au, benh@kernel.crashing.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 11/22/2018 02:04 PM, Russell Currey wrote:
> Necessary for subsequent patches that enable KUAP support for radix.
> Could plausibly be useful for other platforms too, if similar to the
> radix case, reading the register that manages these accesses is
> costly.
> 
> Has the unfortunate downside of another layer of abstraction for
> platforms that implement the locks and unlocks, but this could be
> useful in future for other things too, like counters for benchmarking
> or smartly handling lots of small accesses at once.
> 
> Signed-off-by: Russell Currey <ruscur@russell.cc>

Build failure.

[root@po14163vm linux-powerpc]# make mpc885_ads_defconfig
#
# configuration written to .config
#
[root@po14163vm linux-powerpc]# make
scripts/kconfig/conf  --syncconfig Kconfig
   UPD     include/config/kernel.release
   UPD     include/generated/utsrelease.h
   CC      kernel/bounds.s
   CC      arch/powerpc/kernel/asm-offsets.s
In file included from ./include/linux/uaccess.h:14:0,
                  from ./include/linux/compat.h:19,
                  from arch/powerpc/kernel/asm-offsets.c:16:
./arch/powerpc/include/asm/uaccess.h: In function ‘unlock_user_rd_access’:
./arch/powerpc/include/asm/uaccess.h:70:2: error: implicit declaration 
of function ‘get_paca’ [-Werror=implicit-function-declaration]
   get_paca()->user_access_allowed = 1;
   ^
./arch/powerpc/include/asm/uaccess.h:70:12: error: invalid type argument 
of ‘->’ (have ‘int’)
   get_paca()->user_access_allowed = 1;
             ^
./arch/powerpc/include/asm/uaccess.h: In function ‘lock_user_rd_access’:
./arch/powerpc/include/asm/uaccess.h:75:12: error: invalid type argument 
of ‘->’ (have ‘int’)
   get_paca()->user_access_allowed = 0;
             ^
./arch/powerpc/include/asm/uaccess.h: In function ‘unlock_user_wr_access’:
./arch/powerpc/include/asm/uaccess.h:80:12: error: invalid type argument 
of ‘->’ (have ‘int’)
   get_paca()->user_access_allowed = 1;
             ^
./arch/powerpc/include/asm/uaccess.h: In function ‘lock_user_wr_access’:
./arch/powerpc/include/asm/uaccess.h:85:12: error: invalid type argument 
of ‘->’ (have ‘int’)
   get_paca()->user_access_allowed = 0;
             ^
cc1: some warnings being treated as errors
make[1]: *** [arch/powerpc/kernel/asm-offsets.s] Error 1
make: *** [prepare0] Error 2

Christophe

> ---
> this is all because I can't do PACA things from radix.h and I spent
> an hour figuring this out at midnight
> ---
>   arch/powerpc/include/asm/nohash/32/pte-8xx.h |  8 +++----
>   arch/powerpc/include/asm/paca.h              |  3 +++
>   arch/powerpc/include/asm/uaccess.h           | 23 +++++++++++++++++++-
>   arch/powerpc/kernel/asm-offsets.c            |  1 +
>   4 files changed, 30 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/powerpc/include/asm/nohash/32/pte-8xx.h b/arch/powerpc/include/asm/nohash/32/pte-8xx.h
> index f1ec7cf949d5..7bc0955a56e9 100644
> --- a/arch/powerpc/include/asm/nohash/32/pte-8xx.h
> +++ b/arch/powerpc/include/asm/nohash/32/pte-8xx.h
> @@ -137,22 +137,22 @@ static inline pte_t pte_mkhuge(pte_t pte)
>   #define pte_mkhuge pte_mkhuge
>   
>   #ifdef CONFIG_PPC_KUAP
> -static inline void lock_user_wr_access(void)
> +static inline void __lock_user_wr_access(void)
>   {
>   	mtspr(SPRN_MD_AP, MD_APG_KUAP);
>   }
>   
> -static inline void unlock_user_wr_access(void)
> +static inline void __unlock_user_wr_access(void)
>   {
>   	mtspr(SPRN_MD_AP, MD_APG_INIT);
>   }
>   
> -static inline void lock_user_rd_access(void)
> +static inline void __lock_user_rd_access(void)
>   {
>   	mtspr(SPRN_MD_AP, MD_APG_KUAP);
>   }
>   
> -static inline void unlock_user_rd_access(void)
> +static inline void __unlock_user_rd_access(void)
>   {
>   	mtspr(SPRN_MD_AP, MD_APG_INIT);
>   }
> diff --git a/arch/powerpc/include/asm/paca.h b/arch/powerpc/include/asm/paca.h
> index e843bc5d1a0f..56236f6d8c89 100644
> --- a/arch/powerpc/include/asm/paca.h
> +++ b/arch/powerpc/include/asm/paca.h
> @@ -169,6 +169,9 @@ struct paca_struct {
>   	u64 saved_r1;			/* r1 save for RTAS calls or PM or EE=0 */
>   	u64 saved_msr;			/* MSR saved here by enter_rtas */
>   	u16 trap_save;			/* Used when bad stack is encountered */
> +#ifdef CONFIG_PPC_KUAP
> +	u8 user_access_allowed;		/* can the kernel access user memory? */
> +#endif
>   	u8 irq_soft_mask;		/* mask for irq soft masking */
>   	u8 irq_happened;		/* irq happened while soft-disabled */
>   	u8 io_sync;			/* writel() needs spin_unlock sync */
> diff --git a/arch/powerpc/include/asm/uaccess.h b/arch/powerpc/include/asm/uaccess.h
> index 2f3625cbfcee..76dae1095f7e 100644
> --- a/arch/powerpc/include/asm/uaccess.h
> +++ b/arch/powerpc/include/asm/uaccess.h
> @@ -63,7 +63,28 @@ static inline int __access_ok(unsigned long addr, unsigned long size,
>   
>   #endif
>   
> -#ifndef CONFIG_PPC_KUAP
> +#ifdef CONFIG_PPC_KUAP
> +static inline void unlock_user_rd_access(void)
> +{
> +	__unlock_user_rd_access();
> +	get_paca()->user_access_allowed = 1;
> +}
> +static inline void lock_user_rd_access(void)
> +{
> +	__lock_user_rd_access();
> +	get_paca()->user_access_allowed = 0;
> +}
> +static inline void unlock_user_wr_access(void)
> +{
> +	__unlock_user_wr_access();
> +	get_paca()->user_access_allowed = 1;
> +}
> +static inline void lock_user_wr_access(void)
> +{
> +	__lock_user_wr_access();
> +	get_paca()->user_access_allowed = 0;
> +}
> +#else
>   static inline void unlock_user_rd_access(void) { }
>   static inline void lock_user_rd_access(void) { }
>   static inline void unlock_user_wr_access(void) { }
> diff --git a/arch/powerpc/kernel/asm-offsets.c b/arch/powerpc/kernel/asm-offsets.c
> index da2f5d011ddb..899e9835b45f 100644
> --- a/arch/powerpc/kernel/asm-offsets.c
> +++ b/arch/powerpc/kernel/asm-offsets.c
> @@ -260,6 +260,7 @@ int main(void)
>   	OFFSET(ACCOUNT_STARTTIME_USER, paca_struct, accounting.starttime_user);
>   	OFFSET(ACCOUNT_USER_TIME, paca_struct, accounting.utime);
>   	OFFSET(ACCOUNT_SYSTEM_TIME, paca_struct, accounting.stime);
> +	OFFSET(PACA_USER_ACCESS_ALLOWED, paca_struct, user_access_allowed);
>   	OFFSET(PACA_TRAP_SAVE, paca_struct, trap_save);
>   	OFFSET(PACA_NAPSTATELOST, paca_struct, nap_state_lost);
>   	OFFSET(PACA_SPRG_VDSO, paca_struct, sprg_vdso);
> 
