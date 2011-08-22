Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 22 Aug 2011 13:41:38 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110822094138.GA13710@openwall.com>
References: <20110718194803.GA5337@albatros> <20110723153751.GB11156@openwall.com> <20110822093405.GA2450@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110822093405.GA2450@albatros>
Subject: Re: [kernel-hardening] GNU_STACK policy problem
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Vasiliy,

On Mon, Aug 22, 2011 at 01:34:05PM +0400, Vasiliy Kulikov wrote:
> Looking into ELF documentation:
> 
> In MIPS, SPARC no AT_FLAGS bits are used currently.  And "bits under the
> 0xff000000 mask are reserved for system semantics."
> 
> In IA-32 and PPC no bits are used.  No "system" flags are mentioned.
> 
> 
> I didn't find any definition of "system semantics", I guess it means any
> non-standard usage on local system.  Probably we should use these bits.

Yes, using some of those reserved bits (even if reserved on other archs
only) makes sense to me.

Your changes look good to me - at least good enough to bring a
discussion up on LKML if you choose to do so despite of the NAK
expectation.  As discussed off-list, I think it's OK to try.

Thanks,

Alexander
