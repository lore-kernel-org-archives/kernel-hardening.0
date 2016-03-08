Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 8 Mar 2016 21:03:33 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Message-ID: <20160308210333.7ad77a29@lxorguk.ukuu.org.uk>
In-Reply-To: <1457470075-4586-2-git-send-email-sbauer@eng.utah.edu>
References: <1457470075-4586-1-git-send-email-sbauer@eng.utah.edu>
	<1457470075-4586-2-git-send-email-sbauer@eng.utah.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v3 2/3] x86: SROP mitigation: implement signal cookies
To: Scott Bauer <sbauer@eng.utah.edu>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, x86@kernel.org, wmealing@redhat.com, ak@linux.intel.com, luto@amacapital.net, Abhiram Balasubramanian <abhiram@cs.utah.edu>
List-ID: <kernel-hardening.lists.openwall.com>

>  static int ia32_restore_sigcontext(struct pt_regs *regs,
> -				   struct sigcontext_32 __user *sc)
> +				   struct sigcontext_32 __user *sc,
> +				   void __user **user_cookie)
>  {
>  	unsigned int tmpflags, err = 0;
>  	void __user *buf;
> @@ -105,6 +106,16 @@ static int ia32_restore_sigcontext(struct pt_regs *regs,
>  		buf = compat_ptr(tmp);
>  	} get_user_catch(err);
>  
> +	/*
> +	 * If there is fp state get cookie from the top of the fp state,
> +	 * else get it from the top of the sig frame.
> +	 */
> +
> +	if (tmp != 0)
> +		*user_cookie = compat_ptr(tmp + fpu__getsize(1));
> +	else
> +		*user_cookie = NULL;

user_cookie is is __user, so shouldn't just be poking at it without
get/put_user ? It might fault if someone has engineered a bad stack frame.

Alan
