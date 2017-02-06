Date: Mon, 6 Feb 2017 09:12:37 +0100
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20170206081237.GG6515@twins.programming.kicks-ass.net>
References: <20170203132558.474916683@infradead.org>
 <20170203132737.566324209@infradead.org>
 <20170206042428.GA17028@tardis.cn.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170206042428.GA17028@tardis.cn.ibm.com>
Subject: [kernel-hardening] Re: [PATCH 4/5] atomic: Introduce atomic_try_cmpxchg()
To: Boqun Feng <boqun.feng@gmail.com>
Cc: elena.reshetova@intel.com, gregkh@linuxfoundation.org, keescook@chromium.org, arnd@arndb.de, tglx@linutronix.de, mingo@kernel.org, h.peter.anvin@intel.com, will.deacon@arm.com, dwindsor@gmail.com, dhowells@redhat.com, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Feb 06, 2017 at 12:24:28PM +0800, Boqun Feng wrote:
> On Fri, Feb 03, 2017 at 02:26:02PM +0100, Peter Zijlstra wrote:

> > 
> > 	for (;;) {
> > 		new = val $op $imm;
> > 		if (try_cmpxchg(ptr, &val, new))
> > 			break;
> > 	}
> > 
> > while also generating better code (GCC6 and onwards).
> > 
> 
> But switching to try_cmpxchg() will make @val a memory location, which
> could not be put in a register. And this will generate unnecessary
> memory accesses on archs having enough registers(PPC, e.g.).

GCC was perfectly capable of making @val a register in the code I was
looking at.

> > +#ifndef atomic_try_cmpxchg
> > +
> > +#define __atomic_try_cmpxchg(type, _p, _po, _n)				\
> > +({									\
> > +	typeof(_po) __po = (_po);					\
> > +	typeof(*(_po)) __o = *__po;					\
> > +	bool success = (atomic_cmpxchg##type((_p), __o, (_n)) == __o);	\
> > +	*__po = __o;							\
> 
> Besides, is this part correct? atomic_cmpxchg_*() wouldn't change the
> value of __o, so *__po wouldn't be changed.. IOW, in case of failure,
> *ptr wouldn't be updated to a new value.
> 
> Maybe this should be:
> 
> 	bool success;
> 	*__po = atomic_cmpxchg##type((_p), __o, (_n));
> 	sucess = (*__po == _o);
> 
> , right?

Yes, botched that. Don't think I even compiled it to be honest :/
