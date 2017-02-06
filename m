Date: Mon, 6 Feb 2017 14:06:23 +0100
From: Greg KH <gregkh@linuxfoundation.org>
Message-ID: <20170206130623.GA5869@kroah.com>
References: <20170203132558.474916683@infradead.org>
 <20170203132737.365388918@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170203132737.365388918@infradead.org>
Subject: [kernel-hardening] Re: [PATCH 2/5] kref: Implement using refcount_t
To: Peter Zijlstra <peterz@infradead.org>
Cc: elena.reshetova@intel.com, keescook@chromium.org, arnd@arndb.de, tglx@linutronix.de, mingo@kernel.org, h.peter.anvin@intel.com, will.deacon@arm.com, dwindsor@gmail.com, dhowells@redhat.com, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Feb 03, 2017 at 02:26:00PM +0100, Peter Zijlstra wrote:
> Use the refcount_t 'atomic' type to implement kref, this makes kref
> more robust by bringing saturation semantics.
> 
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>


Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
