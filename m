Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Sun, 12 Jun 2011 17:15:45 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110612131543.GB3994@albatros>
References: <20110612023118.GA15126@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110612023118.GA15126@openwall.com>
Subject: Re: [kernel-hardening] printk()s of user-supplied strings
To: kernel-hardening@lists.openwall.com
Cc: Willy Tarreau <w@1wt.eu>
List-ID: <kernel-hardening.lists.openwall.com>

Solar,

On Sun, Jun 12, 2011 at 06:31 +0400, Solar Designer wrote:
> You could want to review this thread:
> 
> http://lists.openwall.net/linux-kernel/2006/08/22/29
> 
> (click "thread-next" for further messages).
> 
> I don't know (or don't recall) what the outcome of it was, if any.

I don't see any log spoofing protection in the current code.


As a primary threat is \n and \n<X> spoofing, I think the more simple
and bloodless solution would be escaping \n by some string like ">>".  So,
the initial

printk(PR_ERR, "Suspicious string: %s\n",
 "something\n<1>[  2533.035243] TCP: possible syn-flood from google.com")

- would result in -

[  2533.111111] Suspicious string: something
>> <1>[  2533.035243] TCP: possible syn-flood from google.com

Also all non-printable characters should be escaped on their own (1-31,
possibly, 127-255).  \xYYY or similar?

This parsing should be done in "%s" substitution only and in printk()
substitutions only (there are many other users of vscnprintf() and
similar).


An escaping has one drawback - escaped \n looses information about the
log severity.  So, this prefixed ">> .." string will be printed as it
would has emergency log severities.  It is better than simple log
spoofing, though.

Fully filter "\n" is not a solution as, IIRC, there are legitimate users
of such a multiline feature in the kernel.

Thanks,

-- 
Vasiliy
