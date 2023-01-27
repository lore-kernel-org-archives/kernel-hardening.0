Return-Path: <kernel-hardening-return-21620-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 963D4C54EAA
	for <kernel-hardening@archiver.kernel.org>; Fri, 27 Jan 2023 14:37:16 +0000 (UTC)
Received: (qmail 28224 invoked by uid 550); 27 Jan 2023 14:37:06 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24526 invoked from network); 27 Jan 2023 14:33:11 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1674829979;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kiteAAyoqy6B4ia/ir952V9ZLvHxG4HoXe39f/WCgz8=;
	b=g6dOd+yfVnojdz1/Ty3IqWj1HBVcwkpOpABMS1ikY4V6FQJplMTlofRyy6dqvK+OaXtaFK
	9yzXKIeRk9EmmBG/UG4A0rn2avqndoZWYn2S47R+tCv+l0QvmCnBGV+0cZFo5c4hdj6YT7
	5I2sfiPdOewAUuz/9cX31QDnufoCL04=
X-MC-Unique: Q1kK_GU2OLaKxveRnR7jlw-1
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kiteAAyoqy6B4ia/ir952V9ZLvHxG4HoXe39f/WCgz8=;
        b=x/FsWSgiLkhEqG5vW96AyfSCWAg8Cqs9y2F/AXcybbZfWLh3siuPwcIS4TkNN53bzo
         6w/a5GhM6sKYdCwwv36P0uKEd6YwZzyzDPlffbC+AlCq4v9NCGwzm0FsGCMLp2ixy9JK
         AtlO3fgljSgxxq+LhZ0GxfGkvYRTw5+GzziRPDo8KK/n8EmI7qSPzBESiALFOOf6hVh5
         ZTJMhW3Bx/ZIqOwF/cMatyQ4bjB1DZBkGMJWDHC8hJdxQ+gBWQrc2Ndv7x+LxNOTrIi+
         9WH4SQi+bt+2KYL25jPU1DWyjMST3Aiu54BAN/G+RaTZpeXm4BfiN78Nz5SIYEzxTA/M
         yNIQ==
X-Gm-Message-State: AO0yUKXE0KTTlFTReYpMcb9H5RkuenklqOUGYjUp/OgTK3Fz1nz4ndJ2
	XxGzAPocd/0AkDL51wpl+1QWb1Asz8itGkkb+OaBqWZn4/kF8jG7ZZC+whyNj8c1jj8etsldVRP
	Cec0J32kwNWrANrwQJJdbRpFcnT5SJExdCg==
X-Received: by 2002:adf:f286:0:b0:2bf:b5ea:8d66 with SMTP id k6-20020adff286000000b002bfb5ea8d66mr10337110wro.16.1674829975030;
        Fri, 27 Jan 2023 06:32:55 -0800 (PST)
X-Google-Smtp-Source: AK7set9kCnrVbQx6w9vIuIil/TAg2GquVBNkZQMzfOP10T7nbBDZHBAiZ6L43hHXRzeYqeZGjrrtnQ==
X-Received: by 2002:adf:f286:0:b0:2bf:b5ea:8d66 with SMTP id k6-20020adff286000000b002bfb5ea8d66mr10337081wro.16.1674829974746;
        Fri, 27 Jan 2023 06:32:54 -0800 (PST)
Date: Fri, 27 Jan 2023 09:32:49 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
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
Message-ID: <20230127090526-mutt-send-email-mst@kernel.org>
References: <DM8PR11MB57505481B2FE79C3D56C9201E7CE9@DM8PR11MB5750.namprd11.prod.outlook.com>
 <Y9EkCvAfNXnJ+ATo@kroah.com>
 <DM8PR11MB5750FA4849C3224F597C101AE7CE9@DM8PR11MB5750.namprd11.prod.outlook.com>
 <20230126105618-mutt-send-email-mst@kernel.org>
 <DM8PR11MB5750678B5F639F6C2848FC3CE7CC9@DM8PR11MB5750.namprd11.prod.outlook.com>
 <20230127044508-mutt-send-email-mst@kernel.org>
 <DM8PR11MB57501BD39CC1E88206E6CD5FE7CC9@DM8PR11MB5750.namprd11.prod.outlook.com>
