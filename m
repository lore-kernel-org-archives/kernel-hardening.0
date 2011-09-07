Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Wed, 7 Sep 2011 13:55:08 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110907095508.GA16114@albatros>
References: <20110825171934.GA3044@albatros>
 <20110902182929.GA23848@openwall.com>
 <20110903111849.GA2743@albatros>
 <20110903235728.GD29169@openwall.com>
 <20110905124647.GA10247@albatros>
 <20110906050554.GA3889@openwall.com>
 <20110907090900.GA3910@albatros>
 <20110907093036.GA17693@openwall.com>
 <20110907093411.GA4752@albatros>
 <20110907094335.GA17834@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110907094335.GA17834@openwall.com>
Subject: Re: [kernel-hardening] [RFC] x86, mm: start mmap allocation for
 libs from low addresses
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Solar,

On Wed, Sep 07, 2011 at 13:43 +0400, Solar Designer wrote:
> On Wed, Sep 07, 2011 at 01:34:11PM +0400, Vasiliy Kulikov wrote:
> > On Wed, Sep 07, 2011 at 13:30 +0400, Solar Designer wrote:
> > > What if mmap_min_addr set really low, or is even 0?  I think we want to
> > > skip low addresses even if processes are permitted to use those.
> > > (Permitted does not mean encouraged.)  So how about ASCII_ARMOR_MIN_ADDR
> > > 0x19000 (100 KB) when !CONFIG_VM86?
> > 
> > Are you talking about safety with NULL pointer dereferencing?
> 
> Yes.

OK, fully agree.  But why 100 KB?  Probably 0x10000 (64 KB)?  It looks
nicer and not so magic.

-- 
Vasiliy
