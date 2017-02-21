Date: Tue, 21 Feb 2017 10:54:46 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20170221105446.GA8605@leverpostej>
References: <1487498618-16528-1-git-send-email-hoeun.ryu@gmail.com>
 <20170220100213.GA9003@leverpostej>
 <FAEFA506-D7DB-4D92-A773-3A6EA966FE4A@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <FAEFA506-D7DB-4D92-A773-3A6EA966FE4A@gmail.com>
Subject: Re: [kernel-hardening] [PATCH 0/7] introduce __ro_mostly_after_init
 section marker
To: Ho-Eun Ryu <hoeun.ryu@gmail.com>
Cc: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Feb 21, 2017 at 03:10:45PM +0900, Ho-Eun Ryu wrote:
> > On 20 Feb 2017, at 7:02 PM, Mark Rutland <mark.rutland@arm.com> wrote:
> > On Sun, Feb 19, 2017 at 07:03:38PM +0900, Hoeun Ryu wrote:
> >> After `__ro_after_init` marker is included in kernel, many kernel data
> >> objects can be read-only-after-init. But there are many other places that
> >> would be good to read-only-after-init but `__ro_after_init` can not be simply
> >> applicable to them because they should be writable at some points, which are
> >> during module_init/exit or dynamic de/registration for a specific subsystem.
> > 
> > Could you elaborate on this?
> > 
> > For modules, I assume that the __ro_after_init data structures are part
> > of the module, and not part of the "real" kernel image. Is that the case?
> 
> __ro_mostly_after_init is for kernel builtin core subsystems, not for
> modules themselves.  The section can be writable only during kernel
> init and module_init/exit.  Some hooks (or array of hooks) of a core
> subsystem can be marked as __ro_mostly_after_init similar to that way
> of __ro_after_init. After that some modules that may write to those
> hooks of the subsystem to register/deregister something to the
> subsystem can safely access those section.  Please see RFC 3/7 that
> makes this section writable.
> 
> In addition, some subsystems may use this marker for their (array of)
> hooks and make them writable only at some point of time via
> set_ro_mostly_after_init_rw/ro pair.  please read RFC 4/7 for selinux.

Ok.

This sounds like a limited case of __write_rarely, where we only expect
to perform writes in specific time windows.

I'd prefer if we could attack __write_rarely, and use the appraoch to
cater for this case, but I am not necessarily opposed to this approach
if other architectures are happy with it.

> > Which specific subsystems whish to modify data structures that are
> > __ro_after_init?
> 
> I’m not intending to make writable __ro_after_init section but
> introducing new section marker that works mostly like __ro_after_init
> but can be written to at some points.  please see RFC 5/7 for
> cpuhotplug.

Ah. I clearly had not read this sufficiently thoroughly; sorry about
that.

Thanks,
Mark.
