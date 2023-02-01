Return-Path: <kernel-hardening-return-21637-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 1510DC05027
	for <kernel-hardening@archiver.kernel.org>; Wed,  1 Feb 2023 16:02:48 +0000 (UTC)
Received: (qmail 16014 invoked by uid 550); 1 Feb 2023 16:02:35 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15988 invoked from network); 1 Feb 2023 16:02:34 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675267343;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EElzE8+e1kmP7S3k+GEUsksfz7cKl253GIZfZ0NLa3M=;
	b=Tz+IuyEfQ7PbyGij3JfR6A2XOanVaOi66bnKyf53/3hNfzk/4e//xA+3DL/sd190pWcPLY
	JdoZRbDq/e2+2yJre9x9D++VEUGgS5T05zh4xy3quK7tn1rC+rFpSGXLJeTxoAp3/IAnMc
	HPABjpKJyY10lAdH1jkueY6/tugMMW0=
X-MC-Unique: GS52hKm5N16JG8gKl1Fpbg-1
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EElzE8+e1kmP7S3k+GEUsksfz7cKl253GIZfZ0NLa3M=;
        b=OQB9ENFpkfl9hyeKFzEFjD28/6xV03p56h2uX3xkbK2sPGBf0/CDRPLzqUSnGoSFzb
         xF7v5wdg9JwNQ5gVQO0Km/iCQ5spDPUKmqF0p8Ga13P/orElqijBEeQoZkVKJ6TL0b+F
         jYLEGoF82EfZIwsFKPnB4oAPbq8ZL4m9GPULx3lSYWR+5FsHjfRws8z8xdpXz2aeXGqY
         T8hINlaRvxL6ph2Ze3IKQ4MyIsizqMQdeRulnkPVWZei//CV79jzRLGMj/PsXJqsHR0A
         xzxQiLMydnWv2+ncjbOIKsnPNgJEQjwG1e/JW/16TdRbfVOkpNhmqB57/4lPUa2tJPsi
         Rujw==
X-Gm-Message-State: AO0yUKVjYOChHjxjYDtHM8U8pl3895j9qCgl8Wfx1gnhAmp9kkBmganr
	h+ANApf4+gsqNnfxyXmfVXo8NWPtc2/VhX4MelCaX1oNUQOcVw3v+ICnH/xPdpBEXiF/A3pmlhy
	nBGBKGX3Bp3rfGbQ/OPxgrC//KUl66m4gnQ==
X-Received: by 2002:adf:fd88:0:b0:2bf:5dc0:56c8 with SMTP id d8-20020adffd88000000b002bf5dc056c8mr2253284wrr.51.1675267336906;
        Wed, 01 Feb 2023 08:02:16 -0800 (PST)
X-Google-Smtp-Source: AK7set/cViVu8qXP79IJNXkXkroLfOIDkTqq67u9Yp+KKjFvc+/ficndq3vQOcHptFk86I0MldWauA==
X-Received: by 2002:adf:fd88:0:b0:2bf:5dc0:56c8 with SMTP id d8-20020adffd88000000b002bf5dc056c8mr2253258wrr.51.1675267336661;
        Wed, 01 Feb 2023 08:02:16 -0800 (PST)
Date: Wed, 1 Feb 2023 11:02:09 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Christophe de Dinechin Dupont de Dinechin <cdupontd@redhat.com>
Cc: Christophe de Dinechin <dinechin@redhat.com>,
	James Bottomley <jejb@linux.ibm.com>,
	"Reshetova, Elena" <elena.reshetova@intel.com>,
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
Message-ID: <20230201105305-mutt-send-email-mst@kernel.org>
References: <702f22df28e628d41babcf670c909f1fa1bb3c0c.camel@linux.ibm.com>
 <DM8PR11MB5750F939C0B70939AD3CBC37E7D39@DM8PR11MB5750.namprd11.prod.outlook.com>
 <220b0be95a8c733f0a6eeddc08e37977ee21d518.camel@linux.ibm.com>
 <DM8PR11MB575074D3BCBD02F3DD677A57E7D09@DM8PR11MB5750.namprd11.prod.outlook.com>
 <261bc99edc43990eecb1aac4fe8005cedc495c20.camel@linux.ibm.com>
 <m2h6w6k5on.fsf@redhat.com>
 <20230131123033-mutt-send-email-mst@kernel.org>
 <6BCC3285-ACA3-4E38-8811-1A91C9F03852@redhat.com>
 <20230201055412-mutt-send-email-mst@kernel.org>
 <4B78D161-2712-434A-8E6F-9D8BA468BB3A@redhat.com>
