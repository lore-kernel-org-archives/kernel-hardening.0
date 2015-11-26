Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1448535824.19858.42.camel@opteya.com>
From: Yann Droneaud <ydroneaud@opteya.com>
Date: Thu, 26 Nov 2015 12:03:44 +0100
In-Reply-To: <CAJpd-bFvTNQK=qGCPdnB1ec=yJ+jZuzaoR9pNbn01pgim=0aLg@mail.gmail.com>
References: 
	<CAJpd-bFvTNQK=qGCPdnB1ec=yJ+jZuzaoR9pNbn01pgim=0aLg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [kernel-hardening] On techniques for preventing commit_creds()
 user-space abuse
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

Le jeudi 26 novembre 2015 à 00:14 +0100, Salva Peiró a écrit :
> A complete version of the technique can be found at
> http://speirofr.appspot.com/category/techniques/
> 
> # Analysis
> 
> Given the typical path for kernel exploitation is the
> `commit_creds(prepare_kernel_cred(0))` being called from user space
> as detailed in [References].
> Why is not a check placed in commit_creds() that checks the return
> address of the call to ensure the call is a legit one coming from
> kernel space?.
> 
> This blocks direct calls to commit_creds from user space,
> however, it remains vulnerable to alternative exploit routes.
> The alternatives to bypass this protection are:
> 
> - *Indirect jump*
> An attacker can perform an indirect jump to a kernel location that
> does the commit_creds() for him, but it complicates the task of the
> attacker. To prevent indirect calls check the rest of the stack
> trace.
> 
> - *Direct override*
> Another route to bypass would be to figure out the location of the
> process creds in memory, and perform the change directly in memory,
> but AFAIK SMAP and its ARM equivalent would deter this route.
> 
> Therefore, I started implementing some exploits for testing it,
> and implemented the `commit_cred` protection checks technique to
> check if it is viable for preventing the commit_creds abuse.
> 
> The [Implementation] provides a patch that implements the discussed
> approach.
> The [Evaluation] provides the tests performed showing it effectively
> blocks commit_creds abuse from user space.
> 
> # Threat Model
> 
> The steps involved in commit_creds() exploits:
> 
> - Prepare user code to get root:
>     user_addr = commit_creds(prepare_creds(0))
> 
> - Override kernel code with:
>     kernel_struct.fptr = user_addr  (1st vuln point SMAP)
> 
> - Trigger a syscall that calls kernel_struct.fptr
>     - Invoke syscall from user
>     - Results in kernel_struct.fptr() being called
>         Calls user-space code from kernel code 
>             (2nd vuln point this point we're already toasted SMEP)
>         Then call commit_creds (kernel_code) from user
>             At this point the can detect commit_creds called from
>             user
>            (3rd vuln: fix check return address)
> 
> # Implementation
> 
> The patch implementing the commit_creds() abuse prevention:
> 
> From: Salva Peiró <speirofr AT gmail.com>
> Date: Wed, 25 Nov 2015 14:03:50 +0100
> Subject: [PATCH] cred: Prevent commit_creds() user-space abuse
> 


Please add some explanation in your commit message.

> Signed-off-by: Salva Peiró <speirofr AT gmail.com>
> 
> ---
>  kernel/cred.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/kernel/cred.c b/kernel/cred.c
> index 71179a0..7191db3 100644
> --- a/kernel/cred.c
> +++ b/kernel/cred.c
> @@ -428,6 +428,13 @@ int commit_creds(struct cred *new)
>  	       atomic_read(&new->usage),
>  	       read_cred_subscribers(new));
> 
> +	/* block attempts to use commit_creds from user space */
> +	if (__builtin_return_address(0) < PAGE_OFFSET) {
> +		printk(KERN_ERR "CRED: BUG commit_creds called from
> user space\n");
> +		WARN_ON(1);
> +		return -1;
> +	}
> +
> 

What about

#define call_ok() !access_ok(__builtin_return_address(0), VERIFY_READ)


	if (WARN(!call_ok(),
		 "%s called from user space\n", __function__))
		return -1;

If __builtin_return_address() is reliable enough, that trick can be
easily added on many sensitive functions.

If such kind of prologue can be injected by compiler in functions
marked with a dedicated attribute, I think that could be a nice thing
to have before PAX's UDEREF and KERNEXEC are made available, as the
latter should better

Regards.

-- 
Yann Droneaud
OPTEYA