MIME-Version: 1.0
In-Reply-To: <DM8PR11MB57501BD39CC1E88206E6CD5FE7CC9@DM8PR11MB5750.namprd11.prod.outlook.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Fri, Jan 27, 2023 at 12:25:09PM +0000, Reshetova, Elena wrote:
> 
> > On Fri, Jan 27, 2023 at 08:52:22AM +0000, Reshetova, Elena wrote:
> > > > On Wed, Jan 25, 2023 at 03:29:07PM +0000, Reshetova, Elena wrote:
> > > > > And this is a very special aspect of 'hardening' since it is about hardening a
> > > > kernel
> > > > > under different threat model/assumptions.
> > > >
> > > > I am not sure it's that special in that hardening IMHO is not a specific
> > > > threat model or a set of assumptions. IIUC it's just something that
> > > > helps reduce severity of vulnerabilities.  Similarly, one can use the CC
> > > > hardware in a variety of ways I guess. And one way is just that -
> > > > hardening linux such that ability to corrupt guest memory does not
> > > > automatically escalate into guest code execution.
> > >
> > > I am not sure if I fully follow you on this. I do agree that it is in principle
> > > the same 'hardening' that we have been doing in Linux for decades just
> > > applied to a new attack surface, host <-> guest, vs userspace <->kernel.
> > 
> > Sorry about being unclear this is not the type of hardening I meant
> > really.  The "hardening" you meant is preventing kernel vulnerabilities,
> > right? This is what we've been doing for decades.
> > But I meant slightly newer things like e.g. KASLR or indeed ASLR generally -
> > we are trying to reduce a chance a vulnerability causes random
> > code execution as opposed to a DOS. To think in these terms you do not
> > need to think about attack surfaces - in the system including
> > a hypervisor, guest supervisor and guest userspace hiding
> > one component from others is helpful even if they share
> > a privelege level.
> 
> Do you mean that the fact that CoCo guest has memory encrypted
> can help even in non-CoCo scenarios?

Yes.

> I am sorry, I still seem not to be able
> to grasp your idea fully. When the privilege level is shared, there is no
> incentive to perform privilege escalation attacks across components,
> so why hide them from each other?

Because limiting horisontal movement between components is still valuable.

> Data protection? But I don’t think you
> are talking about this? I do agree that KASLR is stronger when you remove
> the possibility to read the memory (make sure kernel code is execute only)
> you are trying to attack, but again not sure if you mean this. 

It's an example. If kernel was 100% secure we won't need KASLR. Nothing
ever is though.

> > 
> > 
> > 
> > > Interfaces have changed, but the types of vulnerabilities, etc are the same.
> > > The attacker model is somewhat different because we have
> > > different expectations on what host/hypervisor should be able to do
> > > to the guest (following business reasons and use-cases), versus what we
> > > expect normal userspace being able to "do" towards kernel. The host and
> > > hypervisor still has a lot of control over the guest (ability to start/stop it,
> > > manage its resources, etc). But the reasons behind this doesn’t come
> > > from the fact that security CoCo HW not being able to support this stricter
> > > security model (it cannot now indeed, but this is a design decision), but
> > > from the fact that it is important for Cloud service providers to retain that
> > > level of control over their infrastructure.
> > 
> > Surely they need ability to control resource usage, not ability to execute DOS
> > attacks. Current hardware just does not have ability to allow the former
> > without the later.
> 
> I don’t see why it cannot be added to HW if requirement comes. However, I think 
> in cloud provider world being able to control resources equals to being able
> to deny these resources when required, so being able to denial of service its clients
> is kind of build-in expectation that everyone just agrees on.  
> 
> > 
> > > >
> > > > If you put it this way, you get to participate in a well understood
> > > > problem space instead of constantly saying "yes but CC is special".  And
> > > > further, you will now talk about features as opposed to fixing bugs.
> > > > Which will stop annoying people who currently seem annoyed by the
> > > > implication that their code is buggy simply because it does not cache in
> > > > memory all data read from hardware. Finally, you then don't really need
> > > > to explain why e.g. DoS is not a problem but info leak is a problem - when
> > > > for many users it's actually the reverse - the reason is not that it's
> > > > not part of a threat model - which then makes you work hard to define
> > > > the threat model - but simply that CC hardware does not support this
> > > > kind of hardening.
> > >
> > > But this won't be correct statement, because it is not limitation of HW, but the
> > > threat and business model that Confidential Computing exists in. I am not
> > > aware of a single cloud provider who would be willing to use the HW that
> > > takes the full control of their infrastructure and running confidential guests,
> > > leaving them with no mechanisms to control the load balancing, enforce
> > > resource usage, etc. So, given that nobody needs/willing to use such HW,
> > > such HW simply doesn’t exist.
> > >
> > > So, I would still say that the model we operate in CoCo usecases is somewhat
> > > special, but I do agree that given that we list a couple of these special
> > assumptions
> > > (over which ones we have no control or ability to influence, none of us are
> > business
> > > people), then the rest becomes just careful enumeration of attack surface
> > interfaces
> > > and break up of potential mitigations.
> > >
> > > Best Regards,
> > > Elena.
> > >
> > 
> > I'd say each business has a slightly different business model, no?
> > Finding common ground is what helps us share code ...
> 
> Fully agree, and a good discussion with everyone willing to listen and cooperate
> can go a long way into defining the best implementation. 
> 
> Best Regards,
> Elena. 

Right. My point was that trying to show how CC usecases are similar to other
existing ones will be more helpful for everyone than just focusing on how they
are different. I hope I was able to show some similarities.

-- 
MST

