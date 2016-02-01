Reply-To: kernel-hardening@lists.openwall.com
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
References: <1453622354-50686-1-git-send-email-sbauer@eng.utah.edu>
	<1453622354-50686-2-git-send-email-sbauer@eng.utah.edu>
Date: Mon, 01 Feb 2016 23:42:01 +0100
In-Reply-To: <1453622354-50686-2-git-send-email-sbauer@eng.utah.edu> (Scott
	Bauer's message of "Sun, 24 Jan 2016 00:59:13 -0700")
Message-ID: <87twlsaw92.fsf@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain
Subject: [kernel-hardening] Re: [RFC PATCH 1/2] SROP Mitigation: Architecture independent code for signal cookies
To: kernel-hardening@lists.openwall.com
Cc: abhiram@cs.utah.edu, Scott Bauer <sbauer@eng.utah.edu>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Jan 24 2016, Scott Bauer <sbauer@eng.utah.edu> wrote:

> This patch adds a per-process secret to the task struct which
> will be used during signal delivery and during a sigreturn.
> Also, logic is added in signal.c to generate, place, extract,
> clear and verify the signal cookie.
>
>  
> +static unsigned long gen_sigcookie(unsigned long __user *location)
> +{
> +
> +	unsigned long sig_cookie;
> +
> +	sig_cookie = (unsigned long) location ^ current->sig_cookie;
> +
> +	sig_cookie = hash_long(sig_cookie, sizeof(sig_cookie) * BITS_PER_BYTE);
> +
> +	return sig_cookie;
> +}

Is current->sig_cookie supposed to be secret, as in unknown to
userspace? If so, this won't work, as hash_long (with BIT_PER_LONG as
nbits parameter) is invertible (since we've just multiplied by an odd
number and right-shifted by 0). Maybe xoring with some global secret
afterwards would fix this, though I'm not sure.

Rasmus