MIME-Version: 1.0
In-Reply-To: <4B78D161-2712-434A-8E6F-9D8BA468BB3A@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Feb 01, 2023 at 02:15:10PM +0100, Christophe de Dinechin Dupont de Dinechin wrote:
> 
> 
> > On 1 Feb 2023, at 12:01, Michael S. Tsirkin <mst@redhat.com> wrote:
> > 
> > On Wed, Feb 01, 2023 at 11:52:27AM +0100, Christophe de Dinechin Dupont de Dinechin wrote:
> >> 
> >> 
> >>> On 31 Jan 2023, at 18:39, Michael S. Tsirkin <mst@redhat.com> wrote:
> >>> 
> >>> On Tue, Jan 31, 2023 at 04:14:29PM +0100, Christophe de Dinechin wrote:
> >>>> Finally, security considerations that apply irrespective of whether the
> >>>> platform is confidential or not are also outside of the scope of this
> >>>> document. This includes topics ranging from timing attacks to social
> >>>> engineering.
> >>> 
> >>> Why are timing attacks by hypervisor on the guest out of scope?
> >> 
> >> Good point.
> >> 
> >> I was thinking that mitigation against timing attacks is the same
> >> irrespective of the source of the attack. However, because the HV
> >> controls CPU time allocation, there are presumably attacks that
> >> are made much easier through the HV. Those should be listed.
> > 
> > Not just that, also because it can and does emulate some devices.
> > For example, are disk encryption systems protected against timing of
> > disk accesses?
> > This is why some people keep saying "forget about emulated devices, require
> > passthrough, include devices in the trust zone".
> > 
> >>> 
> >>>> </doc>
> >>>> 
> >>>> Feel free to comment and reword at will ;-)
> >>>> 
> >>>> 
> >>>> 3/ PCI-as-a-threat: where does that come from
> >>>> 
> >>>> Isn't there a fundamental difference, from a threat model perspective,
> >>>> between a bad actor, say a rogue sysadmin dumping the guest memory (which CC
> >>>> should defeat) and compromised software feeding us bad data? I think there
> >>>> is: at leats inside the TCB, we can detect bad software using measurements,
> >>>> and prevent it from running using attestation.  In other words, we first
> >>>> check what we will run, then we run it. The security there is that we know
> >>>> what we are running. The trust we have in the software is from testing,
> >>>> reviewing or using it.
> >>>> 
> >>>> This relies on a key aspect provided by TDX and SEV, which is that the
> >>>> software being measured is largely tamper-resistant thanks to memory
> >>>> encryption. In other words, after you have measured your guest software
> >>>> stack, the host or hypervisor cannot willy-nilly change it.
> >>>> 
> >>>> So this brings me to the next question: is there any way we could offer the
> >>>> same kind of service for KVM and qemu? The measurement part seems relatively
> >>>> easy. Thetamper-resistant part, on the other hand, seems quite difficult to
> >>>> me. But maybe someone else will have a brilliant idea?
> >>>> 
> >>>> So I'm asking the question, because if you could somehow prove to the guest
> >>>> not only that it's running the right guest stack (as we can do today) but
> >>>> also a known host/KVM/hypervisor stack, we would also switch the potential
> >>>> issues with PCI, MSRs and the like from "malicious" to merely "bogus", and
> >>>> this is something which is evidently easier to deal with.
> >>> 
> >>> Agree absolutely that's much easier.
> >>> 
> >>>> I briefly discussed this with James, and he pointed out two interesting
> >>>> aspects of that question:
> >>>> 
> >>>> 1/ In the CC world, we don't really care about *virtual* PCI devices. We
> >>>>  care about either virtio devices, or physical ones being passed through
> >>>>  to the guest. Let's assume physical ones can be trusted, see above.
> >>>>  That leaves virtio devices. How much damage can a malicious virtio device
> >>>>  do to the guest kernel, and can this lead to secrets being leaked?
> >>>> 
> >>>> 2/ He was not as negative as I anticipated on the possibility of somehow
> >>>>  being able to prevent tampering of the guest. One example he mentioned is
> >>>>  a research paper [1] about running the hypervisor itself inside an
> >>>>  "outer" TCB, using VMPLs on AMD. Maybe something similar can be achieved
> >>>>  with TDX using secure enclaves or some other mechanism?
> >>> 
> >>> Or even just secureboot based root of trust?
> >> 
> >> You mean host secureboot? Or guest?
> >> 
> >> If it’s host, then the problem is detecting malicious tampering with
> >> host code (whether it’s kernel or hypervisor).
> > 
> > Host.  Lots of existing systems do this.  As an extreme boot a RO disk,
> > limit which packages are allowed.
> 
> Is that provable to the guest?
> 
> Consider a cloud provider doing that: how do they prove to their guest:
> 
> a) What firmware, kernel and kvm they run
> 
> b) That what they booted cannot be maliciouly modified, e.g. by a rogue
>    device driver installed by a rogue sysadmin
> 
> My understanding is that SecureBoot is only intended to prevent non-verified
> operating systems from booting. So the proof is given to the cloud provider,
> and the proof is that the system boots successfully.

I think I should have said measured boot not secure boot.

> 
> After that, I think all bets are off. SecureBoot does little AFAICT
> to prevent malicious modifications of the running system by someone with
> root access, including deliberately loading a malicious kvm-zilog.ko

So disable module loading then or don't allow root access?

> 
> It does not mean it cannot be done, just that I don’t think we
> have the tools at the moment.

Phones, chromebooks do this all the time ...

> > 
> >> If it’s guest, at the moment at least, the measurements do not extend
> >> beyond the TCB.
> >> 
> >>> 
> >>> -- 
> >>> MST
> 

