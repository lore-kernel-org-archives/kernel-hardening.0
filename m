Reply-To: kernel-hardening@lists.openwall.com
Date: Sun, 12 Jun 2011 06:56:34 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110612025634.GA15266@openwall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] link & FIFO hardening
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Vasiliy, Kees -

Vasiliy - in your "overview of grsecurity and -ow patches":

http://www.openwall.com/lists/owl-dev/2011/04/23/1

you wrote:

> GRKERNSEC_LINK [+]
> GRKERNSEC_FIFO [+]
> GRKERNSEC_HARDEN_PTRACE [+]
> 
>     There is YAMA LSM for mainline, implementing these features.  It is not
>     yet applied, but Kees Cook does his best to push it.  For RHEL6/OpenVZ
>     YAMA should be OK (with Ubuntu's forcing scheme), with minor
>     synchorization changes.

What's the status on this (for mainline)?  I regard the link (both
symlink and hard link) and FIFO restrictions as a priority, compared to
some other things we'll be working on.  (In general, I want us to have a
full set of whatever was in 2.4.x-ow merged sooner rather than later.)

Thanks,

Alexander
