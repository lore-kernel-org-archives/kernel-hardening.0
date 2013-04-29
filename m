Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 29 Apr 2013 11:25:06 +1000 (EST)
From: James Morris <jmorris@namei.org>
In-Reply-To: <517AF5F2.50404@zytor.com>
Message-ID: <alpine.LRH.2.02.1304291124520.5728@tundra.namei.org>
References: <1367003005-5560-1-git-send-email-keescook@chromium.org> <1367003005-5560-4-git-send-email-keescook@chromium.org> <517AF5F2.50404@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Subject: Re: [kernel-hardening] Re: [PATCH 3/6] x86: kaslr: return location
 from decompress_kernel
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, x86@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@intel.com>, Matthew Garrett <mjg@redhat.com>, Matt Fleming <matt.fleming@intel.com>, Eric Northup <digitaleric@google.com>, Dan Rosenberg <drosenberg@vsecurity.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, 26 Apr 2013, H. Peter Anvin wrote:

> > +	noaslr		[X86]
> > +			Disable kernel base offset ASLR (Address Space
> > +			Layout Randomization) if built into the kernel.
> > +
> >  	noautogroup	Disable scheduler automatic task group creation.
> >  
> >  	nobats		[PPC] Do not use BATs for mapping kernel lowmem
> 
> Calling it "nokaslr" might be useful to note that it is specifically
> about the kernel.
> 

Agreed.


-- 
James Morris
<jmorris@namei.org>
