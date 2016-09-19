Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 19 Sep 2016 08:45:09 -0700
From: Guenter Roeck <linux@roeck-us.net>
Message-ID: <20160919154509.GA24003@roeck-us.net>
References: <20160916203819.GA29767@roeck-us.net>
 <20160916212720.GA18931@jhogan-linux.le.imgtec.org>
 <20160916213718.GA32384@roeck-us.net>
 <20160916233249.GB18931@jhogan-linux.le.imgtec.org>
 <20160919145529.GK18931@jhogan-linux.le.imgtec.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160919145529.GK18931@jhogan-linux.le.imgtec.org>
Subject: [kernel-hardening] Re: qemu:metag image runtime failure in -next due to 'kthread: allow
 to cancel kthread work'
To: James Hogan <james.hogan@imgtec.com>
Cc: Petr Mladek <pmladek@suse.com>, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, linux-metag@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Sep 19, 2016 at 03:55:29PM +0100, James Hogan wrote:
> On Sat, Sep 17, 2016 at 12:32:49AM +0100, James Hogan wrote:
> > Here this version of QEMU puts the args at where it thinks the end of
> > the loaded image is, which is based on the number of bytes copied from
> > the ELF, i.e. the total MemSiz's, not taking into account the alignment
> > gap in between, so it puts them at 0x40377348.
> 
> QEMU meta-v1.3.1 branch updated at:
> https://github.com/img-meta/qemu.git
> 
> Hopefully that'll fix it for you Guenter.
> 
Confirmed fixed.

Thanks a lot!
Guenter
