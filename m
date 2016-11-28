Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 28 Nov 2016 13:48:46 +0100
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20161128124846.GL3174@twins.programming.kicks-ass.net>
References: <2236FBA76BA1254E88B949DDB74E612B41C1884B@IRSMSX102.ger.corp.intel.com>
 <20161128121347.GY3092@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161128121347.GY3092@twins.programming.kicks-ass.net>
Subject: [kernel-hardening] Re: Conversion from atomic_t to refcount_t: summary of issues
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Greg KH <gregkh@linuxfoundation.org>, Kees Cook <keescook@chromium.org>, "will.deacon@arm.com" <will.deacon@arm.com>, Boqun Feng <boqun.feng@gmail.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>, aik@ozlabs.ru, david@gibson.dropbear.id.au
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Nov 28, 2016 at 01:13:47PM +0100, Peter Zijlstra wrote:
> 
> > -    if (atomic_add_unless(&inode->i_count, -1, 1)) (typical for fs and other code)
> 

Many instances are variants of dec_and_lock/dec_and_mutex_lock(), like
for example the one in put_css_set().

However, there are a few, like in super.c and in XFS that are more
complex, but I have too much of a head-ache to actually think about that
atm.
