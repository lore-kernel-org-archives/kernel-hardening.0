Message-ID: <1494439172.1255.1.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Wed, 10 May 2017 13:59:32 -0400
In-Reply-To: <20170510175238.GH32165@htj.duckdns.org>
References: <20170510173637.25116-1-danielmicay@gmail.com>
	 <20170510175238.GH32165@htj.duckdns.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH] mark most percpu globals as __ro_after_init
To: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 2017-05-10 at 13:52 -0400, Tejun Heo wrote:
> Hello, Daniel.
> 
> On Wed, May 10, 2017 at 01:36:37PM -0400, Daniel Micay wrote:
> > Moving pcpu_base_addr to this section comes from PaX where it's part
> > of
> > KERNEXEC. This extends it to the rest of the globals only written by
> > the
> > init code.
> 
> How did you test the patch?

Booted / did some stuff on x86 (it's running right now), and currently
building it for a 3.18 arm64 kernel to test there.

> 
> > -static struct list_head *pcpu_slot __read_mostly; /* chunk list
> > slots */
> > +static struct list_head *pcpu_slot __ro_after_init; /* chunk list
> > slots */
> 
> At least this one isn't read only.

It's the array it points to being modified after it gets assigned to
during init with pcpu_slot = memblock_virt_alloc(...), not the pointer
variable itself. The references after init are all pcpu_slot[...]
including taking references to slots in the array so there's always a
dereference happening first.
