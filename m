Date: Fri, 23 Nov 2018 18:23:09 +0100
From: Solar Designer <solar@openwall.com>
Subject: Re: [RFC PATCH 0/6] Process-local memory allocations
Message-ID: <20181123172308.GA25459@openwall.com>
References: <cover.1542722764.git.jsteckli@amazon.de> <20181120232619.GA13641@cisco> <b37324d7-5d47-3ad6-d5f5-bd2b20a43f5b@gmail.com> <20181121174821.GA3313@cisco> <1542904826.6344.1.camel@amazon.de> <5af3ae36-6e1a-b8f0-c4b6-8a93fb842343@gmail.com> <20181123170401.GA25204@openwall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181123170401.GA25204@openwall.com>
To: Igor Stoppa <igor.stoppa@gmail.com>
Cc: "Stecklina, Julian" <jsteckli@amazon.de>, "tycho@tycho.ws" <tycho@tycho.ws>, "liran.alon@oracle.com" <liran.alon@oracle.com>, "jwadams@google.com" <jwadams@google.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "dwmw2@infradead.org" <dwmw2@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Nov 23, 2018 at 06:04:01PM +0100, Solar Designer wrote:
> On Fri, Nov 23, 2018 at 06:24:08PM +0200, Igor Stoppa wrote:
> > On 22/11/2018 18:40, Stecklina, Julian wrote:
> > >On Wed, 2018-11-21 at 10:48 -0700, Tycho Andersen wrote:
> > >>>Where is the full set of patches?
> > >>>I'm sorry, I searched both KVM and LKML archives, but I couldn't find it.
> > >>
> > >>It looks like they were only sent to kernel hardening, but not sent to
> > >>the archives? I only see our replies here:
> > >>
> > >>https://www.openwall.com/lists/kernel-hardening/
> > >>
> > >>Julian, perhaps you can re-send with a CC to lkml as well?
> > >
> > >Will do. I messed up the threading, due to git send-email being hostile to 
> > >me.
> > >Sorry for the confusion.
> > 
> > If you are not subscribed to the hardening ml, it will neither archive, 
> > nor forward to subscribers your emails.
> 
> No.  There's no requirement to be subscribed to kernel-hardening in
> order to be able to post, nor for messages to be archived.
> 
> > This very mail you wrote is not archived either.
> 
> Julian's message in fact did not appear on kernel-hardening, and the
> reason is that Amazon's mail servers - for reasons unknown to me (and to
> an Amazoner with whom I tried discussing it before) sometimes(?!) add
> the "Precedence: junk" header on messages.  ezmlm-idx drops such
> messages by default (and this behavior is documented).  I'm not eager to
> patch this out.  ezmlm-idx also drops messages with "Precedence: bulk",
> and it sets that header on messages it sends to list subscribers, which
> helps against loops.  Another reason is to avoid vacation auto-replies,
> which I think can use either header.  It'd be weird to continue dropping
> "bulk", yet start accepting "junk", wouldn't it?  But if this is
> unfixable on Amazon's end, I'll have to.

OK, I've just patched the "junk" check out of ezmlm-reject (processing
of messages to the posting addresses), but kept it in ezmlm-weed
(processing of messages to the bounce addresses).  I hope Julian's
messages will be getting through now.

Alexander
