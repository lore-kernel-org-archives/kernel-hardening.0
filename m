Return-Path: <kernel-hardening-return-21602-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id BA988C27C76
	for <kernel-hardening@archiver.kernel.org>; Wed, 25 Jan 2023 16:41:57 +0000 (UTC)
Received: (qmail 28547 invoked by uid 550); 25 Jan 2023 16:41:46 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28515 invoked from network); 25 Jan 2023 16:41:45 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1674664852; bh=87ST+3j3ht853XmSEHN0xdLq8YDjUMk/ZvDAixJFyYM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZyOS15yoknFWtHea0S6sBlb9jLH5MZbIghmMMAeYdcsk1vIDYas9OrAdlD2BjcEOc
	 F4YohO7z4oO96Dyh5T2KBvee4slOGj/QZToOkse0CSkdXEnqzBC30hIZB3A4X/9J6S
	 VbP/PnEWEEAWLo9bG+zONBnRln+1DFQ/KW71NpcDI1dEszCxk9WQsxM9LL+mMEbyfs
	 YULe/cw7S42QiPwhbzwgW/u+P7QH4o0rPBizRVjUrma/+ahw9MWZdKyry+jDF7/xc0
	 N3l7NxzZ1MXrHvL9rKznMJSEHiZg2y44pjmlzahl3odMO8N7evmBTTkAA4TZZ1tafI
	 oLEI5gSH/GuxA==
Date: Wed, 25 Jan 2023 11:40:46 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
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
Message-ID: <Y9FbjjpVTt/Yp0lq@mit.edu>
References: <DM8PR11MB57505481B2FE79C3D56C9201E7CE9@DM8PR11MB5750.namprd11.prod.outlook.com>
 <Y9EkCvAfNXnJ+ATo@kroah.com>
 <DM8PR11MB5750FA4849C3224F597C101AE7CE9@DM8PR11MB5750.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DM8PR11MB5750FA4849C3224F597C101AE7CE9@DM8PR11MB5750.namprd11.prod.outlook.com>

On Wed, Jan 25, 2023 at 03:29:07PM +0000, Reshetova, Elena wrote:
> > Again, as our documentation states, when you submit patches based on
> > these tools, you HAVE TO document that.  Otherwise we think you all are
> > crazy and will get your patches rejected.  You all know this, why ignore
> > it?
> 
> Sorry, I didn’t know that for every bug that is found in linux kernel when
> we are submitting a fix that we have to list the way how it has been found.
> We will fix this in the future submissions, but some bugs we have are found by
> plain code audit, so 'human' is the tool.

So the concern is that *you* may think it is a bug, but other people
may not agree.  Perhaps what is needed is a full description of the
goals of Confidential Computing, and what is in scope, and what is
deliberately *not* in scope.  I predict that when you do this, that
people will come out of the wood work and say, no wait, "CoCo ala
S/390 means FOO", and "CoCo ala AMD means BAR", and "CoCo ala RISC V
means QUUX".

Others may end up objecting, "no wait, doing this is going to mean
***insane*** changes to the entire kernel, and this will be a
performance / maintenance nightmare and unless you fix your hardware
in future chips, we wlil consider this a hardware bug and reject all
of your patches".

But it's better to figure this out now, then after you get hundreds of
patches into the upstream kernel, we discover that this is only 5% of
the necessary changes, and then the rest of your patches are rejected,
and you have to end up fixing the hardware anyway, with the patches
upstreamed so far being wasted effort.  :-)

If we get consensus on that document, then that can get checked into
Documentation, and that can represent general consensus on the problem
early on.

						- Ted
