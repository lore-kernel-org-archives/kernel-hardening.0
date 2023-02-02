Return-Path: <kernel-hardening-return-21640-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 7A230C61DA4
	for <kernel-hardening@archiver.kernel.org>; Thu,  2 Feb 2023 16:48:55 +0000 (UTC)
Received: (qmail 2003 invoked by uid 550); 2 Feb 2023 16:48:40 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13625 invoked from network); 2 Feb 2023 14:52:07 -0000
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 36F1820B74F7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1675349514;
	bh=sGLps7CqkFNZDG3cdYODwV6PIkGOHAkiIVB7Bzz6aGU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DtRoMrNAwoSQzbflumoSS+I9iXvGFkTcZBAMfbISimrqI/V+c7Ub0xH9KpMe9VKV8
	 mhn0La0PK9UxP4m/+GHTOtJoC83sChTWzO1PgZBklKtjcu5an5WMcE9JIwI5C6IBDJ
	 OLe7xFgcSJTomXzzFzgW4bzcIb8eXn1Pwiktak8U=
Date: Thu, 2 Feb 2023 06:51:54 -0800
From: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
	Leon Romanovsky <leon@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
Message-ID: <20230202145154.GA10621@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <Y9EkCvAfNXnJ+ATo@kroah.com>
 <DM8PR11MB5750FA4849C3224F597C101AE7CE9@DM8PR11MB5750.namprd11.prod.outlook.com>
 <Y9Jh2x9XJE1KEUg6@unreal>
 <DM8PR11MB5750414F6638169C7097E365E7CF9@DM8PR11MB5750.namprd11.prod.outlook.com>
 <Y9JyW5bUqV7gWmU8@unreal>
 <DM8PR11MB57507D9C941D77E148EE9E87E7CF9@DM8PR11MB5750.namprd11.prod.outlook.com>
 <702f22df28e628d41babcf670c909f1fa1bb3c0c.camel@linux.ibm.com>
 <DM8PR11MB5750F939C0B70939AD3CBC37E7D39@DM8PR11MB5750.namprd11.prod.outlook.com>
 <220b0be95a8c733f0a6eeddc08e37977ee21d518.camel@linux.ibm.com>
 <DM8PR11MB575074D3BCBD02F3DD677A57E7D09@DM8PR11MB5750.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DM8PR11MB575074D3BCBD02F3DD677A57E7D09@DM8PR11MB5750.namprd11.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Tue, Jan 31, 2023 at 11:31:28AM +0000, Reshetova, Elena wrote:
> > On Mon, 2023-01-30 at 07:42 +0000, Reshetova, Elena wrote:
> > [...]
> > > > The big threat from most devices (including the thunderbolt
> > > > classes) is that they can DMA all over memory.  However, this isn't
> > > > really a threat in CC (well until PCI becomes able to do encrypted
> > > > DMA) because the device has specific unencrypted buffers set aside
> > > > for the expected DMA. If it writes outside that CC integrity will
> > > > detect it and if it reads outside that it gets unintelligible
> > > > ciphertext.  So we're left with the device trying to trick secrets
> > > > out of us by returning unexpected data.
> > >
> > > Yes, by supplying the input that hasn’t been expected. This is
> > > exactly the case we were trying to fix here for example:
> > > https://lore.kernel.org/all/20230119170633.40944-2-
> > alexander.shishkin@linux.intel.com/
> > > I do agree that this case is less severe when others where memory
> > > corruption/buffer overrun can happen, like here:
> > > https://lore.kernel.org/all/20230119135721.83345-6-
> > alexander.shishkin@linux.intel.com/
> > > But we are trying to fix all issues we see now (prioritizing the
> > > second ones though).
> > 
> > I don't see how MSI table sizing is a bug in the category we've
> > defined.  The very text of the changelog says "resulting in a kernel
> > page fault in pci_write_msg_msix()."  which is a crash, which I thought
> > we were agreeing was out of scope for CC attacks?
> 
> As I said this is an example of a crash and on the first look
> might not lead to the exploitable condition (albeit attackers are creative).
> But we noticed this one while fuzzing and it was common enough
> that prevented fuzzer going deeper into the virtio devices driver fuzzing.
> The core PCI/MSI doesn’t seem to have that many easily triggerable 
> Other examples in virtio patchset are more severe. 
> 
> > 
> > > >
> > > > If I set this as the problem, verifying device correct operation is
> > > > a possible solution (albeit hugely expensive) but there are likely
> > > > many other cheaper ways to defeat or detect a device trying to
> > > > trick us into revealing something.
> > >
> > > What do you have in mind here for the actual devices we need to
> > > enable for CC cases?
> > 
> > Well, the most dangerous devices seem to be the virtio set a CC system
> > will rely on to boot up.  After that, there are other ways (like SPDM)
> > to verify a real PCI device is on the other end of the transaction.
> 
> Yes, it the future, but not yet. Other vendors will not necessary be 
> using virtio devices at this point, so we will have non-virtio and not
> CC enabled devices that we want to securely add to the guest.
> 
> > 
> > > We have been using here a combination of extensive fuzzing and static
> > > code analysis.
> > 
> > by fuzzing, I assume you mean fuzzing from the PCI configuration space?
> > Firstly I'm not so sure how useful a tool fuzzing is if we take Oopses
> > off the table because fuzzing primarily triggers those
> 
> If you enable memory sanitizers you can detect more server conditions like
> out of bounds accesses and such. I think given that we have a way to 
> verify that fuzzing is reaching the code locations we want it to reach, it
> can be pretty effective method to find at least low-hanging bugs. And these
> will be the bugs that most of the attackers will go after at the first place. 
> But of course it is not a formal verification of any kind.
> 
>  so its hard to
> > see what else it could detect given the signal will be smothered by
> > oopses and secondly I think the PCI interface is likely the wrong place
> > to begin and you should probably begin on the virtio bus and the
> > hypervisor generated configuration space.
> 
> This is exactly what we do. We don’t fuzz from the PCI config space,
> we supply inputs from the host/vmm via the legitimate interfaces that it can 
> inject them to the guest: whenever guest requests a pci config space
> (which is controlled by host/hypervisor as you said) read operation, 
> it gets input injected by the kafl fuzzer.  Same for other interfaces that 
> are under control of host/VMM (MSRs, port IO, MMIO, anything that goes
> via #VE handler in our case). When it comes to virtio, we employ 
> two different fuzzing techniques: directly injecting kafl fuzz input when
> virtio core or virtio drivers gets the data received from the host 
> (via injecting input in functions virtio16/32/64_to_cpu and others) and 
> directly fuzzing DMA memory pages using kfx fuzzer. 
> More information can be found in https://intel.github.io/ccc-linux-guest-hardening-docs/tdx-guest-hardening.html#td-guest-fuzzing
> 
> Best Regards,
> Elena.

Hi Elena,

I think it might be a good idea to narrow down a configuration that *can*
reasonably be hardened to be suitable for confidential computing, before
proceeding with fuzzing. Eg. a lot of time was spent discussing PCI devices
in the context of virtualization, but what about taking PCI out of scope
completely by switching to virtio-mmio devices?

Jeremi
