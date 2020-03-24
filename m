Return-Path: <SRS0=Jz7m=5J=lists.openwall.com=kernel-hardening-return-18191-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D24BC43331
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Mar 2020 17:00:02 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id EB7522076F
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Mar 2020 17:00:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b="N8IFPUhG";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="a0S+/jxJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EB7522076F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=kroah.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18191-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5693 invoked by uid 550); 24 Mar 2020 16:59:55 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5658 invoked from network); 24 Mar 2020 16:59:54 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
	date:from:to:cc:subject:message-id:references:mime-version
	:content-type:in-reply-to; s=fm3; bh=EmgflmADeX3uKMoV9z6ZCDVZvdB
	T42jj27XLkAu0280=; b=N8IFPUhGgraum0WfQg7hW7S+v41IJ/sSIlOnX+tcuFr
	cHBCkIRuCentE8TS0Z4a23DWnqePzysHB3fAigWRvO3PTf1u08sVcfgxU45ihkhD
	hklmih52QH0vwEOBbEfC4eb1dBqmy0IpLH9NPC43pIEohDWthooGANVifOpAlYCQ
	e8kodiuovk2PdUDo2j3/7lR78Gb/2/bvTXP6FYNEop/3rh21DibHLzht1DLJK0nV
	3OUX0rRJxMvRJnxrVhQdxo7Dv+J3dpkAIQdvu3Stwb1uVkd4tBitxLKyVYxoFUY+
	Si/qdKwpqeV+CfcgSDsM9/1GeQGShU1mKZHBqFshmXw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to:x-me-proxy
	:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Emgflm
	ADeX3uKMoV9z6ZCDVZvdBT42jj27XLkAu0280=; b=a0S+/jxJ5p5bDXnlVG5Ph8
	4QDCN8OK6oebG/3/fUV/ncDX5EGMuNToMf/Y+XXHQFNFgUf78C0e391lOQ+6T1Jz
	dXXhrghdicVQRLSoDsXuGx4+SXU6WFUKyfqfnurz05qWNGBbLHaDEultpXfqAzRY
	lDmi+D5zd+5tc8cw1ElYkHtuD0+F8Dl7cOPe8svUCoPvMU20VdreE/Y9o5iY6DXl
	biatMZLgovryilGBBihCdFEe/0l0aqs1OV0EUegmmONPl5En0gCK8vxh6FUznTSr
	lCJhgfP5xclZ6T/5wwdi6wISU9qOarq7AFRS0Wa2zTU0TJDFIvJr0A0ja8bF7hxw
	==
X-ME-Sender: <xms:fTx6XnGdayaYLdMg97_00iek-9mgSd1FcT9FNwNk5SySwtp1XU2VJQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudehuddgieegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrddutd
    ejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhr
    vghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:fTx6Xn10M5T6WpbDLR8vgx-cHaiLmkGsvkhw7hhA7Sev6Yg1ou-jgw>
    <xmx:fTx6XhqO3uPNrgOiTmMCgF9PDnRaFmTBZ74hKOKR1BFWk1R7tlrt2Q>
    <xmx:fTx6Xn55YFOy6m5pabJiqg34xGgvCPgJuxeJ9vIzGnsSX6UO408bHQ>
    <xmx:fzx6XltL3TawRFpMtINceQTNvTK3BFrf1tjTgQFFH73_vEtH0_PWsA>
Date: Tue, 24 Mar 2020 17:59:38 +0100
From: Greg KH <greg@kroah.com>
To: Jann Horn <jannh@google.com>
Cc: Will Deacon <will@kernel.org>,
	kernel list <linux-kernel@vger.kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Kees Cook <keescook@chromium.org>,
	Maddie Stone <maddiestone@google.com>,
	Marco Elver <elver@google.com>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	kernel-team <kernel-team@android.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Subject: Re: [RFC PATCH 03/21] list: Annotate lockless list primitives with
 data_race()
Message-ID: <20200324165938.GA2521386@kroah.com>
References: <20200324153643.15527-1-will@kernel.org>
 <20200324153643.15527-4-will@kernel.org>
 <CAG48ez1yTbbXn__Kf0csf8=LCFL+0hR0EyHNZsryN8p=SsLp5Q@mail.gmail.com>
 <20200324162652.GA2518046@kroah.com>
 <CAG48ez1c5Rjo+RZRW-qR7h40zT4mT8iQv5m3h0qTjfFpsckEsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez1c5Rjo+RZRW-qR7h40zT4mT8iQv5m3h0qTjfFpsckEsg@mail.gmail.com>

On Tue, Mar 24, 2020 at 05:38:30PM +0100, Jann Horn wrote:
> On Tue, Mar 24, 2020 at 5:26 PM Greg KH <greg@kroah.com> wrote:
> > On Tue, Mar 24, 2020 at 05:20:45PM +0100, Jann Horn wrote:
> > > On Tue, Mar 24, 2020 at 4:37 PM Will Deacon <will@kernel.org> wrote:
> > > > Some list predicates can be used locklessly even with the non-RCU list
> > > > implementations, since they effectively boil down to a test against
> > > > NULL. For example, checking whether or not a list is empty is safe even
> > > > in the presence of a concurrent, tearing write to the list head pointer.
> > > > Similarly, checking whether or not an hlist node has been hashed is safe
> > > > as well.
> > > >
> > > > Annotate these lockless list predicates with data_race() and READ_ONCE()
> > > > so that KCSAN and the compiler are aware of what's going on. The writer
> > > > side can then avoid having to use WRITE_ONCE() in the non-RCU
> > > > implementation.
> > > [...]
> > > >  static inline int list_empty(const struct list_head *head)
> > > >  {
> > > > -       return READ_ONCE(head->next) == head;
> > > > +       return data_race(READ_ONCE(head->next) == head);
> > > >  }
> > > [...]
> > > >  static inline int hlist_unhashed(const struct hlist_node *h)
> > > >  {
> > > > -       return !READ_ONCE(h->pprev);
> > > > +       return data_race(!READ_ONCE(h->pprev));
> > > >  }
> > >
> > > This is probably valid in practice for hlist_unhashed(), which
> > > compares with NULL, as long as the most significant byte of all kernel
> > > pointers is non-zero; but I think list_empty() could realistically
> > > return false positives in the presence of a concurrent tearing store?
> > > This could break the following code pattern:
> > >
> > > /* optimistic lockless check */
> > > if (!list_empty(&some_list)) {
> > >   /* slowpath */
> > >   mutex_lock(&some_mutex);
> > >   list_for_each(tmp, &some_list) {
> > >     ...
> > >   }
> > >   mutex_unlock(&some_mutex);
> > > }
> > >
> > > (I'm not sure whether patterns like this appear commonly though.)
> >
> >
> > I would hope not as the list could go "empty" before the lock is
> > grabbed.  That pattern would be wrong.
> 
> If the list becomes empty in between, the loop just iterates over
> nothing, and the effect is no different from what you'd get if you had
> bailed out before. But sure, you have to be aware that that can
> happen.

Doh, yeah, so it is safe, crazy, but safe :)
