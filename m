Date: Fri, 20 Jan 2017 09:52:04 -0800
From: Eric Biggers <ebiggers3@gmail.com>
Message-ID: <20170120175204.GA48417@gmail.com>
References: <1484730707-29313-1-git-send-email-elena.reshetova@intel.com>
 <20170118215247.GA129388@gmail.com>
 <20170119091952.GH6485@twins.programming.kicks-ass.net>
 <20170119191828.GA104949@gmail.com>
 <20170120083649.GP6485@twins.programming.kicks-ass.net>
 <2236FBA76BA1254E88B949DDB74E612B41C3FAAC@IRSMSX102.ger.corp.intel.com>
 <20170120104429.GA19223@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170120104429.GA19223@openwall.com>
Subject: Re: [kernel-hardening] [RFCv2 PATCH 00/18] refcount_t API + usage
To: Solar Designer <solar@openwall.com>
Cc: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jan 20, 2017 at 11:44:30AM +0100, Solar Designer wrote:
> I dropped all CC's since this sub-thread is only relevant to those
> receiving this via the kernel-hardening mailing list.
> 
> On Fri, Jan 20, 2017 at 09:20:08AM +0000, Reshetova, Elena wrote:
> > Really wonder how it happened that Peter was dropped out of that thread and all other mails were correct.
> > Anyway, here was the mail:
> > 
> > http://www.openwall.com/lists/kernel-hardening/2017/01/05/19
> 
> I'm afraid the kernel-hardening mailing list setup may be at fault.
> On this list, as well as on most others at Openwall, we introduce the
> Reply-To header pointing to the list.  This is meant to keep discussions
> on the list, avoiding inadvertent off-list responses.  However, this has
> a well-known unfortunate side-effect: many MUAs will then only use this
> Reply-To address and not the previous message's From address when doing
> a reply-to-all.  This will keep everyone from the previous message's CC,
> but the From person may be missing from the reply.  In Mutt, after
> pressing "g" for group-reply, to keep the From person on the reply one
> has to answer "n" to the "Reply to kernel-hardening@lists.openwall.com?
> ([yes]/no)" question, in which case the reply is also sent to the list,
> but via a CC.  This is counter-intuitive.
> 
> With this list's practice (inherited from LKML) to CC lots of people and
> other relevant lists on almost every posting, and with many people
> actively participating in discussions not being subscriber to this very
> list, perhaps we should reconsider and drop the forced Reply-To header.
> 
> In fact, I've just made this change.  Please let me know if you think I
> shouldn't have - that is, that we should reintroduce the forced Reply-To.
> 
> Alexander

Yes that is probably what happened.  In fact it happened to me on a different
thread last month: http://www.openwall.com/lists/kernel-hardening/2016/12/10/8.
I agree with dropping the forced Reply-To, to be consistent with other LKML
mailing lists.  Thanks for fixing it!

Eric
