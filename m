Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 19 Jan 2017 13:52:47 +0100
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20170119125247.GK6485@twins.programming.kicks-ass.net>
References: <1484730707-29313-1-git-send-email-elena.reshetova@intel.com>
 <20170118215247.GA129388@gmail.com>
 <20170119091952.GH6485@twins.programming.kicks-ass.net>
 <2236FBA76BA1254E88B949DDB74E612B41C3F0FD@IRSMSX102.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2236FBA76BA1254E88B949DDB74E612B41C3F0FD@IRSMSX102.ger.corp.intel.com>
Subject: Re: [kernel-hardening] [RFCv2 PATCH 00/18] refcount_t API + usage
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: Eric Biggers <ebiggers3@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "keescook@chromium.org" <keescook@chromium.org>, "arnd@arndb.de" <arnd@arndb.de>, "tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "Anvin, H Peter" <h.peter.anvin@intel.com>, "will.deacon@arm.com" <will.deacon@arm.com>, "dwindsor@gmail.com" <dwindsor@gmail.com>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jan 19, 2017 at 10:22:28AM +0000, Reshetova, Elena wrote:
> > You again failed to reply to my last email on the subject. The initial
> > PaX thing was broken as heck, only later did you mention it got fixed. I
> > told you we could change to that for x86 if it could be proven to be
> > equivalent.
> 
> I am confused on what is referred here as a fix.. 

>From http://lkml.kernel.org/r/20161230010627.GA9882@zzz where Eric said:

"I do see they used to use a slightly different approach that did a decrement
instead of setting the counter to INT_MAX.  And that was clearly racy because
two concurrent increments could circumvent the overflow protection."

> This had numbers on addl vs. cmpxchg:
> http://www.openwall.com/lists/kernel-hardening/2016/10/04/10

http://lkml.kernel.org/r/20161111102913.GE3117@twins.programming.kicks-ass.net

does too, sure cmpxchg is a bit slower uncontended, but I'm not sure we
should worry about that much. And refcounts really should not be heavily
contended, if they are there's design level issues that ought to be
looked at.
