Return-Path: <kernel-hardening-return-21631-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 6ADFBC38142
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Jan 2023 17:47:17 +0000 (UTC)
Received: (qmail 19895 invoked by uid 550); 31 Jan 2023 17:40:40 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15995 invoked from network); 31 Jan 2023 17:40:12 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675186800;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=w3FPeGg7hItnWxgo62PHoYeVD78xpshA0pZcr5VAtYY=;
	b=Ah/d0sbLCj4BuFyfLsNHj3ItMfK4RKCmoAJFG4tY++fley1Hvm/29/07SM+UtU09XJy17L
	C4e3W9Y63a8Cvw9bNfOZYFOsuTCo+wf76a9cEcfvxEDS68Vte15ssLY9zg+3IRpg8uMEbB
	mQyDQPDrgkSRKgBq5Md8FZkWVKon0Z8=
X-MC-Unique: n8OyvN-dMge_48ZzpNCkGA-1
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w3FPeGg7hItnWxgo62PHoYeVD78xpshA0pZcr5VAtYY=;
        b=gGwEu6UjmR9m7PUSumNBjslqzloJNhEmqm2VF87YYiGDnVGdS8vPMSb7OXcGdsb4wC
         juK5SN689jEpf/ZIs+yVKpa0+l9BKQeAxS/WJb1hCIpZofGtP5x/0JGyw5TxSNjoNAPW
         /udFmrmyg7UmsBjjOka/FWFdeRwo8RFSge1V7aK/CSWWsdnlgSUBf63M1w+ngLW9m/lq
         vvE7EeFSr030XzJWpSitgfSqv7/6qTIPUf6DNgBqMd85jNpZodPGjGWf698PZ+A0byCy
         +cY1+HxiEy22EL5qDyojugFghniybN5IzORm4H/JuiXmNr4jxkLcwIyOakaRBHIfzaGF
         HaEQ==
X-Gm-Message-State: AO0yUKXR5POBAzKG0Tf9TZz2goONIMK7z96GMSQ3LLvtPhuJEpso4yOn
	YuOqC2EW97iR0Ay+bK3v4I/WBIGrne8m3q9NKVJdzMwKr1JeIMDQZpxxz04GbwJU1Dj42sizeYg
	/61SoTV68GS9pUT+HDXtlIDnGdrkAzpn2Nw==
X-Received: by 2002:a05:6402:35c6:b0:46f:d386:117d with SMTP id z6-20020a05640235c600b0046fd386117dmr5019318edc.33.1675186796146;
        Tue, 31 Jan 2023 09:39:56 -0800 (PST)
X-Google-Smtp-Source: AK7set9ZPgbwWWTJbgUH+vDerGoDBXBQ/8n25BR+kRZY16ejwePSwXUQ1VHiheonNGFC8dalJpBx8Q==
X-Received: by 2002:a05:6402:35c6:b0:46f:d386:117d with SMTP id z6-20020a05640235c600b0046fd386117dmr5019279edc.33.1675186795943;
        Tue, 31 Jan 2023 09:39:55 -0800 (PST)
Date: Tue, 31 Jan 2023 12:39:48 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Christophe de Dinechin <dinechin@redhat.com>
Cc: jejb@linux.ibm.com, "Reshetova, Elena" <elena.reshetova@intel.com>,
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
Message-ID: <20230131123033-mutt-send-email-mst@kernel.org>
References: <Y9Jh2x9XJE1KEUg6@unreal>
 <DM8PR11MB5750414F6638169C7097E365E7CF9@DM8PR11MB5750.namprd11.prod.outlook.com>
 <Y9JyW5bUqV7gWmU8@unreal>
 <DM8PR11MB57507D9C941D77E148EE9E87E7CF9@DM8PR11MB5750.namprd11.prod.outlook.com>
 <702f22df28e628d41babcf670c909f1fa1bb3c0c.camel@linux.ibm.com>
 <DM8PR11MB5750F939C0B70939AD3CBC37E7D39@DM8PR11MB5750.namprd11.prod.outlook.com>
 <220b0be95a8c733f0a6eeddc08e37977ee21d518.camel@linux.ibm.com>
 <DM8PR11MB575074D3BCBD02F3DD677A57E7D09@DM8PR11MB5750.namprd11.prod.outlook.com>
 <261bc99edc43990eecb1aac4fe8005cedc495c20.camel@linux.ibm.com>
 <m2h6w6k5on.fsf@redhat.com>
MIME-Version: 1.0
In-Reply-To: <m2h6w6k5on.fsf@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 31, 2023 at 04:14:29PM +0100, Christophe de Dinechin wrote:
> Finally, security considerations that apply irrespective of whether the
> platform is confidential or not are also outside of the scope of this
> document. This includes topics ranging from timing attacks to social
> engineering.

Why are timing attacks by hypervisor on the guest out of scope?

> </doc>
> 
> Feel free to comment and reword at will ;-)
> 
> 
> 3/ PCI-as-a-threat: where does that come from
> 
> Isn't there a fundamental difference, from a threat model perspective,
> between a bad actor, say a rogue sysadmin dumping the guest memory (which CC
> should defeat) and compromised software feeding us bad data? I think there
> is: at leats inside the TCB, we can detect bad software using measurements,
> and prevent it from running using attestation.  In other words, we first
> check what we will run, then we run it. The security there is that we know
> what we are running. The trust we have in the software is from testing,
> reviewing or using it.
> 
> This relies on a key aspect provided by TDX and SEV, which is that the
> software being measured is largely tamper-resistant thanks to memory
> encryption. In other words, after you have measured your guest software
> stack, the host or hypervisor cannot willy-nilly change it.
> 
> So this brings me to the next question: is there any way we could offer the
> same kind of service for KVM and qemu? The measurement part seems relatively
> easy. Thetamper-resistant part, on the other hand, seems quite difficult to
> me. But maybe someone else will have a brilliant idea?
> 
> So I'm asking the question, because if you could somehow prove to the guest
> not only that it's running the right guest stack (as we can do today) but
> also a known host/KVM/hypervisor stack, we would also switch the potential
> issues with PCI, MSRs and the like from "malicious" to merely "bogus", and
> this is something which is evidently easier to deal with.

Agree absolutely that's much easier.

> I briefly discussed this with James, and he pointed out two interesting
> aspects of that question:
> 
> 1/ In the CC world, we don't really care about *virtual* PCI devices. We
>    care about either virtio devices, or physical ones being passed through
>    to the guest. Let's assume physical ones can be trusted, see above.
>    That leaves virtio devices. How much damage can a malicious virtio device
>    do to the guest kernel, and can this lead to secrets being leaked?
> 
> 2/ He was not as negative as I anticipated on the possibility of somehow
>    being able to prevent tampering of the guest. One example he mentioned is
>    a research paper [1] about running the hypervisor itself inside an
>    "outer" TCB, using VMPLs on AMD. Maybe something similar can be achieved
>    with TDX using secure enclaves or some other mechanism?

Or even just secureboot based root of trust?

-- 
MST

