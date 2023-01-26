Return-Path: <kernel-hardening-return-21606-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 91F19C05027
	for <kernel-hardening@archiver.kernel.org>; Thu, 26 Jan 2023 13:32:58 +0000 (UTC)
Received: (qmail 5879 invoked by uid 550); 26 Jan 2023 13:32:50 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26144 invoked from network); 26 Jan 2023 11:20:13 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1674731999;
	bh=HLNfnERh9yqih9lmJtSKLabo136R/CglFwL3l5Rj5Sg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=B1P0qk7I1ISxzTc2mfP78KRR9qkhlKvXLycdAcYIJgTq7Z4z+GIN6nmkB9rm6iZcK
	 Nu9Wcfup5flrAI+Aw6onJbejHOwFimvel5O7/Z6+LnfBt/c1k1AF4hEp076Sy/mMgs
	 0Q1UKpiOY7Wqm2lafw0WKMG3Jy0ROLgsHe0cwPJyfY38tFxTQBKNhWhdl+fV7olHVD
	 +FqUZICP/kQVIHUTCgwiVcB1qs4tsrj61CN6QDbM6qnKZ03QCKYezwF1/TxNzLZ0kX
	 0yn1a8OdrPdl4ohdn1rN6XzpFq8KZTRyOU/IBGnp3MSCMbAjQPjeoRW2pdJAOPVSd2
	 Xh2nWWqQM0jSg==
Date: Thu, 26 Jan 2023 13:19:55 +0200
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
Message-ID: <Y9Jh2x9XJE1KEUg6@unreal>
References: <DM8PR11MB57505481B2FE79C3D56C9201E7CE9@DM8PR11MB5750.namprd11.prod.outlook.com>
 <Y9EkCvAfNXnJ+ATo@kroah.com>
 <DM8PR11MB5750FA4849C3224F597C101AE7CE9@DM8PR11MB5750.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DM8PR11MB5750FA4849C3224F597C101AE7CE9@DM8PR11MB5750.namprd11.prod.outlook.com>

On Wed, Jan 25, 2023 at 03:29:07PM +0000, Reshetova, Elena wrote:
> Replying only to the not-so-far addressed points. 
> 
> > On Wed, Jan 25, 2023 at 12:28:13PM +0000, Reshetova, Elena wrote:
> > > Hi Greg,

<...>

> > > 3) All the tools are open-source and everyone can start using them right away
> > even
> > > without any special HW (readme has description of what is needed).
> > > Tools and documentation is here:
> > > https://github.com/intel/ccc-linux-guest-hardening
> > 
> > Again, as our documentation states, when you submit patches based on
> > these tools, you HAVE TO document that.  Otherwise we think you all are
> > crazy and will get your patches rejected.  You all know this, why ignore
> > it?
> 
> Sorry, I didn’t know that for every bug that is found in linux kernel when
> we are submitting a fix that we have to list the way how it has been found.
> We will fix this in the future submissions, but some bugs we have are found by
> plain code audit, so 'human' is the tool. 

My problem with that statement is that by applying different threat
model you "invent" bugs which didn't exist in a first place.

For example, in this [1] latest submission, authors labeled correct
behaviour as "bug".

[1] https://lore.kernel.org/all/20230119170633.40944-1-alexander.shishkin@linux.intel.com/

Thanks
