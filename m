Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 12 Aug 2011 16:23:43 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110812122343.GA7859@openwall.com>
References: <20110808173913.GA16028@albatros> <20110810095200.GA2377@albatros> <20110810130333.GA31122@openwall.com> <20110810132715.GA8993@albatros> <20110810142609.GA31434@openwall.com> <20110810150257.GA12198@albatros> <20110810154059.GA31860@openwall.com> <20110810162101.GA2833@albatros> <20110810164225.GA32177@openwall.com> <20110812120747.GA14598@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110812120747.GA14598@albatros>
Subject: Re: [kernel-hardening] 32/64 bitness restriction for pid namespace
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Aug 12, 2011 at 04:07:48PM +0400, Vasiliy Kulikov wrote:
> This is the updated version.  It tries to handle denied syscalls as if
> they are disabled (MSR/IDT entry is not initialized).  I've copied
> handlers' from interrupt handlers and removed kprobes code, which is
> looks like dead in this specific case.

I did suggest this behavior, but I think it's more important to run the
overall idea of this patch by LKML.  So please do that without spending
any further time on the code yet.  Just post this revision as an RFC to
LKML.  Thanks!

Alexander
