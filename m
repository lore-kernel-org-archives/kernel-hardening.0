Return-Path: <kernel-hardening-return-21607-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id D5590C54E94
	for <kernel-hardening@archiver.kernel.org>; Thu, 26 Jan 2023 13:33:07 +0000 (UTC)
Received: (qmail 7414 invoked by uid 550); 26 Jan 2023 13:32:55 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 18003 invoked from network); 26 Jan 2023 12:30:36 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1674736223;
	bh=RMVz0eq5ZX8Yefi/SKmqfnTNPy/3cbwkkEFT1mPYWpk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ybl+10W5nwhEfLsqxE1Lu4Z7A81RDGmQKqTJG8p+04sD8P515JBzLYaJvy2Rh1Lbv
	 /Ga+Rhg6JuPhTQ3Hzb3x20lLggpr9AoydvFxJEv68NSbO1DHT1Rgxt+y2OcEUGYMYe
	 prYrrnY5DRQ4YuzmNi8JWY3OcrpPC3dLzouMO16x+6EFdInqgbRmyTFhg/cfdSG2U/
	 v3TZqWVunkioyz4qhF14J84vaGj8uJWi+RpJqwJNxEwo5xvZsCqpEo+Q0fey9sYIuV
	 iRIz3HH/aDcAEkyUQyIxYYwXlGXh8AJJzU7oP0v3i808doBS31PawVAtWwWdnflDO6
	 Q9Gcia0HHkRAQ==
Date: Thu, 26 Jan 2023 14:30:19 +0200
From: Leon Romanovsky <leon@kernel.org>
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Shishkin, Alexander" <alexander.shishkin@intel.com>,
	"Shutemov, Kirill" <kirill.shutemov@intel.com>,
	"Kuppuswamy, Sathyanarayanan" <sathyanarayanan.kuppuswamy@intel.com>,
	"Kleen, Andi" <andi.kleen@intel.com>,
	"Hansen, Dave" <dave.hansen@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Peter Zijlstra <peterz@infradead.org>,
	"Wunner, Lukas" <lukas.wunner@intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	"Poimboe, Josh" <jpoimboe@redhat.com>,
	"aarcange@redhat.com" <aarcange@redhat.com>,
	Cfir Cohen <cfir@google.com>, Marc Orr <marcorr@google.com>,
	"jbachmann@google.com" <jbachmann@google.com>,
	"pgonda@google.com" <pgonda@google.com>,
	"keescook@chromium.org" <keescook@chromium.org>,
	James Morris <jmorris@namei.org>,
	Michael Kelley <mikelley@microsoft.com>,
	"Lange, Jon" <jlange@microsoft.com>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Subject: Re: Linux guest kernel threat model for Confidential Computing
Message-ID: <Y9JyW5bUqV7gWmU8@unreal>
References: <DM8PR11MB57505481B2FE79C3D56C9201E7CE9@DM8PR11MB5750.namprd11.prod.outlook.com>
 <Y9EkCvAfNXnJ+ATo@kroah.com>
 <DM8PR11MB5750FA4849C3224F597C101AE7CE9@DM8PR11MB5750.namprd11.prod.outlook.com>
 <Y9Jh2x9XJE1KEUg6@unreal>
 <DM8PR11MB5750414F6638169C7097E365E7CF9@DM8PR11MB5750.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DM8PR11MB5750414F6638169C7097E365E7CF9@DM8PR11MB5750.namprd11.prod.outlook.com>

On Thu, Jan 26, 2023 at 11:29:20AM +0000, Reshetova, Elena wrote:
> > On Wed, Jan 25, 2023 at 03:29:07PM +0000, Reshetova, Elena wrote:
> > > Replying only to the not-so-far addressed points.
> > >
> > > > On Wed, Jan 25, 2023 at 12:28:13PM +0000, Reshetova, Elena wrote:
> > > > > Hi Greg,
> > 
> > <...>
> > 
> > > > > 3) All the tools are open-source and everyone can start using them right
> > away
> > > > even
> > > > > without any special HW (readme has description of what is needed).
> > > > > Tools and documentation is here:
> > > > > https://github.com/intel/ccc-linux-guest-hardening
> > > >
> > > > Again, as our documentation states, when you submit patches based on
> > > > these tools, you HAVE TO document that.  Otherwise we think you all are
> > > > crazy and will get your patches rejected.  You all know this, why ignore
> > > > it?
> > >
> > > Sorry, I didn’t know that for every bug that is found in linux kernel when
> > > we are submitting a fix that we have to list the way how it has been found.
> > > We will fix this in the future submissions, but some bugs we have are found by
> > > plain code audit, so 'human' is the tool.
> > 
> > My problem with that statement is that by applying different threat
> > model you "invent" bugs which didn't exist in a first place.
> > 
> > For example, in this [1] latest submission, authors labeled correct
> > behaviour as "bug".
> > 
> > [1] https://lore.kernel.org/all/20230119170633.40944-1-
> > alexander.shishkin@linux.intel.com/
> 
> Hm.. Does everyone think that when kernel dies with unhandled page fault 
> (such as in that case) or detection of a KASAN out of bounds violation (as it is in some
> other cases we already have fixes or investigating) it represents a correct behavior even if
> you expect that all your pci HW devices are trusted? 

This is exactly what I said. You presented me the cases which exist in
your invented world. Mentioned unhandled page fault doesn't exist in real
world. If PCI device doesn't work, it needs to be replaced/blocked and not
left to be operable and accessible from the kernel/user.

> What about an error in two consequent pci reads? What about just some
> failure that results in erroneous input?

Yes, some bugs need to be fixed, but they are not related to trust/not-trust
discussion and PCI spec violations.

Thanks

> 
> Best Regards,
> Elena.
> 
