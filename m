Sender: Tejun Heo <htejun@gmail.com>
Date: Wed, 10 May 2017 15:20:35 -0400
From: Tejun Heo <tj@kernel.org>
Message-ID: <20170510192035.GI32165@htj.duckdns.org>
References: <20170510173637.25116-1-danielmicay@gmail.com>
 <20170510175238.GH32165@htj.duckdns.org>
 <1494439172.1255.1.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1494439172.1255.1.camel@gmail.com>
Subject: [kernel-hardening] Re: [PATCH] mark most percpu globals as __ro_after_init
To: Daniel Micay <danielmicay@gmail.com>
Cc: Christoph Lameter <cl@linux.com>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, May 10, 2017 at 01:59:32PM -0400, Daniel Micay wrote:
> On Wed, 2017-05-10 at 13:52 -0400, Tejun Heo wrote:
> > Hello, Daniel.
> > 
> > On Wed, May 10, 2017 at 01:36:37PM -0400, Daniel Micay wrote:
> > > Moving pcpu_base_addr to this section comes from PaX where it's part
> > > of
> > > KERNEXEC. This extends it to the rest of the globals only written by
> > > the
> > > init code.
> > 
> > How did you test the patch?
> 
> Booted / did some stuff on x86 (it's running right now), and currently
> building it for a 3.18 arm64 kernel to test there.
> 
> > 
> > > -static struct list_head *pcpu_slot __read_mostly; /* chunk list
> > > slots */
> > > +static struct list_head *pcpu_slot __ro_after_init; /* chunk list
> > > slots */
> > 
> > At least this one isn't read only.
> 
> It's the array it points to being modified after it gets assigned to
> during init with pcpu_slot = memblock_virt_alloc(...), not the pointer
> variable itself. The references after init are all pcpu_slot[...]
> including taking references to slots in the array so there's always a
> dereference happening first.

Ah, right.  Cool, applying to percpu/for-4.13.

Thanks.

-- 
tejun
