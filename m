Reply-To: kernel-hardening@lists.openwall.com
Date: Sat, 13 Aug 2011 23:22:51 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110813192251.GA13051@openwall.com>
References: <20110810142609.GA31434@openwall.com> <20110810150257.GA12198@albatros> <20110810154059.GA31860@openwall.com> <20110810162101.GA2833@albatros> <20110810164225.GA32177@openwall.com> <20110812120747.GA14598@albatros> <20110812122343.GA7859@openwall.com> <20110813151220.GA8388@albatros> <20110813151947.GA12495@openwall.com> <20110813165502.GA9328@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110813165502.GA9328@albatros>
Subject: Re: [kernel-hardening] 32/64 bitness restriction for pid namespace
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Vasiliy,

On Sat, Aug 13, 2011 at 08:55:02PM +0400, Vasiliy Kulikov wrote:
> I've decided to go with 2 flags of prctl() - whether 32 bit executable
> is allowed on the next execve(), whether 64 bit exec is allowed.  If set
> both, any bitness is allowed, and the bitness lock depends on the binary
> bitness.  If none set, don't lock at all.

Sounds good.

> 1) If execve() fails, e.g. because of missing binary, drop the flag or
> keep it?  I think dropping is safer.

I wouldn't call this safer, but it does feel more logical.

> 2) If the binary is non-ELF, e.g. a misc binary?  I think execve()
> should fail as we expect to run 64/32 bit ELF.

This makes sense to me.

Alexander
