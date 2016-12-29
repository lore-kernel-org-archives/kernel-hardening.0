Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 29 Dec 2016 17:41:09 +0100
From: Greg KH <gregkh@linuxfoundation.org>
Message-ID: <20161229164109.GA5891@kroah.com>
References: <1482994571-18687-1-git-send-email-elena.reshetova@intel.com>
 <1482994571-18687-2-git-send-email-elena.reshetova@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1482994571-18687-2-git-send-email-elena.reshetova@intel.com>
Subject: [kernel-hardening] Re: [RFC PATCH 01/19] Since we need to change the implementation,
 stop exposing internals. Provide kref_read() to read the current reference
 count; typically used for debug messages.
To: Elena Reshetova <elena.reshetova@intel.com>
Cc: kernel-hardening@lists.openwall.com, keescook@chromium.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, h.peter.anvin@intel.com, peterz@infradead.org, will.deacon@arm.com, dwindsor@gmail.com, ishkamiel@gmail.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Dec 29, 2016 at 08:55:53AM +0200, Elena Reshetova wrote:
> Kills two anti-patterns:
> 
> 	atomic_read(&kref->refcount)
> 	kref->refcount.counter
> 
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>

If you are going to send patches out, do it right, with a correct
subject, your signed-off-by: added, and the rest.  Otherwise it just
makes some of us cringe when we have to read these...
